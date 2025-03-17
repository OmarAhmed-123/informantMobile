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
/*
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:graduation___part1/views/profile.dart';
import 'chat_service.dart';


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