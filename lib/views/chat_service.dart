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
              'Authentication': ' $token',
              'AuthenticationPtoken': ptoken ?? '',
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
      await getOnlinePeople();
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
      getOnlinePeople(); // Refresh users list after reconnection
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
  Future<void> getOnlinePeople() async {
    try {
      final result = await _hubConnection.invoke('GetOnlinePeople');
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

    if (token == null || _currentUserId == null) {
      throw Exception("Token or UserId is missing");
    }

    // Encode the token for the URL
    final encodedToken = Uri.encodeComponent(token);

    // Construct the URL with the token
    final url =
        'https://infinitely-native-lamprey.ngrok-free.app/chat?Authentication=$encodedToken';

    _hubConnection = HubConnectionBuilder()
        .withUrl(
          url,
          HttpConnectionOptions(
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
      await getOnlinePeople();
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
      getOnlinePeople(); // Refresh users list after reconnection
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
  Future<void> getOnlinePeople() async {
    try {
      final result = await _hubConnection.invoke('GetOnlinePeople');
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

    if (token == null || _currentUserId == null) {
      throw Exception("Token or UserId is missing");
    }

    // Encode the token for the URL
    final encodedToken = Uri.encodeComponent(token);

    // Construct the URL with the token
    final url =
        'https://infinitely-native-lamprey.ngrok-free.app/chat?Authentication=$encodedToken';

    _hubConnection = HubConnectionBuilder()
        .withUrl(
          url,
          HttpConnectionOptions(
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
      await getOnlinePeople();
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
      getOnlinePeople(); // Refresh users list after reconnection
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
  Future<void> getOnlinePeople() async {
    try {
      final result = await _hubConnection.invoke('GetOnlinePeople');
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
*/

/*
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

  bool _isConnected = false;
  bool get isConnected => _isConnected;

  Future<void> connect() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString('CookieToken');
      _currentUserId = prefs.getString('UserId');
      // If token or userId is missing, create mock values for testing
      if (token == null || _currentUserId == null) {
        token = 'mock-token-${DateTime.now().millisecondsSinceEpoch}';
        _currentUserId = 'user-${DateTime.now().millisecondsSinceEpoch}';
        // Save mock values
        await prefs.setString('CookieToken', token);
        await prefs.setString('UserId', _currentUserId!);
        print("Created mock token and userId for testing");
      }
      // For testing, use a dummy URL if the real one fails
      String url = 'https://infinitely-native-lamprey.ngrok-free.app/chat';

      try {
        _hubConnection = HubConnectionBuilder()
            .withUrl(
              url,
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
        await _hubConnection.start();
        _isConnected = true;
        print("Connected to SignalR hub");
        // Get initial online users list
        await getOnlinePeople();
      } catch (e) {
        print("Could not connect to real SignalR hub: $e");
        // Create mock users for testing
        _mockOnlineUsers();
        // Notify that we're using mocked data
        print("Using mocked chat data for testing");
      }
    } catch (e) {
      print("Connection setup error: $e");
      // Create mock users for testing
      _mockOnlineUsers();
    }
  }

  void _mockOnlineUsers() {
    // Add some mock users for UI testing
    _onlineUsers.clear();
    _onlineUsers.addAll([
      ChatUser(userId: 'user1', username: 'John Doe', isOnline: true),
      ChatUser(userId: 'user2', username: 'Jane Smith', isOnline: true),
      ChatUser(userId: 'user3', username: 'Mike Johnson', isOnline: false),
    ]);

    if (onUsersUpdated != null) {
      onUsersUpdated!(_onlineUsers);
    }
  }

  void _setupEventHandlers() {
    // Only setup if connection exists
    if (!_isConnected) return;

    // Connection lifecycle events
    _hubConnection.onclose((error) => print("Connection closed: $error"));
    _hubConnection.onreconnecting((error) => print("Reconnecting: $error"));
    _hubConnection.onreconnected((connectionId) {
      print("Reconnected: $connectionId");
      getOnlinePeople(); // Refresh users list after reconnection
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
  Future<void> getOnlinePeople() async {
    if (!_isConnected) return;

    try {
      final result = await _hubConnection.invoke('GetOnlinePeople');
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

    if (_isConnected) {
      try {
        await _hubConnection.invoke('SendMessage', args: [
          receiverId,
          content,
          type.toString().split('.').last,
        ]);
      } catch (e) {
        print("Error sending message: $e");
        // Create a mock message for testing
        _mockMessageReceived(receiverId, content, type);
      }
    } else {
      // Create a mock message for testing
      _mockMessageReceived(receiverId, content, type);
    }
  }

  void _mockMessageReceived(
      String receiverId, String content, MessageType type) {
    // Create mock message for testing
    final mockMessage = ChatMessage(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      senderId: receiverId, // Simulate receiving a message
      receiverId: _currentUserId ?? 'mock-user',
      content: type == MessageType.text ? "Mock response: $content" : content,
      timestamp: DateTime.now(),
      type: type,
      isRead: false,
    );

    if (onMessageReceived != null) {
      // Simulate delay for realism
      Future.delayed(const Duration(milliseconds: 500), () {
        onMessageReceived!(mockMessage);
      });
    }
  }

  Future<void> sendTypingNotification(String receiverId) async {
    if (!_isConnected) return;

    try {
      await _hubConnection.invoke('SendTypingNotification', args: [receiverId]);
    } catch (e) {
      print("Error sending typing notification: $e");
    }
  }

  // Call-related methods
  Future<void> initiateCall(String receiverId, bool isVideoCall) async {
    if (!_isConnected) return;

    try {
      await _hubConnection
          .invoke('InitiateCall', args: [receiverId, isVideoCall]);
    } catch (e) {
      print("Error initiating call: $e");
    }
  }

  Future<void> acceptCall(String callerId) async {
    if (!_isConnected) return;

    try {
      await _hubConnection.invoke('AcceptCall', args: [callerId]);
    } catch (e) {
      print("Error accepting call: $e");
    }
  }

  Future<void> rejectCall(String callerId) async {
    if (!_isConnected) return;

    try {
      await _hubConnection.invoke('RejectCall', args: [callerId]);
    } catch (e) {
      print("Error rejecting call: $e");
    }
  }

  Future<void> endCall(String peerId) async {
    if (!_isConnected) return;

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
    if (_isConnected) {
      try {
        await _hubConnection.stop();
        _isConnected = false;
        print("Disconnected from SignalR hub");
      } catch (e) {
        print("Error disconnecting: $e");
      }
    }
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
import 'package:http/http.dart' as http;

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
      userId: json['userId'] ?? json['id'] ?? '',
      username: json['username'] ?? json['name'] ?? '',
      profileImage: json['profileImage'] ?? json['imageUrl'],
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

  bool _isConnected = false;
  bool get isConnected => _isConnected;

  Future<void> connect() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString('CookieToken');
      _currentUserId = prefs.getString('UserId');

      if (token == null || _currentUserId == null) {
        print("Error: Authentication token or user ID is missing");
        return;
      }

      // Encode token for URL
      String encodedToken = Uri.encodeComponent(token);
      String url =
          'https://infinitely-native-lamprey.ngrok-free.app/chat?Authentication=$encodedToken';

      _hubConnection = HubConnectionBuilder()
          .withUrl(
            url,
            HttpConnectionOptions(
              transport: HttpTransportType.webSockets,
              skipNegotiation: true,
              logging: (level, message) => print("SignalR: $message"),
              reconnectDelays: const [2000, 5000, 10000, 30000],
            ),
          )
          .withAutomaticReconnect()
          .build();

      // Setup SignalR event handlers
      _setupEventHandlers();

      try {
        await _hubConnection.start();
        _isConnected = true;
        print("Connected to SignalR hub");

        // Get initial online users list
        await getOnlinePeople();
      } catch (e) {
        print("SignalR connection error: $e");
        _isConnected = false;
      }
    } catch (e) {
      print("Connection setup error: $e");
      _isConnected = false;
    }
  }

  void _setupEventHandlers() {
    // Connection lifecycle events
    _hubConnection.onclose((error) {
      print("Connection closed: $error");
      _isConnected = false;
    });

    _hubConnection.onreconnecting((error) => print("Reconnecting: $error"));

    _hubConnection.onreconnected((connectionId) {
      print("Reconnected: $connectionId");
      _isConnected = true;
      getOnlinePeople(); // Refresh users list after reconnection
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
  Future<void> getOnlinePeople() async {
    try {
      if (_isConnected) {
        final result = await _hubConnection.invoke('GetOnlinePeople');
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
      } else {
        // Fetch users from REST API instead
        await fetchUsersFromApi();
      }
    } catch (e) {
      print("Error getting online users: $e");
      await fetchUsersFromApi();
    }
  }

  Future<void> fetchUsersFromApi() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString('CookieToken');

      if (token == null) {
        print("Error: Authentication token is missing");
        return;
      }

      final response = await http.get(
        Uri.parse(
            'https://infinitely-native-lamprey.ngrok-free.app/user/users'),
        headers: {
          'Authentication': ' $token',
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final List<dynamic> usersData =
            json.decode(response.body) as List<dynamic>;
        _onlineUsers.clear();
        _onlineUsers.addAll(
          usersData.map((userData) => ChatUser.fromJson(userData)).toList(),
        );

        if (onUsersUpdated != null) {
          onUsersUpdated!(_onlineUsers);
        }
      } else {
        print(
            "Error fetching users: ${response.statusCode} - ${response.body}");
      }
    } catch (e) {
      print("Exception fetching users from API: $e");
    }
  }

  // Messaging methods
  Future<void> sendMessage(String receiverId, String content,
      {MessageType type = MessageType.text}) async {
    if (content.trim().isEmpty) return;

    if (_isConnected) {
      try {
        await _hubConnection.invoke('SendMessage', args: [
          receiverId,
          content,
          type.toString().split('.').last,
        ]);
      } catch (e) {
        print("Error sending message: $e");
      }
    } else {
      print("Cannot send message: not connected to chat server");
    }
  }

  Future<void> sendTypingNotification(String receiverId) async {
    if (!_isConnected) return;

    try {
      await _hubConnection.invoke('SendTypingNotification', args: [receiverId]);
    } catch (e) {
      print("Error sending typing notification: $e");
    }
  }

  // Call-related methods
  Future<void> initiateCall(String receiverId, bool isVideoCall) async {
    if (!_isConnected) return;

    try {
      await _hubConnection
          .invoke('InitiateCall', args: [receiverId, isVideoCall]);
    } catch (e) {
      print("Error initiating call: $e");
    }
  }

  Future<void> acceptCall(String callerId) async {
    if (!_isConnected) return;

    try {
      await _hubConnection.invoke('AcceptCall', args: [callerId]);
    } catch (e) {
      print("Error accepting call: $e");
    }
  }

  Future<void> rejectCall(String callerId) async {
    if (!_isConnected) return;

    try {
      await _hubConnection.invoke('RejectCall', args: [callerId]);
    } catch (e) {
      print("Error rejecting call: $e");
    }
  }

  Future<void> endCall(String peerId) async {
    if (!_isConnected) return;

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
    if (_isConnected) {
      try {
        await _hubConnection.stop();
        _isConnected = false;
        print("Disconnected from SignalR hub");
      } catch (e) {
        print("Error disconnecting: $e");
      }
    }
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
import 'package:dio/dio.dart';

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
      userId: json['userId'] ?? json['id'] ?? '',
      username: json['username'] ?? json['name'] ?? '',
      profileImage: json['profileImage'] ?? json['imageUrl'],
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

  final Dio _dio = Dio();

  // Callbacks
  Function(List<ChatUser>)? onUsersUpdated;
  Function(ChatMessage)? onMessageReceived;
  Function(String)? onTyping;
  Function(CallInfo)? onIncomingCall;
  Function(String)? onCallAccepted;
  Function(String)? onCallRejected;
  Function(String)? onCallEnded;

  bool _isConnected = false;
  bool get isConnected => _isConnected;
  Future<void> connect() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString('CookieToken');
      _currentUserId = prefs.getString('UserId');
      if (token == null || _currentUserId == null) {
        print("Error: Authentication token or user ID is missing");
        return;
      }
      // Set up Dio with default headers
      _dio.options.headers["Authentication"] = " $token";
      _dio.options.headers["Content-Type"] = "application/json";
      // Configure SignalR connection using accessTokenFactory for auth
      final httpConnectionOptions = HttpConnectionOptions(
        transport: HttpTransportType.webSockets,
        skipNegotiation: false,
        accessTokenFactory: () async => token, // Provide token dynamically
        logging: (level, message) => print("SignalR: $message"),
      );
      String encodedToken = Uri.encodeComponent(token);
      // String url ='https://infinitely-native-lamprey.ngrok-free.app/chat?Authentication=$encodedToken';

      _hubConnection = HubConnectionBuilder()
          .withUrl(
            'https://infinitely-native-lamprey.ngrok-free.app/chat?Authentication=$encodedToken',
            httpConnectionOptions,
          )
          .withAutomaticReconnect()
          .build();
      // Setup SignalR event handlers
      _setupEventHandlers();
      try {
        await _hubConnection.start();
        _isConnected = true;
        print("Connected to SignalR hub");
        // Get initial online users list
        await getOnlinePeople();
      } catch (e) {
        print("SignalR connection error: $e");
        _isConnected = false;
        // Try to fetch users from API even if SignalR connection fails
        await fetchUsersFromApi();
      }
    } catch (e) {
      print("Connection setup error: $e");
      _isConnected = false;
    }
  }

  void _setupEventHandlers() {
    // Connection lifecycle events
    _hubConnection.onclose((error) {
      print("Connection closed: $error");
      _isConnected = false;
    });

    _hubConnection.onreconnecting((error) => print("Reconnecting: $error"));

    _hubConnection.onreconnected((connectionId) {
      print("Reconnected: $connectionId");
      _isConnected = true;
      getOnlinePeople(); // Refresh users list after reconnection
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
  Future<void> getOnlinePeople() async {
    try {
      if (_isConnected) {
        final result = await _hubConnection.invoke('GetOnlinePeople');
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
      } else {
        // Fetch users from REST API instead
        await fetchUsersFromApi();
      }
    } catch (e) {
      print("Error getting online users: $e");
      await fetchUsersFromApi();
    }
  }

  Future<void> fetchUsersFromApi() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString('CookieToken');

      if (token == null) {
        print("Error: Authentication token is missing");
        return;
      }

      try {
        final response = await _dio.get(
          'https://infinitely-native-lamprey.ngrok-free.app/user/users',
          options: Options(
            headers: {
              'Authentication': ' $token',
              'Content-Type': 'application/json',
            },
          ),
        );

        if (response.statusCode == 200) {
          final List<dynamic> usersData = response.data as List<dynamic>;
          _onlineUsers.clear();
          _onlineUsers.addAll(
            usersData.map((userData) => ChatUser.fromJson(userData)).toList(),
          );

          if (onUsersUpdated != null) {
            onUsersUpdated!(_onlineUsers);
          }
        } else {
          print(
              "Error fetching users: ${response.statusCode} - ${response.data}");
        }
      } on DioException catch (e) {
        print(
            "Dio error fetching users: ${e.response?.statusCode} - ${e.response?.data}");
        print("Error message: ${e.message}");

        // Try to refresh token if unauthorized
        if (e.response?.statusCode == 401) {
          // Here you would implement token refresh logic if needed
          print("Authentication failed. Token may be expired.");
        }
      }
    } catch (e) {
      print("Exception fetching users from API: $e");
    }
  }

  // Messaging methods
  Future<void> sendMessage(String receiverId, String content,
      {MessageType type = MessageType.text}) async {
    if (content.trim().isEmpty) return;

    if (_isConnected) {
      try {
        await _hubConnection.invoke('SendMessage', args: [
          receiverId,
          content,
          type.toString().split('.').last,
        ]);
      } catch (e) {
        print("Error sending message: $e");
      }
    } else {
      print("Cannot send message: not connected to chat server");
    }
  }

  Future<void> sendTypingNotification(String receiverId) async {
    if (!_isConnected) return;

    try {
      await _hubConnection.invoke('SendTypingNotification', args: [receiverId]);
    } catch (e) {
      print("Error sending typing notification: $e");
    }
  }

  // Call-related methods
  Future<void> initiateCall(String receiverId, bool isVideoCall) async {
    if (!_isConnected) return;

    try {
      await _hubConnection
          .invoke('InitiateCall', args: [receiverId, isVideoCall]);
    } catch (e) {
      print("Error initiating call: $e");
    }
  }

  Future<void> acceptCall(String callerId) async {
    if (!_isConnected) return;

    try {
      await _hubConnection.invoke('AcceptCall', args: [callerId]);
    } catch (e) {
      print("Error accepting call: $e");
    }
  }

  Future<void> rejectCall(String callerId) async {
    if (!_isConnected) return;

    try {
      await _hubConnection.invoke('RejectCall', args: [callerId]);
    } catch (e) {
      print("Error rejecting call: $e");
    }
  }

  Future<void> endCall(String peerId) async {
    if (!_isConnected) return;

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
    if (_isConnected) {
      try {
        await _hubConnection.stop();
        _isConnected = false;
        print("Disconnected from SignalR hub");
      } catch (e) {
        print("Error disconnecting: $e");
      }
    }
  }
}
*/

/*
import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:signalr_core/signalr_core.dart';
import 'package:flutter/foundation.dart';
import 'package:path_provider/path_provider.dart';
import 'package:dio/dio.dart';

class ChatUser {
  final String userId;
  final String username;
  final String? profileImage;
  final bool isOnline;

  const ChatUser({
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

  const ChatMessage({
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

  const CallInfo({
    required this.callerId,
    required this.callerName,
    this.isVideoCall = false,
  });
}

class ChatService {
  late final HubConnection _hubConnection;
  final List<ChatUser> _onlineUsers = [];
  final Dio _dio = Dio();

  // Connection state
  bool _isConnected = false;
  String? _currentUserId;

  // Event callbacks
  Function(List<ChatUser>)? onUsersUpdated;
  Function(ChatMessage)? onMessageReceived;
  Function(String)? onTyping;
  Function(CallInfo)? onIncomingCall;
  Function(String)? onCallAccepted;
  Function(String)? onCallRejected;
  Function(String)? onCallEnded;

  List<ChatUser> get onlineUsers => List.unmodifiable(_onlineUsers);
  bool get isConnected => _isConnected;
  String? get currentUserId => _currentUserId;

  Future<void> connect() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('CookieToken');
      _currentUserId = prefs.getString('UserId');

      if (token == null || _currentUserId == null) {
        throw Exception('Authentication token or user ID not available');
      }

      // Configure HTTP headers for REST API calls
      _dio.options.headers = {
        'Authentication': ' $token',
        'Content-Type': 'application/json',
      };

      // Configure SignalR connection
      final connectionOptions = HttpConnectionOptions(
        transport: HttpTransportType.webSockets,
        skipNegotiation: false,
        accessTokenFactory: () async => token,
        logging: (level, message) => debugPrint("SignalR: $message"),
      );

      _hubConnection = HubConnectionBuilder()
          .withUrl(
            'https://infinitely-native-lamprey.ngrok-free.app/chat',
            connectionOptions,
          )
          .withAutomaticReconnect()
          .build();

      _setupEventHandlers();

      await _hubConnection.start();
      _isConnected = true;
      debugPrint("Connected to SignalR hub");

      // Initial data fetch
      await getOnlinePeople();
    } catch (e) {
      _isConnected = false;
      debugPrint("Connection error: $e");
      rethrow;
    }
  }

  void _setupEventHandlers() {
    _hubConnection.onclose((error) {
      _isConnected = false;
      debugPrint("Connection closed: ${error ?? 'No error'}");
    });

    _hubConnection.onreconnecting(
        (error) => debugPrint("Reconnecting: ${error ?? 'No error'}"));

    _hubConnection.onreconnected((connectionId) {
      _isConnected = true;
      debugPrint("Reconnected with ID: $connectionId");
      getOnlinePeople();
    });

    _hubConnection.on('ReceiveMessage', (arguments) {
      if (arguments?.isNotEmpty ?? false) {
        final message = ChatMessage.fromJson(arguments![0]);
        onMessageReceived?.call(message);
      }
    });

    _hubConnection.on('UpdateOnlineUsers', (arguments) {
      if (arguments?.isNotEmpty ?? false) {
        _onlineUsers.clear();
        _onlineUsers.addAll(
          (arguments![0] as List).map((e) => ChatUser.fromJson(e)),
        );
        onUsersUpdated?.call(_onlineUsers);
      }
    });

    _hubConnection.on('UserTyping', (arguments) {
      if (arguments?.isNotEmpty ?? false) {
        onTyping?.call(arguments![0]);
      }
    });

    _hubConnection.on('IncomingCall', (arguments) {
      if (arguments?.length == 3) {
        onIncomingCall?.call(CallInfo(
          callerId: arguments![0],
          callerName: arguments[1],
          isVideoCall: arguments[2],
        ));
      }
    });

    _hubConnection.on('CallAccepted', (arguments) {
      if (arguments?.isNotEmpty ?? false) {
        onCallAccepted?.call(arguments![0]);
      }
    });

    _hubConnection.on('CallRejected', (arguments) {
      if (arguments?.isNotEmpty ?? false) {
        onCallRejected?.call(arguments![0]);
      }
    });

    _hubConnection.on('CallEnded', (arguments) {
      if (arguments?.isNotEmpty ?? false) {
        onCallEnded?.call(arguments![0]);
      }
    });
  }

  Future<void> getOnlinePeople() async {
    try {
      if (_isConnected) {
        final result = await _hubConnection.invoke('GetOnlinePeople');
        if (result != null) {
          _updateUsersList(result as List<dynamic>);
        }
      } else {
        await fetchUsersFromApi();
      }
    } catch (e) {
      debugPrint("Error getting online users: $e");
      await fetchUsersFromApi();
    }
  }

  Future<void> fetchUsersFromApi() async {
    try {
      final response = await _dio.get(
        'https://infinitely-native-lamprey.ngrok-free.app/user/users',
      );

      if (response.statusCode == 200) {
        _updateUsersList(response.data as List<dynamic>);
      } else {
        throw Exception('Failed to fetch users: ${response.statusCode}');
      }
    } on DioException catch (e) {
      debugPrint("Dio error: ${e.message}");
      if (e.response?.statusCode == 401) {
        // Token might be expired - should trigger re-authentication
        debugPrint("Authentication failed - token may be expired");
      }
      rethrow;
    }
  }

  void _updateUsersList(List<dynamic> usersData) {
    _onlineUsers.clear();
    _onlineUsers.addAll(usersData.map((e) => ChatUser.fromJson(e)));
    onUsersUpdated?.call(_onlineUsers);
  }

  Future<void> sendMessage(
    String receiverId,
    String content, {
    MessageType type = MessageType.text,
  }) async {
    if (!_isConnected || content.trim().isEmpty) return;

    try {
      await _hubConnection.invoke('SendMessage', args: [
        receiverId,
        content,
        type.toString().split('.').last,
      ]);
    } catch (e) {
      debugPrint("Error sending message: $e");
      rethrow;
    }
  }

  Future<void> sendTypingNotification(String receiverId) async {
    if (!_isConnected) return;

    try {
      await _hubConnection.invoke('SendTypingNotification', args: [receiverId]);
    } catch (e) {
      debugPrint("Error sending typing notification: $e");
    }
  }

  Future<void> initiateCall(String receiverId, bool isVideoCall) async {
    if (!_isConnected) return;

    try {
      await _hubConnection
          .invoke('InitiateCall', args: [receiverId, isVideoCall]);
    } catch (e) {
      debugPrint("Error initiating call: $e");
    }
  }

  Future<void> acceptCall(String callerId) async {
    if (!_isConnected) return;

    try {
      await _hubConnection.invoke('AcceptCall', args: [callerId]);
    } catch (e) {
      debugPrint("Error accepting call: $e");
    }
  }

  Future<void> rejectCall(String callerId) async {
    if (!_isConnected) return;

    try {
      await _hubConnection.invoke('RejectCall', args: [callerId]);
    } catch (e) {
      debugPrint("Error rejecting call: $e");
    }
  }

  Future<void> endCall(String peerId) async {
    if (!_isConnected) return;

    try {
      await _hubConnection.invoke('EndCall', args: [peerId]);
    } catch (e) {
      debugPrint("Error ending call: $e");
    }
  }

  Future<String> saveAudioMessage(Uint8List audioBytes) async {
    try {
      final directory = await getApplicationDocumentsDirectory();
      final filePath =
          '${directory.path}/audio_${DateTime.now().millisecondsSinceEpoch}.m4a';
      await File(filePath).writeAsBytes(audioBytes);
      return filePath;
    } catch (e) {
      debugPrint("Error saving audio: $e");
      rethrow;
    }
  }

  Future<void> disconnect() async {
    if (_isConnected) {
      try {
        await _hubConnection.stop();
        _isConnected = false;
        debugPrint("Disconnected from SignalR hub");
      } catch (e) {
        debugPrint("Error disconnecting: $e");
      }
    }
  }
}
*/

/*
import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:signalr_core/signalr_core.dart';
import 'package:flutter/foundation.dart';
import 'package:path_provider/path_provider.dart';
import 'package:dio/dio.dart';

class ChatUser {
  final String userId;
  final String username;
  final String? profileImage;
  final bool isOnline;

  const ChatUser({
    required this.userId,
    required this.username,
    this.profileImage,
    this.isOnline = false,
  });

  factory ChatUser.fromJson(Map<String, dynamic> json) {
    return ChatUser(
      userId: json['userId'] ?? json['id'] ?? '',
      username: json['username'] ?? json['name'] ?? '',
      profileImage: json['profileImage'] ?? json['imageUrl'],
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

  const ChatMessage({
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

  const CallInfo({
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

  final Dio _dio = Dio();

  // Callbacks
  Function(List<ChatUser>)? onUsersUpdated;
  Function(ChatMessage)? onMessageReceived;
  Function(String)? onTyping;
  Function(CallInfo)? onIncomingCall;
  Function(String)? onCallAccepted;
  Function(String)? onCallRejected;
  Function(String)? onCallEnded;

  bool _isConnected = false;
  bool get isConnected => _isConnected;

  Future<void> connect() async {
    try {
      // Get authentication token from SharedPreferences
      SharedPreferences prefs = await SharedPreferences.getInstance();

      // Retrieve the token that was saved during login
      String? token = prefs.getString('CookieToken');
      _currentUserId = prefs.getString('UserId');

      // Also check for pToken (persisted token) if available
      if (token == null) {
        token = prefs.getString('pToken');
      }

      if (token == null || _currentUserId == null) {
        print("Error: Authentication token or user ID is missing");
        return;
      }

      // Set up Dio with default headers
      _dio.options.headers["Authentication "] = " $token";
      _dio.options.headers["Content-Type"] = "application/json";

      // Configure SignalR connection using accessTokenFactory for auth
      final httpConnectionOptions = HttpConnectionOptions(
        transport: HttpTransportType.webSockets,
        skipNegotiation: true,
        accessTokenFactory: () async =>
            token ?? '', // Provide token dynamically
        logging: (level, message) => print("SignalR: $message"),
      );

      // Create URL with authentication token
      String encodedToken = Uri.encodeComponent(token);
      String url =
          'https://infinitely-native-lamprey.ngrok-free.app/chat?Authentication=$encodedToken';

      _hubConnection = HubConnectionBuilder()
          .withUrl(
            url,
            httpConnectionOptions,
          )
          .withAutomaticReconnect()
          .build();

      // Setup SignalR event handlers
      _setupEventHandlers();

      try {
        await _hubConnection.start();
        _isConnected = true;
        print("Connected to SignalR hub");

        // Get initial online users list
        await getOnlinePeople();
      } catch (e) {
        print("SignalR connection error: $e");
        _isConnected = false;
        // Try to fetch users from API even if SignalR connection fails
        await fetchUsersFromApi();
      }
    } catch (e) {
      print("Connection setup error: $e");
      _isConnected = false;
    }
  }

  void _setupEventHandlers() {
    // Connection lifecycle events
    _hubConnection.onclose((error) {
      print("Connection closed: $error");
      _isConnected = false;
    });

    _hubConnection.onreconnecting((error) => print("Reconnecting: $error"));

    _hubConnection.onreconnected((connectionId) {
      print("Reconnected: $connectionId");
      _isConnected = true;
      getOnlinePeople(); // Refresh users list after reconnection
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
  Future<void> getOnlinePeople() async {
    try {
  //    _hubConnection.on()
      if (_isConnected) {
        final result = await _hubConnection.invoke('GetOnlinePeople');
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
      } else {
        // Fetch users from REST API instead
        await fetchUsersFromApi();
      }
    } catch (e) {
      print("Error getting online users: $e");
      await fetchUsersFromApi();
    }
  }

  Future<void> fetchUsersFromApi() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString('CookieToken');

      // Also check for pToken if available
      if (token == null) {
        token = prefs.getString('pToken');
      }

      if (token == null) {
        print("Error: Authentication token is missing");
        return;
      }

      try {
        final response = await _dio.get(
          'https://infinitely-native-lamprey.ngrok-free.app/user/users',
          options: Options(
            headers: {
              'Authentication ': ' $token',
              'Content-Type': 'application/json',
            },
          ),
        );

        if (response.statusCode == 200) {
          final List<dynamic> usersData = response.data as List<dynamic>;
          _onlineUsers.clear();
          _onlineUsers.addAll(
            usersData.map((userData) => ChatUser.fromJson(userData)).toList(),
          );

          if (onUsersUpdated != null) {
            onUsersUpdated!(_onlineUsers);
          }
        } else {
          print(
              "Error fetching users: ${response.statusCode} - ${response.data}");
        }
      } on DioException catch (e) {
        print(
            "Dio error fetching users: ${e.response?.statusCode} - ${e.response?.data}");
        print("Error message: ${e.message}");

        // Try to refresh token if unauthorized
        if (e.response?.statusCode == 401) {
          // Here you would implement token refresh logic if needed
          print("Authentication failed. Token may be expired.");
        }
      }
    } catch (e) {
      print("Exception fetching users from API: $e");
    }
  }

  // Messaging methods
  Future<void> sendMessage(String receiverId, String content,
      {MessageType type = MessageType.text}) async {
    if (content.trim().isEmpty) return;

    if (_isConnected) {
      try {
        await _hubConnection.invoke('SendMessage', args: [
          receiverId,
          content,
          type.toString().split('.').last,
        ]);
      } catch (e) {
        print("Error sending message: $e");
      }
    } else {
      print("Cannot send message: not connected to chat server");
    }
  }

  Future<void> sendTypingNotification(String receiverId) async {
    if (!_isConnected) return;

    try {
      await _hubConnection.invoke('SendTypingNotification', args: [receiverId]);
    } catch (e) {
      print("Error sending typing notification: $e");
    }
  }

  // Call-related methods
  Future<void> initiateCall(String receiverId, bool isVideoCall) async {
    if (!_isConnected) return;

    try {
      await _hubConnection
          .invoke('InitiateCall', args: [receiverId, isVideoCall]);
    } catch (e) {
      print("Error initiating call: $e");
    }
  }

  Future<void> acceptCall(String callerId) async {
    if (!_isConnected) return;

    try {
      await _hubConnection.invoke('AcceptCall', args: [callerId]);
    } catch (e) {
      print("Error accepting call: $e");
    }
  }

  Future<void> rejectCall(String callerId) async {
    if (!_isConnected) return;

    try {
      await _hubConnection.invoke('RejectCall', args: [callerId]);
    } catch (e) {
      print("Error rejecting call: $e");
    }
  }

  Future<void> endCall(String peerId) async {
    if (!_isConnected) return;

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
    if (_isConnected) {
      try {
        await _hubConnection.stop();
        _isConnected = false;
        print("Disconnected from SignalR hub");
      } catch (e) {
        print("Error disconnecting: $e");
      }
    }
  }
}
*/
/*
import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:signalr_core/signalr_core.dart';
import 'package:flutter/foundation.dart';
import 'package:path_provider/path_provider.dart';
import 'package:dio/dio.dart';

class ChatUser {
  final String userId;
  final String username;
  final String? profileImage;
  final bool isOnline;

  const ChatUser({
    required this.userId,
    required this.username,
    this.profileImage,
    this.isOnline = false,
  });

  factory ChatUser.fromJson(Map<String, dynamic> json) {
    return ChatUser(
      userId: json['userId'] ?? json['id'] ?? '',
      username: json['username'] ?? json['name'] ?? '',
      profileImage: json['profileImage'] ?? json['imageUrl'],
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

  const ChatMessage({
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

  const CallInfo({
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

  final Dio _dio = Dio();

  // Callbacks
  Function(List<ChatUser>)? onUsersUpdated;
  Function(ChatMessage)? onMessageReceived;
  Function(String)? onTyping;
  Function(CallInfo)? onIncomingCall;
  Function(String)? onCallAccepted;
  Function(String)? onCallRejected;
  Function(String)? onCallEnded;

  bool _isConnected = false;
  bool get isConnected => _isConnected;

  Future<void> connect() async {
    try {
      // Get authentication token from SharedPreferences
      SharedPreferences prefs = await SharedPreferences.getInstance();

      // Retrieve the token that was saved during login
      String? token = prefs.getString('CookieToken');
      _currentUserId = prefs.getString('UserId');

      // Also check for pToken (persisted token) if available
      if (token == null) {
        token = prefs.getString('pToken');
      }

      if (token == null || _currentUserId == null) {
        print("Error: Authentication token or user ID is missing");
        return;
      }

      // Set up Dio with default headers
      _dio.options.headers["Authentication "] = " $token";
      _dio.options.headers["Content-Type"] = "application/json";

      // Configure SignalR connection using accessTokenFactory for auth
      final httpConnectionOptions = HttpConnectionOptions(
        transport: HttpTransportType.webSockets,
        skipNegotiation: true,
        accessTokenFactory: () async =>
            token ?? '', // Provide token dynamically
        logging: (level, message) => print("SignalR: $message"),
      );

      // Create URL with authentication token
      String encodedToken = Uri.encodeComponent(token);
      String url =
          'https://infinitely-native-lamprey.ngrok-free.app/chat?Authentication=$encodedToken';

      _hubConnection = HubConnectionBuilder()
          .withUrl(
            url,
            httpConnectionOptions,
          )
          .withAutomaticReconnect()
          .build();

      // Setup SignalR event handlers
      _setupEventHandlers();

      try {
        await _hubConnection.start();
        _isConnected = true;
        print("Connected to SignalR hub");

        // Get initial online users list
        await getOnlinePeople();
      } catch (e) {
        print("SignalR connection error: $e");
        _isConnected = false;
        // Try to fetch users from API even if SignalR connection fails
        await fetchUsersFromApi();
      }
    } catch (e) {
      print("Connection setup error: $e");
      _isConnected = false;
    }
  }

  void _setupEventHandlers() {
    // Connection lifecycle events
    _hubConnection.onclose((error) {
      print("Connection closed: $error");
      _isConnected = false;
    });

    _hubConnection.onreconnecting((error) => print("Reconnecting: $error"));

    _hubConnection.onreconnected((connectionId) {
      print("Reconnected: $connectionId");
      _isConnected = true;
      getOnlinePeople(); // Refresh users list after reconnection
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
    _hubConnection.on(
        "GetOnlinePeople",
        (sending, chosen) {
          //listener
          if (sending != null) {
            final List<dynamic> usersData = sending as List<dynamic>;
            _onlineUsers.clear();
            _onlineUsers.addAll(
              usersData.map((userData) => ChatUser.fromJson(userData)).toList(),
            );

            if (onUsersUpdated != null) {
              onUsersUpdated!(_onlineUsers);
            }
          }
        } as MethodInvocationFunc);
  }

  // User list methods
  Future<void> getOnlinePeople() async {
    try {
//      _hubConnection.on('GetOnlinePeople',g)
      if (_isConnected) {
        //final result =  await _hubConnection.invoke('GetOnlinePeople', "-1");
        await _hubConnection.invoke('GetOnlinePeople', args: ["-1"]);
        /*
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
        */
      } else {
        // Fetch users from REST API instead
        await fetchUsersFromApi();
      }
    } catch (e) {
      print("Error getting online users: $e");
      await fetchUsersFromApi();
    }
  }

  Future<void> fetchUsersFromApi() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString('CookieToken');

      // Also check for pToken if available
      if (token == null) {
        token = prefs.getString('pToken');
      }

      if (token == null) {
        print("Error: Authentication token is missing");
        return;
      }

      try {
        final response = await _dio.get(
          'https://infinitely-native-lamprey.ngrok-free.app/user/users',
          options: Options(
            headers: {
              'Authentication ': ' $token',
              'Content-Type': 'application/json',
            },
          ),
        );

        if (response.statusCode == 200) {
          final List<dynamic> usersData = response.data as List<dynamic>;
          _onlineUsers.clear();
          _onlineUsers.addAll(
            usersData.map((userData) => ChatUser.fromJson(userData)).toList(),
          );

          if (onUsersUpdated != null) {
            onUsersUpdated!(_onlineUsers);
          }
        } else {
          print(
              "Error fetching users: ${response.statusCode} - ${response.data}");
        }
      } on DioException catch (e) {
        print(
            "Dio error fetching users: ${e.response?.statusCode} - ${e.response?.data}");
        print("Error message: ${e.message}");

        // Try to refresh token if unauthorized
        if (e.response?.statusCode == 401) {
          // Here you would implement token refresh logic if needed
          print("Authentication failed. Token may be expired.");
        }
      }
    } catch (e) {
      print("Exception fetching users from API: $e");
    }
  }

  // Messaging methods
  Future<void> sendMessage(String receiverId, String content,
      {MessageType type = MessageType.text}) async {
    if (content.trim().isEmpty) return;

    if (_isConnected) {
      try {
        await _hubConnection.invoke('SendMessage', args: [
          receiverId,
          content,
          type.toString().split('.').last,
        ]);
      } catch (e) {
        print("Error sending message: $e");
      }
    } else {
      print("Cannot send message: not connected to chat server");
    }
  }

  Future<void> sendTypingNotification(String receiverId) async {
    if (!_isConnected) return;

    try {
      await _hubConnection.invoke('SendTypingNotification', args: [receiverId]);
    } catch (e) {
      print("Error sending typing notification: $e");
    }
  }

  // Call-related methods
  Future<void> initiateCall(String receiverId, bool isVideoCall) async {
    if (!_isConnected) return;

    try {
      await _hubConnection
          .invoke('InitiateCall', args: [receiverId, isVideoCall]);
    } catch (e) {
      print("Error initiating call: $e");
    }
  }

  Future<void> acceptCall(String callerId) async {
    if (!_isConnected) return;

    try {
      await _hubConnection.invoke('AcceptCall', args: [callerId]);
    } catch (e) {
      print("Error accepting call: $e");
    }
  }

  Future<void> rejectCall(String callerId) async {
    if (!_isConnected) return;

    try {
      await _hubConnection.invoke('RejectCall', args: [callerId]);
    } catch (e) {
      print("Error rejecting call: $e");
    }
  }

  Future<void> endCall(String peerId) async {
    if (!_isConnected) return;

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
    if (_isConnected) {
      try {
        await _hubConnection.stop();
        _isConnected = false;
        print("Disconnected from SignalR hub");
      } catch (e) {
        print("Error disconnecting: $e");
      }
    }
  }
}
*/

/*
import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:signalr_core/signalr_core.dart';
import 'package:flutter/foundation.dart';
import 'package:path_provider/path_provider.dart';
import 'package:dio/dio.dart';

class ChatUser {
  final String userId;
  final String username;
  final String? profileImage;
  final bool isOnline;

  const ChatUser({
    required this.userId,
    required this.username,
    this.profileImage,
    this.isOnline = false,
  });

  factory ChatUser.fromJson(Map<String, dynamic> json) {
    return ChatUser(
      userId: json['userId'] ?? json['id'] ?? '',
      username: json['username'] ?? json['name'] ?? '',
      profileImage: json['profileImage'] ?? json['imageUrl'],
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

  const ChatMessage({
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

  const CallInfo({
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

  final Dio _dio = Dio();

  // Callbacks
  Function(List<ChatUser>)? onUsersUpdated;
  Function(ChatMessage)? onMessageReceived;
  Function(String)? onTyping;
  Function(CallInfo)? onIncomingCall;
  Function(String)? onCallAccepted;
  Function(String)? onCallRejected;
  Function(String)? onCallEnded;

  bool _isConnected = false;
  bool get isConnected => _isConnected;

  Future<void> connect() async {
    try {
      // Get authentication token from SharedPreferences
      SharedPreferences prefs = await SharedPreferences.getInstance();

      // Retrieve the token that was saved during login
      String? token = prefs.getString('CookieToken');
      _currentUserId = prefs.getString('UserId');

      // Also check for pToken (persisted token) if available
      if (token == null) {
        token = prefs.getString('pToken');
      }

      if (token == null || _currentUserId == null) {
        print("Error: Authentication token or user ID is missing");
        return;
      }

      // Set up Dio with default headers - fixed the header name (removed space)
      _dio.options.headers["Authentication"] = "$token";
      _dio.options.headers["Content-Type"] = "application/json";

      // Configure SignalR connection using accessTokenFactory for auth
      final httpConnectionOptions = HttpConnectionOptions(
        transport: HttpTransportType.webSockets,
        skipNegotiation: true,
        accessTokenFactory: () async =>
            token ?? '', // Provide token dynamically
        logging: (level, message) => print("SignalR: $message"),
      );

      // Create URL with authentication token
      String encodedToken = Uri.encodeComponent(token);
      String url =
          'https://infinitely-native-lamprey.ngrok-free.app/chat?Authentication=$encodedToken';

      _hubConnection = HubConnectionBuilder()
          .withUrl(
            url,
            httpConnectionOptions,
          )
          .withAutomaticReconnect()
          .build();

      // Setup SignalR event handlers
      _setupEventHandlers();

      try {
        await _hubConnection.start();
        _isConnected = true;
        print("Connected to SignalR hub");

        // Get initial online users list
        await getOnlinePeople();
      } catch (e) {
        print("SignalR connection error: $e");
        _isConnected = false;
        // Try to fetch users from API even if SignalR connection fails
        await fetchUsersFromApi();
      }
    } catch (e) {
      print("Connection setup error: $e");
      _isConnected = false;
    }
  }

  void _setupEventHandlers() {
    // Connection lifecycle events
    _hubConnection.onclose((error) {
      print("Connection closed: $error");
      _isConnected = false;
    });

    _hubConnection.onreconnecting((error) => print("Reconnecting: $error"));

    _hubConnection.onreconnected((connectionId) {
      print("Reconnected: $connectionId");
      _isConnected = true;
      getOnlinePeople(); // Refresh users list after reconnection
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
  Future<void> getOnlinePeople() async {
    try {
      if (_isConnected) {
        // Invoke the GetOnlinePeople method without arguments or with proper arguments
        final result = await _hubConnection.invoke('GetOnlinePeople');

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
      } else {
        // Fetch users from REST API instead
        await fetchUsersFromApi();
      }
    } catch (e) {
      print("Error getting online users: $e");
      await fetchUsersFromApi();
    }
  }

  Future<void> fetchUsersFromApi() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString('CookieToken');

      // Also check for pToken if available
      if (token == null) {
        token = prefs.getString('pToken');
      }

      if (token == null) {
        print("Error: Authentication token is missing");
        return;
      }

      try {
        // Fixed the header name (removed space)
        final response = await _dio.get(
          'https://infinitely-native-lamprey.ngrok-free.app/user/users',
          options: Options(
            headers: {
              'Authentication': ' $token',
              'Content-Type': 'application/json',
            },
          ),
        );

        if (response.statusCode == 200) {
          final List<dynamic> usersData = response.data as List<dynamic>;
          _onlineUsers.clear();
          _onlineUsers.addAll(
            usersData.map((userData) => ChatUser.fromJson(userData)).toList(),
          );

          if (onUsersUpdated != null) {
            onUsersUpdated!(_onlineUsers);
          }
        } else {
          print(
              "Error fetching users: ${response.statusCode} - ${response.data}");
        }
      } on DioException catch (e) {
        print(
            "Dio error fetching users: ${e.response?.statusCode} - ${e.response?.data}");
        print("Error message: ${e.message}");

        // Try to refresh token if unauthorized
        if (e.response?.statusCode == 401) {
          // Here you would implement token refresh logic if needed
          print("Authentication failed. Token may be expired.");
        }
      }
    } catch (e) {
      print("Exception fetching users from API: $e");
    }
  }

  // Messaging methods
  Future<void> sendMessage(String receiverId, String content,
      {MessageType type = MessageType.text}) async {
    if (content.trim().isEmpty) return;

    if (_isConnected) {
      try {
        await _hubConnection.invoke('SendMessage', args: [
          receiverId,
          content,
          type.toString().split('.').last,
        ]);
      } catch (e) {
        print("Error sending message: $e");
      }
    } else {
      print("Cannot send message: not connected to chat server");
    }
  }

  Future<void> sendTypingNotification(String receiverId) async {
    if (!_isConnected) return;

    try {
      await _hubConnection.invoke('SendTypingNotification', args: [receiverId]);
    } catch (e) {
      print("Error sending typing notification: $e");
    }
  }

  // Call-related methods
  Future<void> initiateCall(String receiverId, bool isVideoCall) async {
    if (!_isConnected) return;

    try {
      await _hubConnection
          .invoke('InitiateCall', args: [receiverId, isVideoCall]);
    } catch (e) {
      print("Error initiating call: $e");
    }
  }

  Future<void> acceptCall(String callerId) async {
    if (!_isConnected) return;

    try {
      await _hubConnection.invoke('AcceptCall', args: [callerId]);
    } catch (e) {
      print("Error accepting call: $e");
    }
  }

  Future<void> rejectCall(String callerId) async {
    if (!_isConnected) return;

    try {
      await _hubConnection.invoke('RejectCall', args: [callerId]);
    } catch (e) {
      print("Error rejecting call: $e");
    }
  }

  Future<void> endCall(String peerId) async {
    if (!_isConnected) return;

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
    if (_isConnected) {
      try {
        await _hubConnection.stop();
        _isConnected = false;
        print("Disconnected from SignalR hub");
      } catch (e) {
        print("Error disconnecting: $e");
      }
    }
  }
}

*/

/*
import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:signalr_core/signalr_core.dart';
import 'package:flutter/foundation.dart';
import 'package:path_provider/path_provider.dart';
import 'package:dio/dio.dart';

class ChatUser {
  final String userId;
  final String username;
  final String? profileImage;
  final bool isOnline;

  const ChatUser({
    required this.userId,
    required this.username,
    this.profileImage,
    this.isOnline = false,
  });

  factory ChatUser.fromJson(Map<String, dynamic> json) {
    return ChatUser(
      userId: json['userId'] ?? json['id'] ?? '',
      username: json['username'] ?? json['name'] ?? '',
      profileImage: json['profileImage'] ?? json['imageUrl'],
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

  const ChatMessage({
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

  const CallInfo({
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

  final Dio _dio = Dio();

  // Callbacks
  Function(List<ChatUser>)? onUsersUpdated;
  Function(ChatMessage)? onMessageReceived;
  Function(String)? onTyping;
  Function(CallInfo)? onIncomingCall;
  Function(String)? onCallAccepted;
  Function(String)? onCallRejected;
  Function(String)? onCallEnded;

  bool _isConnected = false;
  bool get isConnected => _isConnected;

  Future<void> connect() async {
    try {
      // Get authentication token from SharedPreferences
      SharedPreferences prefs = await SharedPreferences.getInstance();

      // Retrieve the token that was saved during login
      String? token = prefs.getString('CookieToken');
      _currentUserId = prefs.getString('UserId');

      // Also check for pToken (persisted token) if available
      if (token == null) {
        token = prefs.getString('pToken');
      }

      if (token == null || _currentUserId == null) {
        print("Error: Authentication token or user ID is missing");
        return;
      }

      // Set up Dio with default headers
      _dio.options.headers["Authentication"] = "$token";
      _dio.options.headers["Content-Type"] = "application/json";

      // Configure SignalR connection using accessTokenFactory for auth
      final httpConnectionOptions = HttpConnectionOptions(
        transport: HttpTransportType.webSockets,
        skipNegotiation: true,
        accessTokenFactory: () async => token ?? '',
        logging: (level, message) => print("SignalR: $message"),
      );

      // Create URL with authentication token in the query string
      String encodedToken = Uri.encodeComponent(token);
      String url =
          'https://infinitely-native-lamprey.ngrok-free.app/chat?token=$encodedToken';

      _hubConnection = HubConnectionBuilder()
          .withUrl(
            url,
            httpConnectionOptions,
          )
          .withAutomaticReconnect()
          .build();

      // Setup SignalR event handlers
      _setupEventHandlers();

      try {
        await _hubConnection.start();
        _isConnected = true;
        print("Connected to SignalR hub");

        // Get initial online users list
        await fetchUsersFromApi(); // Start with API fetch instead of SignalR method
      } catch (e) {
        print("SignalR connection error: $e");
        _isConnected = false;
        await fetchUsersFromApi();
      }
    } catch (e) {
      print("Connection setup error: $e");
      _isConnected = false;
    }
  }

  void _setupEventHandlers() {
    // Connection lifecycle events
    _hubConnection.onclose((error) {
      print("Connection closed: $error");
      _isConnected = false;
    });

    _hubConnection.onreconnecting((error) => print("Reconnecting: $error"));

    _hubConnection.onreconnected((connectionId) {
      print("Reconnected: $connectionId");
      _isConnected = true;
      fetchUsersFromApi(); // Use API fetch on reconnection
    });

    // Chat-specific events
    _hubConnection.on('ReceiveMessage', (arguments) {
      if (arguments != null && arguments.isNotEmpty) {
        try {
          final messageData = arguments[0] as Map<String, dynamic>;
          final message = ChatMessage.fromJson(messageData);
          onMessageReceived?.call(message);
        } catch (e) {
          print("Error processing received message: $e");
        }
      }
    });

    _hubConnection.on('UpdateOnlineUsers', (arguments) {
      if (arguments != null && arguments.isNotEmpty) {
        try {
          final List<dynamic> usersData = arguments[0] as List<dynamic>;
          _updateUsersList(usersData);
        } catch (e) {
          print("Error processing online users update: $e");
        }
      }
    });

    _hubConnection.on('UserTyping', (arguments) {
      if (arguments != null && arguments.isNotEmpty) {
        final userId = arguments[0] as String? ?? '';
        onTyping?.call(userId);
      }
    });

    // Call-related events
    _hubConnection.on('IncomingCall', (arguments) {
      if (arguments != null && arguments.length >= 3) {
        final callerId = arguments[0] as String? ?? '';
        final callerName = arguments[1] as String? ?? '';
        final isVideo = arguments[2] as bool? ?? false;

        onIncomingCall?.call(CallInfo(
          callerId: callerId,
          callerName: callerName,
          isVideoCall: isVideo,
        ));
      }
    });

    _hubConnection.on('CallAccepted', (arguments) {
      if (arguments != null && arguments.isNotEmpty) {
        final receiverId = arguments[0] as String? ?? '';
        onCallAccepted?.call(receiverId);
      }
    });

    _hubConnection.on('CallRejected', (arguments) {
      if (arguments != null && arguments.isNotEmpty) {
        final receiverId = arguments[0] as String? ?? '';
        onCallRejected?.call(receiverId);
      }
    });

    _hubConnection.on('CallEnded', (arguments) {
      if (arguments != null && arguments.isNotEmpty) {
        final userId = arguments[0] as String? ?? '';
        onCallEnded?.call(userId);
      }
    });

    // Server provides user list via GetOnlinePeople event
    _hubConnection.on('GetOnlinePeople', (arguments) {
      if (arguments != null && arguments.length >= 1) {
        try {
          final List<dynamic> onlineUsers = arguments[0] as List<dynamic>;
          final String chosen =
              arguments.length > 1 ? arguments[1] as String : "-1";

          print("Received online users with chosen: $chosen");
          _updateUsersList(onlineUsers);
        } catch (e) {
          print("Error processing GetOnlinePeople event: $e");
        }
      }
    });
  }

  // We're avoiding the SignalR GetOnlinePeople method since it's causing errors
  // and using the REST API instead
  Future<void> getOnlinePeople() async {
    await fetchUsersFromApi();
  }

  Future<void> fetchUsersFromApi() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString('CookieToken');

      // Also check for pToken if available
      if (token == null) {
        token = prefs.getString('pToken');
      }

      if (token == null) {
        print("Error: Authentication token is missing");
        return;
      }

      try {
        final response = await _dio.get(
          'https://infinitely-native-lamprey.ngrok-free.app/user/users',
          options: Options(
            headers: {
              'Authentication': '$token',
              'Content-Type': 'application/json',
            },
          ),
        );

        if (response.statusCode == 200) {
          try {
            // Handle the case where the response could be a map or a list
            if (response.data is List) {
              final List<dynamic> usersData = response.data as List<dynamic>;
              _updateUsersList(usersData);
            } else if (response.data is Map) {
              // If it's a map, check if there's a users array inside it
              final Map<String, dynamic> responseMap =
                  response.data as Map<String, dynamic>;
              if (responseMap.containsKey('users') &&
                  responseMap['users'] is List) {
                final List<dynamic> usersData =
                    responseMap['users'] as List<dynamic>;
                _updateUsersList(usersData);
              } else {
                // If there's no users array, create a single user from the map
                final user = ChatUser.fromJson(responseMap);
                _onlineUsers.clear();
                _onlineUsers.add(user);
                onUsersUpdated?.call(_onlineUsers);
              }
            }
          } catch (e) {
            print("Error parsing users data: $e");
            print("Response data type: ${response.data.runtimeType}");
            print("Response data: ${response.data}");
          }
        } else {
          print(
              "Error fetching users: ${response.statusCode} - ${response.data}");
        }
      } on DioException catch (e) {
        print(
            "Dio error fetching users: ${e.response?.statusCode} - ${e.response?.data}");
        print("Error message: ${e.message}");

        // Try to refresh token if unauthorized
        if (e.response?.statusCode == 401) {
          print("Authentication failed. Token may be expired.");
        }
      }
    } catch (e) {
      print("Exception fetching users from API: $e");
    }
  }

  void _updateUsersList(List<dynamic> usersData) {
    _onlineUsers.clear();
    _onlineUsers.addAll(
      usersData.map((userData) => ChatUser.fromJson(userData)).toList(),
    );
    onUsersUpdated?.call(_onlineUsers);
  }

  // Messaging methods
  Future<void> sendMessage(String receiverId, String content,
      {MessageType type = MessageType.text}) async {
    if (content.trim().isEmpty) return;

    if (_isConnected) {
      try {
        await _hubConnection.invoke('SendMessage', args: [
          receiverId,
          content,
          type.toString().split('.').last,
        ]);
      } catch (e) {
        print("Error sending message: $e");
      }
    } else {
      print("Cannot send message: not connected to chat server");
    }
  }

  Future<void> sendTypingNotification(String receiverId) async {
    if (!_isConnected) return;

    try {
      await _hubConnection.invoke('SendTypingNotification', args: [receiverId]);
    } catch (e) {
      print("Error sending typing notification: $e");
    }
  }

  // Call-related methods
  Future<void> initiateCall(String receiverId, bool isVideoCall) async {
    if (!_isConnected) return;

    try {
      await _hubConnection
          .invoke('InitiateCall', args: [receiverId, isVideoCall]);
    } catch (e) {
      print("Error initiating call: $e");
    }
  }

  Future<void> acceptCall(String callerId) async {
    if (!_isConnected) return;

    try {
      await _hubConnection.invoke('AcceptCall', args: [callerId]);
    } catch (e) {
      print("Error accepting call: $e");
    }
  }

  Future<void> rejectCall(String callerId) async {
    if (!_isConnected) return;

    try {
      await _hubConnection.invoke('RejectCall', args: [callerId]);
    } catch (e) {
      print("Error rejecting call: $e");
    }
  }

  Future<void> endCall(String peerId) async {
    if (!_isConnected) return;

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
    if (_isConnected) {
      try {
        await _hubConnection.stop();
        _isConnected = false;
        print("Disconnected from SignalR hub");
      } catch (e) {
        print("Error disconnecting: $e");
      }
    }
  }
}
*/

import 'dart:convert';
import 'dart:io';
import 'dart:math' as math;
import 'dart:typed_data';
import 'dart:async';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:signalr_core/signalr_core.dart';
import 'package:flutter/foundation.dart';
import 'package:path_provider/path_provider.dart';
import 'package:dio/dio.dart';

class ChatUser {
  final String userId;
  final String username;
  final String? profileImage;
  final bool isOnline;

  const ChatUser({
    required this.userId,
    required this.username,
    this.profileImage,
    this.isOnline = false,
  });

  factory ChatUser.fromJson(Map<String, dynamic> json) {
    return ChatUser(
      userId: json['userId'] ?? json['id'] ?? '',
      username: json['username'] ?? json['name'] ?? '',
      profileImage: json['profileImage'] ?? json['imageUrl'],
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

  const ChatMessage({
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

  const CallInfo({
    required this.callerId,
    required this.callerName,
    this.isVideoCall = false,
  });
}

class ChatService {
  HubConnection? _hubConnection;
  final List<ChatUser> _onlineUsers = [];
  List<ChatUser> get onlineUsers => List.unmodifiable(_onlineUsers);

  String? _currentUserId;
  String? get currentUserId => _currentUserId;

  final Dio _dio = Dio();
  bool _reconnecting = false;
  int _connectionRetryCount = 0;
  static const int _maxRetryAttempts = 5;
  Timer? _reconnectTimer;
  Timer? _heartbeatTimer;

  // Flag to track if a connection attempt is in progress
  bool _connectionInProgress = false;

  // Callbacks
  Function(List<ChatUser>)? onUsersUpdated;
  Function(ChatMessage)? onMessageReceived;
  Function(String)? onTyping;
  Function(CallInfo)? onIncomingCall;
  Function(String)? onCallAccepted;
  Function(String)? onCallRejected;
  Function(String)? onCallEnded;
  Function(String)? onConnectionError;
  Function()? onConnectionSuccess;

  bool _isConnected = false;
  bool get isConnected => _isConnected;

  ChatService() {
    // Initialize Dio with error handling
    _dio.options.validateStatus = (status) {
      return status != null && status < 500;
    };
  }

  Future<void> connect() async {
    if (_connectionInProgress) {
      print("Connection already in progress, skipping duplicate request");
      return;
    }

    if (_reconnecting) {
      print("Already attempting to reconnect, skipping duplicate request");
      return;
    }

    try {
      _connectionInProgress = true;
      _reconnecting = false;
      _connectionRetryCount = 0;

      // Get authentication token from SharedPreferences
      SharedPreferences prefs = await SharedPreferences.getInstance();

      // Retrieve the token that was saved during login
      String? token = prefs.getString('CookieToken');
      _currentUserId = prefs.getString('UserId');

      // Also check for pToken (persisted token) if available
      if (token == null) {
        token = prefs.getString('pToken');
      }

      // Hard-coded fallback for testing if no token is found
      if (token == null) {
        token =
            "s1PPIgtC8AG+x0Qr+F++zHFBLOB0MqKzFYt6vDHr259yJ6US7WrK16pDo/8ua4bLbSKwDAcTH+fLXsglVzz8hu03D7CzF+kX8vnruONnAB/O56YZe/pbymI1ZJioW3V3MqTnCiHoUagPLTzjZOj2N4kxH7WSSn89t9gtQwWJW3XmzYYO/EkMRQ7vRUaxKGW77ExLEvmi8FDqHg9cbgIApN33KQpW6bMY2wx1bWkNW68jTanUeOpLCWx9JXx3ul1W";
      }

      if (_currentUserId == null) {
        _currentUserId = "user123"; // Fallback user ID for testing
      }

      if (token == null || _currentUserId == null) {
        print("Error: Authentication token or user ID is missing");
        _reconnecting = false;
        _connectionInProgress = false;
        onConnectionError?.call("Authentication token or user ID is missing");
        return;
      }

      // Set up Dio with both header formats to maximize compatibility
      _dio.options.headers["Authorization"] = "Bearer $token";
      _dio.options.headers["Authentication"] =
          token; // Some servers use this format

      // Configure SignalR connection
      final httpConnectionOptions = HttpConnectionOptions(
        transport: HttpTransportType.webSockets,
        skipNegotiation: true,
        accessTokenFactory: () async => token ?? '',
        logging: (level, message) => print("SignalR: $message"),
      );

      // Create URL with authentication token in multiple formats to ensure compatibility
      String encodedToken = Uri.encodeComponent(token);
      String url =
          'https://infinitely-native-lamprey.ngrok-free.app/chat?token=$encodedToken&Authentication=$encodedToken';

      // Create retry delays for reconnection
      final retryDelays = <int>[];
      for (int i = 0; i < _maxRetryAttempts; i++) {
        retryDelays.add(1000 * math.pow(2, i).toInt());
      }

      try {
        // Safely stop any existing connection before creating a new one
        await safeDisconnect();

        _hubConnection = HubConnectionBuilder()
            .withUrl(
              url,
              httpConnectionOptions,
            )
            .withAutomaticReconnect(retryDelays)
            .build();

        // Setup SignalR event handlers
        _setupEventHandlers();

        // Start the connection
        await _hubConnection?.start();
        _isConnected = true;
        print("Connected to SignalR hub");

        // Start a heartbeat timer to keep the connection alive
        _startHeartbeat();

        // Inform listeners of successful connection
        onConnectionSuccess?.call();

        // Get initial online users list - try multiple approaches
        await _fetchUsers();
      } catch (e) {
        print("SignalR connection error: $e");
        _isConnected = false;

        try {
          await fetchUsersFromApi();
        } catch (apiError) {
          print("API fallback also failed: $apiError");
          _addDefaultUserIfEmpty();
        }

        onConnectionError?.call("Failed to connect to chat server: $e");
      }
    } catch (e) {
      print("Connection setup error: $e");
      _isConnected = false;
      onConnectionError?.call("Connection setup error: $e");
    } finally {
      _reconnecting = false;
      _connectionInProgress = false;
    }
  }

  Future<void> _fetchUsers() async {
    try {
      // First try to fetch users from the API (most reliable)
      await fetchUsersFromApi();

      // If API didn't return users, try SignalR's GetOnlinePeople
      if (_onlineUsers.isEmpty && _isConnected && _hubConnection != null) {
        await getOnlinePeople();
      }

      // If still no users, add a default user
      _addDefaultUserIfEmpty();
    } catch (e) {
      print("Error fetching users: $e");
      _addDefaultUserIfEmpty();
    }
  }

  void _addDefaultUserIfEmpty() {
    if (_onlineUsers.isEmpty) {
      _onlineUsers
          .add(ChatUser(userId: "system", username: "System", isOnline: true));
      onUsersUpdated?.call(_onlineUsers);
    }
  }

  void _startHeartbeat() {
    // Cancel any existing heartbeat
    _heartbeatTimer?.cancel();

    // Send a ping every 30 seconds to keep the connection alive
    _heartbeatTimer = Timer.periodic(Duration(seconds: 30), (timer) async {
      if (_isConnected && _hubConnection != null) {
        try {
          // Invoke a harmless method to keep the connection alive
          await _hubConnection!.invoke('GetOnlinePeople', args: ["-1"]);
          print("Heartbeat sent");
        } catch (e) {
          print("Heartbeat failed: $e");
          // Don't reconnect here, let the automatic reconnection handle it
        }
      }
    });
  }

  Future<void> safeDisconnect() async {
    // Stop heartbeat
    _heartbeatTimer?.cancel();
    _heartbeatTimer = null;

    // Stop reconnect timer
    _reconnectTimer?.cancel();
    _reconnectTimer = null;

    if (_hubConnection != null) {
      try {
        if (_isConnected) {
          await _hubConnection!.stop();
        }
      } catch (e) {
        print("Error during safe disconnect: $e");
      } finally {
        _isConnected = false;
        _hubConnection = null;
      }
    }
  }

  void _setupEventHandlers() {
    if (_hubConnection == null) return;

    // Connection lifecycle events
    _hubConnection!.onclose((error) {
      print("Connection closed: $error");
      _isConnected = false;

      // Try to reconnect if not deliberately disconnecting
      if (!_reconnecting && !_connectionInProgress) {
        _scheduleReconnect();
      }
    });

    _hubConnection!.onreconnecting((error) {
      print("Reconnecting: $error");
      _isConnected = false;
    });

    _hubConnection!.onreconnected((connectionId) {
      print("Reconnected: $connectionId");
      _isConnected = true;
      _fetchUsers(); // Refresh users after reconnection
    });

    // Chat-specific events
    _hubConnection!.on('ReceiveMessage', (arguments) {
      if (arguments != null && arguments.isNotEmpty) {
        try {
          final messageData = arguments[0] as Map<String, dynamic>;
          final message = ChatMessage.fromJson(messageData);
          onMessageReceived?.call(message);
        } catch (e) {
          print("Error processing received message: $e");
        }
      }
    });

    _hubConnection!.on('UpdateOnlineUsers', (arguments) {
      if (arguments != null && arguments.isNotEmpty) {
        try {
          final List<dynamic> usersData = arguments[0] as List<dynamic>;
          _updateUsersList(usersData);
          print("Received UpdateOnlineUsers with ${usersData.length} users");
        } catch (e) {
          print("Error processing online users update: $e");
        }
      }
    });

    _hubConnection!.on('UserTyping', (arguments) {
      if (arguments != null && arguments.isNotEmpty) {
        final userId = arguments[0] as String? ?? '';
        onTyping?.call(userId);
      }
    });

    // Call-related events
    _hubConnection!.on('IncomingCall', (arguments) {
      if (arguments != null && arguments.length >= 3) {
        final callerId = arguments[0] as String? ?? '';
        final callerName = arguments[1] as String? ?? '';
        final isVideo = arguments[2] as bool? ?? false;

        onIncomingCall?.call(CallInfo(
          callerId: callerId,
          callerName: callerName,
          isVideoCall: isVideo,
        ));
      }
    });

    _hubConnection!.on('CallAccepted', (arguments) {
      if (arguments != null && arguments.isNotEmpty) {
        final receiverId = arguments[0] as String? ?? '';
        onCallAccepted?.call(receiverId);
      }
    });

    _hubConnection!.on('CallRejected', (arguments) {
      if (arguments != null && arguments.isNotEmpty) {
        final receiverId = arguments[0] as String? ?? '';
        onCallRejected?.call(receiverId);
      }
    });

    _hubConnection!.on('CallEnded', (arguments) {
      if (arguments != null && arguments.isNotEmpty) {
        final userId = arguments[0] as String? ?? '';
        onCallEnded?.call(userId);
      }
    });

    // Server provides user list via GetOnlinePeople event
    _hubConnection!.on('GetOnlinePeople', (arguments) {
      if (arguments != null && arguments.length >= 1) {
        try {
          final List<dynamic> onlineUsers = arguments[0] as List<dynamic>;
          final String chosen =
              arguments.length > 1 ? arguments[1] as String : "-1";

          print(
              "Received online users with chosen: $chosen, count: ${onlineUsers.length}");
          _updateUsersList(onlineUsers);
        } catch (e) {
          print("Error processing GetOnlinePeople event: $e");
        }
      } else {
        print("GetOnlinePeople received but no arguments");
      }
    });
  }

  void _scheduleReconnect() {
    if (_reconnectTimer != null && _reconnectTimer!.isActive) {
      _reconnectTimer!.cancel();
    }

    if (_connectionRetryCount < _maxRetryAttempts) {
      _connectionRetryCount++;
      final delay = math.pow(2, _connectionRetryCount).toInt() * 1000;
      print(
          "Scheduling reconnect attempt $_connectionRetryCount in ${delay}ms");

      _reconnectTimer = Timer(Duration(milliseconds: delay), () {
        _reconnecting = true;
        connect();
      });
    } else {
      print("Max reconnection attempts reached");
      onConnectionError
          ?.call("Failed to reconnect after $_maxRetryAttempts attempts");
    }
  }

  // Implementation of GetOnlinePeople function that matches the server design
  Future<void> getOnlinePeople({String chosen = "-1"}) async {
    try {
      if (!_isConnected || _hubConnection == null) {
        print("Cannot get online people: not connected to chat server");
        await fetchUsersFromApi();
        return;
      }

      try {
        // Try the SignalR invoke format the server expects
        await _hubConnection!.invoke('GetOnlinePeople', args: [chosen]);
        print("GetOnlinePeople invoked successfully");
      } catch (e) {
        print("Error invoking GetOnlinePeople: $e");

        // Try alternate method call format
        try {
          await _hubConnection!.invoke('getOnlinePeople', args: [chosen]);
          print("getOnlinePeople (lowercase) invoked successfully");
        } catch (e2) {
          print("Alternate method also failed: $e2");

          // If connection issue, try to reconnect
          if (e.toString().contains("Connection stopped") ||
              e.toString().contains("Connection disconnected")) {
            if (!_reconnecting && !_connectionInProgress) {
              _scheduleReconnect();
            }
          } else {
            // For other errors, try API fallback
            await fetchUsersFromApi();
          }
        }
      }
    } catch (e) {
      print("Error in getOnlinePeople: $e");
      await fetchUsersFromApi();
    }
  }

  Future<void> fetchUsersFromApi() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString('CookieToken');

      // Also check for pToken if available
      if (token == null) {
        token = prefs.getString('pToken');
      }

      // Use fallback token if still null
      if (token == null) {
        token =
            "s1PPIgtC8AG+x0Qr+F++zHFBLOB0MqKzFYt6vDHr259yJ6US7WrK16pDo/8ua4bLbSKwDAcTH+fLXsglVzz8hu03D7CzF+kX8vnruONnAB/O56YZe/pbymI1ZJioW3V3MqTnCiHoUagPLTzjZOj2N4kxH7WSSn89t9gtQwWJW3XmzYYO/EkMRQ7vRUaxKGW77ExLEvmi8FDqHg9cbgIApN33KQpW6bMY2wx1bWkNW68jTanUeOpLCWx9JXx3ul1W";
      }

      if (token == null) {
        print("Error: Authentication token is missing");
        _addDefaultUserIfEmpty();
        return;
      }

      // Try different API endpoints and authentication methods
      await _tryMultipleApiFetches(token);
    } catch (e) {
      print("Exception in fetchUsersFromApi: $e");
      _addDefaultUserIfEmpty();
    }
  }

  Future<void> _tryMultipleApiFetches(String token) async {
    bool success = false;

    // Define all options to try
    final endpoints = [
      'https://infinitely-native-lamprey.ngrok-free.app/user/users',
      'https://infinitely-native-lamprey.ngrok-free.app/api/users',
      'https://infinitely-native-lamprey.ngrok-free.app/users',
      'https://infinitely-native-lamprey.ngrok-free.app/chat/users',
    ];

    final authHeaders = [
      {'Authorization': 'Bearer $token', 'Content-Type': 'application/json'},
      {'Authentication': token, 'Content-Type': 'application/json'},
      {'token': token, 'Content-Type': 'application/json'},
    ];

    // Try each combination
    for (var endpoint in endpoints) {
      for (var headers in authHeaders) {
        if (success) break;

        try {
          final response = await _dio.get(
            endpoint,
            options: Options(headers: headers),
          );

          if (_processUserResponse(response)) {
            success = true;
            print("Successfully fetched users from $endpoint");
            break;
          }
        } catch (e) {
          print("Failed with endpoint $endpoint and headers $headers: $e");
        }
      }

      if (success) break;
    }

    if (!success) {
      _addDefaultUserIfEmpty();
    }
  }

  bool _processUserResponse(Response response) {
    if (response.statusCode == 200) {
      try {
        // Handle the case where the response could be a map or a list
        if (response.data is List) {
          final List<dynamic> usersData = response.data as List<dynamic>;
          _updateUsersList(usersData);
          return true;
        } else if (response.data is Map) {
          // If it's a map, check if there's a users array inside it
          final Map<String, dynamic> responseMap =
              response.data as Map<String, dynamic>;
          if (responseMap.containsKey('users') &&
              responseMap['users'] is List) {
            final List<dynamic> usersData =
                responseMap['users'] as List<dynamic>;
            _updateUsersList(usersData);
            return true;
          } else {
            // If there's no users array, create a single user from the map
            try {
              final user = ChatUser.fromJson(responseMap);
              _onlineUsers.clear();
              _onlineUsers.add(user);
              onUsersUpdated?.call(_onlineUsers);
              return true;
            } catch (e) {
              print("Error creating user from map: $e");
            }
          }
        }
      } catch (e) {
        print("Error parsing users data: $e");
        print("Response data type: ${response.data.runtimeType}");
        print("Response data: ${response.data}");
      }
    } else {
      print("Non-200 response: ${response.statusCode} - ${response.data}");
    }
    return false;
  }

  void _updateUsersList(List<dynamic> usersData) {
    if (usersData.isEmpty) {
      print("Received empty users list");
      _addDefaultUserIfEmpty();
      return;
    }

    print("Updating users list with ${usersData.length} users");

    _onlineUsers.clear();

    // Process each user
    for (var userData in usersData) {
      try {
        final user = ChatUser.fromJson(userData);
        _onlineUsers.add(user);
      } catch (e) {
        print("Error parsing user data: $e");
      }
    }

    // Add current user if not in the list
    if (_currentUserId != null &&
        !_onlineUsers.any((u) => u.userId == _currentUserId)) {
      _onlineUsers.add(ChatUser(
        userId: _currentUserId!,
        username: "You",
        isOnline: true,
      ));
    }

    // Ensure we have at least a system user if the list is empty
    _addDefaultUserIfEmpty();

    // Notify listeners
    onUsersUpdated?.call(_onlineUsers);
  }

  // Messaging methods
  Future<bool> sendMessage(String receiverId, String content,
      {MessageType type = MessageType.text}) async {
    if (content.trim().isEmpty) return false;

    if (_isConnected && _hubConnection != null) {
      try {
        await _hubConnection!.invoke('SendMessage', args: [
          receiverId,
          content,
          type.toString().split('.').last,
        ]);
        return true;
      } catch (e) {
        print("Error sending message: $e");

        // Try to reconnect if connection lost
        if (e.toString().contains("Connection stopped") ||
            e.toString().contains("Connection disconnected")) {
          if (!_reconnecting && !_connectionInProgress) {
            _scheduleReconnect();
          }
        }
        return false;
      }
    } else {
      print("Cannot send message: not connected to chat server");
      if (!_reconnecting && !_connectionInProgress) {
        _scheduleReconnect();
      }
      return false;
    }
  }

  Future<void> sendTypingNotification(String receiverId) async {
    if (!_isConnected || _hubConnection == null) return;

    try {
      await _hubConnection!
          .invoke('SendTypingNotification', args: [receiverId]);
    } catch (e) {
      print("Error sending typing notification: $e");
    }
  }

  // Call-related methods
  Future<bool> initiateCall(String receiverId, bool isVideoCall) async {
    if (!_isConnected || _hubConnection == null) {
      print("Cannot initiate call: not connected to chat server");
      if (!_reconnecting && !_connectionInProgress) {
        _scheduleReconnect();
      }
      return false;
    }

    try {
      await _hubConnection!
          .invoke('InitiateCall', args: [receiverId, isVideoCall]);
      return true;
    } catch (e) {
      print("Error initiating call: $e");
      return false;
    }
  }

  Future<bool> acceptCall(String callerId) async {
    if (!_isConnected || _hubConnection == null) return false;

    try {
      await _hubConnection!.invoke('AcceptCall', args: [callerId]);
      return true;
    } catch (e) {
      print("Error accepting call: $e");
      return false;
    }
  }

  Future<bool> rejectCall(String callerId) async {
    if (!_isConnected || _hubConnection == null) return false;

    try {
      await _hubConnection!.invoke('RejectCall', args: [callerId]);
      return true;
    } catch (e) {
      print("Error rejecting call: $e");
      return false;
    }
  }

  Future<bool> endCall(String peerId) async {
    if (!_isConnected || _hubConnection == null) return false;

    try {
      await _hubConnection!.invoke('EndCall', args: [peerId]);
      return true;
    } catch (e) {
      print("Error ending call: $e");
      return false;
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
    if (_reconnectTimer != null && _reconnectTimer!.isActive) {
      _reconnectTimer!.cancel();
      _reconnectTimer = null;
    }

    if (_heartbeatTimer != null && _heartbeatTimer!.isActive) {
      _heartbeatTimer!.cancel();
      _heartbeatTimer = null;
    }

    await safeDisconnect();
  }
}
