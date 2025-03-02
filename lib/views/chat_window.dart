

import 'dart:async';
import 'dart:io';
import 'dart:ui';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:path_provider/path_provider.dart';
import 'package:record/record.dart'; // Correct import for the record package
import 'package:audioplayers/audioplayers.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter_webrtc/flutter_webrtc.dart';
import 'package:animate_do/animate_do.dart';
import 'package:lottie/lottie.dart';
import 'chat_cubit.dart';
import 'chat_service.dart' as chat_service;
import 'package:permission_handler/permission_handler.dart';

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
  final AudioRecorder _audioRecorder =
      AudioRecorder(); // Use AudioRecorder instead of Record
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
          const RecordConfig(), // Use RecordConfig for configuration
          path: filePath,
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
    await _audioRecorder.dispose();
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
                        child: BlocConsumer<ChatCubit, ChatState>(
                          listener: (context, state) {
                            if (state.incomingCall != null) {
                              _showIncomingCallDialog(
                                  context, state.incomingCall!);
                            }
                          },
                          builder: (context, state) {
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
                                        _buildChatHeader(context, state),

                                        // Chat body
                                        Expanded(
                                          child: Row(
                                            children: [
                                              // User list
                                              _buildUserList(state),

                                              // Message area
                                              Expanded(
                                                flex: 3,
                                                child: state.selectedUser !=
                                                        null
                                                    ? _buildMessageArea(state)
                                                    : _buildWelcomeScreen(),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),

                                // Active call overlay
                                if (state.isInCall) _buildCallOverlay(context),
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

  Widget _buildChatHeader(BuildContext context, ChatState state) {
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

  Widget _buildUserList(ChatState state) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      width: 80,
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.6),
        border: Border(
          right: BorderSide(
            color: Colors.blue.shade900.withOpacity(0.5),
            width: 1,
          ),
        ),
      ),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 12),
            child: Text(
              "Users",
              style: TextStyle(
                color: Colors.blue.shade100,
                fontSize: 12,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              padding: EdgeInsets.zero,
              itemCount: state.users.length,
              itemBuilder: (context, index) {
                final user = state.users[index];
                final isSelected = state.selectedUser?.userId == user.userId;

                return GestureDetector(
                  onTap: () => context.read<ChatCubit>().selectUser(user),
                  child: FadeInLeft(
                    delay: Duration(milliseconds: index * 100),
                    child: Container(
                      margin: const EdgeInsets.symmetric(
                          vertical: 8, horizontal: 8),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: isSelected ? Colors.blue : Colors.transparent,
                          width: 2,
                        ),
                        color: isSelected
                            ? Colors.blue.withOpacity(0.3)
                            : Colors.transparent,
                      ),
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: CircleAvatar(
                              backgroundColor: user.isOnline
                                  ? Colors.blue.shade200
                                  : Colors.grey.shade700,
                              child: Text(
                                user.username.isNotEmpty
                                    ? user.username[0].toUpperCase()
                                    : "?",
                                style: TextStyle(
                                  color: user.isOnline
                                      ? Colors.blue.shade900
                                      : Colors.grey.shade300,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                          if (user.isOnline)
                            Positioned(
                              right: 0,
                              bottom: 0,
                              child: Container(
                                width: 12,
                                height: 12,
                                decoration: BoxDecoration(
                                  color: Colors.green,
                                  shape: BoxShape.circle,
                                  border: Border.all(
                                    color: Colors.white,
                                    width: 2,
                                  ),
                                ),
                              ),
                            ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildWelcomeScreen() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.4),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Lottie.network(
            'https://assets9.lottiefiles.com/packages/lf20_rbtawnwz.json',
            width: 200,
            height: 200,
          ),
          const SizedBox(height: 20),
          Text(
            "Welcome to Chat",
            style: TextStyle(
              color: Colors.blue.shade100,
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            "Select a user to start messaging",
            style: TextStyle(
              color: Colors.blue.shade200.withOpacity(0.7),
              fontSize: 16,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMessageArea(ChatState state) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.4),
      ),
      child: Column(
        children: [
          // Selected user header
          _buildSelectedUserHeader(state),

          // Messages list
          Expanded(
            child: _buildMessagesList(state),
          ),

          // Message input
          _buildMessageInput(state),
        ],
      ),
    );
  }

  Widget _buildSelectedUserHeader(ChatState state) {
    if (state.selectedUser == null) return const SizedBox.shrink();

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.3),
        border: Border(
          bottom: BorderSide(
            color: Colors.blue.shade900.withOpacity(0.5),
            width: 1,
          ),
        ),
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 16,
            backgroundColor: Colors.blue.shade200,
            child: Text(
              state.selectedUser!.username.isNotEmpty
                  ? state.selectedUser!.username[0].toUpperCase()
                  : "?",
              style: TextStyle(
                color: Colors.blue.shade900,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  state.selectedUser!.username,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                if (state.typingUsers.containsKey(state.selectedUser!.userId))
                  Text(
                    "typing...",
                    style: TextStyle(
                      color: Colors.green.shade300,
                      fontSize: 12,
                      fontStyle: FontStyle.italic,
                    ),
                  ),
              ],
            ),
          ),
          IconButton(
            icon: Icon(
              Icons.phone,
              color: Colors.green.shade300,
              size: 20,
            ),
            tooltip: "Voice Call",
            onPressed: () => context.read<ChatCubit>().initiateCall(false),
          ),
          IconButton(
            icon: Icon(
              Icons.videocam,
              color: Colors.blue.shade300,
              size: 20,
            ),
            tooltip: "Video Call",
            onPressed: () => context.read<ChatCubit>().initiateCall(true),
          ),
        ],
      ),
    );
  }

  Widget _buildMessagesList(ChatState state) {
    final messageBubbles = <Widget>[];

    if (state.viewState == ChatViewState.loading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (state.messages.isEmpty) {
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

    DateTime? previousDate;

    for (int i = 0; i < state.messages.length; i++) {
      final message = state.messages[i];
      final isMe = message.senderId == widget.userId;

      // Add date separator if needed
      final messageDate = DateTime(
        message.timestamp.year,
        message.timestamp.month,
        message.timestamp.day,
      );

      if (previousDate == null || previousDate != messageDate) {
        messageBubbles.add(
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 16.0),
            child: Center(
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.blue.shade900.withOpacity(0.5),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  _formatDate(message.timestamp),
                  style: TextStyle(
                    color: Colors.blue.shade100,
                    fontSize: 12,
                  ),
                ),
              ),
            ),
          ),
        );
        previousDate = messageDate;
      }

      messageBubbles.add(
        Align(
          alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
          child: ZoomIn(
            duration: const Duration(milliseconds: 200),
            delay: Duration(milliseconds: i * 50),
            child: Padding(
              padding: EdgeInsets.only(
                left: isMe ? 64 : 16,
                right: isMe ? 16 : 64,
                top: 4,
                bottom: 4,
              ),
              child: Column(
                crossAxisAlignment:
                    isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      if (!isMe)
                        CircleAvatar(
                          radius: 12,
                          backgroundColor: Colors.blue.shade200,
                          child: Text(
                            state.selectedUser!.username.isNotEmpty
                                ? state.selectedUser!.username[0].toUpperCase()
                                : "?",
                            style: TextStyle(
                              color: Colors.blue.shade900,
                              fontWeight: FontWeight.bold,
                              fontSize: 10,
                            ),
                          ),
                        ),
                      if (!isMe) const SizedBox(width: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 8,
                        ),
                        decoration: BoxDecoration(
                          color: isMe
                              ? Colors.blue.shade700.withOpacity(0.9)
                              : Colors.grey.shade800.withOpacity(0.9),
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: _buildMessageContent(message),
                      ),
                    ],
                  ),
                  Padding(
                    padding:
                        const EdgeInsets.only(top: 4.0, left: 8.0, right: 8.0),
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
        ),
      );
    }

    return ListView(
      padding: const EdgeInsets.symmetric(vertical: 16),
      children: messageBubbles,
    );
  }

  Widget _buildMessageContent(chat_service.ChatMessage message) {
    switch (message.type) {
      case chat_service.MessageType.text:
        return Text(
          message.content,
          style: const TextStyle(color: Colors.white),
        );
      case chat_service.MessageType.audio:
        return _buildAudioPlayer(message.content);
      case chat_service.MessageType.image:
        return ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: Image.file(
            File(message.content),
            width: 200,
            fit: BoxFit.cover,
          ),
        );
      case chat_service.MessageType.video:
        return Container(
          decoration: BoxDecoration(
            color: Colors.blue.shade900.withOpacity(0.3),
            borderRadius: BorderRadius.circular(8),
          ),
          padding: const EdgeInsets.all(8),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.video_file, color: Colors.white),
              const SizedBox(width: 8),
              const Text(
                "Video Message",
                style: TextStyle(color: Colors.white),
              ),
            ],
          ),
        );
      default:
        return const Text(
          "Unsupported message type",
          style: TextStyle(color: Colors.white),
        );
    }
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

  Widget _buildMessageInput(ChatState state) {
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
                          context.read<ChatCubit>().sendTypingNotification();
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
                      context
                          .read<ChatCubit>()
                          .sendAudioMessage(recordingPath!);
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
                    context.read<ChatCubit>().sendTextMessage(message);
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
                  context.read<ChatCubit>().endCurrentCall();
                },
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _showIncomingCallDialog(
      BuildContext context, chat_service.CallInfo callInfo) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.grey.shade900,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        title: Text(
          "Incoming ${callInfo.isVideoCall ? 'Video' : 'Audio'} Call",
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            CircleAvatar(
              radius: 30,
              backgroundColor: Colors.blue.shade700,
              child: Text(
                callInfo.callerName.isNotEmpty
                    ? callInfo.callerName[0].toUpperCase()
                    : "?",
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(height: 16),
            Text(
              callInfo.callerName,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 18,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              "is calling you...",
              style: TextStyle(
                color: Colors.grey.shade400,
                fontSize: 14,
              ),
            ),
            const SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                CallButton(
                  icon: Icons.call_end,
                  color: Colors.red,
                  onPressed: () {
                    context.read<ChatCubit>().rejectIncomingCall();
                    Navigator.of(context).pop();
                  },
                ),
                CallButton(
                  icon: callInfo.isVideoCall ? Icons.videocam : Icons.call,
                  color: Colors.green,
                  onPressed: () {
                    context.read<ChatCubit>().acceptIncomingCall();
                    Navigator.of(context).pop();
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final yesterday = DateTime(now.year, now.month, now.day - 1);
    final messageDate = DateTime(date.year, date.month, date.day);

    if (messageDate == today) {
      return "Today";
    } else if (messageDate == yesterday) {
      return "Yesterday";
    } else {
      return "${date.day}/${date.month}/${date.year}";
    }
  }

  String _formatTime(DateTime dateTime) {
    final hour = dateTime.hour.toString().padLeft(2, '0');
    final minute = dateTime.minute.toString().padLeft(2, '0');
    return "$hour:$minute";
  }
}

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
