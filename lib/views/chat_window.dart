/*
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

*/


/*
// Import statements at the top
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:avatar_glow/avatar_glow.dart';
import 'package:animate_do/animate_do.dart';
import 'chat_bubble.dart';
import 'audio_player_widget.dart';
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
  bool showVoiceRecorder = false;

  @override
  void initState() {
    super.initState();
    voiceRecorder.initialize();
  }

  @override
  void dispose() {
    messageController.dispose();
    scrollController.dispose();
    voiceRecorder.dispose();
    super.dispose();
  }

  void _sendTextMessage() {
    final message = messageController.text;
    if (message.trim().isNotEmpty) {
      _sendMessage(message, MessageType.text);
      messageController.clear();
    }
  }

  void _sendMessage(String content, MessageType type) {
    context.read<ChatCubit>().sendMessage(
      content: content,
      sender: widget.username,
      type: type,
      replyTo: replyingTo,
    );

    // Clear reply state after sending
    setState(() {
      replyingTo = null;
    });

    // Scroll to bottom after sending message
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (scrollController.hasClients) {
        scrollController.animateTo(
          scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  void _startRecording() async {
    await voiceRecorder.startRecording();
    setState(() {
      showVoiceRecorder = true;
    });
  }

  void _stopRecording() async {
    final path = await voiceRecorder.stopRecording();
    if (path != null) {
      _sendMessage(path, MessageType.audio);
    }
    setState(() {
      showVoiceRecorder = false;
    });
  }

  void _cancelRecording() async {
    await voiceRecorder.cancelRecording();
    setState(() {
      showVoiceRecorder = false;
    });
  }

  void _setReplyMessage(ChatMessage message) {
    setState(() {
      replyingTo = message;
    });
  }

  void _cancelReply() {
    setState(() {
      replyingTo = null;
    });
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
          _buildInputArea(),
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
        return ListView.builder(
          controller: scrollController,
          padding: const EdgeInsets.only(top: 16),
          itemCount: messages.length,
          itemBuilder: (context, index) {
            final message = messages[index];

            return FadeInUp(
              duration: const Duration(milliseconds: 300),
              delay: Duration(milliseconds: 50 * index),
              child: GestureDetector(
                onLongPress: () {
                  _setReplyMessage(message);
                },
                child: ChatBubble(
                  message: message,
                  isMe: message.sender == widget.username,
                ),
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildReplyPreview() {
    return Container(
      margin: const EdgeInsets.all(8),
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Colors.grey[800],
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.blue.withOpacity(0.5)),
      ),
      child: Row(
        children: [
          const Icon(Icons.reply, color: Colors.blue, size: 18),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  "Replying to ${replyingTo!.sender}",
                  style: TextStyle(
                    color: Colors.blue[200],
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  replyingTo!.type == MessageType.text
                      ? replyingTo!.content
                      : "Voice message",
                  style: const TextStyle(
                    color: Colors.white70,
                    fontSize: 12,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
          IconButton(
            icon: const Icon(Icons.close, color: Colors.white70, size: 16),
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(),
            onPressed: _cancelReply,
          ),
        ],
      ),
    );
  }

  Widget _buildInputArea() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey[850],
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(20),
          bottomRight: Radius.circular(20),
        ),
      ),
      child: Column(
        children: [
          if (showVoiceRecorder) _buildVoiceRecorderUI(),
          if (!showVoiceRecorder) _buildTextInputUI(),
        ],
      ),
    );
  }

  Widget _buildTextInputUI() {
    return Row(
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
            onSubmitted: (_) => _sendTextMessage(),
          ),
        ),
        const SizedBox(width: 8),
        GestureDetector(
          onLongPress: _startRecording,
          child: FloatingActionButton(
            mini: messageController.text.trim().isEmpty,
            backgroundColor: Colors.blue,
            child: Icon(
              messageController.text.trim().isEmpty
                  ? Icons.mic
                  : Icons.send,
            ),
            onPressed: messageController.text.trim().isEmpty
                ? null
                : _sendTextMessage,
          ),
        ),
      ],
    );
  }

  Widget _buildVoiceRecorderUI() {
    return Row(
      children: [
        Expanded(
          child: Container(
            padding: const EdgeInsets.symmetric(
              horizontal: 20,
              vertical: 10,
            ),
            decoration: BoxDecoration(
              color: Colors.grey[800],
              borderRadius: BorderRadius.circular(30),
            ),
            child: StreamBuilder<int>(
              stream: voiceRecorder.durationStream,
              initialData: 0,
              builder: (context, snapshot) {
                final duration = snapshot.data ?? 0;
                final minutes = (duration / 60).floor();
                final seconds = duration % 60;

                return Row(
                  children: [
                    Icon(
                      Icons.mic,
                      color: Colors.red[400],
                      size: 20,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      "Recording: ${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}",
                      style: const TextStyle(color: Colors.white),
                    ),
                  ],
                );
              },
            ),
          ),
        ),
        const SizedBox(width: 8),
        FloatingActionButton(
          mini: true,
          backgroundColor: Colors.red,
          child: const Icon(Icons.stop),
          onPressed: _stopRecording,
        ),
        const SizedBox(width: 8),
        FloatingActionButton(
          mini: true,
          backgroundColor: Colors.grey,
          child: const Icon(Icons.close),
          onPressed: _cancelRecording,
        ),
      ],
    );
  }
}

// Voice recorder button with animation
class RecordButton extends StatelessWidget {
  final VoidCallback onTap;
  final bool isRecording;

  const RecordButton({
    super.key,
    required this.onTap,
    this.isRecording = false,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AvatarGlow(
        endRadius: 40,
        animate: isRecording,
        // Removed the problematic parameter: showTwoGlows
        duration: const Duration(milliseconds: 1500),
        repeatPauseDuration: const Duration(milliseconds: 100),
        glowColor: Colors.red,
        child: Container(
          height: 50,
          width: 50,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: isRecording ? Colors.red : Colors.blue,
          ),
          child: Icon(
            isRecording ? Icons.stop : Icons.mic,
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}
*/

/*
import 'dart:core';
import 'dart:io';
import 'dart:ui';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:path_provider/path_provider.dart';
import 'package:record/record.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter_webrtc/flutter_webrtc.dart';
import 'package:animate_do/animate_do.dart';
import 'package:lottie/lottie.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:graduation___part1/views/audio_recorder_helper.dart';
import 'package:graduation___part1/views/chat_service.dart' as chat_service;
import 'package:graduation___part1/views/chat_cubit.dart';

// Import the ChatMessage and MessageType from chat_service.dart
// Make sure these are properly defined in chat_service.dart

// Recording class
class AudioRecord {
  final String id;
  final String filePath;
  final DateTime? createdAt;
  final Duration? duration;
  final String name;
  bool isPlaying;
  bool isPaused;

  AudioRecord({
    required this.id,
    required this.filePath,
    required this.createdAt,
    this.duration,
    required this.name,
    this.isPlaying = false,
    this.isPaused = false,
  });

  factory AudioRecord.create({
    required String filePath,
    required String name,
  }) {
    return AudioRecord(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      filePath: filePath,
      createdAt: DateTime.now(),
      name: name,
    );
  }

  factory AudioRecord.fromJson(Map<String, dynamic> json) {
    return AudioRecord(
      id: json['id'] as String,
      filePath: json['filePath'] as String,
      createdAt: DateTime.parse(json['createdAt'] as String),
      duration: json['duration'] != null
          ? Duration(milliseconds: json['duration'] as int)
          : null,
      name: json['name'] as String,
      isPlaying: json['isPlaying'] as bool? ?? false,
      isPaused: json['isPaused'] as bool? ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'filePath': filePath,
      'createdAt': createdAt?.toIso8601String(),
      'duration': duration?.inMilliseconds,
      'name': name,
      'isPlaying': isPlaying,
      'isPaused': isPaused,
    };
  }

  AudioRecord copyWith({
    String? id,
    String? filePath,
    DateTime? createdAt,
    Duration? duration,
    String? name,
    bool? isPlaying,
    bool? isPaused,
  }) {
    return AudioRecord(
      id: id ?? this.id,
      filePath: filePath ?? this.filePath,
      createdAt: createdAt ?? this.createdAt,
      duration: duration ?? this.duration,
      name: name ?? this.name,
      isPlaying: isPlaying ?? this.isPlaying,
      isPaused: isPaused ?? this.isPaused,
    );
  }

  AudioRecord updateDuration(Duration newDuration) {
    return copyWith(duration: newDuration);
  }

  String get durationString {
    if (duration == null) return "00:00";

    String twoDigits(int n) => n.toString().padLeft(2, '0');
    String twoDigitMinutes = twoDigits(duration!.inMinutes.remainder(60));
    String twoDigitSeconds = twoDigits(duration!.inSeconds.remainder(60));
    return "$twoDigitMinutes:$twoDigitSeconds";
  }

  String get formattedDate {
    return "${createdAt?.day}/${createdAt?.month}/${createdAt?.year}";
  }

  Future<double> get fileSize async {
    try {
      final file = File(filePath);
      final bytes = await file.length();
      return bytes / (1024 * 1024); // Convert to MB
    } catch (e) {
      return 0.0;
    }
  }

  Future<bool> exists() async {
    return File(filePath).exists();
  }

  Future<bool> deleteFile() async {
    try {
      final file = File(filePath);
      if (await file.exists()) {
        await file.delete();
        return true;
      }
      return false;
    } catch (e) {
      return false;
    }
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
          other is AudioRecord &&
              runtimeType == other.runtimeType &&
              id == other.id &&
              filePath == other.filePath;

  @override
  int get hashCode => id.hashCode ^ filePath.hashCode;

  @override
  String toString() {
    return 'AudioRecord{id: $id, name: $name, duration: $durationString}';
  }
}

// AudioRecorderHelper Class Implementation
class AudioRecorderHelper {
  final _audioRecorder = Record();
  bool _isRecording = false;

  bool get isRecording => _isRecording;

  Future<bool> hasPermission() async {
    return await AudioPermissionHandler.hasPermission();
  }

  Future<void> start() async {
    if (!_isRecording) {
      try {
        final directory = await getTemporaryDirectory();
        final filePath =
            '${directory.path}/audio_${DateTime.now().millisecondsSinceEpoch}.m4a';

        await _audioRecorder.start(
          path: filePath,
          encoder: AudioEncoder.aacLc,
          bitRate: 128000,
          samplingRate: 44100,
        );
        _isRecording = true;
      } catch (e) {
        print('Error starting recording: $e');
        rethrow;
      }
    }
  }

  Future<String?> stop() async {
    if (_isRecording) {
      try {
        final path = await _audioRecorder.stop();
        _isRecording = false;
        return path;
      } catch (e) {
        print('Error stopping recording: $e');
        return null;
      }
    }
    return null;
  }

  Future<void> dispose() async {
    // Record doesn't have a dispose method in newer versions
    if (_isRecording) {
      await _audioRecorder.stop();
    }
  }
}

// AudioPermissionHandler Class Implementation
class AudioPermissionHandler {
  static Future<bool> hasPermission() async {
    try {
      PermissionStatus microphoneStatus = await Permission.microphone.status;

      if (!microphoneStatus.isGranted) {
        microphoneStatus = await Permission.microphone.request();
      }

      if (Platform.isAndroid) {
        PermissionStatus storageStatus = await Permission.storage.status;

        if (!storageStatus.isGranted) {
          storageStatus = await Permission.storage.request();
        }

        return microphoneStatus.isGranted && storageStatus.isGranted;
      }

      return microphoneStatus.isGranted;
    } catch (e) {
      print('Error checking permissions: $e');
      return false;
    }
  }

  static Future<bool> requestPermission() async {
    try {
      PermissionStatus microphoneStatus = await Permission.microphone.request();

      if (Platform.isAndroid) {
        PermissionStatus storageStatus = await Permission.storage.request();
        return microphoneStatus.isGranted && storageStatus.isGranted;
      }

      return microphoneStatus.isGranted;
    } catch (e) {
      print('Error requesting permissions: $e');
      return false;
    }
  }

  static Future<bool> isPermanentlyDenied() async {
    try {
      bool microphoneDenied = await Permission.microphone.isPermanentlyDenied;

      if (Platform.isAndroid) {
        bool storageDenied = await Permission.storage.isPermanentlyDenied;
        return microphoneDenied || storageDenied;
      }

      return microphoneDenied;
    } catch (e) {
      print('Error checking permanent denial: $e');
      return false;
    }
  }

  static Future<void> openSettings() async {
    try {
      await openAppSettings();
    } catch (e) {
      print('Error opening settings: $e');
    }
  }
}

class ChatApp extends StatefulWidget {
  final String username;
  final String userId;
  final VoidCallback onLogout;

  const ChatApp({
    Key? key,
    required this.username,
    required this.userId,
    required this.onLogout,
  }) : super(key: key);

  @override
  State<ChatApp> createState() => _ChatAppState();
}

class _ChatAppState extends State<ChatApp> with SingleTickerProviderStateMixin {
  bool _isExpanded = false;
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;
  String? _backgroundImage;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );

    _scaleAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.elasticOut,
      ),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  Future<void> _selectBackgroundImage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);

    if (image != null) {
      setState(() {
        _backgroundImage = image.path;
      });
    }
  }

  void _toggleChat() {
    setState(() {
      _isExpanded = !_isExpanded;
      if (_isExpanded) {
        _animationController.forward();
      } else {
        _animationController.reverse();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: Stack(
        children: [
          if (_isExpanded)
            GestureDetector(
              onTap: _toggleChat,
              child: Container(
                color: Colors.black.withOpacity(0.5),
              ),
            ),
          AnimatedPositioned(
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeInOut,
            right: 16,
            bottom: _isExpanded ? 80 : 16,
            child: _isExpanded
                ? ScaleTransition(
              scale: _scaleAnimation,
              child: Container(
                width: MediaQuery.of(context).size.width * 0.9,
                height: MediaQuery.of(context).size.height * 0.8,
                decoration: BoxDecoration(
                  color: Colors.transparent,
                  borderRadius: BorderRadius.circular(24),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(24),
                  child: BlocBuilder<ChatCubit, List<ChatMessage>>(
                    builder: (context, messages) {
                      // Since we're using a different state structure, we'll adapt our UI
                      final incomingCall = null; // No incoming call in this simple implementation
                      final selectedUser = null; // No selected user
                      final users = <chat_service.ChatUser>[]; // Empty users list
                      final isInCall = false; // Not in call
                      final viewState = ChatViewState.loaded; // Default state

                      return Stack(
                        children: [
                          // Background
                          _backgroundImage != null
                              ? Image.file(
                            File(_backgroundImage!),
                            fit: BoxFit.cover,
                            width: double.infinity,
                            height: double.infinity,
                          )
                              : Container(
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                                colors: [
                                  Colors.blue.shade900,
                                  Colors.black,
                                ],
                              ),
                            ),
                          ),

                          // Chat interface with frosted glass effect
                          BackdropFilter(
                            filter: _backgroundImage != null
                                ? ImageFilter.blur(sigmaX: 10, sigmaY: 10)
                                : ImageFilter.blur(sigmaX: 0, sigmaY: 0),
                            child: Container(
                              color: _backgroundImage != null
                                  ? Colors.black.withOpacity(0.3)
                                  : Colors.transparent,
                              child: Column(
                                children: [
                                  // Chat header
                                  _buildChatHeader(context, messages),

                                  // Chat body
                                  Expanded(
                                    child: _buildMessageArea(messages),
                                  ),
                                ],
                              ),
                            ),
                          ),

                          // Active call overlay
                          if (isInCall) _buildCallOverlay(context),
                        ],
                      );
                    },
                  ),
                ),
              ),
            )
                : _buildChatButton(),
          ),
        ],
      ),
    );
  }

  Widget _buildChatButton() {
    return FadeIn(
      duration: const Duration(milliseconds: 500),
      child: FloatingActionButton(
        onPressed: _toggleChat,
        backgroundColor: Colors.blue.shade700,
        elevation: 8,
        child: Stack(
          alignment: Alignment.center,
          children: [
            const Icon(Icons.chat, color: Colors.white, size: 26),
            Positioned(
              top: 0,
              right: 0,
              child: Container(
                padding: const EdgeInsets.all(2),
                decoration: BoxDecoration(
                  color: Colors.red,
                  borderRadius: BorderRadius.circular(10),
                ),
                constraints: const BoxConstraints(
                  minWidth: 14,
                  minHeight: 14,
                ),
                child: const Text(
                  '1',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 8,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildChatHeader(BuildContext context, List<ChatMessage> messages) {
    return Container(
      height: 70,
      decoration: BoxDecoration(
        color: Colors.blue.shade900.withOpacity(0.8),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Row(
          children: [
            CircleAvatar(
              radius: 20,
              backgroundColor: Colors.white,
              child: Text(
                widget.username.isNotEmpty
                    ? widget.username[0].toUpperCase()
                    : "?",
                style: TextStyle(
                  color: Colors.blue.shade700,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(width: 12),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  widget.username,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  "Online",
                  style: TextStyle(
                    color: Colors.greenAccent.shade100,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
            const Spacer(),
            IconButton(
              icon: const Icon(Icons.wallpaper, color: Colors.white),
              tooltip: "Change Background",
              onPressed: _selectBackgroundImage,
            ),
            IconButton(
              icon: const Icon(Icons.close, color: Colors.white),
              onPressed: _toggleChat,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMessageArea(List<ChatMessage> messages) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.4),
      ),
      child: Column(
        children: [
          // Messages list
          Expanded(
            child: _buildMessagesList(messages),
          ),

          // Message input
          _buildMessageInput(),
        ],
      ),
    );
  }

  Widget _buildMessagesList(List<ChatMessage> messages) {
    if (messages.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Lottie.network(
              'https://assets9.lottiefiles.com/private_files/lf30_kanwuonz.json',
              width: 150,
              height: 150,
            ),
            const SizedBox(height: 20),
            Text(
              "No messages yet",
              style: TextStyle(
                color: Colors.blue.shade200.withOpacity(0.7),
                fontSize: 16,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              "Start the conversation!",
              style: TextStyle(
                color: Colors.blue.shade300.withOpacity(0.5),
                fontSize: 14,
              ),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.symmetric(vertical: 16),
      itemCount: messages.length,
      itemBuilder: (context, index) {
        final message = messages[index];
        final isMe = message.sender == widget.userId;

        return GestureDetector(
          onLongPress: () {
            // Handle message options
          },
          child: Align(
            alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
            child: Container(
              margin: EdgeInsets.only(
                left: isMe ? 64 : 16,
                right: isMe ? 16 : 64,
                top: 8,
                bottom: 8,
              ),
              child: Column(
                crossAxisAlignment: isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: isMe ? Colors.blue.shade700 : Colors.grey.shade800,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (message.type == MessageType.text)
                          Text(
                            message.text,
                            style: const TextStyle(color: Colors.white),
                          )
                        else if (message.type == MessageType.audio && message.audioPath != null)
                          _buildAudioPlayer(message.audioPath!),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 4.0, left: 8.0, right: 8.0),
                    child: Text(
                      _formatTime(message.timestamp),
                      style: TextStyle(
                        color: Colors.blue.shade100.withOpacity(0.7),
                        fontSize: 10,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildAudioPlayer(String audioPath) {
    final audioPlayer = AudioPlayer();
    bool isPlaying = false;
    Duration duration = const Duration();
    Duration position = const Duration();

    return StatefulBuilder(
      builder: (context, setState) {
        return SizedBox(
          width: 200,
          child: Row(
            children: [
              IconButton(
                iconSize: 24,
                icon: Icon(
                  isPlaying ? Icons.pause : Icons.play_arrow,
                  color: Colors.white,
                ),
                onPressed: () async {
                  if (isPlaying) {
                    await audioPlayer.pause();
                    setState(() => isPlaying = false);
                  } else {
                    await audioPlayer.play(DeviceFileSource(audioPath));
                    setState(() => isPlaying = true);

                    audioPlayer.onPlayerComplete.listen((event) {
                      setState(() => isPlaying = false);
                    });

                    audioPlayer.onDurationChanged.listen((newDuration) {
                      setState(() => duration = newDuration);
                    });

                    audioPlayer.onPositionChanged.listen((newPosition) {
                      setState(() => position = newPosition);
                    });
                  }
                },
              ),
              Expanded(
                child: LinearProgressIndicator(
                  value: duration.inSeconds > 0
                      ? position.inSeconds / duration.inSeconds
                      : 0.0,
                  backgroundColor: Colors.grey.shade700,
                  valueColor:
                  AlwaysStoppedAnimation<Color>(Colors.blue.shade300),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildMessageInput() {
    final TextEditingController messageController = TextEditingController();
    final audioRecorderHelper = AudioRecorderHelper();
    bool isRecording = false;
    String? recordingPath;

    return StatefulBuilder(
      builder: (context, setState) {
        return Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.black.withOpacity(0.6),
            border: Border(
              top: BorderSide(
                color: Colors.blue.shade900.withOpacity(0.5),
                width: 1,
              ),
            ),
          ),
          child: Row(
            children: [
              IconButton(
                icon: Icon(
                  Icons.image,
                  color: Colors.blue.shade300,
                ),
                onPressed: () async {
                  // Image selection logic
                  final ImagePicker picker = ImagePicker();
                  final XFile? image =
                  await picker.pickImage(source: ImageSource.gallery);

                  if (image != null) {
                    // Process and send image
                  }
                },
              ),
              Expanded(
                child: isRecording
                    ? Container(
                  height: 50,
                  decoration: BoxDecoration(
                    color: Colors.red.shade900.withOpacity(0.3),
                    borderRadius: BorderRadius.circular(24),
                  ),
                  child: Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Lottie.network(
                          'https://assets6.lottiefiles.com/packages/lf20_qhrbrh3m.json',
                          width: 32,
                          height: 32,
                        ),
                      ),
                      const Text(
                        "Recording...",
                        style: TextStyle(
                          color: Colors.white,
                          fontStyle: FontStyle.italic,
                        ),
                      ),
                    ],
                  ),
                )
                    : TextField(
                  controller: messageController,
                  style: const TextStyle(color: Colors.white),
                  decoration: InputDecoration(
                    hintText: "Type a message...",
                    hintStyle: TextStyle(
                        color: Colors.blue.shade200.withOpacity(0.5)),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(24),
                      borderSide: BorderSide.none,
                    ),
                    filled: true,
                    fillColor: Colors.blue.shade900.withOpacity(0.2),
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 8,
                    ),
                  ),
                  onChanged: (value) {
                    // Send typing notification
                  },
                ),
              ),
              const SizedBox(width: 8),
              GestureDetector(
                onLongPress: () async {
                  // Start recording
                  if (await audioRecorderHelper.hasPermission()) {
                    await audioRecorderHelper.start();
                    setState(() {
                      isRecording = true;
                    });
                  }
                },
                onLongPressEnd: (_) async {
                  // Stop recording
                  if (isRecording) {
                    recordingPath = await audioRecorderHelper.stop();
                    setState(() {
                      isRecording = false;
                    });

                    if (recordingPath != null) {
                      // Send audio message
                      final cubit = context.read<ChatCubit>();
                      cubit.sendAudioMessage(recordingPath!, widget.userId);
                      recordingPath = null;
                    }
                  }
                },
                child: Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: isRecording ? Colors.red : Colors.blue.shade700,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    isRecording ? Icons.mic : Icons.mic_none,
                    color: Colors.white,
                  ),
                ),
              ),
              const SizedBox(width: 8),
              FloatingActionButton(
                mini: true,
                backgroundColor: Colors.blue.shade700,
                child: const Icon(Icons.send, color: Colors.white),
                onPressed: () {
                  final message = messageController.text.trim();
                  if (message.isNotEmpty) {
                    // Send text message
                    final cubit = context.read<ChatCubit>();
                    cubit.sendMessage(message, widget.userId);
                    messageController.clear();
                  }
                },
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildCallOverlay(BuildContext context) {
    return Container(
      color: Colors.black.withOpacity(0.8),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text(
            "Call in progress",
            style: TextStyle(
              color: Colors.white,
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 40),
          // Video container
          Container(
            width: 320,
            height: 240,
            decoration: BoxDecoration(
              color: Colors.grey.shade900,
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Center(
              child: Icon(
                Icons.videocam_off,
                color: Colors.white54,
                size: 48,
              ),
            ),
          ),
          const SizedBox(height: 40),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CallButton(
                icon: Icons.mic_off,
                color: Colors.blue.shade700,
                onPressed: () {},
              ),
              const SizedBox(width: 16),
              CallButton(
                icon: Icons.videocam_off,
                color: Colors.blue.shade700,
                onPressed: () {},
              ),
              const SizedBox(width: 16),
              CallButton(
                icon: Icons.call_end,
                color: Colors.red,
                onPressed: () {
                  // End call logic
                },
              ),
            ],
          ),
        ],
      ),
    );
  }

  String _formatTime(DateTime dateTime) {
    final hour = dateTime.hour.toString().padLeft(2, '0');
    final minute = dateTime.minute.toString().padLeft(2, '0');
    return "$hour:$minute";
  }
}

// Simple enum for chat view state
enum ChatViewState { loading, loaded, error }

class CallButton extends StatelessWidget {
  final IconData icon;
  final Color color;
  final VoidCallback onPressed;

  const CallButton({
    Key? key,
    required this.icon,
    required this.color,
    required this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: color,
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: color.withOpacity(0.3),
            blurRadius: 10,
            spreadRadius: 2,
          ),
        ],
      ),
      child: IconButton(
        icon: Icon(icon, color: Colors.white),
        onPressed: onPressed,
      ),
    );
  }
}
*/

import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'chat_cubit.dart';
import 'chat_bubble.dart';
import 'audio_recorder_helper.dart';

class ChatWindow extends StatelessWidget {
  final VoidCallback onBack;
  final Function(ChatMessage) onReply;

  const ChatWindow({
    Key? key,
    required this.onBack,
    required this.onReply,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ChatCubit, List<ChatMessage>>(
      builder: (context, messages) {
        return Scaffold(
          backgroundColor: Colors.grey[900],
          appBar: AppBar(
            backgroundColor: Colors.grey[850],
            title: const Text('Chat'),
            leading: IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: onBack,
            ),
          ),
          body: Column(
            children: [
              // Messages list
              Expanded(
                child: messages.isEmpty
                    ? _buildEmptyState()
                    : ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: messages.length,
                  itemBuilder: (context, index) {
                    final message = messages[index];
                    // Assuming current user ID is 'user123' for demo
                    final isMe = message.sender == 'user123';
                    return ChatBubble(
                      message: message,
                      isMe: isMe,
                      onReply: () => onReply(message),
                    );
                  },
                ),
              ),

              // Message input
              _buildMessageInput(context),
            ],
          ),
        );
      },
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.chat_bubble_outline,
            size: 80,
            color: Colors.grey[700],
          ),
          const SizedBox(height: 16),
          Text(
            'No messages yet',
            style: TextStyle(
              color: Colors.grey[500],
              fontSize: 18,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Start the conversation!',
            style: TextStyle(
              color: Colors.grey[400],
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMessageInput(BuildContext context) {
    final TextEditingController messageController = TextEditingController();
    final audioRecorderHelper = AudioRecorderHelper();
    bool isRecording = false;
    String? recordingPath;

    return StatefulBuilder(
      builder: (context, setState) {
        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 12),
          color: Colors.grey[850],
          child: Row(
            children: [
              IconButton(
                icon: const Icon(Icons.image, color: Colors.blue),
                onPressed: () async {
                  final ImagePicker picker = ImagePicker();
                  final XFile? image = await picker.pickImage(source: ImageSource.gallery);

                  if (image != null) {
                    // Process image
                  }
                },
              ),
              Expanded(
                child: isRecording
                    ? Container(
                  height: 50,
                  decoration: BoxDecoration(
                    color: Colors.red.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(24),
                  ),
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.mic, color: Colors.red),
                      SizedBox(width: 8),
                      Text(
                        "Recording...",
                        style: TextStyle(
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                )
                    : TextField(
                  controller: messageController,
                  style: const TextStyle(color: Colors.white),
                  decoration: InputDecoration(
                    hintText: "Type a message...",
                    hintStyle: TextStyle(color: Colors.grey[400]),
                    contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                    filled: true,
                    fillColor: Colors.grey[800],
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(24),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              GestureDetector(
                onLongPress: () async {
                  if (await audioRecorderHelper.hasPermission()) {
                    await audioRecorderHelper.start();
                    setState(() {
                      isRecording = true;
                    });
                  }
                },
                onLongPressEnd: (_) async {
                  if (isRecording) {
                    recordingPath = await audioRecorderHelper.stop();
                    setState(() {
                      isRecording = false;
                    });

                    if (recordingPath != null) {
                      // Send audio message
                      final cubit = context.read<ChatCubit>();
                      cubit.sendAudioMessage(recordingPath!, 'user123');
                      recordingPath = null;
                    }
                  }
                },
                child: Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: isRecording ? Colors.red : Colors.grey[700],
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    isRecording ? Icons.mic : Icons.mic_none,
                    color: Colors.white,
                  ),
                ),
              ),
              const SizedBox(width: 8),
              IconButton(
                icon: const Icon(Icons.send, color: Colors.blue),
                onPressed: () {
                  final message = messageController.text.trim();
                  if (message.isNotEmpty) {
                    final cubit = context.read<ChatCubit>();
                    cubit.sendMessage(message, 'user123');
                    messageController.clear();
                  }
                },
              ),
            ],
          ),
        );
      },
    );
  }
}
