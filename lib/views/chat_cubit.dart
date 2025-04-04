/*
import 'package:flutter_bloc/flutter_bloc.dart';
import 'chat_service.dart';

// Define the ChatMessage class
class ChatMessage {
  final String text;
  final String sender;
  final DateTime timestamp;

  ChatMessage({
    required this.text,
    required this.sender,
    required this.timestamp,
  });
}

class ChatCubit extends Cubit<List<ChatMessage>> {
  final ChatService _chatService;

  ChatCubit(this._chatService) : super([]) {
    _initialize();
  }

  void _initialize() async {
    await _chatService.connect();
    _chatService.onReceiveMessage((sender, message) {
      final chatMessage = ChatMessage(
        text: message,
        sender: sender,
        timestamp: DateTime.now(),
      );
      emit([...state, chatMessage]);
    });
  }

  void sendMessage(String message, String sender) {
    _chatService.sendMessage(message, sender);
  }

  @override
  Future<void> close() async {
    await _chatService.disconnect();
    return super.close();
  }
}
*/
/*
import 'package:flutter_bloc/flutter_bloc.dart';

enum MessageType { text, audio }

class ChatMessage {
  final String id;
  final String sender;
  final String text;
  final DateTime timestamp;
  final MessageType type;
  final ChatMessage? replyTo;
  final String? audioPath;

  ChatMessage({
    required this.id,
    required this.sender,
    required this.text,
    required this.timestamp,
    this.type = MessageType.text,
    this.replyTo,
    this.audioPath,
  });
}

class ChatCubit extends Cubit<List<ChatMessage>> {
  ChatCubit() : super([]);

  void sendMessage(String message, String sender, {ChatMessage? replyTo}) {
    final newMessage = ChatMessage(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      sender: sender,
      text: message,
      timestamp: DateTime.now(),
      type: MessageType.text,
      replyTo: replyTo,
    );

    emit([...state, newMessage]);
  }

  void sendAudioMessage(String audioPath, String sender,
      {ChatMessage? replyTo}) {
    final newMessage = ChatMessage(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      sender: sender,
      text: "Voice message",
      timestamp: DateTime.now(),
      type: MessageType.audio,
      replyTo: replyTo,
      audioPath: audioPath,
    );

    emit([...state, newMessage]);
  }
}
*/

/*
import 'package:flutter_bloc/flutter_bloc.dart';

enum MessageType { text, audio }

class ChatMessage {
  final String id;
  final String sender;
  final String text;
  final DateTime timestamp;
  final MessageType type;
  final ChatMessage? replyTo;
  final String? audioPath;

  ChatMessage({
    required this.id,
    required this.sender,
    required this.text,
    required this.timestamp,
    this.type = MessageType.text,
    this.replyTo,
    this.audioPath,
  });
}

class ChatCubit extends Cubit<List<ChatMessage>> {
  ChatCubit() : super([]);

  void sendMessage(String message, String sender, {ChatMessage? replyTo}) {
    final newMessage = ChatMessage(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      sender: sender,
      text: message,
      timestamp: DateTime.now(),
      type: MessageType.text,
      replyTo: replyTo,
    );

    emit([...state, newMessage]);
  }

  void sendAudioMessage(String audioPath, String sender,
      {ChatMessage? replyTo}) {
    final newMessage = ChatMessage(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      sender: sender,
      text: "Voice message",
      timestamp: DateTime.now(),
      type: MessageType.audio,
      replyTo: replyTo,
      audioPath: audioPath,
    );

    emit([...state, newMessage]);
  }
}

*/
/*
import 'package:flutter_bloc/flutter_bloc.dart';

enum MessageType { text, audio }

class ChatMessage {
  final String id;
  final String sender;
  final String text;
  final DateTime timestamp;
  final MessageType type;
  final ChatMessage? replyTo;
  final String? audioPath;

  ChatMessage({
    required this.id,
    required this.sender,
    required this.text,
    required this.timestamp,
    this.type = MessageType.text,
    this.replyTo,
    this.audioPath,
  });
}

class ChatCubit extends Cubit<List<ChatMessage>> {
  ChatCubit() : super([]);

  void sendMessage(String message, String sender, {ChatMessage? replyTo}) {
    final newMessage = ChatMessage(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      sender: sender,
      text: message,
      timestamp: DateTime.now(),
      type: MessageType.text,
      replyTo: replyTo,
    );

    emit([...state, newMessage]);
  }

  void sendAudioMessage(String audioPath, String sender, {ChatMessage? replyTo}) {
    final newMessage = ChatMessage(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      sender: sender,
      text: "Voice message",
      timestamp: DateTime.now(),
      type: MessageType.audio,
      replyTo: replyTo,
      audioPath: audioPath,
    );

    emit([...state, newMessage]);
  }
}
*/
/*
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'chat_service.dart' as service;

enum MessageType { text, audio }

class ChatMessage {
  final String id;
  final String sender;
  final String text;
  final DateTime timestamp;
  final MessageType type;
  final ChatMessage? replyTo;
  final String? audioPath;

  ChatMessage({
    required this.id,
    required this.sender,
    required this.text,
    required this.timestamp,
    this.type = MessageType.text,
    this.replyTo,
    this.audioPath,
  });

  factory ChatMessage.fromServiceMessage(service.ChatMessage message) {
    return ChatMessage(
      id: message.id,
      sender: message.senderId,
      text: message.content,
      timestamp: message.timestamp,
      type: message.type == service.MessageType.audio
          ? MessageType.audio
          : MessageType.text,
      audioPath:
          message.type == service.MessageType.audio ? message.content : null,
    );
  }
}

class ChatCubit extends Cubit<List<ChatMessage>> {
  final service.ChatService _chatService = service.ChatService();
  String? _selectedReceiverId;

  String get _getReceiverId => _selectedReceiverId ?? 'default-receiver-id';

  ChatCubit() : super([]) {
    _initializeChat();
  }

  Future<void> _initializeChat() async {
    try {
      await _chatService.connect();
      _chatService.onMessageReceived = _handleMessageReceived;
    } catch (e) {
      debugPrint('Error initializing chat service: $e');
    }
  }

  void _handleMessageReceived(service.ChatMessage message) {
    if (_selectedReceiverId != null &&
        (message.senderId == _selectedReceiverId ||
            message.receiverId == _selectedReceiverId)) {
      final newUiMessage = ChatMessage.fromServiceMessage(message);
      emit([...state, newUiMessage]);
    }
  }

  void selectReceiver(String receiverId) {
    _selectedReceiverId = receiverId;
  }

  void sendMessage(String message, String sender, {ChatMessage? replyTo}) {
    try {
      _chatService.sendMessage(
        _getReceiverId,
        message,
      );

      final newMessage = ChatMessage(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        sender: sender,
        text: message,
        timestamp: DateTime.now(),
        type: MessageType.text,
        replyTo: replyTo,
      );

      emit([...state, newMessage]);
    } catch (e) {
      debugPrint('Error sending message: $e');
    }
  }

  void sendAudioMessage(String audioPath, String sender,
      {ChatMessage? replyTo}) {
    try {
      _chatService.sendMessage(
        _getReceiverId,
        audioPath,
        type: service.MessageType.audio,
      );

      final newMessage = ChatMessage(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        sender: sender,
        text: "Voice message",
        timestamp: DateTime.now(),
        type: MessageType.audio,
        replyTo: replyTo,
        audioPath: audioPath,
      );

      emit([...state, newMessage]);
    } catch (e) {
      debugPrint('Error sending audio message: $e');
    }
  }

  void sendTypingNotification() {
    try {
      if (_selectedReceiverId != null) {
        _chatService.sendTypingNotification(_selectedReceiverId!);
      }
    } catch (e) {
      debugPrint('Error sending typing notification: $e');
    }
  }

  @override
  Future<void> close() async {
    await _chatService.disconnect();
    return super.close();
  }
}
*/

import 'package:flutter_bloc/flutter_bloc.dart';
import 'chat_service.dart' as service;

enum MessageType { text, audio, image, video }

class ChatMessage {
  final String id;
  final String sender;
  final String receiver;
  final String text;
  final DateTime timestamp;
  final MessageType type;
  final ChatMessage? replyTo;
  final String? audioPath;
  final String? imagePath;

  ChatMessage({
    required this.id,
    required this.sender,
    required this.receiver,
    required this.text,
    required this.timestamp,
    this.type = MessageType.text,
    this.replyTo,
    this.audioPath,
    this.imagePath,
  });

  // Factory constructor to convert service.ChatMessage to ChatMessage
  factory ChatMessage.fromServiceMessage(service.ChatMessage message) {
    MessageType msgType;
    String? audioPath;
    String? imagePath;

    switch (message.type) {
      case service.MessageType.audio:
        msgType = MessageType.audio;
        audioPath = message.localFilePath ?? message.content;
        break;
      case service.MessageType.image:
        msgType = MessageType.image;
        imagePath = message.localFilePath ?? message.content;
        break;
      case service.MessageType.video:
        msgType = MessageType.video;
        break;
      default:
        msgType = MessageType.text;
    }

    return ChatMessage(
      id: message.id,
      sender: message.senderId,
      receiver: message.receiverId,
      text: message.content,
      timestamp: message.timestamp,
      type: msgType,
      audioPath: audioPath,
      imagePath: imagePath,
    );
  }
}

class ChatCubit extends Cubit<List<ChatMessage>> {
  final service.ChatService _chatService = service.ChatService();
  String? _selectedReceiverId;

  // Default to a test receiver ID if none is selected
  String get _getReceiverId => _selectedReceiverId ?? 'default-receiver-id';

  ChatCubit() : super([]) {
    _initializeChat();
  }

  Future<void> _initializeChat() async {
    try {
      await _chatService.connect();
      _chatService.onMessageReceived = _handleMessageReceived;
    } catch (e) {
      print('Error initializing chat service: $e');
    }
  }

  void _handleMessageReceived(service.ChatMessage message) {
    if (_selectedReceiverId != null &&
        (message.senderId == _selectedReceiverId ||
            message.receiverId == _selectedReceiverId)) {
      final newUiMessage = ChatMessage.fromServiceMessage(message);
      emit([...state, newUiMessage]);
    }
  }

  void selectReceiver(String receiverId) {
    _selectedReceiverId = receiverId;
    // Clear the chat history when switching receivers
    emit([]);
  }

  void sendMessage(String message, String sender,
      {String? receiverId, ChatMessage? replyTo}) {
    try {
      final actualReceiverId = receiverId ?? _getReceiverId;

      _chatService.sendMessage(
        actualReceiverId,
        message,
        type: service.MessageType.text,
      );

      final newMessage = ChatMessage(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        sender: sender,
        receiver: actualReceiverId,
        text: message,
        timestamp: DateTime.now(),
        type: MessageType.text,
        replyTo: replyTo,
      );

      emit([...state, newMessage]);
    } catch (e) {
      print('Error sending message: $e');
    }
  }

  void sendAudioMessage(String audioPath, String sender, String receiverId,
      {ChatMessage? replyTo}) {
    try {
      // The actual sending happens in the chat_window widget
      // We just update the UI state here
      final newMessage = ChatMessage(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        sender: sender,
        receiver: receiverId,
        text: "Voice message",
        timestamp: DateTime.now(),
        type: MessageType.audio,
        replyTo: replyTo,
        audioPath: audioPath,
      );

      emit([...state, newMessage]);
    } catch (e) {
      print('Error sending audio message: $e');
    }
  }

  void sendImageMessage(String imagePath, String sender, String receiverId,
      {ChatMessage? replyTo}) {
    try {
      // The actual sending happens in the chat_window widget
      // We just update the UI state here
      final newMessage = ChatMessage(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        sender: sender,
        receiver: receiverId,
        text: "Image",
        timestamp: DateTime.now(),
        type: MessageType.image,
        replyTo: replyTo,
        imagePath: imagePath,
      );

      emit([...state, newMessage]);
    } catch (e) {
      print('Error sending image message: $e');
    }
  }

  // Add the missing method for typing notifications
  void sendTypingNotification() {
    try {
      if (_selectedReceiverId != null) {
        _chatService.sendTypingNotification(_selectedReceiverId!);
      }
    } catch (e) {
      print('Error sending typing notification: $e');
    }
  }

  @override
  Future<void> close() async {
    await _chatService.disconnect();
    return super.close();
  }
}
