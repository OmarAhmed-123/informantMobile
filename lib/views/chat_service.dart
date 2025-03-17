/*
/*
import 'package:shared_preferences/shared_preferences.dart';
import 'package:signalr_core/signalr_core.dart';

class ChatService {
  late HubConnection _hubConnection;

  Future<void> connect() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('CookieToken');
    String? ptoken = prefs.getString('pToken');

    _hubConnection = HubConnectionBuilder()
        .withUrl(
          'https://infinitely-native-lamprey.ngrok-free.app/chatHub',
          options: HttpConnectionOptions(
            accessTokenFactory: () async => token ?? '',
            headers: {
              'Authorization': 'Bearer $token',
              'AuthorizationPtoken': ptoken ?? '',
            },
          ),
        )
        .build();

    await _hubConnection.start();
  }

  void onReceiveMessage(Function(String, String) onMessageReceived) {
    _hubConnection.on('ReceiveMessage', (arguments) {
      final sender = arguments?[0] as String? ?? '';
      final message = arguments?[1] as String? ?? '';
      onMessageReceived(sender, message);
    });
  }

  void sendMessage(String message, String sender) {
    if (message.trim().isEmpty) return;
    _hubConnection.invoke('SendMessage', args: [sender, message]);
  }

  Future<void> disconnect() async {
    await _hubConnection.stop();
  }
}
*/
import 'package:shared_preferences/shared_preferences.dart';
import 'package:signalr_core/signalr_core.dart';

class ChatService {
  late HubConnection _hubConnection;

  Future<void> connect() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('CookieToken');

    _hubConnection = HubConnectionBuilder()
        .withUrl(
          'https://infinitely-native-lamprey.ngrok-free.app/chat',
          HttpConnectionOptions(
            accessTokenFactory: () async => token ?? '',
            transport: HttpTransportType
                .webSockets, // Ensure WebSocket transport is used
            logging: (level, message) =>
                print("SignalR Log: $message"), // Optional logging
          ),
        )
        .build();

    // Handling connection events
    _hubConnection.onclose((error) => print("Connection closed: $error"));
    _hubConnection.onreconnecting((error) => print("Reconnecting: $error"));
    _hubConnection
        .onreconnected((connectionId) => print("Reconnected: $connectionId"));

    try {
      await _hubConnection.start();
      print("Connected to SignalR");
    } catch (e) {
      print("SignalR connection error: $e");
    }
  }

  void onReceiveMessage(Function(String, String) onMessageReceived) {
    _hubConnection.on('ReceiveMessage', (arguments) {
      if (arguments != null && arguments.length >= 2) {
        final sender = arguments[0] as String? ?? 'Unknown';
        final message = arguments[1] as String? ?? '';
        onMessageReceived(sender, message);
      }
    });
  }

  void sendMessage(String message, String sender) {
    if (message.trim().isEmpty) return;
    _hubConnection.invoke('SendMessage', args: [sender, message]).catchError(
        (error) => print("Error sending message: $error"));
  }

  Future<void> disconnect() async {
    await _hubConnection.stop();
    print("Disconnected from SignalR");
  }
}
*/

/*
import 'dart:convert';
import 'dart:io';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:signalr_core/signalr_core.dart';
import 'package:flutter/foundation.dart';
import 'package:path_provider/path_provider.dart';

class ChatUser {
  final String userId;
  final String username;
  final String? profileImage;
  final bool isOnline;

  ChatUser({
    required this.userId,
    required this.username,
    this.profileImage,
    this.isOnline = false,
  });

  factory ChatUser.fromJson(Map<String, dynamic> json) {
    return ChatUser(
      userId: json['userId'] ?? '',
      username: json['username'] ?? '',
      profileImage: json['profileImage'],
      isOnline: json['isOnline'] ?? false,
    );
  }
}

enum MessageType { text, audio, image, video }

class ChatMessage {
  final String id;
  final String senderId;
  final String receiverId;
  final String content;
  final DateTime timestamp;
  final MessageType type;
  final bool isRead;

  ChatMessage({
    required this.id,
    required this.senderId,
    required this.receiverId,
    required this.content,
    required this.timestamp,
    this.type = MessageType.text,
    this.isRead = false,
  });

  factory ChatMessage.fromJson(Map<String, dynamic> json) {
    return ChatMessage(
      id: json['id'] ?? '',
      senderId: json['senderId'] ?? '',
      receiverId: json['receiverId'] ?? '',
      content: json['content'] ?? '',
      timestamp: json['timestamp'] != null
          ? DateTime.parse(json['timestamp'])
          : DateTime.now(),
      type: _parseMessageType(json['type']),
      isRead: json['isRead'] ?? false,
    );
  }

  static MessageType _parseMessageType(String? type) {
    switch (type) {
      case 'audio':
        return MessageType.audio;
      case 'image':
        return MessageType.image;
      case 'video':
        return MessageType.video;
      default:
        return MessageType.text;
    }
  }
}

class CallInfo {
  final String callerId;
  final String callerName;
  final bool isVideoCall;

  CallInfo({
    required this.callerId,
    required this.callerName,
    this.isVideoCall = false,
  });
}

class ChatService {
  late HubConnection _hubConnection;
  final List<ChatUser> _onlineUsers = [];
  List<ChatUser> get onlineUsers => List.unmodifiable(_onlineUsers);

  String? _currentUserId;
  String? get currentUserId => _currentUserId;

  // Callbacks
  Function(List<ChatUser>)? onUsersUpdated;
  Function(ChatMessage)? onMessageReceived;
  Function(String)? onTyping;
  Function(CallInfo)? onIncomingCall;
  Function(String)? onCallAccepted;
  Function(String)? onCallRejected;
  Function(String)? onCallEnded;

  Future<void> connect() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('CookieToken');
    _currentUserId = prefs.getString('UserId');

    _hubConnection = HubConnectionBuilder()
        .withUrl(
      'https://infinitely-native-lamprey.ngrok-free.app/chat',
      HttpConnectionOptions(
        accessTokenFactory: () async => token ?? '',
        transport: HttpTransportType.webSockets,
        skipNegotiation: true,
        logging: (level, message) => print("SignalR: $message"),
      ),
    )
        .withAutomaticReconnect()
        .build();

    // Setup SignalR event handlers
    _setupEventHandlers();

    try {
      await _hubConnection.start();
      print("Connected to SignalR hub");

      // Get initial online users list
      await getOnlineUsers();
    } catch (e) {
      print("SignalR connection error: $e");
    }
  }

  void _setupEventHandlers() {
    // Connection lifecycle events
    _hubConnection.onclose((error) => print("Connection closed: $error"));
    _hubConnection.onreconnecting((error) => print("Reconnecting: $error"));
    _hubConnection.onreconnected((connectionId) {
      print("Reconnected: $connectionId");
      getOnlineUsers(); // Refresh users list after reconnection
    });

    // Chat-specific events
    _hubConnection.on('ReceiveMessage', (arguments) {
      if (arguments != null && arguments.length >= 1) {
        final messageData = arguments[0] as Map<String, dynamic>? ?? {};
        final message = ChatMessage.fromJson(messageData);
        if (onMessageReceived != null) {
          onMessageReceived!(message);
        }
      }
    });

    _hubConnection.on('UpdateOnlineUsers', (arguments) {
      if (arguments != null && arguments.length >= 1) {
        final List<dynamic> usersData = arguments[0] as List<dynamic>? ?? [];
        _onlineUsers.clear();
        _onlineUsers.addAll(
          usersData.map((userData) => ChatUser.fromJson(userData)).toList(),
        );

        if (onUsersUpdated != null) {
          onUsersUpdated!(_onlineUsers);
        }
      }
    });

    _hubConnection.on('UserTyping', (arguments) {
      if (arguments != null && arguments.length >= 1) {
        final userId = arguments[0] as String? ?? '';
        if (onTyping != null) {
          onTyping!(userId);
        }
      }
    });

    // Call-related events
    _hubConnection.on('IncomingCall', (arguments) {
      if (arguments != null && arguments.length >= 3) {
        final callerId = arguments[0] as String? ?? '';
        final callerName = arguments[1] as String? ?? '';
        final isVideo = arguments[2] as bool? ?? false;

        if (onIncomingCall != null) {
          onIncomingCall!(CallInfo(
            callerId: callerId,
            callerName: callerName,
            isVideoCall: isVideo,
          ));
        }
      }
    });

    _hubConnection.on('CallAccepted', (arguments) {
      if (arguments != null && arguments.length >= 1) {
        final receiverId = arguments[0] as String? ?? '';
        if (onCallAccepted != null) {
          onCallAccepted!(receiverId);
        }
      }
    });

    _hubConnection.on('CallRejected', (arguments) {
      if (arguments != null && arguments.length >= 1) {
        final receiverId = arguments[0] as String? ?? '';
        if (onCallRejected != null) {
          onCallRejected!(receiverId);
        }
      }
    });

    _hubConnection.on('CallEnded', (arguments) {
      if (arguments != null && arguments.length >= 1) {
        final userId = arguments[0] as String? ?? '';
        if (onCallEnded != null) {
          onCallEnded!(userId);
        }
      }
    });
  }

  // User list methods
  Future<void> getOnlineUsers() async {
    try {
      final result = await _hubConnection.invoke('GetOnlineUsers');
      if (result != null) {
        final List<dynamic> usersData = result as List<dynamic>;
        _onlineUsers.clear();
        _onlineUsers.addAll(
          usersData.map((userData) => ChatUser.fromJson(userData)).toList(),
        );

        if (onUsersUpdated != null) {
          onUsersUpdated!(_onlineUsers);
        }
      }
    } catch (e) {
      print("Error getting online users: $e");
    }
  }

  // Messaging methods
  Future<void> sendMessage(String receiverId, String content, {MessageType type = MessageType.text}) async {
    if (content.trim().isEmpty) return;

    try {
      await _hubConnection.invoke('SendMessage', args: [
        receiverId,
        content,
        type.toString().split('.').last,
      ]);
    } catch (e) {
      print("Error sending message: $e");
    }
  }

  Future<void> sendTypingNotification(String receiverId) async {
    try {
      await _hubConnection.invoke('SendTypingNotification', args: [receiverId]);
    } catch (e) {
      print("Error sending typing notification: $e");
    }
  }

  // Call-related methods
  Future<void> initiateCall(String receiverId, bool isVideoCall) async {
    try {
      await _hubConnection.invoke('InitiateCall', args: [receiverId, isVideoCall]);
    } catch (e) {
      print("Error initiating call: $e");
    }
  }

  Future<void> acceptCall(String callerId) async {
    try {
      await _hubConnection.invoke('AcceptCall', args: [callerId]);
    } catch (e) {
      print("Error accepting call: $e");
    }
  }

  Future<void> rejectCall(String callerId) async {
    try {
      await _hubConnection.invoke('RejectCall', args: [callerId]);
    } catch (e) {
      print("Error rejecting call: $e");
    }
  }

  Future<void> endCall(String peerId) async {
    try {
      await _hubConnection.invoke('EndCall', args: [peerId]);
    } catch (e) {
      print("Error ending call: $e");
    }
  }

  // File handling methods
  Future<String> saveAudioMessage(Uint8List audioBytes) async {
    try {
      final directory = await getApplicationDocumentsDirectory();
      final filePath = '${directory.path}/audio_${DateTime.now().millisecondsSinceEpoch}.m4a';
      final file = File(filePath);
      await file.writeAsBytes(audioBytes);
      return filePath;
    } catch (e) {
      print("Error saving audio: $e");
      return '';
    }
  }

  Future<void> disconnect() async {
    try {
      await _hubConnection.stop();
      print("Disconnected from SignalR hub");
    } catch (e) {
      print("Error disconnecting: $e");
    }
  }
}
*/

import 'dart:io';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:signalr_core/signalr_core.dart';
import 'package:flutter/foundation.dart';
import 'package:path_provider/path_provider.dart';

class ChatUser {
  final String userId;
  final String username;
  final String? profileImage;
  final bool isOnline;

  ChatUser({
    required this.userId,
    required this.username,
    this.profileImage,
    this.isOnline = false,
  });

  factory ChatUser.fromJson(Map<String, dynamic> json) {
    return ChatUser(
      userId: json['userId'] ?? '',
      username: json['username'] ?? '',
      profileImage: json['profileImage'],
      isOnline: json['isOnline'] ?? false,
    );
  }
}

enum MessageType { text, audio, image, video }

class ChatMessage {
  final String id;
  final String senderId;
  final String receiverId;
  final String content;
  final DateTime timestamp;
  final MessageType type;
  final bool isRead;

  ChatMessage({
    required this.id,
    required this.senderId,
    required this.receiverId,
    required this.content,
    required this.timestamp,
    this.type = MessageType.text,
    this.isRead = false,
  });

  factory ChatMessage.fromJson(Map<String, dynamic> json) {
    return ChatMessage(
      id: json['id'] ?? '',
      senderId: json['senderId'] ?? '',
      receiverId: json['receiverId'] ?? '',
      content: json['content'] ?? '',
      timestamp: json['timestamp'] != null
          ? DateTime.parse(json['timestamp'])
          : DateTime.now(),
      type: _parseMessageType(json['type']),
      isRead: json['isRead'] ?? false,
    );
  }

  static MessageType _parseMessageType(String? type) {
    switch (type) {
      case 'audio':
        return MessageType.audio;
      case 'image':
        return MessageType.image;
      case 'video':
        return MessageType.video;
      default:
        return MessageType.text;
    }
  }
}

class CallInfo {
  final String callerId;
  final String callerName;
  final bool isVideoCall;

  CallInfo({
    required this.callerId,
    required this.callerName,
    this.isVideoCall = false,
  });
}

class ChatService {
  late HubConnection _hubConnection;
  final List<ChatUser> _onlineUsers = [];
  List<ChatUser> get onlineUsers => List.unmodifiable(_onlineUsers);

  String? _currentUserId;
  String? get currentUserId => _currentUserId;

  // Callbacks
  Function(List<ChatUser>)? onUsersUpdated;
  Function(ChatMessage)? onMessageReceived;
  Function(String)? onTyping;
  Function(CallInfo)? onIncomingCall;
  Function(String)? onCallAccepted;
  Function(String)? onCallRejected;
  Function(String)? onCallEnded;

  Future<void> connect() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('CookieToken');
    _currentUserId = prefs.getString('UserId');

    _hubConnection = HubConnectionBuilder()
        .withUrl(
          'https://infinitely-native-lamprey.ngrok-free.app/chat',
          HttpConnectionOptions(
            accessTokenFactory: () async => token ?? '',
            transport: HttpTransportType.webSockets,
            skipNegotiation: true,
            logging: (level, message) => print("SignalR: $message"),
          ),
        )
        .withAutomaticReconnect()
        .build();

    // Setup SignalR event handlers
    _setupEventHandlers();

    try {
      await _hubConnection.start();
      print("Connected to SignalR hub");

      // Get initial online users list
      await getOnlineUsers();
    } catch (e) {
      print("SignalR connection error: $e");
    }
  }

  void _setupEventHandlers() {
    // Connection lifecycle events
    _hubConnection.onclose((error) => print("Connection closed: $error"));
    _hubConnection.onreconnecting((error) => print("Reconnecting: $error"));
    _hubConnection.onreconnected((connectionId) {
      print("Reconnected: $connectionId");
      getOnlineUsers(); // Refresh users list after reconnection
    });

    // Chat-specific events
    _hubConnection.on('ReceiveMessage', (arguments) {
      if (arguments != null && arguments.length >= 1) {
        final messageData = arguments[0] as Map<String, dynamic>? ?? {};
        final message = ChatMessage.fromJson(messageData);
        if (onMessageReceived != null) {
          onMessageReceived!(message);
        }
      }
    });

    _hubConnection.on('UpdateOnlineUsers', (arguments) {
      if (arguments != null && arguments.length >= 1) {
        final List<dynamic> usersData = arguments[0] as List<dynamic>? ?? [];
        _onlineUsers.clear();
        _onlineUsers.addAll(
          usersData.map((userData) => ChatUser.fromJson(userData)).toList(),
        );

        if (onUsersUpdated != null) {
          onUsersUpdated!(_onlineUsers);
        }
      }
    });

    _hubConnection.on('UserTyping', (arguments) {
      if (arguments != null && arguments.length >= 1) {
        final userId = arguments[0] as String? ?? '';
        if (onTyping != null) {
          onTyping!(userId);
        }
      }
    });

    // Call-related events
    _hubConnection.on('IncomingCall', (arguments) {
      if (arguments != null && arguments.length >= 3) {
        final callerId = arguments[0] as String? ?? '';
        final callerName = arguments[1] as String? ?? '';
        final isVideo = arguments[2] as bool? ?? false;

        if (onIncomingCall != null) {
          onIncomingCall!(CallInfo(
            callerId: callerId,
            callerName: callerName,
            isVideoCall: isVideo,
          ));
        }
      }
    });

    _hubConnection.on('CallAccepted', (arguments) {
      if (arguments != null && arguments.length >= 1) {
        final receiverId = arguments[0] as String? ?? '';
        if (onCallAccepted != null) {
          onCallAccepted!(receiverId);
        }
      }
    });

    _hubConnection.on('CallRejected', (arguments) {
      if (arguments != null && arguments.length >= 1) {
        final receiverId = arguments[0] as String? ?? '';
        if (onCallRejected != null) {
          onCallRejected!(receiverId);
        }
      }
    });

    _hubConnection.on('CallEnded', (arguments) {
      if (arguments != null && arguments.length >= 1) {
        final userId = arguments[0] as String? ?? '';
        if (onCallEnded != null) {
          onCallEnded!(userId);
        }
      }
    });
  }

  // User list methods
  Future<void> getOnlineUsers() async {
    try {
      final result = await _hubConnection.invoke('GetOnlineUsers');
      if (result != null) {
        final List<dynamic> usersData = result as List<dynamic>;
        _onlineUsers.clear();
        _onlineUsers.addAll(
          usersData.map((userData) => ChatUser.fromJson(userData)).toList(),
        );

        if (onUsersUpdated != null) {
          onUsersUpdated!(_onlineUsers);
        }
      }
    } catch (e) {
      print("Error getting online users: $e");
    }
  }

  // Messaging methods
  Future<void> sendMessage(String receiverId, String content,
      {MessageType type = MessageType.text}) async {
    if (content.trim().isEmpty) return;

    try {
      await _hubConnection.invoke('SendMessage', args: [
        receiverId,
        content,
        type.toString().split('.').last,
      ]);
    } catch (e) {
      print("Error sending message: $e");
    }
  }

  Future<void> sendTypingNotification(String receiverId) async {
    try {
      await _hubConnection.invoke('SendTypingNotification', args: [receiverId]);
    } catch (e) {
      print("Error sending typing notification: $e");
    }
  }

  // Call-related methods
  Future<void> initiateCall(String receiverId, bool isVideoCall) async {
    try {
      await _hubConnection
          .invoke('InitiateCall', args: [receiverId, isVideoCall]);
    } catch (e) {
      print("Error initiating call: $e");
    }
  }

  Future<void> acceptCall(String callerId) async {
    try {
      await _hubConnection.invoke('AcceptCall', args: [callerId]);
    } catch (e) {
      print("Error accepting call: $e");
    }
  }

  Future<void> rejectCall(String callerId) async {
    try {
      await _hubConnection.invoke('RejectCall', args: [callerId]);
    } catch (e) {
      print("Error rejecting call: $e");
    }
  }

  Future<void> endCall(String peerId) async {
    try {
      await _hubConnection.invoke('EndCall', args: [peerId]);
    } catch (e) {
      print("Error ending call: $e");
    }
  }

  // File handling methods
  Future<String> saveAudioMessage(Uint8List audioBytes) async {
    try {
      final directory = await getApplicationDocumentsDirectory();
      final filePath =
          '${directory.path}/audio_${DateTime.now().millisecondsSinceEpoch}.m4a';
      final file = File(filePath);
      await file.writeAsBytes(audioBytes);
      return filePath;
    } catch (e) {
      print("Error saving audio: $e");
      return '';
    }
  }

  Future<void> disconnect() async {
    try {
      await _hubConnection.stop();
      print("Disconnected from SignalR hub");
    } catch (e) {
      print("Error disconnecting: $e");
    }
  }
}
