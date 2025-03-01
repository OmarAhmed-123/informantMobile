/*
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:graduation___part1/views/profile.dart';
import 'chat_cubit.dart';
import 'chat_service.dart';

class ChatOverlay extends StatefulWidget {
  final String username;

  const ChatOverlay({
    super.key,
    required this.username,
  });

  @override
  ChatOverlayState createState() => ChatOverlayState();
}

class ChatOverlayState extends State<ChatOverlay> {
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  bool _isChatVisible = false;

  void _toggleChat() {
    setState(() {
      _isChatVisible = !_isChatVisible;
    });
  }

  void _scrollToBottom() {
    Future.delayed(const Duration(milliseconds: 100), () {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        if (!_isChatVisible)
          Positioned(
            bottom: 20,
            right: 20,
            child: FloatingActionButton(
              onPressed: _toggleChat,
              backgroundColor: Colors.blue.shade700,
              child: const Icon(Icons.message),
            ),
          ),
        if (_isChatVisible)
          Positioned.fill(
            child: GestureDetector(
              onTap: _toggleChat,
              child: Container(
                color: Colors.black.withOpacity(0.5),
              ),
            ),
          ),
        if (_isChatVisible)
          Positioned(
            bottom: 0,
            right: 0,
            width: MediaQuery.of(context).size.width * 0.8,
            child: BlocProvider(
              create: (context) => ChatCubit(ChatService()),
              child: ChatWindow(
                scrollController: _scrollController,
                messageController: _messageController,
                onSendMessage: (message) {
                  context
                      .read<ChatCubit>()
                      .sendMessage(message, widget.username);
                },
                onClose: _toggleChat,
                username: widget.username,
              ),
            ),
          ),
      ],
    );
  }
}

class ChatWindow extends StatelessWidget {
  final ScrollController scrollController;
  final TextEditingController messageController;
  final Function(String) onSendMessage;
  final VoidCallback onClose;
  final String username;

  const ChatWindow({
    super.key,
    required this.scrollController,
    required this.messageController,
    required this.onSendMessage,
    required this.onClose,
    required this.username,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.7,
      margin: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey[900],
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.3),
            blurRadius: 10,
            spreadRadius: 5,
          ),
        ],
      ),
      child: Column(
        children: [
          _buildChatHeader(),
          Expanded(
            child: _buildMessageList(),
          ),
          _buildMessageInput(),
        ],
      ),
    );
  }

  Widget _buildChatHeader() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      decoration: const BoxDecoration(
        color: Colors.blue,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      child: Row(
        children: [
          const CircleAvatar(
            radius: 20,
            backgroundColor: Colors.white,
            child: Icon(Icons.message, color: Colors.blue),
          ),
          const SizedBox(width: 12),
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Live Chat",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  "Online",
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
          IconButton(
            icon: const Icon(Icons.close, color: Colors.white),
            onPressed: onClose,
          ),
        ],
      ),
    );
  }
/*
  Widget _buildMessageList() {
    return BlocBuilder<ChatCubit, List<ChatMessage>>(
      builder: (context, messages) {
        return ListView.builder(
          controller: scrollController,
          padding: const EdgeInsets.only(top: 16),
          itemCount: messages.length,
          itemBuilder: (context, index) {
            final message = messages[index];
            return ChatBubble(
              message: message.text,
              isMe: message.sender == username,
            );
          },
        );
      },
    );
  }
*/
  Widget _buildMessageInput() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey[850],
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(20),
          bottomRight: Radius.circular(20),
        ),
      ),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: messageController,
              style: const TextStyle(color: Colors.white),
              decoration: InputDecoration(
                hintText: "Type a message...",
                hintStyle: TextStyle(color: Colors.grey[400]),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                  borderSide: BorderSide.none,
                ),
                filled: true,
                fillColor: Colors.grey[800],
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 10,
                ),
              ),
              onSubmitted: onSendMessage,
            ),
          ),
          const SizedBox(width: 8),
          FloatingActionButton(
            mini: true,
            backgroundColor: Colors.blue,
            child: const Icon(Icons.send),
            onPressed: () {
              if (messageController.text.isNotEmpty) {
                onSendMessage(messageController.text);
                messageController.clear();
              }
            },
          ),
        ],
      ),
    );
  }
}

class ChatBubble extends StatelessWidget {
  final String message;
  final bool isMe;

  const ChatBubble({
    super.key,
    required this.message,
    required this.isMe,
  });

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: isMe ? Colors.blue : Colors.grey[800],
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(
          message,
          style: const TextStyle(color: Colors.white),
        ),
      ),
    );
  }
}
*/