import 'dart:async';

import 'package:flutter/material.dart';

import 'package:shared_preferences/shared_preferences.dart';

import 'editProfile.dart';

import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:graduation___part1/views/chat_cubit.dart';

import 'package:flutter/services.dart';

import 'package:intl/intl.dart';

import 'dart:convert';

import 'package:flutter_sound/flutter_sound.dart';

import 'package:permission_handler/permission_handler.dart';

import 'package:path_provider/path_provider.dart';

import 'dart:io';

import 'dart:typed_data';

class Chat extends StatelessWidget {

  final Profile profile;

  const Chat({super.key, required this.profile});

  @override

  Widget build(BuildContext context) {

    return BlocProvider(

      create: (context) => ChatCubit(profile)

        ..connectToSignalR()

        ..loadMessages(),

      child: const Scaffold(

        body: ChatBody(),

      ),

    );

  }

}

class ChatBody extends StatefulWidget {

  const ChatBody({super.key});

  @override

  State<ChatBody> createState() => _ChatBodyState();

}

class _ChatBodyState extends State<ChatBody> with TickerProviderStateMixin {

  final TextEditingController _messageController = TextEditingController();

  final ScrollController _scrollController = ScrollController();

  late AnimationController _adLoadingController;

  String? myImage;

  bool _isRecording = false;

  bool _isAudioPlaying = false;

  String? _currentlyPlayingPath;

  String? _recordingPath;

  final FlutterSoundRecorder _soundRecorder = FlutterSoundRecorder();

  final FlutterSoundPlayer _soundPlayer = FlutterSoundPlayer();

  Timer? _recordingTimer;

  Duration _recordingDuration = Duration.zero;

  @override

  void initState() {

    super.initState();

    _adLoadingController = AnimationController(

      vsync: this,

      duration: const Duration(milliseconds: 300),

    );

    _loadMyProfile();

    _initAudio();

  }

  Future<void> _initAudio() async {

    await _soundPlayer.openPlayer();

    await _soundRecorder.openRecorder();

    await Permission.microphone.request();

  }

  Future<void> _startRecording() async {

    try {

      Directory tempDir = await getTemporaryDirectory();

      _recordingPath =

          '${tempDir.path}/audio_message_${DateTime.now().millisecondsSinceEpoch}.aac';

      await _soundRecorder.startRecorder(

        toFile: _recordingPath,

        codec: Codec.aacADTS,

      );

      setState(() {

        _isRecording = true;

        _recordingDuration = Duration.zero;

      });

      _recordingTimer = Timer.periodic(const Duration(seconds: 1), (timer) {

        setState(() {

          _recordingDuration += const Duration(seconds: 1);

        });

      });

      context.read<ChatCubit>().sendRecordingNotification(true);

    } catch (e) {

      // Error handling would be here

    }

  }

  Future<void> _stopRecording() async {

    try {

      await _soundRecorder.stopRecorder();

      _recordingTimer?.cancel();

      setState(() {

        _isRecording = false;

      });

      if (_recordingPath != null) {

        final audioFile = File(_recordingPath!);

        if (await audioFile.exists()) {

          final fileSize = await audioFile.length();

          if (fileSize > 0) {

            final base64Audio = await _convertAudioToBase64(_recordingPath!);

            final duration = _formatDuration(_recordingDuration);

            context.read<ChatCubit>().sendAudioMessage(

                  audioData: base64Audio,

                  duration: duration,

                  filePath: _recordingPath!,

                );

          }

        }

      }

      context.read<ChatCubit>().sendRecordingNotification(false);

    } catch (e) {

      // Error handling would be here

    }

  }

  String _formatDuration(Duration duration) {

    String twoDigits(int n) => n.toString().padLeft(2, '0');

    final minutes = twoDigits(duration.inMinutes.remainder(60));

    final seconds = twoDigits(duration.inSeconds.remainder(60));

    return "$minutes:$seconds";

  }

  Future<String> _convertAudioToBase64(String audioPath) async {

    try {

      File audioFile = File(audioPath);

      Uint8List bytes = await audioFile.readAsBytes();

      return base64Encode(bytes);

    } catch (e) {

      return '';

    }

  }

  Future<void> _playAudio(String path, String? base64Audio) async {

    try {

      if (_isAudioPlaying) {

        await _soundPlayer.stopPlayer();

        setState(() {

          _isAudioPlaying = false;

          _currentlyPlayingPath = null;

        });

        return;

      }

      setState(() {

        _isAudioPlaying = true;

        _currentlyPlayingPath = path;

      });

      if (await File(path).exists()) {

        await _soundPlayer.startPlayer(

          fromURI: path,

          codec: Codec.aacADTS,

          whenFinished: () {

            setState(() {

              _isAudioPlaying = false;

              _currentlyPlayingPath = null;

            });

          },

        );

      } else if (base64Audio != null && base64Audio.isNotEmpty) {

        await _playFromBase64(base64Audio);

      }

    } catch (e) {

      setState(() {

        _isAudioPlaying = false;

        _currentlyPlayingPath = null;

      });

    }

  }

  Future<void> _playFromBase64(String base64Audio) async {

    try {

      Uint8List audioBytes = base64Decode(base64Audio);

      Directory tempDir = await getTemporaryDirectory();

      String tempPath =

          '${tempDir.path}/temp_audio_${DateTime.now().millisecondsSinceEpoch}.aac';

      File tempFile = File(tempPath);

      await tempFile.writeAsBytes(audioBytes);

      setState(() {

        _isAudioPlaying = true;

        _currentlyPlayingPath = tempPath;

      });

      await _soundPlayer.startPlayer(

        fromURI: tempPath,

        codec: Codec.aacADTS,

        whenFinished: () {

          setState(() {

            _isAudioPlaying = false;

            _currentlyPlayingPath = null;

          });

          tempFile.delete();

        },

      );

    } catch (e) {

      setState(() {

        _isAudioPlaying = false;

        _currentlyPlayingPath = null;

      });

    }

  }

  Widget _buildAudioMessageContent(

      Map<String, dynamic> message, bool isUserMessage) {

    final bool isPlaying =

        _isAudioPlaying && _currentlyPlayingPath == message['filePath'];

    final String duration = message['duration'] ?? '0:00';

    return GestureDetector(

      onTap: () => _playAudio(message['filePath'], message['audioData']),

      child: Container(

        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),

        decoration: BoxDecoration(

          color: isUserMessage ? Colors.indigo[100] : Colors.grey[200],

          borderRadius: BorderRadius.circular(16),

        ),

        child: Row(

          mainAxisSize: MainAxisSize.min,

          children: [

            Icon(

              isPlaying ? Icons.pause : Icons.play_arrow,

              color: isUserMessage ? Colors.indigo[800] : Colors.grey[800],

              size: 24,

            ),

            const SizedBox(width: 8),

            Text(

              duration,

              style: TextStyle(

                color: isUserMessage ? Colors.indigo[800] : Colors.grey[800],

                fontWeight: FontWeight.bold,

              ),

            ),

            const SizedBox(width: 8),

            Expanded(

              child: LinearProgressIndicator(

                value: isPlaying ? null : 0,

                backgroundColor: Colors.grey.withOpacity(0.3),

                valueColor: AlwaysStoppedAnimation<Color>(

                  isUserMessage ? Colors.indigo[400]! : Colors.grey[600]!,

                ),

              ),

            ),

          ],

        ),

      ),

    );

  }

  Future<void> _loadMyProfile() async {

    final prefs = await SharedPreferences.getInstance();

    setState(() {

      myImage = prefs.getString('profile_image');

    });

  }

  @override

  void dispose() {

    _messageController.dispose();

    _scrollController.dispose();

    _adLoadingController.dispose();

    _soundPlayer.closePlayer();

    _soundRecorder.closeRecorder();

    _recordingTimer?.cancel();

    context.read<ChatCubit>().disconnectSignalR();

    super.dispose();

  }

  void _scrollToBottom() {

    if (_scrollController.hasClients) {

      _scrollController.animateTo(

        _scrollController.position.maxScrollExtent,

        duration: const Duration(milliseconds: 300),

        curve: Curves.easeOut,

      );

    }

  }

  @override

  Widget build(BuildContext context) {

    final Profile profile = context.read<ChatCubit>().userProfile;

    return Container(

      width: double.infinity,

      height: double.infinity,

      decoration: BoxDecoration(

        color: Colors.grey[50],

        borderRadius: BorderRadius.circular(0),

      ),

      child: Column(

        children: [

          _buildChatHeader(context, profile),

          BlocBuilder<ChatCubit, ChatState>(

            builder: (context, state) {

              if (state.connectionStatus == ConnectionStatus.connecting) {

                return const Padding(

                  padding: EdgeInsets.all(8.0),

                  child: LinearProgressIndicator(),

                );

              }

              if (state.connectionStatus == ConnectionStatus.disconnected) {

                return Container(

                  color: Colors.red[100],

                  padding: const EdgeInsets.all(8),

                  child: Row(

                    children: [

                      const Icon(Icons.error_outline, color: Colors.red),

                      const SizedBox(width: 8),

                      Text(

                        'Disconnected from chat server',

                        style: TextStyle(

                          color: Colors.red[800],

                        ),

                      ),

                      const Spacer(),

                      TextButton(

                        onPressed: () =>

                            context.read<ChatCubit>().connectToSignalR(),

                        child: const Text("Reconnect"),

                      )

                    ],

                  ),

                );

              }

              return const SizedBox.shrink();

            },

          ),

          Expanded(child: _buildChatMessages(context)),

          BlocBuilder<ChatCubit, ChatState>(

            builder: (context, state) {

              if (state.isBotTyping) {

                return _buildTypingIndicator();

              } else if (state.isRecording) {

                return _buildRecordingIndicator();

              } else {

                return const SizedBox.shrink();

              }

            },

          ),

          _buildChatInput(context),

        ],

      ),

    );

  }

  Widget _buildChatHeader(BuildContext context, Profile profile) {

    return Container(

      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),

      decoration: BoxDecoration(

        color: Colors.indigo[800],

        boxShadow: [

          BoxShadow(

            color: Colors.black.withOpacity(0.1),

            blurRadius: 4,

            offset: const Offset(0, 2),

          ),

        ],

      ),

      child: SafeArea(

        bottom: false,

        child: Row(

          children: [

            Container(

              padding: const EdgeInsets.all(2),

              decoration: BoxDecoration(

                color: Colors.white,

                shape: BoxShape.circle,

                boxShadow: [

                  BoxShadow(

                    color: Colors.black.withOpacity(0.1),

                    blurRadius: 2,

                    offset: const Offset(0, 1),

                  ),

                ],

              ),

              child: profile.imageUrl != null && profile.imageUrl!.isNotEmpty

                  ? CircleAvatar(

                      radius: 25,

                      backgroundImage: NetworkImage(profile.imageUrl!),

                    )

                  : CircleAvatar(

                      radius: 25,

                      backgroundColor: Colors.indigo[400],

                      child: const Icon(Icons.person, color: Colors.white),

                    ),

            ),

            const SizedBox(width: 14),

            Column(

              crossAxisAlignment: CrossAxisAlignment.start,

              children: [

                Text(

                  profile.name ?? 'Chat Room',

                  style: const TextStyle(

                    color: Colors.white,

                    fontSize: 18,

                    fontWeight: FontWeight.w600,

                    letterSpacing: 0.3,

                  ),

                ),

              ],

            ),

            const Spacer(),

            IconButton(

              icon: const Icon(Icons.close, color: Colors.white),

              onPressed: () {

                Navigator.pop(context);

              },

              splashRadius: 24,

            ),

          ],

        ),

      ),

    );

  }

  Widget _buildChatMessages(BuildContext context) {

    return BlocConsumer<ChatCubit, ChatState>(

      listenWhen: (previous, current) =>

          previous.chatMessages.length != current.chatMessages.length ||

          previous.forceRefresh != current.forceRefresh,

      listener: (context, state) {

        WidgetsBinding.instance.addPostFrameCallback((_) {

          _scrollToBottom();

        });

      },

      builder: (context, state) {

        final Profile profile = context.read<ChatCubit>().userProfile;

        return ListView.builder(

          controller: _scrollController,

          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),

          itemCount: state.chatMessages.length,

          itemBuilder: (context, index) {

            final message = state.chatMessages[index];

            final isLastMessage = index == state.chatMessages.length - 1;

            final bottomPadding = isLastMessage ? 12.0 : 16.0;

            final isUserMessage = message['sender'] == 'user';

            final isSystemMessage = message['sender'] == 'system';

            final isAudioMessage = message['type'] == 'audio';

            if (isSystemMessage) {

              return Container(

                alignment: Alignment.center,

                padding: EdgeInsets.only(bottom: bottomPadding),

                child: Container(

                  padding:

                      const EdgeInsets.symmetric(horizontal: 12, vertical: 8),

                  decoration: BoxDecoration(

                    color: Colors.grey[300],

                    borderRadius: BorderRadius.circular(12),

                  ),

                  child: Text(

                    message['text'] ?? '',

                    style: TextStyle(

                      fontSize: 13,

                      color: Colors.grey[800],

                      fontStyle: FontStyle.italic,

                    ),

                  ),

                ),

              );

            }

            return Padding(

              padding: EdgeInsets.only(bottom: bottomPadding),

              child: Row(

                mainAxisAlignment: isUserMessage

                    ? MainAxisAlignment.end

                    : MainAxisAlignment.start,

                crossAxisAlignment: CrossAxisAlignment.start,

                children: [

                  if (!isUserMessage) ...[

                    CircleAvatar(

                      radius: 18,

                      backgroundColor: Colors.indigo[400],

                      backgroundImage: profile.imageUrl != null &&

                              profile.imageUrl!.isNotEmpty

                          ? NetworkImage(profile.imageUrl!)

                          : null,

                      child:

                          profile.imageUrl == null || profile.imageUrl!.isEmpty

                              ? const Icon(

                                  Icons.person_rounded,

                                  color: Colors.white,

                                  size: 20,

                                )

                              : null,

                    ),

                    const SizedBox(width: 12),

                    _buildOtherUserMessage(context, message),

                  ] else ...[

                    _buildUserMessage(context, message, profile),

                    const SizedBox(width: 12),

                    CircleAvatar(

                      radius: 18,

                      backgroundColor: Colors.indigo[400],

                      backgroundImage: myImage != null && myImage!.isNotEmpty

                          ? NetworkImage(myImage!)

                          : null,

                      child: myImage == null || myImage!.isEmpty

                          ? const Icon(

                              Icons.person_rounded,

                              color: Colors.white,

                              size: 20,

                            )

                          : null,

                    ),

                  ],

                ],

              ),

            );

          },

        );

      },

    );

  }

  Widget _buildUserMessage(

      BuildContext context, Map<String, dynamic> message, Profile profile) {

    final isAudioMessage = message['type'] == 'audio';

    return Flexible(

      child: Container(

        padding: const EdgeInsets.all(14),

        constraints: BoxConstraints(

          maxWidth: MediaQuery.of(context).size.width * 0.65,

        ),

        decoration: BoxDecoration(

          color: Colors.indigo[100],

          borderRadius: const BorderRadius.only(

            topLeft: Radius.circular(18),

            bottomLeft: Radius.circular(18),

            bottomRight: Radius.circular(18),

          ),

          boxShadow: [

            BoxShadow(

              color: Colors.black.withOpacity(0.05),

              blurRadius: 2,

              offset: const Offset(0, 1),

            ),

          ],

        ),

        child: Column(

          crossAxisAlignment: CrossAxisAlignment.end,

          children: [

            if (isAudioMessage)

              _buildAudioMessageContent(message, true)

            else

              Text(

                message['text'] ?? '',

                style: const TextStyle(

                  fontSize: 15,

                  color: Colors.black87,

                ),

              ),

            const SizedBox(height: 6),

            Text(

              message['time'] ?? '',

              style: TextStyle(

                fontSize: 12,

                color: Colors.grey[600],

              ),

            ),

          ],

        ),

      ),

    );

  }

  Widget _buildOtherUserMessage(

      BuildContext context, Map<String, dynamic> message) {

    final isAudioMessage = message['type'] == 'audio';

    return Flexible(

      child: Container(

        padding: const EdgeInsets.all(14),

        constraints: BoxConstraints(

          maxWidth: MediaQuery.of(context).size.width * 0.65,

        ),

        decoration: BoxDecoration(

          color: Colors.grey[200],

          borderRadius: const BorderRadius.only(

            topRight: Radius.circular(18),

            bottomLeft: Radius.circular(18),

            bottomRight: Radius.circular(18),

          ),

          boxShadow: [

            BoxShadow(

              color: Colors.black.withOpacity(0.05),

              blurRadius: 2,

              offset: const Offset(0, 1),

            ),

          ],

        ),

        child: Column(

          crossAxisAlignment: CrossAxisAlignment.start,

          children: [

            if (isAudioMessage)

              _buildAudioMessageContent(message, false)

            else

              Text(

                message['text'] ?? '',

                style: const TextStyle(

                  fontSize: 15,

                  color: Colors.black87,

                ),

              ),

            const SizedBox(height: 6),

            Text(

              message['time'] ?? '',

              style: TextStyle(

                fontSize: 12,

                color: Colors.grey[600],

              ),

            ),

          ],

        ),

      ),

    );

  }

  Widget _buildTypingIndicator() {

    return Padding(

      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),

      child: Row(

        children: [

          CircleAvatar(

            radius: 18,

            backgroundColor: Colors.teal[600],

            child: const Icon(

              Icons.person_outline_rounded,

              color: Colors.white,

              size: 20,

            ),

          ),

          const SizedBox(width: 12),

          Container(

            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),

            decoration: BoxDecoration(

              color: Colors.grey[200],

              borderRadius: const BorderRadius.only(

                topRight: Radius.circular(18),

                bottomLeft: Radius.circular(18),

                bottomRight: Radius.circular(18),

              ),

            ),

            child: Row(

              children: [

                Text(

                  'Typing',

                  style: TextStyle(

                    fontSize: 14,

                    color: Colors.grey[700],

                  ),

                ),

                const SizedBox(width: 10),

                _buildDotAnimation(),

              ],

            ),

          ),

        ],

      ),

    );

  }

  Widget _buildRecordingIndicator() {

    return Padding(

      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),

      child: Row(

        children: [

          CircleAvatar(

            radius: 18,

            backgroundColor: Colors.teal[600],

            child: const Icon(

              Icons.person_outline_rounded,

              color: Colors.white,

              size: 20,

            ),

          ),

          const SizedBox(width: 12),

          Container(

            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),

            decoration: BoxDecoration(

              color: Colors.grey[200],

              borderRadius: const BorderRadius.only(

                topRight: Radius.circular(18),

                bottomLeft: Radius.circular(18),

                bottomRight: Radius.circular(18),

              ),

            ),

            child: Row(

              children: [

                Icon(Icons.mic, color: Colors.red[400]),

                const SizedBox(width: 8),

                Text(

                  'Recording...',

                  style: TextStyle(

                    fontSize: 14,

                    color: Colors.grey[700],

                  ),

                ),

              ],

            ),

          ),

        ],

      ),

    );

  }

  Widget _buildDotAnimation() {

    return TweenAnimationBuilder<double>(

      tween: Tween<double>(begin: 0, end: 1),

      duration: const Duration(milliseconds: 1500),

      builder: (context, value, child) {

        return Row(

          children: List.generate(

            3,

            (index) {

              final delay = (index / 3);

              final position = (value - delay) % 1;

              final opacity =

                  position > 0.5 ? (1 - position) * 2 : position * 2;

              return Container(

                margin: const EdgeInsets.symmetric(horizontal: 2),

                width: 5,

                height: 5,

                decoration: BoxDecoration(

                  color: Colors.grey[600]!.withOpacity(0.3 + (opacity * 0.7)),

                  shape: BoxShape.circle,

                ),

              );

            },

          ),

        );

      },

    );

  }

  Widget _buildChatInput(BuildContext context) {

    return Container(

      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 12),

      decoration: BoxDecoration(

        color: Colors.white,

        borderRadius: BorderRadius.circular(30.0),

        boxShadow: [

          BoxShadow(

            color: Colors.grey.withOpacity(0.2),

            spreadRadius: 1,

            blurRadius: 3,

            offset: const Offset(0, 1),

          ),

        ],

      ),

      child: SafeArea(

        top: false,

        child: Row(

          children: [

            Expanded(

              child: TextField(

                controller: _messageController,

                decoration: InputDecoration(

                  hintText: 'Type a message...',

                  hintStyle: TextStyle(color: Colors.grey[500]),

                  border: InputBorder.none,

                  contentPadding: const EdgeInsets.symmetric(

                    horizontal: 15,

                    vertical: 14,

                  ),

                ),

                minLines: 1,

                maxLines: 5,

                textCapitalization: TextCapitalization.sentences,

                onChanged: (_) {

                  context.read<ChatCubit>().sendTypingNotification();

                  setState(() {});

                },

                onSubmitted: (text) {

                  if (text.trim().isNotEmpty) {

                    context.read<ChatCubit>().sendMessage(text.trim());

                    _messageController.clear();

                    setState(() {});

                  }

                },

              ),

            ),

            const SizedBox(width: 12),

            BlocBuilder<ChatCubit, ChatState>(

              builder: (context, state) {

                final bool isConnected =

                    state.connectionStatus == ConnectionStatus.connected;

                final bool hasText = _messageController.text.trim().isNotEmpty;

                return Container(

                  decoration: BoxDecoration(

                    color: isConnected ? Colors.indigo[600] : Colors.grey[400],

                    shape: BoxShape.circle,

                    boxShadow: isConnected

                        ? [

                            BoxShadow(

                              color: Colors.indigo.withOpacity(0.3),

                              blurRadius: 4,

                              offset: const Offset(0, 2),

                            ),

                          ]

                        : [],

                  ),

                  child: _isRecording

                      ? IconButton(

                          icon: const Icon(

                            Icons.stop,

                            color: Colors.white,

                          ),

                          onPressed: isConnected ? _stopRecording : null,

                          splashRadius: 24,

                        )

                      : hasText

                          ? IconButton(

                              icon: const Icon(

                                Icons.send_rounded,

                                color: Colors.white,

                              ),

                              onPressed: isConnected

                                  ? () {

                                      final message =

                                          _messageController.text.trim();

                                      if (message.isNotEmpty) {

                                        context

                                            .read<ChatCubit>()

                                            .sendMessage(message);

                                        _messageController.clear();

                                        setState(() {});

                                      }

                                    }

                                  : null,

                              splashRadius: 24,

                            )

                          : IconButton(

                              icon: const Icon(

                                Icons.mic,

                                color: Colors.white,

                              ),

                              onPressed: isConnected ? _startRecording : null,

                              splashRadius: 24,

                            ),

                );

              },

            ),

          ],

        ),

      ),

    );

  }

}
