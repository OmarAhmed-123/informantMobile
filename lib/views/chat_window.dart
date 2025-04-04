/*
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'chat_cubit.dart' as cubit;
import 'chat_bubble.dart';
import 'audio_recorder_helper.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'chat_service.dart' as service;

class ChatWindow extends StatefulWidget {
  final VoidCallback onBack;
  final Function(cubit.ChatMessage) onReply;

  const ChatWindow({
    Key? key,
    required this.onBack,
    required this.onReply,
  }) : super(key: key);

  @override
  State<ChatWindow> createState() => _ChatWindowState();
}

class _ChatWindowState extends State<ChatWindow> {
  final List<service.ChatUser> _onlineUsers = [];
  service.ChatUser? _selectedUser;
  final service.ChatService _chatService = service.ChatService();
  bool _isLoading = true;
  String? _errorMessage;
  String? _currentUserId;

  @override
  void initState() {
    super.initState();
    _initializeChat();
  }

  Future<void> _initializeChat() async {
    try {
      setState(() {
        _isLoading = true;
        _errorMessage = null;
      });

      // Get the stored token
      final prefs = await SharedPreferences.getInstance();
      _currentUserId = prefs.getString('UserId');

      await _chatService.connect();

      // Set up the callbacks
      _chatService.onUsersUpdated = (users) {
        setState(() {
          _onlineUsers.clear();
          _onlineUsers.addAll(users);
          _isLoading = false;
        });
      };

      _chatService.onMessageReceived = (message) {
        // Add logic to handle received messages if needed
        debugPrint('Message received: ${message.content}');
      };

      // If there are no users received yet, fetch them again
      if (_onlineUsers.isEmpty) {
        await _chatService.getOnlinePeople();
      }

      setState(() {
        _isLoading = false;
      });
    } catch (e) {
      debugPrint('Error initializing chat: $e');
      setState(() {
        _isLoading = false;
        _errorMessage = 'Failed to connect to the chat server';
      });
    }
  }

  void _selectUser(service.ChatUser user) {
    setState(() {
      _selectedUser = user;
    });

    // Set the receiver in the ChatCubit
    final chatCubit = context.read<cubit.ChatCubit>();
    chatCubit.selectReceiver(user.userId);
  }

  @override
  Widget build(BuildContext context) {
    if (_selectedUser == null) {
      return _buildUserSelectionScreen();
    }

    return _buildChatScreen();
  }

  Widget _buildUserSelectionScreen() {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue.shade900,
        title: const Text('Select Contact'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: widget.onBack,
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () => _initializeChat(),
          ),
        ],
      ),
      body: Container(
        color: Colors.grey[900],
        child: Column(
          children: [
            // Online users section
            Container(
              padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
              color: Colors.grey[850],
              child: Row(
                children: [
                  Icon(Icons.circle, color: Colors.green, size: 14),
                  const SizedBox(width: 8),
                  Text(
                    'Online Users (${_onlineUsers.where((user) => user.isOnline).length})',
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),

            // User list
            Expanded(
              child: _isLoading
                  ? const Center(
                      child: CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.blue),
                      ),
                    )
                  : _errorMessage != null
                      ? Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.error_outline,
                                size: 48,
                                color: Colors.red.shade300,
                              ),
                              const SizedBox(height: 16),
                              Text(
                                _errorMessage!,
                                style: TextStyle(color: Colors.grey[400]),
                              ),
                              const SizedBox(height: 24),
                              ElevatedButton(
                                onPressed: _initializeChat,
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.blue.shade700,
                                ),
                                child: const Text('Retry'),
                              ),
                            ],
                          ),
                        )
                      : _onlineUsers.isEmpty
                          ? Center(
                              child: Text(
                                'No users available',
                                style: TextStyle(color: Colors.grey[400]),
                              ),
                            )
                          : ListView.builder(
                              itemCount: _onlineUsers.length,
                              itemBuilder: (context, index) {
                                final user = _onlineUsers[index];
                                return ListTile(
                                  leading: CircleAvatar(
                                    backgroundColor: user.isOnline
                                        ? Colors.blue.shade700
                                        : Colors.grey[700],
                                    child: Text(
                                      user.username.isNotEmpty
                                          ? user.username[0].toUpperCase()
                                          : '?',
                                      style:
                                          const TextStyle(color: Colors.white),
                                    ),
                                  ),
                                  title: Text(
                                    user.username,
                                    style: const TextStyle(color: Colors.white),
                                  ),
                                  subtitle: Text(
                                    user.isOnline ? 'Online' : 'Offline',
                                    style: TextStyle(
                                      color: user.isOnline
                                          ? Colors.green
                                          : Colors.grey,
                                      fontSize: 12,
                                    ),
                                  ),
                                  trailing: user.isOnline
                                      ? Container(
                                          width: 12,
                                          height: 12,
                                          decoration: BoxDecoration(
                                            color: Colors.green,
                                            shape: BoxShape.circle,
                                          ),
                                        )
                                      : null,
                                  onTap: () {
                                    _selectUser(user);
                                  },
                                );
                              },
                            ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildChatScreen() {
    return BlocBuilder<cubit.ChatCubit, List<cubit.ChatMessage>>(
      builder: (context, messages) {
        return Scaffold(
          backgroundColor: Colors.grey[900],
          appBar: AppBar(
            backgroundColor: Colors.blue.shade900,
            title: Row(
              children: [
                CircleAvatar(
                  radius: 16,
                  backgroundColor: _selectedUser!.isOnline
                      ? Colors.blue.shade300
                      : Colors.grey,
                  child: Text(
                    _selectedUser!.username.isNotEmpty
                        ? _selectedUser!.username[0].toUpperCase()
                        : '?',
                    style: TextStyle(
                      color: Colors.blue.shade900,
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        _selectedUser!.username,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        _selectedUser!.isOnline ? 'Online' : 'Offline',
                        style: TextStyle(
                          fontSize: 12,
                          color: _selectedUser!.isOnline
                              ? Colors.green.shade300
                              : Colors.grey,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            leading: IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: () {
                setState(() {
                  _selectedUser = null;
                });
              },
            ),
            actions: [
              IconButton(
                icon: const Icon(Icons.call),
                onPressed: () {
                  // Initiate a voice call using the service
                  _chatService.initiateCall(_selectedUser!.userId, false);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                        content: Text('Calling ${_selectedUser!.username}...')),
                  );
                },
              ),
              IconButton(
                icon: const Icon(Icons.videocam),
                onPressed: () {
                  // Initiate a video call using the service
                  _chatService.initiateCall(_selectedUser!.userId, true);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                        content: Text(
                            'Video calling ${_selectedUser!.username}...')),
                  );
                },
              ),
            ],
          ),
          body: SafeArea(
            child: Column(
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
                            final isMe = message.sender == _currentUserId;
                            return ChatBubble(
                              message: message,
                              isMe: isMe,
                              onReply: () => widget.onReply(message),
                            );
                          },
                        ),
                ),

                // Message input
                _buildMessageInput(context),
              ],
            ),
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

    return StatefulBuilder(
      builder: (context, setState) {
        bool isRecording = false;

        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 12),
          decoration: BoxDecoration(
            color: Colors.grey[850],
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.2),
                blurRadius: 4,
                offset: const Offset(0, -1),
              ),
            ],
          ),
          child: Row(
            children: [
              IconButton(
                icon: const Icon(Icons.image, color: Colors.blue),
                onPressed: () async {
                  final ImagePicker picker = ImagePicker();
                  final XFile? image =
                      await picker.pickImage(source: ImageSource.gallery);

                  if (image != null) {
                    // Process image
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                          content: Text('Image sending not implemented yet')),
                    );
                  }
                },
              ),
              Expanded(
                child: TextField(
                  controller: messageController,
                  style: const TextStyle(color: Colors.white),
                  decoration: InputDecoration(
                    hintText: "Type a message...",
                    hintStyle: TextStyle(color: Colors.grey[400]),
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 10,
                    ),
                    filled: true,
                    fillColor: Colors.grey[800],
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(24),
                      borderSide: BorderSide.none,
                    ),
                  ),
                  onChanged: (text) {
                    // Send typing notification
                    if (text.isNotEmpty && _selectedUser != null) {
                      _chatService
                          .sendTypingNotification(_selectedUser!.userId);
                    }
                  },
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
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text(
                            'Microphone permission denied. Cannot record audio.'),
                        duration: Duration(seconds: 3),
                      ),
                    );
                  }
                },
                onLongPressEnd: (_) async {
                  if (isRecording) {
                    final recordingPath = await audioRecorderHelper.stop();
                    setState(() {
                      isRecording = false;
                    });

                    if (recordingPath != null && _selectedUser != null) {
                      // Send audio message via the service
                      await _chatService.sendMessage(
                          _selectedUser!.userId, recordingPath,
                          type: service.MessageType.audio);

                      // Also notify the cubit for local UI update
                      final chatCubit = context.read<cubit.ChatCubit>();
                      chatCubit.sendAudioMessage(
                          recordingPath, _currentUserId ?? '');
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
              IconButton(
                icon: const Icon(Icons.send, color: Colors.blue),
                onPressed: () {
                  final message = messageController.text.trim();
                  if (message.isNotEmpty && _selectedUser != null) {
                    // Send message via the service
                    _chatService.sendMessage(_selectedUser!.userId, message);

                    // Also notify the cubit for local UI update
                    final chatCubit = context.read<cubit.ChatCubit>();
                    chatCubit.sendMessage(message, _currentUserId ?? '');

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

  @override
  void dispose() {
    _chatService.disconnect();
    super.dispose();
  }
}
*/


import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'chat_cubit.dart' as cubit;
import 'chat_bubble.dart';
import 'audio_recorder_helper.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'chat_service.dart' as service;

class ChatWindow extends StatefulWidget {
  final VoidCallback onBack;
  final Function(cubit.ChatMessage) onReply;

  const ChatWindow({
    Key? key,
    required this.onBack,
    required this.onReply,
  }) : super(key: key);

  @override
  State<ChatWindow> createState() => _ChatWindowState();
}

class _ChatWindowState extends State<ChatWindow> {
  final List<service.ChatUser> _onlineUsers = [];
  service.ChatUser? _selectedUser;
  final service.ChatService _chatService = service.ChatService();
  bool _isLoading = true;
  String? _errorMessage;
  String? _currentUserId;
  bool _isRecording = false;

  @override
  void initState() {
    super.initState();
    _initializeChat();
  }

  Future<void> _initializeChat() async {
    try {
      setState(() {
        _isLoading = true;
        _errorMessage = null;
      });

      // Get the stored token
      final prefs = await SharedPreferences.getInstance();
      _currentUserId = prefs.getString('UserId');

      // Set callback handlers
      _chatService.onUsersUpdated = (users) {
        setState(() {
          _onlineUsers.clear();
          _onlineUsers.addAll(users);
          _isLoading = false;
        });
      };

      _chatService.onMessageReceived = (message) {
        // Add logic to handle received messages if needed
        debugPrint('Message received: ${message.content}');
      };

      _chatService.onCallInitiated = (isVideo) {
        // Update UI to show call in progress
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('${isVideo ? "Video" : "Voice"} call initiated'),
            duration: const Duration(seconds: 2),
          ),
        );
      };

      _chatService.onImageSelected = (imagePath) {
        // Handle selected image - automatically done via cubit
      };

      await _chatService.connect();

      // If there are no users received yet, fetch them again
      if (_onlineUsers.isEmpty) {
        await _chatService.getOnlinePeople();
      }

      setState(() {
        _isLoading = false;
      });
    } catch (e) {
      debugPrint('Error initializing chat: $e');
      setState(() {
        _isLoading = false;
        _errorMessage = 'Failed to connect to the chat server';
      });
    }
  }

  void _selectUser(service.ChatUser user) {
    setState(() {
      _selectedUser = user;
    });

    // Set the receiver in the ChatCubit
    final chatCubit = context.read<cubit.ChatCubit>();
    chatCubit.selectReceiver(user.userId);
  }

  @override
  Widget build(BuildContext context) {
    if (_selectedUser == null) {
      return _buildUserSelectionScreen();
    }

    return _buildChatScreen();
  }

  Widget _buildUserSelectionScreen() {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue.shade900,
        title: const Text('Select Contact'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: widget.onBack,
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () => _initializeChat(),
          ),
        ],
      ),
      body: Container(
        color: Colors.grey[900],
        child: Column(
          children: [
            // Online users section
            Container(
              padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
              color: Colors.grey[850],
              child: Row(
                children: [
                  Icon(Icons.circle, color: Colors.green, size: 14),
                  const SizedBox(width: 8),
                  Text(
                    'Online Users (${_onlineUsers.where((user) => user.isOnline).length})',
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),

            // User list
            Expanded(
              child: _isLoading
                  ? const Center(
                      child: CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.blue),
                      ),
                    )
                  : _errorMessage != null
                      ? Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.error_outline,
                                size: 48,
                                color: Colors.red.shade300,
                              ),
                              const SizedBox(height: 16),
                              Text(
                                _errorMessage!,
                                style: TextStyle(color: Colors.grey[400]),
                              ),
                              const SizedBox(height: 24),
                              ElevatedButton(
                                onPressed: _initializeChat,
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.blue.shade700,
                                ),
                                child: const Text('Retry'),
                              ),
                            ],
                          ),
                        )
                      : _onlineUsers.isEmpty
                          ? Center(
                              child: Text(
                                'No users available',
                                style: TextStyle(color: Colors.grey[400]),
                              ),
                            )
                          : ListView.builder(
                              itemCount: _onlineUsers.length,
                              itemBuilder: (context, index) {
                                final user = _onlineUsers[index];
                                // Skip the current user
                                if (user.userId == _currentUserId) {
                                  return const SizedBox.shrink();
                                }
                                return ListTile(
                                  leading: CircleAvatar(
                                    backgroundColor: user.isOnline
                                        ? Colors.blue.shade700
                                        : Colors.grey[700],
                                    child: Text(
                                      user.username.isNotEmpty
                                          ? user.username[0].toUpperCase()
                                          : '?',
                                      style:
                                          const TextStyle(color: Colors.white),
                                    ),
                                  ),
                                  title: Text(
                                    user.username,
                                    style: const TextStyle(color: Colors.white),
                                  ),
                                  subtitle: Text(
                                    user.isOnline ? 'Online' : 'Offline',
                                    style: TextStyle(
                                      color: user.isOnline
                                          ? Colors.green
                                          : Colors.grey,
                                      fontSize: 12,
                                    ),
                                  ),
                                  trailing: user.isOnline
                                      ? Container(
                                          width: 12,
                                          height: 12,
                                          decoration: BoxDecoration(
                                            color: Colors.green,
                                            shape: BoxShape.circle,
                                          ),
                                        )
                                      : null,
                                  onTap: () {
                                    _selectUser(user);
                                  },
                                );
                              },
                            ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildChatScreen() {
    return BlocBuilder<cubit.ChatCubit, List<cubit.ChatMessage>>(
      builder: (context, messages) {
        return Scaffold(
          backgroundColor: Colors.grey[900],
          appBar: AppBar(
            backgroundColor: Colors.blue.shade900,
            title: Row(
              children: [
                CircleAvatar(
                  radius: 16,
                  backgroundColor: _selectedUser!.isOnline
                      ? Colors.blue.shade300
                      : Colors.grey,
                  child: Text(
                    _selectedUser!.username.isNotEmpty
                        ? _selectedUser!.username[0].toUpperCase()
                        : '?',
                    style: TextStyle(
                      color: Colors.blue.shade900,
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        _selectedUser!.username,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        _selectedUser!.isOnline ? 'Online' : 'Offline',
                        style: TextStyle(
                          fontSize: 12,
                          color: _selectedUser!.isOnline
                              ? Colors.green.shade300
                              : Colors.grey,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            leading: IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: () {
                setState(() {
                  _selectedUser = null;
                });
              },
            ),
            actions: [
              IconButton(
                icon: const Icon(Icons.call),
                onPressed: () {
                  // Initiate a voice call using the service
                  _chatService.initiateCall(_selectedUser!.userId, false);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                        content: Text('Calling ${_selectedUser!.username}...')),
                  );
                },
              ),
              IconButton(
                icon: const Icon(Icons.videocam),
                onPressed: () {
                  // Initiate a video call using the service
                  _chatService.initiateCall(_selectedUser!.userId, true);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                        content: Text(
                            'Video calling ${_selectedUser!.username}...')),
                  );
                },
              ),
            ],
          ),
          body: SafeArea(
            child: Column(
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
                            final isMe = message.sender == _currentUserId;
                            return ChatBubble(
                              message: message,
                              isMe: isMe,
                              onReply: () => widget.onReply(message),
                            );
                          },
                        ),
                ),

                // Message input
                _buildMessageInput(context),
              ],
            ),
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
    final AudioRecorderHelper audioRecorderHelper = AudioRecorderHelper();

    return StatefulBuilder(
      builder: (context, setState) {
        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 12),
          decoration: BoxDecoration(
            color: Colors.grey[850],
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.2),
                blurRadius: 4,
                offset: const Offset(0, -1),
              ),
            ],
          ),
          child: Row(
            children: [
              IconButton(
                icon: const Icon(Icons.image, color: Colors.blue),
                onPressed: () async {
                  if (_selectedUser == null) return;

                  final imagePath = await _chatService.pickImage();

                  if (imagePath != null) {
                    // Send the image message via the service
                    final success = await _chatService.sendImageMessage(
                        _selectedUser!.userId, imagePath);

                    if (success) {
                      // Add the message to the UI via cubit
                      final chatCubit = context.read<cubit.ChatCubit>();
                      chatCubit.sendImageMessage(imagePath,
                          _currentUserId ?? '', _selectedUser!.userId);
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Failed to send image')),
                      );
                    }
                  }
                },
              ),
              Expanded(
                child: TextField(
                  controller: messageController,
                  style: const TextStyle(color: Colors.white),
                  decoration: InputDecoration(
                    hintText: "Type a message...",
                    hintStyle: TextStyle(color: Colors.grey[400]),
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 10,
                    ),
                    filled: true,
                    fillColor: Colors.grey[800],
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(24),
                      borderSide: BorderSide.none,
                    ),
                  ),
                  onChanged: (text) {
                    // Send typing notification
                    if (text.isNotEmpty && _selectedUser != null) {
                      _chatService
                          .sendTypingNotification(_selectedUser!.userId);
                    }
                  },
                ),
              ),
              const SizedBox(width: 8),
              GestureDetector(
                onLongPress: () async {
                  if (await audioRecorderHelper.hasPermission()) {
                    await audioRecorderHelper.start();
                    setState(() {
                      _isRecording = true;
                    });
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text(
                            'Microphone permission denied. Cannot record audio.'),
                        duration: Duration(seconds: 3),
                      ),
                    );
                  }
                },
                onLongPressEnd: (_) async {
                  if (_isRecording) {
                    final recordingPath = await audioRecorderHelper.stop();
                    setState(() {
                      _isRecording = false;
                    });

                    if (recordingPath != null && _selectedUser != null) {
                      // Send audio message via the service
                      final success = await _chatService.sendMessage(
                          _selectedUser!.userId, recordingPath,
                          type: service.MessageType.audio,
                          localFilePath: recordingPath);

                      if (success) {
                        // Also notify the cubit for local UI update
                        final chatCubit = context.read<cubit.ChatCubit>();
                        chatCubit.sendAudioMessage(recordingPath,
                            _currentUserId ?? '', _selectedUser!.userId);
                      }
                    }
                  }
                },
                child: Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: _isRecording ? Colors.red : Colors.blue.shade700,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    _isRecording ? Icons.mic : Icons.mic_none,
                    color: Colors.white,
                  ),
                ),
              ),
              const SizedBox(width: 8),
              IconButton(
                icon: const Icon(Icons.send, color: Colors.blue),
                onPressed: () {
                  final message = messageController.text.trim();
                  if (message.isNotEmpty && _selectedUser != null) {
                    // Send message via the service
                    _chatService.sendMessage(_selectedUser!.userId, message);

                    // Also notify the cubit for local UI update
                    final chatCubit = context.read<cubit.ChatCubit>();
                    chatCubit.sendMessage(message, _currentUserId ?? '',
                        receiverId: _selectedUser!.userId);

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

  @override
  void dispose() {
    _chatService.disconnect();
    super.dispose();
  }
}

/*
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'chat_cubit.dart' as cubit;
import 'chat_bubble.dart';
import 'audio_recorder_helper.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'chat_service.dart' as service;

class ChatWindow extends StatefulWidget {
  final VoidCallback onBack;
  final Function(cubit.ChatMessage) onReply;

  const ChatWindow({
    Key? key,
    required this.onBack,
    required this.onReply,
  }) : super(key: key);

  @override
  State<ChatWindow> createState() => _ChatWindowState();
}

class _ChatWindowState extends State<ChatWindow> {
  final service.ChatService _chatService = service.ChatService();
  final List<service.ChatUser> _onlineUsers = [];
  service.ChatUser? _selectedUser;
  bool _isLoading = true;
  String? _errorMessage;
  String? _currentUserId;

  @override
  void initState() {
    super.initState();
    _initializeChat();
  }

  Future<void> _initializeChat() async {
    try {
      setState(() {
        _isLoading = true;
        _errorMessage = null;
      });

      final prefs = await SharedPreferences.getInstance();
      _currentUserId = prefs.getString('UserId');

      await _chatService.connect();

      _chatService.onUsersUpdated = (users) {
        setState(() {
          _onlineUsers.clear();
          _onlineUsers.addAll(users);
          _isLoading = false;
        });
      };

      if (_onlineUsers.isEmpty) {
        await _chatService.getOnlinePeople();
      }

      setState(() {
        _isLoading = false;
      });
    } catch (e) {
      debugPrint('Error initializing chat: $e');
      setState(() {
        _isLoading = false;
        _errorMessage = 'Failed to connect to the chat server';
      });
    }
  }

  void _selectUser(service.ChatUser user) {
    setState(() {
      _selectedUser = user;
    });

    final chatCubit = context.read<cubit.ChatCubit>();
    chatCubit.selectReceiver(user.userId);
  }

  @override
  Widget build(BuildContext context) {
    if (_selectedUser == null) {
      return _buildUserSelectionScreen();
    }

    return _buildChatScreen();
  }

  Widget _buildUserSelectionScreen() {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue.shade900,
        title: const Text('Select Contact'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: widget.onBack,
        ),
      ),
      body: Container(
        color: Colors.grey[900],
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
              color: Colors.grey[850],
              child: Row(
                children: [
                  const Icon(Icons.circle, color: Colors.green, size: 14),
                  const SizedBox(width: 8),
                  Text(
                    'Online Users (${_onlineUsers.where((user) => user.isOnline).length})',
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: _isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : _errorMessage != null
                      ? Center(child: Text(_errorMessage!))
                      : _onlineUsers.isEmpty
                          ? const Center(child: Text('No users available'))
                          : ListView.builder(
                              itemCount: _onlineUsers.length,
                              itemBuilder: (context, index) {
                                final user = _onlineUsers[index];
                                return ListTile(
                                  leading: CircleAvatar(
                                    backgroundColor: user.isOnline
                                        ? Colors.blue.shade700
                                        : Colors.grey[700],
                                    child: Text(
                                      user.username.isNotEmpty
                                          ? user.username[0].toUpperCase()
                                          : '?',
                                      style:
                                          const TextStyle(color: Colors.white),
                                    ),
                                  ),
                                  title: Text(
                                    user.username,
                                    style: const TextStyle(color: Colors.white),
                                  ),
                                  onTap: () => _selectUser(user),
                                );
                              },
                            ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildChatScreen() {
    return BlocBuilder<cubit.ChatCubit, List<cubit.ChatMessage>>(
      builder: (context, messages) {
        return Scaffold(
          backgroundColor: Colors.grey[900],
          appBar: AppBar(
            backgroundColor: Colors.blue.shade900,
            title: Text(_selectedUser?.username ?? 'Chat'),
            leading: IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: () => setState(() => _selectedUser = null),
            ),
          ),
          body: Column(
            children: [
              Expanded(
                child: messages.isEmpty
                    ? _buildEmptyState()
                    : ListView.builder(
                        itemCount: messages.length,
                        itemBuilder: (context, index) {
                          final message = messages[index];
                          final isMe = message.sender == _currentUserId;
                          return ChatBubble(
                            message: message,
                            isMe: isMe,
                            onReply: () => widget.onReply(message),
                          );
                        },
                      ),
              ),
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

    return StatefulBuilder(
      builder: (context, setState) {
        bool isRecording = false;

        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 12),
          decoration: BoxDecoration(
            color: Colors.grey[850],
          ),
          child: Row(
            children: [
              IconButton(
                icon: const Icon(Icons.image, color: Colors.blue),
                onPressed: () async {
                  final image = await ImagePicker()
                      .pickImage(source: ImageSource.gallery);
                  if (image != null) {
                    // Handle image
                  }
                },
              ),
              Expanded(
                child: TextField(
                  controller: messageController,
                  style: const TextStyle(color: Colors.white),
                  decoration: InputDecoration(
                    hintText: "Type a message...",
                    hintStyle: TextStyle(color: Colors.grey[400]),
                    filled: true,
                    fillColor: Colors.grey[800],
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(24),
                      borderSide: BorderSide.none,
                    ),
                  ),
                  onChanged: (text) {
                    if (text.isNotEmpty && _selectedUser != null) {
                      context.read<cubit.ChatCubit>().sendTypingNotification();
                    }
                  },
                ),
              ),
              const SizedBox(width: 8),
              IconButton(
                icon: const Icon(Icons.send, color: Colors.blue),
                onPressed: () {
                  final message = messageController.text.trim();
                  if (message.isNotEmpty && _selectedUser != null) {
                    context.read<cubit.ChatCubit>().sendMessage(
                          message,
                          _currentUserId ?? '',
                        );
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

  @override
  void dispose() {
    _chatService.disconnect();
    super.dispose();
  }
}
*/