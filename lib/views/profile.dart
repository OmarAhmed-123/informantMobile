/*
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:graduation___part1/views/collectData.dart';
import 'package:graduation___part1/views/home_view.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
import 'package:web_socket_channel/io.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  ProfilePageState createState() => ProfilePageState();
}

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
  late WebSocketChannel _channel;

  ChatCubit() : super([]) {
    _connectToWebSocket();
  }

  void _connectToWebSocket() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('CookieToken');
    String? ptoken = prefs.getString('pToken');

    final wsUrl =
        'wss://infinitely-native-lamprey.ngrok-free.app/ws?token=$token&ptoken=$ptoken';
    _channel = IOWebSocketChannel.connect(wsUrl);

    _channel.stream.listen((message) {
      final data = jsonDecode(message);
      final chatMessage = ChatMessage(
        text: data['message'],
        sender: data['sender'],
        timestamp: DateTime.now(),
      );
      emit([...state, chatMessage]);
    }, onError: (error) {
      print("WebSocket error: $error");
    }, onDone: () {
      print("WebSocket connection closed");
    });
  }

  void sendMessage(String message, String sender) {
    if (message.trim().isEmpty) return;

    _channel.sink.add(jsonEncode({
      'message': message,
      'sender': sender,
    }));
  }

  @override
  Future<void> close() {
    _channel.sink.close();
    return super.close();
  }
}

class ProfilePageState extends State<ProfilePage>
    with TickerProviderStateMixin {
  String? about;
  String? username;
  String? skills;
  ImageProvider? profileImage;
  int selectedTab = 0;
  String? linkedin;
  int? numOfEx;
  String? email;
  String? phone;
  String? profile;
  bool _isChatVisible = false;

  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    getProfileData();
  }

  Future<void> getProfileData() async {
    SharedPreferences objShared = await SharedPreferences.getInstance();

    setState(() {
      about = objShared.getString('about');
      skills = objShared.getString('skills');
      username = objShared.getString('username');
      final base64Image = objShared.getString('profile_image');

      email = objShared.getString('email');
      linkedin = objShared.getString('linkedin');
      profile = objShared.getString('profile_link');
      phone = objShared.getString('phone');
      numOfEx = objShared.getInt('experience_years');

      if (base64Image != null) {
        final bytes = base64Decode(base64Image);
        profileImage = MemoryImage(bytes);
      } else {
        profileImage = const AssetImage('assets/default_avatar.png');
      }
    });
  }

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
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.home, color: Colors.white),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const HomeView()),
            );
          },
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit, color: Colors.white),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const collectData()),
              );
            },
          ),
        ],
      ),
      body: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Colors.black,
                  Colors.blue.shade900.withOpacity(0.6),
                  Colors.black,
                ],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Hero(
                      tag: 'profile-image',
                      child: Container(
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.blue.withOpacity(0.3),
                              blurRadius: 20,
                              spreadRadius: 5,
                            ),
                          ],
                        ),
                        child: CircleAvatar(
                          radius: 60,
                          backgroundColor: Colors.grey[800],
                          backgroundImage: profileImage,
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      username ?? "Username",
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 20),
                    ElevatedButton.icon(
                      onPressed: _toggleChat,
                      icon: const Icon(Icons.message),
                      label: const Text("Contact Me"),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 24,
                          vertical: 12,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        _buildTabButton(0, Icons.person, "Profile"),
                        _buildTabButton(1, Icons.star, "Rates"),
                        _buildTabButton(2, Icons.work, "My Works"),
                      ],
                    ),
                    Divider(height: 40, thickness: 1, color: Colors.grey[600]),
                    _buildContent(),
                  ],
                ),
              ),
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
              left: 0,
              right: 0,
              child: BlocProvider(
                create: (context) => ChatCubit(),
                child: ChatWindow(
                  scrollController: _scrollController,
                  messageController: _messageController,
                  onSendMessage: (message) {
                    context.read<ChatCubit>().sendMessage(message, username!);
                  },
                  onCall: () {
                    // Implement phone call functionality
                    print("Initiating phone call...");
                  },
                  username: username ?? "User",
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildContent() {
    switch (selectedTab) {
      case 0:
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "About Me",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              about ?? "No information provided.",
              textAlign: TextAlign.justify,
              style: const TextStyle(fontSize: 16, color: Colors.white),
            ),
            const SizedBox(height: 20),
            const Text(
              "My Skills",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              skills ?? "No skills added.",
              textAlign: TextAlign.justify,
              style: const TextStyle(fontSize: 16, color: Colors.white),
            ),
            const SizedBox(height: 20),
            _buildInfoSection("LinkedIn Link", linkedin),
            _buildInfoSection("Years of Experience", numOfEx?.toString()),
            _buildInfoSection("Email", email),
            _buildInfoSection("Phone", phone),
            _buildInfoSection("Profile Link", profile),
          ],
        );
      case 1:
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Rates",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 10),
            const Text(
              "⭐️⭐️⭐️⭐️⭐️ - Excellent, very professional and punctual.",
              style: TextStyle(fontSize: 16, color: Colors.white),
            ),
          ],
        );
      case 2:
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "My Works",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 10),
            const Text(
              "You can add photos or samples of your previous work here.",
              style: TextStyle(fontSize: 16, color: Colors.white),
            ),
          ],
        );
      default:
        return Container();
    }
  }

  Widget _buildInfoSection(String title, String? content) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        const SizedBox(height: 10),
        Text(
          content ?? "Not provided",
          textAlign: TextAlign.justify,
          style: const TextStyle(fontSize: 16, color: Colors.white),
        ),
        const SizedBox(height: 20),
      ],
    );
  }

  Widget _buildTabButton(int index, IconData icon, String label) {
    final isSelected = selectedTab == index;
    return Column(
      children: [
        IconButton(
          icon: Icon(
            icon,
            color: isSelected ? Colors.blue : Colors.white,
          ),
          onPressed: () {
            setState(() {
              selectedTab = index;
            });
          },
        ),
        Text(
          label,
          style: TextStyle(
            color: isSelected ? Colors.blue : Colors.white,
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
  final VoidCallback onCall;
  final String username;

  const ChatWindow({
    Key? key,
    required this.scrollController,
    required this.messageController,
    required this.onSendMessage,
    required this.onCall,
    required this.username,
  }) : super(key: key);

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
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: 20,
              vertical: 16,
            ),
            decoration: BoxDecoration(
              color: Colors.blue,
              borderRadius: const BorderRadius.only(
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
                  onPressed: onCall,
                ),
                IconButton(
                  icon: const Icon(
                    Icons.close,
                    color: Colors.white,
                  ),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
              ],
            ),
          ),
          Expanded(
            child: BlocBuilder<ChatCubit, List<ChatMessage>>(
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
            ),
          ),
          Container(
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
                  onPressed: () => onSendMessage(messageController.text),
                ),
              ],
            ),
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
    Key? key,
    required this.message,
    required this.isMe,
  }) : super(key: key);

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
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:graduation___part1/views/chat_cubit.dart';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:graduation___part1/views/collectData.dart';
import 'package:graduation___part1/views/home_view.dart';
import 'chat_service.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  ProfilePageState createState() => ProfilePageState();
}

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

class ProfilePageState extends State<ProfilePage>
    with TickerProviderStateMixin {
  String? about;
  String? username;
  String? skills;
  ImageProvider? profileImage;
  int selectedTab = 0;
  String? linkedin;
  int? numOfEx;
  String? email;
  String? phone;
  String? profile;
  bool _isChatVisible = false;

  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    getProfileData();
  }

  Future<void> getProfileData() async {
    SharedPreferences objShared = await SharedPreferences.getInstance();

    setState(() {
      about = objShared.getString('about');
      skills = objShared.getString('skills');
      username = objShared.getString('username');
      final base64Image = objShared.getString('profile_image');

      email = objShared.getString('email');
      linkedin = objShared.getString('linkedin');
      profile = objShared.getString('profile_link');
      phone = objShared.getString('phone');
      numOfEx = objShared.getInt('experience_years');

      if (base64Image != null) {
        final bytes = base64Decode(base64Image);
        profileImage = MemoryImage(bytes);
      } else {
        profileImage = const AssetImage('assets/default_avatar.png');
      }
    });
  }

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
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.home, color: Colors.white),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const HomeView()),
            );
          },
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit, color: Colors.white),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const collectData()),
              );
            },
          ),
        ],
      ),
      body: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Colors.black,
                  Colors.blue.shade900.withOpacity(0.6),
                  Colors.black,
                ],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Hero(
                      tag: 'profile-image',
                      child: Container(
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.blue.withOpacity(0.3),
                              blurRadius: 20,
                              spreadRadius: 5,
                            ),
                          ],
                        ),
                        child: CircleAvatar(
                          radius: 60,
                          backgroundColor: Colors.grey[800],
                          backgroundImage: profileImage,
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      username ?? "Username",
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 20),
                    ElevatedButton.icon(
                      onPressed: _toggleChat,
                      icon: const Icon(Icons.message),
                      label: const Text("Contact Me"),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 24,
                          vertical: 12,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        _buildTabButton(0, Icons.person, "Profile"),
                        _buildTabButton(1, Icons.star, "Rates"),
                        _buildTabButton(2, Icons.work, "My Works"),
                      ],
                    ),
                    Divider(height: 40, thickness: 1, color: Colors.grey[600]),
                    _buildContent(),
                  ],
                ),
              ),
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
              left: 0,
              right: 0,
              child: BlocProvider(
                create: (context) => ChatCubit(ChatService()),
                child: ChatWindow(
                  scrollController: _scrollController,
                  messageController: _messageController,
                  onSendMessage: (message) {
                    context.read<ChatCubit>().sendMessage(message, username!);
                  },
                  onCall: () {
                    // Implement phone call functionality
                    print("Initiating phone call...");
                  },
                  username: username ?? "User",
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildContent() {
    switch (selectedTab) {
      case 0:
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "About Me",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              about ?? "No information provided.",
              textAlign: TextAlign.justify,
              style: const TextStyle(fontSize: 16, color: Colors.white),
            ),
            const SizedBox(height: 20),
            const Text(
              "My Skills",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              skills ?? "No skills added.",
              textAlign: TextAlign.justify,
              style: const TextStyle(fontSize: 16, color: Colors.white),
            ),
            const SizedBox(height: 20),
            _buildInfoSection("LinkedIn Link", linkedin),
            _buildInfoSection("Years of Experience", numOfEx?.toString()),
            _buildInfoSection("Email", email),
            _buildInfoSection("Phone", phone),
            _buildInfoSection("Profile Link", profile),
          ],
        );
      case 1:
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Rates",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 10),
            const Text(
              "⭐️⭐️⭐️⭐️⭐️ - Excellent, very professional and punctual.",
              style: TextStyle(fontSize: 16, color: Colors.white),
            ),
          ],
        );
      case 2:
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "My Works",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 10),
            const Text(
              "You can add photos or samples of your previous work here.",
              style: TextStyle(fontSize: 16, color: Colors.white),
            ),
          ],
        );
      default:
        return Container();
    }
  }

  Widget _buildInfoSection(String title, String? content) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        const SizedBox(height: 10),
        Text(
          content ?? "Not provided",
          textAlign: TextAlign.justify,
          style: const TextStyle(fontSize: 16, color: Colors.white),
        ),
        const SizedBox(height: 20),
      ],
    );
  }

  Widget _buildTabButton(int index, IconData icon, String label) {
    final isSelected = selectedTab == index;
    return Column(
      children: [
        IconButton(
          icon: Icon(
            icon,
            color: isSelected ? Colors.blue : Colors.white,
          ),
          onPressed: () {
            setState(() {
              selectedTab = index;
            });
          },
        ),
        Text(
          label,
          style: TextStyle(
            color: isSelected ? Colors.blue : Colors.white,
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
  final VoidCallback onCall;
  final String username;

  const ChatWindow({
    Key? key,
    required this.scrollController,
    required this.messageController,
    required this.onSendMessage,
    required this.onCall,
    required this.username,
  }) : super(key: key);

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
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: 20,
              vertical: 16,
            ),
            decoration: BoxDecoration(
              color: Colors.blue,
              borderRadius: const BorderRadius.only(
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
                  onPressed: onCall,
                ),
                IconButton(
                  icon: const Icon(
                    Icons.close,
                    color: Colors.white,
                  ),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
              ],
            ),
          ),
          Expanded(
            child: BlocBuilder<ChatCubit, List<ChatMessage>>(
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
            ),
          ),
          Container(
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
                  onPressed: () => onSendMessage(messageController.text),
                ),
              ],
            ),
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
    Key? key,
    required this.message,
    required this.isMe,
  }) : super(key: key);

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
