/*
import 'package:flutter/material.dart';
import 'package:animate_do/animate_do.dart';
import 'chat_cubit.dart';
import 'audio_player_widget.dart';

class ChatBubble extends StatelessWidget {
  final ChatMessage message;
  final bool isMe;
  final VoidCallback onReply;

  const ChatBubble({
    super.key,
    required this.message,
    required this.isMe,
    required this.onReply,
  });

  @override
  Widget build(BuildContext context) {
    return FadeInUp(
      from: 20,
      duration: const Duration(milliseconds: 300),
      child: Align(
        alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
        child: Container(
          margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
          constraints: BoxConstraints(
            maxWidth: MediaQuery.of(context).size.width * 0.75,
          ),
          child: Column(
            crossAxisAlignment:
            isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
            children: [
              if (message.replyTo != null) _buildReplyPreview(context),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: isMe ? Colors.blue : Colors.grey[800],
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 3,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    if (message.type == MessageType.text)
                      Text(
                        message.text,
                        style: const TextStyle(color: Colors.white),
                      )
                    else if (message.type == MessageType.audio &&
                        message.audioPath != null)
                      AudioPlayerWidget(audioPath: message.audioPath!),
                    const SizedBox(height: 4),
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          _formatTimestamp(message.timestamp),
                          style: TextStyle(
                            color: Colors.white.withOpacity(0.6),
                            fontSize: 10,
                          ),
                        ),
                        if (isMe) ...[
                          const SizedBox(width: 4),
                          Icon(
                            Icons.done_all,
                            size: 12,
                            color: Colors.blue[100],
                          ),
                        ],
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 4),
              Row(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment:
                isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
                children: [
                  GestureDetector(
                    onTap: onReply,
                    child: Container(
                      padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: Colors.grey[850],
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.reply,
                            size: 12,
                            color: Colors.grey[400],
                          ),
                          const SizedBox(width: 4),
                          Text(
                            "Reply",
                            style: TextStyle(
                              color: Colors.grey[400],
                              fontSize: 10,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildReplyPreview(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Colors.grey[850]!.withOpacity(0.7),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: isMe
              ? Colors.blue.withOpacity(0.5)
              : Colors.grey.withOpacity(0.5),
          width: 1,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 2,
            height: 30,
            decoration: BoxDecoration(
              color: isMe ? Colors.blue : Colors.grey,
              borderRadius: BorderRadius.circular(1),
            ),
          ),
          const SizedBox(width: 8),
          Flexible(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  message.replyTo!.sender,
                  style: TextStyle(
                    color: isMe ? Colors.blue[300] : Colors.grey[400],
                    fontWeight: FontWeight.bold,
                    fontSize: 10,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  message.replyTo!.type == MessageType.text
                      ? message.replyTo!.text
                      : "Voice message",
                  style: TextStyle(
                    color: Colors.grey[400],
                    fontSize: 10,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String _formatTimestamp(DateTime timestamp) {
    return '${timestamp.hour}:${timestamp.minute.toString().padLeft(2, '0')}';
  }
}
*/
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:path/path.dart' as path;
import 'audio_player_widget.dart';
import 'chat_cubit.dart';

class ChatBubble extends StatelessWidget {
  final ChatMessage message;
  final bool isMe;
  final VoidCallback onReply;

  const ChatBubble({
    Key? key,
    required this.message,
    required this.isMe,
    required this.onReply,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 8),
        constraints: BoxConstraints(
          maxWidth: MediaQuery.of(context).size.width * 0.75,
        ),
        decoration: BoxDecoration(
          color: isMe ? Colors.blue.shade600 : Colors.grey.shade700,
          borderRadius: BorderRadius.circular(18),
        ),
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (message.replyTo != null) ...[
                _buildReplyPreview(context),
                const SizedBox(height: 8),
                const Divider(color: Colors.white24),
              ],

              // Message content based on type
              _buildMessageContent(),

              // Timestamp
              Align(
                alignment: Alignment.bottomRight,
                child: Padding(
                  padding: const EdgeInsets.only(top: 4),
                  child: Text(
                    "${message.timestamp.hour}:${message.timestamp.minute.toString().padLeft(2, '0')}",
                    style: TextStyle(
                      fontSize: 10,
                      color: Colors.grey.shade300,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildReplyPreview(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: isMe ? Colors.blue.shade800 : Colors.grey.shade800,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Reply to",
            style: TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.bold,
              color: Colors.grey.shade400,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            message.replyTo!.text,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              fontSize: 12,
              color: Colors.grey.shade300,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMessageContent() {
    switch (message.type) {
      case MessageType.audio:
        return _buildAudioContent();
      case MessageType.image:
        return _buildImageContent();
      case MessageType.video:
        return _buildVideoContent();
      case MessageType.text:
      default:
        return _buildTextContent();
    }
  }

  Widget _buildTextContent() {
    return Text(
      message.text,
      style: const TextStyle(
        color: Colors.white,
        fontSize: 16,
      ),
    );
  }

  Widget _buildAudioContent() {
    if (message.audioPath == null) {
      return const Text(
        "Audio message unavailable",
        style: TextStyle(
          color: Colors.white70,
          fontSize: 14,
          fontStyle: FontStyle.italic,
        ),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Voice Message",
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8),
        AudioPlayerWidget(audioPath: message.audioPath!),
      ],
    );
  }

  Widget _buildImageContent() {
    if (message.imagePath == null) {
      return const Text(
        "Image unavailable",
        style: TextStyle(
          color: Colors.white70,
          fontSize: 14,
          fontStyle: FontStyle.italic,
        ),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: Image.file(
            File(message.imagePath!),
            fit: BoxFit.cover,
            errorBuilder: (context, error, stackTrace) {
              return Container(
                height: 150,
                width: double.infinity,
                color: Colors.grey.shade800,
                alignment: Alignment.center,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.broken_image,
                        color: Colors.grey.shade600, size: 48),
                    const SizedBox(height: 8),
                    Text(
                      "Failed to load image",
                      style: TextStyle(color: Colors.grey.shade400),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
        const SizedBox(height: 4),
        Text(
          path.basename(message.imagePath!),
          style: const TextStyle(
            color: Colors.white70,
            fontSize: 12,
          ),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
      ],
    );
  }

  Widget _buildVideoContent() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          height: 160,
          decoration: BoxDecoration(
            color: Colors.black,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Center(
            child: Icon(
              Icons.play_circle_fill,
              size: 48,
              color: Colors.white.withOpacity(0.8),
            ),
          ),
        ),
        const SizedBox(height: 4),
        const Text(
          "Video message (tap to play)",
          style: TextStyle(
            color: Colors.white70,
            fontSize: 12,
          ),
        ),
      ],
    );
  }
}
