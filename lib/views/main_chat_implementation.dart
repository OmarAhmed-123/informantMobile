/*
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'chat_window.dart';
import 'chat_cubit.dart' as cubit;
import 'chat_service.dart' as service;
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ChatImplementation extends StatefulWidget {
  final VoidCallback onBack;
  final Function(cubit.ChatMessage) onReply;
  final String userId;
  final String username;

  const ChatImplementation({
    super.key,
    required this.onBack,
    required this.onReply,
    required this.userId,
    required this.username,
  });

  @override
  State<ChatImplementation> createState() => _ChatImplementationState();
}

class _ChatImplementationState extends State<ChatImplementation> {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => cubit.ChatCubit(),
      child: _ChatImplementationContent(
        onBack: widget.onBack,
        onReply: widget.onReply,
        userId: widget.userId,
        username: widget.username,
      ),
    );
  }
}

class _ChatImplementationContent extends StatefulWidget {
  final VoidCallback onBack;
  final Function(cubit.ChatMessage) onReply;
  final String userId;
  final String username;

  const _ChatImplementationContent({
    required this.onBack,
    required this.onReply,
    required this.userId,
    required this.username,
  });

  @override
  State<_ChatImplementationContent> createState() =>
      _ChatImplementationContentState();
}

class _ChatImplementationContentState extends State<_ChatImplementationContent>
    with TickerProviderStateMixin {
  final service.ChatService _chatService = service.ChatService();
  bool _isLoading = true;
  List<service.ChatUser> _users = [];
  service.ChatUser? _selectedUser;
  bool _isInChat = false;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _initChatService();
  }

  Future<void> _initChatService() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      await _chatService.connect();
      _chatService.onUsersUpdated = _handleUsersUpdated;

      // Initial fetch of users
      await _chatService.getOnlinePeople();

      setState(() {
        _users = _chatService.onlineUsers;
        _isLoading = false;
      });
    } catch (e) {
      print("Error initializing chat service: $e");
      setState(() {
        _isLoading = false;
        _errorMessage =
            "Could not connect to the chat service. Please try again.";
      });
    }
  }

  void _handleUsersUpdated(List<service.ChatUser> users) {
    if (mounted) {
      setState(() {
        _users = users;
      });
    }
  }

  void _selectUser(service.ChatUser user) {
    setState(() {
      _selectedUser = user;
      _isInChat = true;
    });
    context.read<cubit.ChatCubit>().selectReceiver(user.userId);
  }

  void _goBackToUserList() {
    setState(() {
      _isInChat = false;
      _selectedUser = null;
    });
  }

  @override
  void dispose() {
    _chatService.disconnect();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Colors.grey[900]!,
              Colors.black,
            ],
          ),
        ),
        child: _isInChat
            ? ChatWindow(
                onBack: _goBackToUserList,
                onReply: widget.onReply,
              )
            : _buildUsersList(),
      ),
    );
  }

  Widget _buildUsersList() {
    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        backgroundColor: Colors.grey[850],
        title: const Text(
          'Contacts',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: widget.onBack,
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh, color: Colors.white),
            onPressed: () => _initChatService(),
          ),
        ],
      ),
      body: _isLoading
          ? Center(
              child: SpinKitPulse(
                color: Colors.blue[400],
                size: 50.0,
                controller: AnimationController(
                  vsync: this,
                  duration: const Duration(milliseconds: 1200),
                ),
              ),
            )
          : _errorMessage != null
              ? _buildErrorState()
              : _users.isEmpty
                  ? _buildEmptyState()
                  : _buildUsersListView(),
    );
  }

  Widget _buildErrorState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.error_outline,
            size: 80,
            color: Colors.red[300],
          ),
          const SizedBox(height: 16),
          Text(
            _errorMessage ?? "An unknown error occurred",
            style: TextStyle(
              color: Colors.grey[300],
              fontSize: 18,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 24),
          ElevatedButton.icon(
            onPressed: _initChatService,
            icon: const Icon(Icons.refresh),
            label: const Text("Try Again"),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blue,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(
                horizontal: 24,
                vertical: 12,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.people_outline,
            size: 80,
            color: Colors.grey[700],
          ),
          const SizedBox(height: 16),
          Text(
            'No online users',
            style: TextStyle(
              color: Colors.grey[500],
              fontSize: 18,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Try again later or refresh the list',
            style: TextStyle(
              color: Colors.grey[400],
              fontSize: 14,
            ),
          ),
          const SizedBox(height: 24),
          ElevatedButton.icon(
            onPressed: _initChatService,
            icon: const Icon(Icons.refresh),
            label: const Text("Refresh"),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blue,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(
                horizontal: 24,
                vertical: 12,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildUsersListView() {
    return ListView.builder(
      itemCount: _users.length,
      itemBuilder: (context, index) {
        final user = _users[index];
        if (user.userId == widget.userId) {
          return const SizedBox.shrink();
        }
        return _buildUserTile(user);
      },
    );
  }

  Widget _buildUserTile(service.ChatUser user) {
    return Slidable(
      endActionPane: ActionPane(
        motion: const ScrollMotion(),
        children: [
          SlidableAction(
            onPressed: (context) {
              _chatService.initiateCall(user.userId, false);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text("Voice calling ${user.username}...")),
              );
            },
            backgroundColor: Colors.green,
            foregroundColor: Colors.white,
            icon: Icons.call,
            label: 'Call',
            borderRadius: BorderRadius.circular(10),
          ),
          SlidableAction(
            onPressed: (context) {
              _chatService.initiateCall(user.userId, true);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text("Video calling ${user.username}...")),
              );
            },
            backgroundColor: Colors.blue,
            foregroundColor: Colors.white,
            icon: Icons.videocam,
            label: 'Video',
            borderRadius: BorderRadius.circular(10),
          ),
        ],
      ),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        child: ListTile(
          onTap: () => _selectUser(user),
          leading: CircleAvatar(
            backgroundColor: Colors.blue.shade800,
            radius: 25,
            backgroundImage: user.profileImage != null
                ? NetworkImage(user.profileImage!)
                : null,
            child: user.profileImage == null
                ? Text(
                    user.username.isNotEmpty ? user.username[0] : "?",
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                  )
                : null,
          ),
          title: Text(
            user.username,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          subtitle: Text(
            user.isOnline ? "Online" : "Offline",
            style: TextStyle(
              color: user.isOnline ? Colors.green[400] : Colors.grey[400],
            ),
          ),
          trailing: Container(
            width: 12,
            height: 12,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: user.isOnline ? Colors.green : Colors.grey,
            ),
          ),
        ),
      ),
    );
  }
}

class ChatApp extends StatefulWidget {
  final String username;
  final String userId;
  final VoidCallback? onLogout;

  const ChatApp({
    super.key,
    required this.username,
    required this.userId,
    this.onLogout,
  });

  @override
  State<ChatApp> createState() => _ChatAppState();
}

class _ChatAppState extends State<ChatApp> with SingleTickerProviderStateMixin {
  bool _isChatOpen = false;
  final service.ChatService _chatService = service.ChatService();
  late AnimationController _animationController;

  @override
  void initState() {
    super.initState();
    _initializeChat();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
  }

  Future<void> _initializeChat() async {
    try {
      final prefs = await SharedPreferences.getInstance();

      // Store actual user data
      if (prefs.getString('CookieToken') == null) {
        // In a real app, this would be a real token from the server
        await prefs.setString('CookieToken', 'token');
      }

      await prefs.setString('UserId', widget.userId);
      await _chatService.connect();
    } catch (e) {
      debugPrint("Error initializing chat: $e");
    }
  }

  void _toggleChat() {
    setState(() {
      _isChatOpen = !_isChatOpen;
      if (_isChatOpen) {
        _animationController.forward();
      } else {
        _animationController.reverse();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        if (!_isChatOpen)
          Positioned(
            right: 20,
            bottom: 20,
            child: FloatingActionButton(
              onPressed: _toggleChat,
              backgroundColor: Colors.blue,
              child: const Icon(Icons.chat),
            ),
          ),
        if (_isChatOpen)
          Positioned.fill(
            child: Material(
              elevation: 8,
              child: BlocProvider(
                create: (context) => cubit.ChatCubit(),
                child: ChatWindow(
                  onBack: _toggleChat,
                  onReply: (message) {
                    // Handle reply
                  },
                ),
              ),
            ),
          ),
      ],
    );
  }

  @override
  void dispose() {
    _chatService.disconnect();
    _animationController.dispose();
    super.dispose();
  }
}
*/

/*
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'chat_window.dart';
import 'chat_cubit.dart' as cubit;
import 'chat_service.dart' as service;
import 'package:shared_preferences/shared_preferences.dart';

class ChatImplementation extends StatelessWidget {
  final VoidCallback onBack;
  final Function(cubit.ChatMessage) onReply;
  final String userId;

  const ChatImplementation({
    super.key,
    required this.onBack,
    required this.onReply,
    required this.userId,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => cubit.ChatCubit(),
      child: _ChatImplementationContent(
        onBack: onBack,
        onReply: onReply,
        userId: userId,
      ),
    );
  }
}

class _ChatImplementationContent extends StatefulWidget {
  final VoidCallback onBack;
  final Function(cubit.ChatMessage) onReply;
  final String userId;

  const _ChatImplementationContent({
    required this.onBack,
    required this.onReply,
    required this.userId,
  });

  @override
  State<_ChatImplementationContent> createState() =>
      _ChatImplementationContentState();
}

class _ChatImplementationContentState
    extends State<_ChatImplementationContent> {
  late final service.ChatService _chatService;
  bool _isLoading = true;
  bool _isInChat = false;
  service.ChatUser? _selectedUser;

  @override
  void initState() {
    super.initState();
    _chatService = service.ChatService();
    _initializeChat();
  }

  Future<void> _initializeChat() async {
    try {
      await _chatService.connect();
      _chatService.onUsersUpdated = (users) {
        if (mounted) setState(() => _isLoading = false);
      };
      await _chatService.getOnlinePeople();
    } catch (e) {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  void _selectUser(service.ChatUser user) {
    setState(() {
      _selectedUser = user;
      _isInChat = true;
    });
    context.read<cubit.ChatCubit>().selectReceiver(user.userId);
  }

  @override
  void dispose() {
    _chatService.disconnect();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return _isInChat
        ? ChatWindow(
            onBack: () => setState(() => _isInChat = false),
            onReply: widget.onReply,
          )
        : Scaffold(
            appBar: AppBar(
              title: const Text('Contacts'),
              leading: IconButton(
                icon: const Icon(Icons.arrow_back),
                onPressed: widget.onBack,
              ),
            ),
            body: _isLoading
                ? const Center(child: CircularProgressIndicator())
                : _buildUserList(),
          );
  }

  Widget _buildUserList() {
    return ListView.builder(
      itemCount: _chatService.onlineUsers.length,
      itemBuilder: (context, index) {
        final user = _chatService.onlineUsers[index];
        if (user.userId == widget.userId) return const SizedBox.shrink();
        return ListTile(
          title: Text(user.username),
          onTap: () => _selectUser(user),
        );
      },
    );
  }
}

class ChatApp extends StatelessWidget {
  final String userId;

  const ChatApp({super.key, required this.userId});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => cubit.ChatCubit(),
      child: _ChatAppContent(userId: userId),
    );
  }
}

class _ChatAppContent extends StatefulWidget {
  final String userId;

  const _ChatAppContent({required this.userId});

  @override
  State<_ChatAppContent> createState() => _ChatAppContentState();
}

class _ChatAppContentState extends State<_ChatAppContent> {
  late final service.ChatService _chatService;

  @override
  void initState() {
    super.initState();
    _chatService = service.ChatService();
    _initializeChat();
  }

  Future<void> _initializeChat() async {
    try {
      await _chatService.connect();
    } catch (e) {
      debugPrint("Chat initialization error: $e");
    }
  }

  @override
  void dispose() {
    _chatService.disconnect();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      onPressed: () {
        Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => BlocProvider.value(
                value: context.read<cubit.ChatCubit>(),
                child: ChatWindow(
                  onBack: () => Navigator.pop(context),
                  onReply: (message) {},
                ),
              ),
            ));
      },
      child: const Icon(Icons.chat),
    );
  }
}
*/
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'chat_window.dart';
import 'chat_cubit.dart' as cubit;
import 'chat_service.dart' as service;
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ChatImplementation extends StatefulWidget {
  final VoidCallback onBack;
  final Function(cubit.ChatMessage) onReply;
  final String userId;
  final String username;

  const ChatImplementation({
    super.key,
    required this.onBack,
    required this.onReply,
    required this.userId,
    required this.username,
  });

  @override
  State<ChatImplementation> createState() => _ChatImplementationState();
}

class _ChatImplementationState extends State<ChatImplementation> {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => cubit.ChatCubit(),
      child: _ChatImplementationContent(
        onBack: widget.onBack,
        onReply: widget.onReply,
        userId: widget.userId,
        username: widget.username,
      ),
    );
  }
}

class _ChatImplementationContent extends StatefulWidget {
  final VoidCallback onBack;
  final Function(cubit.ChatMessage) onReply;
  final String userId;
  final String username;

  const _ChatImplementationContent({
    required this.onBack,
    required this.onReply,
    required this.userId,
    required this.username,
  });

  @override
  State<_ChatImplementationContent> createState() =>
      _ChatImplementationContentState();
}

class _ChatImplementationContentState extends State<_ChatImplementationContent>
    with TickerProviderStateMixin {
  final service.ChatService _chatService = service.ChatService();
  bool _isLoading = true;
  List<service.ChatUser> _users = [];
  service.ChatUser? _selectedUser;
  bool _isInChat = false;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _initChatService();
  }

  Future<void> _initChatService() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      await _chatService.connect();
      _chatService.onUsersUpdated = _handleUsersUpdated;

      // Initial fetch of users
      await _chatService.getOnlinePeople();

      setState(() {
        _users = _chatService.onlineUsers;
        _isLoading = false;
      });
    } catch (e) {
      print("Error initializing chat service: $e");
      setState(() {
        _isLoading = false;
        _errorMessage =
            "Could not connect to the chat service. Please try again.";
      });
    }
  }

  void _handleUsersUpdated(List<service.ChatUser> users) {
    if (mounted) {
      setState(() {
        _users = users;
      });
    }
  }

  void _selectUser(service.ChatUser user) {
    setState(() {
      _selectedUser = user;
      _isInChat = true;
    });
    context.read<cubit.ChatCubit>().selectReceiver(user.userId);
  }

  void _goBackToUserList() {
    setState(() {
      _isInChat = false;
      _selectedUser = null;
    });
  }

  @override
  void dispose() {
    _chatService.disconnect();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Colors.grey[900]!,
              Colors.black,
            ],
          ),
        ),
        child: _isInChat
            ? ChatWindow(
                onBack: _goBackToUserList,
                onReply: widget.onReply,
              )
            : _buildUsersList(),
      ),
    );
  }

  Widget _buildUsersList() {
    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        backgroundColor: Colors.grey[850],
        title: const Text(
          'Contacts',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: widget.onBack,
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh, color: Colors.white),
            onPressed: () => _initChatService(),
          ),
        ],
      ),
      body: _isLoading
          ? Center(
              child: SpinKitPulse(
                color: Colors.blue[400],
                size: 50.0,
                controller: AnimationController(
                  vsync: this,
                  duration: const Duration(milliseconds: 1200),
                ),
              ),
            )
          : _errorMessage != null
              ? _buildErrorState()
              : _users.isEmpty
                  ? _buildEmptyState()
                  : _buildUsersListView(),
    );
  }

  Widget _buildErrorState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.error_outline,
            size: 80,
            color: Colors.red[300],
          ),
          const SizedBox(height: 16),
          Text(
            _errorMessage ?? "An unknown error occurred",
            style: TextStyle(
              color: Colors.grey[300],
              fontSize: 18,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 24),
          ElevatedButton.icon(
            onPressed: _initChatService,
            icon: const Icon(Icons.refresh),
            label: const Text("Try Again"),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blue,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(
                horizontal: 24,
                vertical: 12,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.people_outline,
            size: 80,
            color: Colors.grey[700],
          ),
          const SizedBox(height: 16),
          Text(
            'No online users',
            style: TextStyle(
              color: Colors.grey[500],
              fontSize: 18,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Try again later or refresh the list',
            style: TextStyle(
              color: Colors.grey[400],
              fontSize: 14,
            ),
          ),
          const SizedBox(height: 24),
          ElevatedButton.icon(
            onPressed: _initChatService,
            icon: const Icon(Icons.refresh),
            label: const Text("Refresh"),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blue,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(
                horizontal: 24,
                vertical: 12,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildUsersListView() {
    return ListView.builder(
      itemCount: _users.length,
      itemBuilder: (context, index) {
        final user = _users[index];
        if (user.userId == widget.userId) {
          return const SizedBox.shrink();
        }
        return _buildUserTile(user);
      },
    );
  }

  Widget _buildUserTile(service.ChatUser user) {
    return Slidable(
      endActionPane: ActionPane(
        motion: const ScrollMotion(),
        children: [
          SlidableAction(
            onPressed: (context) {
              _chatService.initiateCall(user.userId, false);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text("Voice calling ${user.username}...")),
              );
            },
            backgroundColor: Colors.green,
            foregroundColor: Colors.white,
            icon: Icons.call,
            label: 'Call',
            borderRadius: BorderRadius.circular(10),
          ),
          SlidableAction(
            onPressed: (context) {
              _chatService.initiateCall(user.userId, true);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text("Video calling ${user.username}...")),
              );
            },
            backgroundColor: Colors.blue,
            foregroundColor: Colors.white,
            icon: Icons.videocam,
            label: 'Video',
            borderRadius: BorderRadius.circular(10),
          ),
        ],
      ),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        child: ListTile(
          onTap: () => _selectUser(user),
          leading: CircleAvatar(
            backgroundColor: Colors.blue.shade800,
            radius: 25,
            backgroundImage: user.profileImage != null
                ? NetworkImage(user.profileImage!)
                : null,
            child: user.profileImage == null
                ? Text(
                    user.username.isNotEmpty ? user.username[0] : "?",
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                  )
                : null,
          ),
          title: Text(
            user.username,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          subtitle: Text(
            user.isOnline ? "Online" : "Offline",
            style: TextStyle(
              color: user.isOnline ? Colors.green[400] : Colors.grey[400],
            ),
          ),
          trailing: Container(
            width: 12,
            height: 12,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: user.isOnline ? Colors.green : Colors.grey,
            ),
          ),
        ),
      ),
    );
  }
}

class ChatApp extends StatefulWidget {
  final String username;
  final String userId;
  final VoidCallback? onLogout;

  const ChatApp({
    super.key,
    required this.username,
    required this.userId,
    this.onLogout,
  });

  @override
  State<ChatApp> createState() => _ChatAppState();
}

class _ChatAppState extends State<ChatApp> with SingleTickerProviderStateMixin {
  bool _isChatOpen = false;
  final service.ChatService _chatService = service.ChatService();
  late AnimationController _animationController;

  @override
  void initState() {
    super.initState();
    _initializeChat();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
  }

  Future<void> _initializeChat() async {
    try {
      // Just ensure the UserId is set
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('UserId', widget.userId);

      // Connect to chat service using the existing token from login
      await _chatService.connect();
    } catch (e) {
      debugPrint("Error initializing chat: $e");
    }
  }

  void _toggleChat() {
    setState(() {
      _isChatOpen = !_isChatOpen;
      if (_isChatOpen) {
        _animationController.forward();
      } else {
        _animationController.reverse();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        if (!_isChatOpen)
          Positioned(
            right: 20,
            bottom: 20,
            child: FloatingActionButton(
              onPressed: _toggleChat,
              backgroundColor: Colors.blue,
              child: const Icon(Icons.chat),
            ),
          ),
        if (_isChatOpen)
          Positioned.fill(
            child: Material(
              elevation: 8,
              child: BlocProvider(
                create: (context) => cubit.ChatCubit(),
                child: ChatWindow(
                  onBack: _toggleChat,
                  onReply: (message) {
                    // Handle reply
                  },
                ),
              ),
            ),
          ),
      ],
    );
  }

  @override
  void dispose() {
    _chatService.disconnect();
    _animationController.dispose();
    super.dispose();
  }
}
