/*
// chat_cubit.dart - Fix imports and consolidate code

import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:graduation___part1/views/editProfile.dart';

import 'package:intl/intl.dart';

import 'package:shared_preferences/shared_preferences.dart';

import 'dart:convert';

import 'package:signalr_netcore/signalr_client.dart';

import 'dart:async';

import 'package:uuid/uuid.dart';

import 'package:flutter/material.dart';

import 'package:path_provider/path_provider.dart';

import 'dart:io';

enum ConnectionStatus { disconnected, connecting, connected }

enum TextInputDirection { ltr, rtl }

enum TextDirection { ltr, rtl }

class ChatCubit extends Cubit<ChatState> {
  HubConnection? _hubConnection;

  late Profile userProfile;

  Timer? _reconnectTimer;

  Timer? _typingIndicatorTimer;

  List<Map<String, dynamic>> notSent = [];

  int idCounter = 0;

  String _refID = "";

  Timer? _messageQueueTimer;

  final Uuid _uuid = Uuid();

  Map<String, List<Map<String, dynamic>>> notSeen = {};

  String? myProfileImage;

  final RegExp _rtlRegex =
      RegExp(r'[\u0591-\u07FF\u200F\u202B\u202E\uFB1D-\uFDFD\uFE70-\uFEFC]');

  final Map<String, dynamic> _audioMessageBuffer = {};

  ChatCubit(Profile profile) : super(ChatState.initial()) {
    userProfile = profile;

    _refID = "";

    _loadMyProfileImage();

    loadMessages();

    connectToSignalR();
  }

  void handleTextInput(String value, TextEditingController controller) {
    if (value == "\n") {
      controller.clear();

      return;
    }

    final TextInputDirection direction = _rtlRegex.hasMatch(value)
        ? TextInputDirection.rtl
        : TextInputDirection.ltr;

    emit(state.copyWith(textDirection: direction));

    if (value.length % 10 == 1) {
      sendTypingNotification();
    }
  }

  TextDirection getTextDirection() {
    return state.textDirection == TextInputDirection.rtl
        ? TextDirection.rtl
        : TextDirection.ltr;
  }

  Future _loadMyProfileImage() async {
    try {
      final prefs = await SharedPreferences.getInstance();

      myProfileImage = prefs.getString('profile_image');
    } catch (e) {
      // Error handling

      print('Error loading profile image: $e');
    }
  }

  void _processReceivedMessage(String senderName, String messageText,
      String messageTime, String? messageRef, String? messageId) {
    final message = {
      'sender': 'other',
      'username': senderName,
      'text': messageText,
      'time': messageTime,
      'ref': messageRef,
      'id': messageId,
    };

    final updatedMessages = List<Map<String, dynamic>>.from(state.chatMessages)
      ..add(message);

    emit(state.copyWith(
        chatMessages: updatedMessages,
        forceRefresh: !state.forceRefresh,
        isBotTyping: false));

    saveMessages();
  }

  String _generateRefID() {
    return _uuid.v4();
  }

  void hideViewAdsAction() {
    emit(state.copyWith(showViewAdsAction: false));
  }

  Future loadMessages() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();

      String? messagesString =
          prefs.getString('chatMessages_${userProfile.id}');

      if (messagesString != null) {
        List messagesJson = json.decode(messagesString);

        final loadedMessages = List<Map<String, dynamic>>.from(messagesJson);

        emit(state.copyWith(
            chatMessages: loadedMessages, forceRefresh: !state.forceRefresh));
      }
    } catch (e) {
      print('Error loading messages: $e');

      emit(state.copyWith(chatMessages: []));
    }
  }

  Future saveMessages() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();

      String messagesString = json.encode(state.chatMessages);

      await prefs.setString('chatMessages_${userProfile.id}', messagesString);
    } catch (e) {
      print('Error saving messages: $e');
    }
  }

  String _getCurrentTime() {
    return DateFormat('hh:mm a').format(DateTime.now());
  }

  String _getFormattedTimeForId() {
    final now = DateTime.now();

    return "${now.hour}:${now.minute}:${now.second}";
  }

  Future connectToSignalR() async {
    if (state.connectionStatus == ConnectionStatus.connecting) {
      return;
    }

    emit(state.copyWith(connectionStatus: ConnectionStatus.connecting));

    final prefs = await SharedPreferences.getInstance();

    final String? tokenId = prefs.getString("Token");

    if (tokenId == null) {
      emit(state.copyWith(connectionStatus: ConnectionStatus.disconnected));

      return;
    }

    try {
      String username = prefs.getString("username") ?? "User";

      emit(state.copyWith(currentUsername: username));

      final url =
          "https://infinitely-native-lamprey.ngrok-free.app/chat?Authentication=${Uri.encodeComponent(tokenId)}";

      _hubConnection = HubConnectionBuilder()
          .withUrl(url)
          .withAutomaticReconnect(
              retryDelays: [2000, 5000, 10000, 30000]).build();

      _setupSignalRHandlers();

      await _hubConnection!.start();

      emit(state.copyWith(connectionStatus: ConnectionStatus.connected));

      await _hubConnection!.invoke("MyID");

      await _hubConnection!.invoke("SendPendingMasseges");

      _processNotSentMessages();

      _cancelReconnectTimer();
    } catch (e) {
      print('Error connecting to SignalR: $e');

      emit(state.copyWith(connectionStatus: ConnectionStatus.disconnected));

      _scheduleReconnect();
    }
  }

  void _setupSignalRHandlers() {
    _hubConnection!.on("MyID", (arguments) {
      if (arguments != null && arguments.isNotEmpty) {
        final myId = arguments[0].toString();

        emit(state.copyWith(myUserId: myId));
      }
    });

    _hubConnection!.on("ReceiveMessage", (arguments) {
      if (arguments != null && arguments.length >= 2) {
        try {
          final username = arguments[0] as String;

          final messageText = arguments[1] as String;

          final message = {
            'sender': username == state.currentUsername ? 'user' : 'other',
            'username': username == state.currentUsername ? null : username,
            'text': messageText,
            'time': _getCurrentTime(),
          };

          final updatedMessages =
              List<Map<String, dynamic>>.from(state.chatMessages)..add(message);

          emit(state.copyWith(
            chatMessages: updatedMessages,
            forceRefresh: !state.forceRefresh,
            isBotTyping: false,
          ));

          saveMessages();
        } catch (e) {
          print('Error processing message: $e');
        }
      }
    });

    _hubConnection!.on("ReceivePrivateMessage", (arguments) async {
      if (arguments != null && arguments.length >= 3) {
        try {
          final senderId = arguments[0].toString();

          final messageObj = arguments[1];

          final senderDetails = arguments[2];

          String messageText = "";

          String messageTime = _getCurrentTime();

          String? messageRef;

          String? messageId;

          if (messageObj is Map) {
            messageText = messageObj['message'] ?? "";

            messageTime = messageObj['time'] ?? _getCurrentTime();

            messageRef = messageObj['ref'];

            messageId = messageObj['messageID'];
          } else if (messageObj is String) {
            messageText = messageObj;
          }

          String senderName = "Unknown";

          if (senderDetails is Map) {
            senderName = senderDetails['username'] ?? "Unknown";
          } else if (senderDetails is String) {
            senderName = senderDetails;
          }

          if (senderId == userProfile.id.toString()) {
            _processReceivedMessage(
                senderName, messageText, messageTime, messageRef, messageId);

            _hubConnection!.invoke("Confirmation", args: [senderId]);
          } else {
            _storeNotSeenMessage(senderId, messageText, senderName);
          }
        } catch (e) {
          print('Error processing private message: $e');
        }
      }
    });

    _hubConnection!.on("IsTyping", (arguments) {
      if (arguments != null && arguments.isNotEmpty) {
        final senderId = arguments[0].toString();

        if (senderId == userProfile.id.toString()) {
          emit(state.copyWith(isBotTyping: true));

          _typingIndicatorTimer?.cancel();

          _typingIndicatorTimer = Timer(const Duration(seconds: 3), () {
            emit(state.copyWith(isBotTyping: false));
          });
        }
      }
    });

    _hubConnection!.on("isRecording", (arguments) {
      if (arguments != null && arguments.isNotEmpty) {
        final senderId = arguments[0].toString();

        if (senderId == userProfile.id.toString()) {
          emit(state.copyWith(isRecording: true));
        }
      }
    });

    _hubConnection!.on("stopRecording", (arguments) {
      if (arguments != null && arguments.isNotEmpty) {
        final senderId = arguments[0].toString();

        if (senderId == userProfile.id.toString()) {
          emit(state.copyWith(isRecording: false));
        }
      }
    });

    _hubConnection!.on("sendlargemessage", (arguments) async {
      if (arguments != null && arguments.length >= 8) {
        try {
          // Extract arguments
          final senderId = arguments[0].toString();
          final messageSize = arguments[1] as int;
          final chunkIndex = arguments[2] as int;
          final chunk = arguments[3] as String;
          final finished = arguments[4] as bool;
          final time = arguments[5] as String;
          final messageId = arguments[6] as String;
          final messageRefId = "";
          final senderDetails = arguments.length > 8 ? arguments[8] : null;

          // Create a unique key using sender ID + message ID to handle multiple concurrent audio messages
          final bufferKey = "$senderId:$messageId";

          // Initialize buffer if needed
          if (!_audioMessageBuffer.containsKey(bufferKey)) {
            _audioMessageBuffer[bufferKey] = {
              'chunks': List<String?>.filled(messageSize ~/ 1000 + 100,
                  null), // Better estimate of needed size
              'receivedSize': 0,
              'messageSize': messageSize,
              'time': time,
              'senderName': "Unknown"
            };

            // Extract sender name
            if (senderDetails is Map) {
              _audioMessageBuffer[bufferKey]['senderName'] =
                  senderDetails['username'] ?? "Unknown";
            } else if (senderDetails is String) {
              _audioMessageBuffer[bufferKey]['senderName'] = senderDetails;
            }
          }

          // Store chunk
          final buffer = _audioMessageBuffer[bufferKey];
          final List<String?> chunksList = buffer['chunks'];

          // Ensure chunk index is valid
          if (chunkIndex < chunksList.length) {
            chunksList[chunkIndex] = chunk;
            buffer['receivedSize'] =
                (buffer['receivedSize'] as int) + chunk.length;
          } else {
            // If we receive a chunk with index beyond our buffer size, resize the buffer
            final newSize = chunkIndex + 50; // Add some extra space
            final newChunks = List<String?>.filled(newSize, null);
            for (int i = 0; i < chunksList.length; i++) {
              newChunks[i] = chunksList[i];
            }
            newChunks[chunkIndex] = chunk;
            buffer['chunks'] = newChunks;
            buffer['receivedSize'] =
                (buffer['receivedSize'] as int) + chunk.length;
            print('Resized buffer for message $messageId to $newSize');
          }

          // Process completed message
          if (finished &&
              (buffer['receivedSize'] as int) >= messageSize * 0.95) {
            // Allow for some data loss
            print(
                'Audio message complete: $messageId (${buffer['receivedSize']}/$messageSize bytes)');

            try {
              // Combine chunks into complete audio data, filtering out null chunks
              final base64Audio =
                  chunksList.where((element) => element != null).join("");

              // Ensure we have valid base64 data
              if (base64Audio.isNotEmpty) {
                // Save to file with proper error handling
                try {
                  final tempDir = await getTemporaryDirectory();
                  final tempPath = '${tempDir.path}/audio_$messageId.aac';
                  final file = File(tempPath);
                  await file.writeAsBytes(base64Decode(base64Audio));

                  // Get sender information
                  final senderName = buffer['senderName'] as String;

                  // Process based on sender
                  if (senderId == userProfile.id.toString()) {
                    // Add to chat messages
                    final messages =
                        List<Map<String, dynamic>>.from(state.chatMessages)
                          ..add({
                            'sender': 'other',
                            'type': 'audio',
                            'audioData': base64Audio,
                            'filePath': tempPath,
                            'time': buffer['time'],
                            'username': senderName,
                            'messageId': messageId,
                          });

                    emit(state.copyWith(
                      chatMessages: messages,
                      forceRefresh: !state.forceRefresh,
                      isBotTyping: false,
                    ));

                    saveMessages();

                    // Send confirmation
                    try {
                      await _hubConnection!
                          .invoke("Confirmation", args: [senderId, messageId]);
                    } catch (e) {
                      print('Error sending audio confirmation: $e');
                    }
                  } else {
                    // Store in not seen messages
                    if (!notSeen.containsKey(senderId)) {
                      notSeen[senderId] = [];
                    }

                    notSeen[senderId]!.add({
                      'type': 'audio',
                      'audioData': base64Audio,
                      'filePath': tempPath,
                      'time': buffer['time'],
                      'sender': senderName,
                      'messageId': messageId,
                    });
                  }
                } catch (e) {
                  print('Error saving audio file: $e');
                }
              } else {
                print('Empty audio data for message $messageId');
              }
            } catch (e) {
              print('Error processing audio data: $e');
            }

            // Clean up buffer
            _audioMessageBuffer.remove(bufferKey);
          }
        } catch (e) {
          print('Error processing large message: $e');
        }
      }
    });

    _hubConnection!.on("CheckPendingMasseges", (arguments) {
      if (arguments != null && arguments.isNotEmpty) {
        try {
          final List messagesList = arguments[0] as List;

          for (var messageData in messagesList) {
            final String senderId = messageData['senderId'] ?? "";

            final String message = messageData['message'] ?? "";

            final String senderName = messageData['senderName'] ?? "Unknown";

            final String messageTime =
                messageData['messageTime'] ?? _getCurrentTime();

            final String? refId = "";

            final String? messageId = messageData['messageId'];

            if (senderId == userProfile.id.toString()) {
              _processReceivedMessage(
                  senderName, message, messageTime, refId, messageId);
            } else {
              _storeNotSeenMessage(senderId, message, senderName);
            }
          }
        } catch (e) {
          print('Error checking pending messages: $e');
        }
      }
    });

    _hubConnection!.on("Confirmation", (arguments) {
      // Message delivery confirmation

      print('Message delivered');
    });

    _hubConnection!.onclose(({error}) {
      print('Connection closed: $error');

      emit(state.copyWith(connectionStatus: ConnectionStatus.disconnected));

      _scheduleReconnect();
    } as ClosedCallback);
  }

  void sendRecordingNotification(bool isRecording) {
    if (_hubConnection?.state == HubConnectionState.Connected) {
      try {
        if (isRecording) {
          _hubConnection!
              .invoke("isRecording", args: [userProfile.id.toString()]);
        } else {
          _hubConnection!
              .invoke("stopRecording", args: [userProfile.id.toString()]);
        }
      } catch (e) {
        print('Error sending recording notification: $e');
      }
    }
  }

  void sendAudioMessage({
    required String audioData,
    required String duration,
    required String filePath,
  }) {
    final messageId = "audio_${_getFormattedTimeForId()}_${++idCounter}";

    try {
      if (_hubConnection?.state == HubConnectionState.Connected) {
        final chunkSize = 5000;

        final totalChunks = (audioData.length / chunkSize).ceil();

        for (int i = 0; i < totalChunks; i++) {
          final start = i * chunkSize;

          final end = (i + 1) * chunkSize;

          final chunk = audioData.substring(
              start, end > audioData.length ? audioData.length : end);

          final isLastChunk = i == totalChunks - 1;

          _hubConnection!.invoke("SendLargeMessage", args: [
            userProfile.id.toString(),
            audioData.length,
            i,
            chunk,
            isLastChunk,
            messageId,
            "",
          ]);
        }
      } else {
        notSent.add({
          'type': 'audio',
          'audioData': audioData,
          'duration': duration,
          'filePath': filePath,
          'receiverId': userProfile.id.toString(),
          'time': _getCurrentTime(),
        });
      }

      final messages = List<Map<String, dynamic>>.from(state.chatMessages)
        ..add({
          'sender': 'user',
          'type': 'audio',
          'audioData': audioData,
          'duration': duration,
          'filePath': filePath,
          'time': _getCurrentTime(),
        });

      emit(state.copyWith(
        chatMessages: messages,
        forceRefresh: !state.forceRefresh,
      ));

      saveMessages();
    } catch (e) {
      print('Error sending audio message: $e');
    }
  }

  void _storeNotSeenMessage(
      String senderId, String messageText, String senderName) {
    if (!notSeen.containsKey(senderId)) {
      notSeen[senderId] = [];
    }

    notSeen[senderId]!.add({
      'message': messageText,
      'time': _getCurrentTime(),
      'sender': senderName,
    });
  }

  void _scheduleReconnect() {
    _cancelReconnectTimer();

    _reconnectTimer = Timer(const Duration(seconds: 5), () {
      connectToSignalR();
    });
  }

  void _cancelReconnectTimer() {
    if (_reconnectTimer != null) {
      _reconnectTimer?.cancel();

      _reconnectTimer = null;
    }
  }

  void disconnectSignalR() {
    _cancelReconnectTimer();

    if (_typingIndicatorTimer != null) {
      _typingIndicatorTimer?.cancel();

      _typingIndicatorTimer = null;
    }

    if (_messageQueueTimer != null) {
      _messageQueueTimer?.cancel();

      _messageQueueTimer = null;
    }

    if (_hubConnection != null) {
      _hubConnection?.stop();

      _hubConnection = null;
    }
  }

  Future sendMessage(String message) async {
    if (message.trim().isEmpty) {
      return;
    }

    final currentTime = _getCurrentTime();

    final userMessage = {
      'sender': 'user',
      'text': message,
      'time': currentTime,
    };

    final updatedMessages = List<Map<String, dynamic>>.from(state.chatMessages)
      ..add(userMessage);

    emit(state.copyWith(
        chatMessages: updatedMessages, forceRefresh: !state.forceRefresh));

    if (_hubConnection == null ||
        _hubConnection!.state != HubConnectionState.Connected) {
      final errorMessage = {
        'sender': 'system',
        'text': 'Not connected to chat server. Reconnecting...',
        'time': currentTime,
      };

      final messages = List<Map<String, dynamic>>.from(state.chatMessages)
        ..add(errorMessage);

      emit(state.copyWith(
          chatMessages: messages, forceRefresh: !state.forceRefresh));

      connectToSignalR();

      saveMessages();

      return;
    }

    try {
      String count = "${++idCounter}";

      final messageId = (_getFormattedTimeForId() + message + count)
          .replaceAll(RegExp(r'\s', caseSensitive: false), "");

      await _hubConnection!.invoke("SendPrivateMessage",
          args: [userProfile.id.toString(), message, messageId, ""]);

      saveMessages();
    } catch (e) {
      print('Error sending message: $e');

      final errorMessage = {
        'sender': 'system',
        'text': 'Message will be sent when connection is restored.',
        'time': currentTime,
      };

      final messages = List<Map<String, dynamic>>.from(state.chatMessages)
        ..add(errorMessage);

      emit(state.copyWith(
          chatMessages: messages, forceRefresh: !state.forceRefresh));

      saveMessages();

      _processNotSentMessages();
    }
  }

  Future _processNotSentMessages() async {
    if (_messageQueueTimer != null) {
      _messageQueueTimer?.cancel();
    }

    if (notSent.isEmpty) {
      return;
    }

    if (_hubConnection?.state != HubConnectionState.Connected) {
      _messageQueueTimer = Timer(Duration(seconds: 5), _processNotSentMessages);

      return;
    }

    _messageQueueTimer = Timer.periodic(Duration(seconds: 1), (timer) async {
      if (notSent.isEmpty) {
        timer.cancel();

        _messageQueueTimer = null;

        return;
      }

      if (_hubConnection?.state != HubConnectionState.Connected) {
        timer.cancel();

        _messageQueueTimer =
            Timer(Duration(seconds: 5), _processNotSentMessages);

        return;
      }

      final myMessage = notSent.removeAt(0);

      try {
        if (myMessage['type'] == 'audio') {
          // Process audio message

          final audioData = myMessage['audioData'];

          final chunkSize = 5000;

          final totalChunks = (audioData.length / chunkSize).ceil();

          final messageId = "audio_${_getFormattedTimeForId()}_${++idCounter}";

          for (int i = 0; i < totalChunks; i++) {
            final start = i * chunkSize;

            final end = (i + 1) * chunkSize;

            final chunk = audioData.substring(
                start, end > audioData.length ? audioData.length : end);

            final isLastChunk = i == totalChunks - 1;

            await _hubConnection!.invoke("SendLargeMessage", args: [
              myMessage['receiverId'],
              audioData.length,
              i,
              chunk,
              isLastChunk,
              messageId,
              "",
            ]);
          }

        } else {
          // Process text message

          String count = "${++idCounter}";

          final messageText = myMessage['message'] ?? '';

          final messageId = (_getFormattedTimeForId() + messageText + count)
              .replaceAll(RegExp(r'\s', caseSensitive: false), "");

          await _hubConnection!.invoke("SendPrivateMessage",
              args: [myMessage['receiverId'], messageText, messageId, ""]);
        }
      } catch (err) {
        print('Error processing unsent message: $err');

        notSent.insert(0, myMessage);

        timer.cancel();

        _messageQueueTimer =
            Timer(Duration(seconds: 5), _processNotSentMessages);
      }
    });
  }

  void sendTypingNotification() {
    if (_hubConnection?.state == HubConnectionState.Connected) {
      try {
        _hubConnection!.invoke("IsTyping", args: [userProfile.id.toString()]);
      } catch (e) {
        print('Error sending typing notification: $e');
      }
    }
  }

  List<Map<String, dynamic>> getUnseenMessages(String userId) {
    return notSeen[userId] ?? [];
  }

  void clearUnseenMessages(String userId) {
    notSeen.remove(userId);
  }

  @override
  Future<void> close() {
    if (_typingIndicatorTimer != null) {
      _typingIndicatorTimer?.cancel();

      _typingIndicatorTimer = null;
    }

    disconnectSignalR();

    return super.close();
  }
}

class ChatState {
  final List<Map<String, dynamic>> chatMessages;

  final bool isBotTyping;

  final bool showViewAdsAction;

  final bool forceRefresh;

  final ConnectionStatus connectionStatus;

  final String currentUsername;

  final String myUserId;

  final TextInputDirection textDirection;

  final bool isRecording;

  const ChatState({
    this.chatMessages = const [],
    this.isBotTyping = false,
    this.showViewAdsAction = true,
    this.forceRefresh = false,
    this.connectionStatus = ConnectionStatus.disconnected,
    this.currentUsername = '',
    this.myUserId = '',
    this.textDirection = TextInputDirection.ltr,
    this.isRecording = false,
  });

  factory ChatState.initial() {
    return const ChatState(
      chatMessages: [],
      isBotTyping: false,
      showViewAdsAction: true,
      connectionStatus: ConnectionStatus.disconnected,
      currentUsername: '',
      myUserId: '',
      textDirection: TextInputDirection.ltr,
      isRecording: false,
    );
  }

  ChatState copyWith({
    List<Map<String, dynamic>>? chatMessages,
    bool? isBotTyping,
    bool? showViewAdsAction,
    bool? forceRefresh,
    ConnectionStatus? connectionStatus,
    String? currentUsername,
    String? myUserId,
    TextInputDirection? textDirection,
    bool? isRecording,
  }) {
    return ChatState(
      chatMessages: chatMessages ?? this.chatMessages,
      isBotTyping: isBotTyping ?? this.isBotTyping,
      showViewAdsAction: showViewAdsAction ?? this.showViewAdsAction,
      forceRefresh: forceRefresh ?? this.forceRefresh,
      connectionStatus: connectionStatus ?? this.connectionStatus,
      currentUsername: currentUsername ?? this.currentUsername,
      myUserId: myUserId ?? this.myUserId,
      textDirection: textDirection ?? this.textDirection,
      isRecording: isRecording ?? this.isRecording,
    );
  }
}
*/

import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:signalr_netcore/hub_connection.dart';
import 'package:signalr_netcore/hub_connection_builder.dart';
import 'package:uuid/uuid.dart';

import 'editProfile.dart';

enum ConnectionStatus { disconnected, connecting, connected }

enum TextInputDirection { ltr, rtl }

enum TextDirection { ltr, rtl }

class ChatCubit extends Cubit<ChatState> {
  HubConnection? _hubConnection;
  late Profile userProfile;
  Timer? _reconnectTimer;
  Timer? _typingIndicatorTimer;
  Timer? _messageQueueTimer;
  final Uuid _uuid = Uuid();
  List<Map<String, dynamic>> notSent = [];
  Map<String, List<Map<String, dynamic>>> notSeen = {};
  String? myProfileImage;
  int idCounter = 0;
  final RegExp _rtlRegex =
      RegExp(r'[\u0591-\u07FF\u200F\u202B\u202E\uFB1D-\uFDFD\uFE70-\uFEFC]');
  final Map<String, dynamic> _audioMessageBuffer = {};

  ChatCubit(Profile profile) : super(ChatState.initial()) {
    userProfile = profile;
    _initialize();
  }

  Future<void> _initialize() async {
    await _loadMyProfileImage();
    await loadMessages();
    await connectToSignalR();
  }

  Future<void> _loadMyProfileImage() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      myProfileImage = prefs.getString('profile_image');
    } catch (e) {
      debugPrint('Error loading profile image: $e');
    }
  }

  Future<void> loadMessages() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final messagesString = prefs.getString('chatMessages_${userProfile.id}');
      if (messagesString != null) {
        final messagesJson = json.decode(messagesString) as List;
        final loadedMessages = messagesJson.cast<Map<String, dynamic>>();
        emit(state.copyWith(
          chatMessages: loadedMessages,
          forceRefresh: !state.forceRefresh,
        ));
      }
    } catch (e) {
      debugPrint('Error loading messages: $e');
      emit(state.copyWith(chatMessages: []));
    }
  }

  Future<void> saveMessages() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final messagesString = json.encode(state.chatMessages);
      await prefs.setString('chatMessages_${userProfile.id}', messagesString);
    } catch (e) {
      debugPrint('Error saving messages: $e');
    }
  }

  Future<void> connectToSignalR() async {
    if (state.connectionStatus == ConnectionStatus.connecting) return;

    emit(state.copyWith(connectionStatus: ConnectionStatus.connecting));

    final prefs = await SharedPreferences.getInstance();
    final tokenId = prefs.getString('Token');
    if (tokenId == null) {
      emit(state.copyWith(connectionStatus: ConnectionStatus.disconnected));
      return;
    }

    try {
      final username = prefs.getString('username') ?? 'User';
      emit(state.copyWith(currentUsername: username));

      final url =
          'https://infinitely-native-lamprey.ngrok-free.app/chat?Authentication=${Uri.encodeComponent(tokenId)}';
      _hubConnection = HubConnectionBuilder().withUrl(url).build();

      _setupSignalRHandlers();

      await _hubConnection!.start();
      emit(state.copyWith(connectionStatus: ConnectionStatus.connected));

      await _hubConnection!.invoke('MyID');
      await _hubConnection!.invoke('SendPendingMasseges');

      _processNotSentMessages();
      _cancelReconnectTimer();
    } catch (e) {
      debugPrint('Error connecting to SignalR: $e');
      emit(state.copyWith(connectionStatus: ConnectionStatus.disconnected));
      _scheduleReconnect();
    }
  }

  void _setupSignalRHandlers() {
    _hubConnection!.on('MyID', (arguments) {
      if (arguments != null && arguments.isNotEmpty) {
        emit(state.copyWith(myUserId: arguments[0].toString()));
      }
    });

    _hubConnection!.on('ReceiveMessage', (arguments) {
      if (arguments != null && arguments.length >= 2) {
        try {
          final username = arguments[0] as String;
          final messageText = arguments[1] as String;
          final message = {
            'sender': username == state.currentUsername ? 'user' : 'other',
            'username': username == state.currentUsername ? null : username,
            'text': messageText,
            'time': _getCurrentTime(),
          };
          _addMessage(message);
        } catch (e) {
          debugPrint('Error processing message: $e');
        }
      }
    });

    _hubConnection!.on('ReceivePrivateMessage', (arguments) async {
      if (arguments != null && arguments.length >= 3) {
        try {
          final senderId = arguments[0].toString();
          final messageObj = arguments[1];
          final senderDetails = arguments[2];

          String messageText = '';
          String messageTime = _getCurrentTime();
          String? messageRef;
          String? messageId;

          if (messageObj is Map) {
            messageText = messageObj['message'] ?? '';
            messageTime = messageObj['time'] ?? _getCurrentTime();
            messageRef = messageObj['ref'];
            messageId = messageObj['messageID'];
          } else if (messageObj is String) {
            messageText = messageObj;
          }

          final senderName = senderDetails is Map
              ? senderDetails['username'] ?? 'Unknown'
              : senderDetails is String
                  ? senderDetails
                  : 'Unknown';

          if (senderId == userProfile.id.toString()) {
            _processReceivedMessage(
                senderName, messageText, messageTime, messageRef, messageId);
            await _hubConnection!.invoke('Confirmation', args: [senderId]);
          } else {
            _storeNotSeenMessage(senderId, messageText, senderName);
          }
        } catch (e) {
          debugPrint('Error processing private message: $e');
        }
      }
    });

    _hubConnection!.on('IsTyping', (arguments) {
      if (arguments != null && arguments.isNotEmpty) {
        final senderId = arguments[0].toString();
        if (senderId == userProfile.id.toString()) {
          emit(state.copyWith(isBotTyping: true));
          _typingIndicatorTimer?.cancel();
          _typingIndicatorTimer = Timer(const Duration(seconds: 3), () {
            emit(state.copyWith(isBotTyping: false));
          });
        }
      }
    });

    _hubConnection!.on('isRecording', (arguments) {
      if (arguments != null && arguments.isNotEmpty) {
        final senderId = arguments[0].toString();
        if (senderId == userProfile.id.toString()) {
          emit(state.copyWith(isRecording: true));
        }
      }
    });

    _hubConnection!.on('stopRecording', (arguments) {
      if (arguments != null && arguments.isNotEmpty) {
        final senderId = arguments[0].toString();
        if (senderId == userProfile.id.toString()) {
          emit(state.copyWith(isRecording: false));
        }
      }
    });

    _hubConnection!.on('sendlargemessage', (arguments) async {
      if (arguments != null && arguments.length >= 8) {
        try {
          final senderId = arguments[0].toString();
          final messageSize = arguments[1] as int;
          final chunkIndex = arguments[2] as int;
          final chunk = arguments[3] as String;
          final finished = arguments[4] as bool;
          final time = arguments[5] as String;
          final messageId = arguments[6] as String;
          final senderDetails = arguments.length > 8 ? arguments[8] : null;

          final bufferKey = '$senderId:$messageId';
          if (!_audioMessageBuffer.containsKey(bufferKey)) {
            _audioMessageBuffer[bufferKey] = {
              'chunks': List<String?>.filled((messageSize ~/ 1000) + 100, null),
              'receivedSize': 0,
              'messageSize': messageSize,
              'time': time,
              'senderName': senderDetails is Map
                  ? senderDetails['username'] ?? 'Unknown'
                  : senderDetails is String
                      ? senderDetails
                      : 'Unknown',
            };
          }

          final buffer = _audioMessageBuffer[bufferKey];
          final List<String?> chunksList = buffer['chunks'];

          if (chunkIndex < chunksList.length) {
            chunksList[chunkIndex] = chunk;
            buffer['receivedSize'] =
                (buffer['receivedSize'] as int) + chunk.length;
          } else {
            final newSize = chunkIndex + 50;
            final newChunks = List<String?>.filled(newSize, null);
            for (var i = 0; i < chunksList.length; i++) {
              newChunks[i] = chunksList[i];
            }
            newChunks[chunkIndex] = chunk;
            buffer['chunks'] = newChunks;
            buffer['receivedSize'] =
                (buffer['receivedSize'] as int) + chunk.length;
          }

          if (finished &&
              (buffer['receivedSize'] as int) >= messageSize * 0.95) {
            final base64Audio =
                chunksList.where((element) => element != null).join('');
            if (base64Audio.isNotEmpty) {
              final tempDir = await getTemporaryDirectory();
              final tempPath = '${tempDir.path}/audio_$messageId.aac';
              final file = File(tempPath);
              await file.writeAsBytes(base64Decode(base64Audio));

              final senderName = buffer['senderName'] as String;
              if (senderId == userProfile.id.toString()) {
                final messages =
                    List<Map<String, dynamic>>.from(state.chatMessages)
                      ..add({
                        'sender': 'other',
                        'type': 'audio',
                        'audioData': base64Audio,
                        'filePath': tempPath,
                        'time': buffer['time'],
                        'username': senderName,
                        'messageId': messageId,
                      });
                emit(state.copyWith(
                  chatMessages: messages,
                  forceRefresh: !state.forceRefresh,
                  isBotTyping: false,
                ));
                await saveMessages();
                await _hubConnection!
                    .invoke('Confirmation', args: [senderId, messageId]);
              } else {
                if (!notSeen.containsKey(senderId)) {
                  notSeen[senderId] = [];
                }
                notSeen[senderId]!.add({
                  'type': 'audio',
                  'audioData': base64Audio,
                  'filePath': tempPath,
                  'time': buffer['time'],
                  'sender': senderName,
                  'messageId': messageId,
                });
              }
            }
            _audioMessageBuffer.remove(bufferKey);
          }
        } catch (e) {
          debugPrint('Error processing large message: $e');
        }
      }
    });

    _hubConnection!.on('CheckPendingMasseges', (arguments) {
      if (arguments != null && arguments.isNotEmpty) {
        try {
          final messagesList = arguments[0] as List;
          for (var messageData in messagesList) {
            final senderId = messageData['senderId'] ?? '';
            final message = messageData['message'] ?? '';
            final senderName = messageData['senderName'] ?? 'Unknown';
            final messageTime = messageData['messageTime'] ?? _getCurrentTime();
            final messageId = messageData['messageId'];
            if (senderId == userProfile.id.toString()) {
              _processReceivedMessage(
                  senderName, message, messageTime, null, messageId);
            } else {
              _storeNotSeenMessage(senderId, message, senderName);
            }
          }
        } catch (e) {
          debugPrint('Error checking pending messages: $e');
        }
      }
    });

    _hubConnection!.on('Confirmation', (arguments) {
      debugPrint('Message delivered');
    });

    _hubConnection!.onclose(({error}) {
      debugPrint('Connection closed: $error');
      emit(state.copyWith(connectionStatus: ConnectionStatus.disconnected));
      _scheduleReconnect();
    } as ClosedCallback);
  }

  void handleTextInput(String value, TextEditingController controller) {
    if (value == '\n') {
      controller.clear();
      return;
    }

    final direction = _rtlRegex.hasMatch(value)
        ? TextInputDirection.rtl
        : TextInputDirection.ltr;
    emit(state.copyWith(textDirection: direction));

    if (value.length % 10 == 1) {
      sendTypingNotification();
    }
  }

  TextDirection getTextDirection() {
    return state.textDirection == TextInputDirection.rtl
        ? TextDirection.rtl
        : TextDirection.ltr;
  }

  void hideViewAdsAction() {
    emit(state.copyWith(showViewAdsAction: false));
  }

  Future<void> sendMessage(String message) async {
    if (message.trim().isEmpty) return;

    final currentTime = _getCurrentTime();
    final userMessage = {
      'sender': 'user',
      'text': message,
      'time': currentTime,
    };
    _addMessage(userMessage);

    if (_hubConnection?.state != HubConnectionState.Connected) {
      _addErrorMessage('Not connected to chat server. Reconnecting...');
      await connectToSignalR();
      await saveMessages();
      return;
    }

    try {
      final messageId = '${_getFormattedTimeForId()}${message}${++idCounter}'
          .replaceAll(RegExp(r'\s'), '');
      await _hubConnection!.invoke('SendPrivateMessage',
          args: [userProfile.id.toString(), message, messageId, '']);
      await saveMessages();
    } catch (e) {
      debugPrint('Error sending message: $e');
      _addErrorMessage('Message will be sent when connection is restored.');
      await saveMessages();
      _processNotSentMessages();
    }
  }

  void sendTypingNotification() {
    if (_hubConnection?.state == HubConnectionState.Connected) {
      try {
        _hubConnection!.invoke('IsTyping', args: [userProfile.id.toString()]);
      } catch (e) {
        debugPrint('Error sending typing notification: $e');
      }
    }
  }

  void sendRecordingNotification(bool isRecording) {
    if (_hubConnection?.state == HubConnectionState.Connected) {
      try {
        final method = isRecording ? 'isRecording' : 'stopRecording';
        _hubConnection!.invoke(method, args: [userProfile.id.toString()]);
      } catch (e) {
        debugPrint('Error sending recording notification: $e');
      }
    }
  }

  void sendAudioMessage({
    required String audioData,
    required String duration,
    required String filePath,
  }) {
    final messageId = 'audio_${_getFormattedTimeForId()}_${++idCounter}';
    try {
      if (_hubConnection?.state == HubConnectionState.Connected) {
        final chunkSize = 5000;
        final totalChunks = (audioData.length / chunkSize).ceil();
        for (var i = 0; i < totalChunks; i++) {
          final start = i * chunkSize;
          final end = (i + 1) * chunkSize;
          final chunk = audioData.substring(
              start, end > audioData.length ? audioData.length : end);
          final isLastChunk = i == totalChunks - 1;
          _hubConnection!.invoke('SendLargeMessage', args: [
            userProfile.id.toString(),
            audioData.length,
            i,
            chunk,
            isLastChunk,
            messageId,
            '',
          ]);
        }
      } else {
        notSent.add({
          'type': 'audio',
          'audioData': audioData,
          'duration': duration,
          'filePath': filePath,
          'receiverId': userProfile.id.toString(),
          'time': _getCurrentTime(),
        });
      }

      final messages = List<Map<String, dynamic>>.from(state.chatMessages)
        ..add({
          'sender': 'user',
          'type': 'audio',
          'audioData': audioData,
          'duration': duration,
          'filePath': filePath,
          'time': _getCurrentTime(),
        });
      emit(state.copyWith(
        chatMessages: messages,
        forceRefresh: !state.forceRefresh,
      ));
      saveMessages();
    } catch (e) {
      debugPrint('Error sending audio message: $e');
    }
  }

  void _addMessage(Map<String, dynamic> message) {
    final updatedMessages = List<Map<String, dynamic>>.from(state.chatMessages)
      ..add(message);
    emit(state.copyWith(
      chatMessages: updatedMessages,
      forceRefresh: !state.forceRefresh,
      isBotTyping: false,
    ));
    saveMessages();
  }

  void _addErrorMessage(String text) {
    final errorMessage = {
      'sender': 'system',
      'text': text,
      'time': _getCurrentTime(),
    };
    final messages = List<Map<String, dynamic>>.from(state.chatMessages)
      ..add(errorMessage);
    emit(state.copyWith(
      chatMessages: messages,
      forceRefresh: !state.forceRefresh,
    ));
  }

  void _processReceivedMessage(
    String senderName,
    String messageText,
    String messageTime,
    String? messageRef,
    String? messageId,
  ) {
    final message = {
      'sender': 'other',
      'username': senderName,
      'text': messageText,
      'time': messageTime,
      'ref': messageRef,
      'id': messageId,
    };
    _addMessage(message);
  }

  void _storeNotSeenMessage(
      String senderId, String messageText, String senderName) {
    notSeen.putIfAbsent(senderId, () => []).add({
      'message': messageText,
      'time': _getCurrentTime(),
      'sender': senderName,
    });
  }

  Future<void> _processNotSentMessages() async {
    _messageQueueTimer?.cancel();
    if (notSent.isEmpty) return;

    if (_hubConnection?.state != HubConnectionState.Connected) {
      _messageQueueTimer =
          Timer(const Duration(seconds: 5), _processNotSentMessages);
      return;
    }

    _messageQueueTimer =
        Timer.periodic(const Duration(seconds: 1), (timer) async {
      if (notSent.isEmpty) {
        timer.cancel();
        _messageQueueTimer = null;
        return;
      }

      if (_hubConnection?.state != HubConnectionState.Connected) {
        timer.cancel();
        _messageQueueTimer =
            Timer(const Duration(seconds: 5), _processNotSentMessages);
        return;
      }

      final message = notSent.removeAt(0);
      try {
        if (message['type'] == 'audio') {
          final audioData = message['audioData'];
          final chunkSize = 5000;
          final totalChunks = (audioData.length / chunkSize).ceil();
          final messageId = 'audio_${_getFormattedTimeForId()}_${++idCounter}';
          for (var i = 0; i < totalChunks; i++) {
            final start = i * chunkSize;
            final end = (i + 1) * chunkSize;
            final chunk = audioData.substring(
                start, end > audioData.length ? audioData.length : end);
            final isLastChunk = i == totalChunks - 1;
            await _hubConnection!.invoke('SendLargeMessage', args: [
              message['receiverId'],
              audioData.length,
              i,
              chunk,
              isLastChunk,
              messageId,
              '',
            ]);
          }
        } else {
          final messageText = message['message'] ?? '';
          final messageId =
              '${_getFormattedTimeForId()}${messageText}${++idCounter}'
                  .replaceAll(RegExp(r'\s'), '');
          await _hubConnection!.invoke('SendPrivateMessage',
              args: [message['receiverId'], messageText, messageId, '']);
        }
      } catch (e) {
        debugPrint('Error processing unsent message: $e');
        notSent.insert(0, message);
        timer.cancel();
        _messageQueueTimer =
            Timer(const Duration(seconds: 5), _processNotSentMessages);
      }
    });
  }

  void _scheduleReconnect() {
    _cancelReconnectTimer();
    _reconnectTimer = Timer(const Duration(seconds: 5), connectToSignalR);
  }

  void _cancelReconnectTimer() {
    _reconnectTimer?.cancel();
    _reconnectTimer = null;
  }

  void disconnectSignalR() {
    _cancelReconnectTimer();
    _typingIndicatorTimer?.cancel();
    _messageQueueTimer?.cancel();
    _hubConnection?.stop();
    _hubConnection = null;
  }

  String _getCurrentTime() => DateFormat('hh:mm a').format(DateTime.now());

  String _getFormattedTimeForId() {
    final now = DateTime.now();
    return '${now.hour}:${now.minute}:${now.second}';
  }

  List<Map<String, dynamic>> getUnseenMessages(String userId) =>
      notSeen[userId] ?? [];

  void clearUnseenMessages(String userId) => notSeen.remove(userId);

  @override
  Future<void> close() {
    _typingIndicatorTimer?.cancel();
    disconnectSignalR();
    return super.close();
  }
}

class ChatState {
  final List<Map<String, dynamic>> chatMessages;
  final bool isBotTyping;
  final bool showViewAdsAction;
  final bool forceRefresh;
  final ConnectionStatus connectionStatus;
  final String currentUsername;
  final String myUserId;
  final TextInputDirection textDirection;
  final bool isRecording;

  const ChatState({
    this.chatMessages = const [],
    this.isBotTyping = false,
    this.showViewAdsAction = true,
    this.forceRefresh = false,
    this.connectionStatus = ConnectionStatus.disconnected,
    this.currentUsername = '',
    this.myUserId = '',
    this.textDirection = TextInputDirection.ltr,
    this.isRecording = false,
  });

  factory ChatState.initial() => const ChatState();

  ChatState copyWith({
    List<Map<String, dynamic>>? chatMessages,
    bool? isBotTyping,
    bool? showViewAdsAction,
    bool? forceRefresh,
    ConnectionStatus? connectionStatus,
    String? currentUsername,
    String? myUserId,
    TextInputDirection? textDirection,
    bool? isRecording,
  }) {
    return ChatState(
      chatMessages: chatMessages ?? this.chatMessages,
      isBotTyping: isBotTyping ?? this.isBotTyping,
      showViewAdsAction: showViewAdsAction ?? this.showViewAdsAction,
      forceRefresh: forceRefresh ?? this.forceRefresh,
      connectionStatus: connectionStatus ?? this.connectionStatus,
      currentUsername: currentUsername ?? this.currentUsername,
      myUserId: myUserId ?? this.myUserId,
      textDirection: textDirection ?? this.textDirection,
      isRecording: isRecording ?? this.isRecording,
    );
  }
}
