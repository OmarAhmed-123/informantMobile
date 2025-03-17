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
