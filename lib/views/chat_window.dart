import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:animate_do/animate_do.dart';
import 'package:avatar_glow/avatar_glow.dart';
import 'chat_bubble.dart';
import 'chat_cubit.dart';
import 'voice_recorder.dart';

class ChatWindow extends StatefulWidget {
  final VoidCallback onClose;
  final VoidCallback onCall;
  final String username;

  const ChatWindow({
    super.key,
    required this.onClose,
    required this.onCall,
    required this.username,
  });

  @override
  State<ChatWindow> createState() => _ChatWindowState();
}

class _ChatWindowState extends State<ChatWindow> {
  final TextEditingController messageController = TextEditingController();
  final ScrollController scrollController = ScrollController();
  final VoiceRecorder voiceRecorder = VoiceRecorder();

  ChatMessage? replyingTo;
  bool isRecording = false;
  bool isSending = false;

  @override
  void dispose() {
    messageController.dispose();
    scrollController.dispose();
    voiceRecorder.disposeRecorder();
    super.dispose();
  }

  void _sendTextMessage() {
    final message = messageController.text;
    if (message.trim().isNotEmpty) {
      context.read<ChatCubit>().sendMessage(
            message,
            widget.username,
            replyTo: replyingTo,
          );
      messageController.clear();
      setState(() {
        replyingTo = null;
      });
      _scrollToBottom();
    }
  }

  void _startRecording() async {
    final hasPermission = await voiceRecorder.hasPermission();
    if (hasPermission) {
      try {
        await voiceRecorder.startRecording();
        setState(() {
          isRecording = true;
        });
      } catch (e) {
        print('Could not start recording: $e');
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Microphone permission required'),
        ),
      );
    }
  }

  void _stopRecording() async {
    if (isRecording) {
      setState(() {
        isSending = true;
      });

      final path = await voiceRecorder.stopRecording();
      setState(() {
        isRecording = false;
        isSending = false;
      });

      if (path != null) {
        context.read<ChatCubit>().sendAudioMessage(
              path,
              widget.username,
              replyTo: replyingTo,
            );
        setState(() {
          replyingTo = null;
        });
        _scrollToBottom();
      }
    }
  }

  void _cancelRecording() async {
    if (isRecording) {
      await voiceRecorder.cancelRecording();
      setState(() {
        isRecording = false;
      });
    }
  }

  void _reply(ChatMessage message) {
    setState(() {
      replyingTo = message;
    });
    FocusScope.of(context).requestFocus(FocusNode());
  }

  void _cancelReply() {
    setState(() {
      replyingTo = null;
    });
  }

  void _scrollToBottom() {
    if (scrollController.hasClients) {
      Future.delayed(const Duration(milliseconds: 100), () {
        scrollController.animateTo(
          scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      });
    }
  }

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
          _buildHeader(),
          Expanded(
            child: _buildMessageList(),
          ),
          if (replyingTo != null) _buildReplyPreview(),
          _buildMessageInput(),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 20,
        vertical: 16,
      ),
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
            child: Icon(
              Icons.message,
              color: Colors.blue,
            ),
          ),
          const SizedBox(width: 12),
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Chat",
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
            icon: const Icon(
              Icons.phone,
              color: Colors.white,
            ),
            onPressed: widget.onCall,
          ),
          IconButton(
            icon: const Icon(
              Icons.close,
              color: Colors.white,
            ),
            onPressed: widget.onClose,
          ),
        ],
      ),
    );
  }

  Widget _buildMessageList() {
    return BlocBuilder<ChatCubit, List<ChatMessage>>(
      builder: (context, messages) {
        if (messages.isEmpty) {
          return Center(
            child: FadeIn(
              duration: const Duration(milliseconds: 500),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.chat_bubble_outline,
                    size: 80,
                    color: Colors.blue[400],
                  ),
                  const SizedBox(height: 16),
                  Text(
                    "Start a conversation",
                    style: TextStyle(
                      color: Colors.grey[400],
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
            ),
          );
        }

        return ListView.builder(
          controller: scrollController,
          padding: const EdgeInsets.only(top: 16),
          itemCount: messages.length,
          itemBuilder: (context, index) {
            final message = messages[index];
            return GestureDetector(
              onLongPress: () => _reply(message),
              child: ChatBubble(
                message: message,
                isMe: message.sender == widget.username,
                onReply: () => _reply(message),
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildReplyPreview() {
    return FadeInUp(
      duration: const Duration(milliseconds: 200),
      child: Container(
        padding: const EdgeInsets.all(8),
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: Colors.grey[850],
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: Colors.blue.withOpacity(0.5),
            width: 1,
          ),
        ),
        child: Row(
          children: [
            Container(
              width: 4,
              height: 40,
              decoration: BoxDecoration(
                color: Colors.blue,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    replyingTo!.sender,
                    style: TextStyle(
                      color: Colors.blue[300],
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    replyingTo!.type == MessageType.text
                        ? replyingTo!.text
                        : "Voice message",
                    style: TextStyle(
                      color: Colors.grey[400],
                      fontSize: 12,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
            IconButton(
              icon: const Icon(
                Icons.close,
                size: 16,
                color: Colors.grey,
              ),
              onPressed: _cancelReply,
            ),
          ],
        ),
      ),
    );
  }

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
                hintText: isRecording ? "Recording..." : "Type a message...",
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
                suffixIcon: isRecording
                    ? IconButton(
                        icon: Icon(
                          Icons.delete,
                          color: Colors.red[300],
                        ),
                        onPressed: _cancelRecording,
                      )
                    : null,
                enabled: !isRecording,
              ),
              onSubmitted: (message) {
                if (message.trim().isNotEmpty) {
                  _sendTextMessage();
                }
              },
            ),
          ),
          const SizedBox(width: 8),
          GestureDetector(
            onLongPress: isRecording ? null : _startRecording,
            onLongPressEnd: isRecording ? (_) => _stopRecording() : null,
            child: AvatarGlow(
              glowRadiusFactor: 30,
              glowColor: Colors.blue,
              duration: const Duration(milliseconds: 2000),
              repeat: true,
              animate: isRecording,
              child: Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: isRecording ? Colors.red : Colors.blue,
                ),
                padding: const EdgeInsets.all(10),
                child: Icon(
                  isRecording ? Icons.mic : Icons.mic_none,
                  color: Colors.white,
                ),
              ),
            ),
          ),
          if (!isRecording) ...[
            const SizedBox(width: 8),
            FloatingActionButton(
              mini: true,
              backgroundColor: Colors.blue,
              child: const Icon(Icons.send),
              onPressed: _sendTextMessage,
            ),
          ],
        ],
      ),
    );
  }
}
