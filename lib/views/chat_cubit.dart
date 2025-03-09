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