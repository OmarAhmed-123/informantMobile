import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:graduation___part1/views/collectData.dart';
import 'package:graduation___part1/views/home_view.dart';
import 'package:flutter/services.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  ProfilePageState createState() => ProfilePageState();
}

class ChatMessage {
  final String text;
  final bool isUser;
  final DateTime timestamp;

  ChatMessage({
    required this.text,
    required this.isUser,
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
  bool _isChatbotVisible = false;

  // Enhanced animations
  late AnimationController _slideController;
  late AnimationController _fadeController;
  late AnimationController _scaleController;
  late Animation<Offset> _slideAnimation;
  late Animation<double> _fadeAnimation;
  late Animation<double> _scaleAnimation;

  // Chatbot specific controllers
  late TextEditingController _messageController;
  final List<ChatMessage> _messages = [];
  late ScrollController _scrollController;
  bool _isTyping = false;

  // Typing animation controller
  late AnimationController _typingController;
  final List<AnimationController> _dotControllers = [];
  final List<Animation<double>> _dotAnimations = [];

  @override
  void initState() {
    super.initState();
    getProfileData();
    _initializeControllers();
    _setupAnimations();
  }

  void _initializeControllers() {
    _messageController = TextEditingController();
    _scrollController = ScrollController();

    _slideController = AnimationController(
      duration: const Duration(milliseconds: 400),
      vsync: this,
    );

    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );

    _scaleController = AnimationController(
      duration: const Duration(milliseconds: 400),
      vsync: this,
    );

    _typingController = AnimationController(
      duration: const Duration(milliseconds: 700),
      vsync: this,
    );

    // Initialize typing dots animations
    for (int i = 0; i < 3; i++) {
      final dotController = AnimationController(
        duration: Duration(milliseconds: 600),
        vsync: this,
      );

      final dotAnimation = Tween(begin: 0.0, end: 1.0).animate(
        CurvedAnimation(
          parent: dotController,
          curve: Interval(
            i * 0.2,
            0.6 + i * 0.2,
            curve: Curves.easeInOut,
          ),
        ),
      );

      _dotControllers.add(dotController);
      _dotAnimations.add(dotAnimation);
    }
  }

  void _setupAnimations() {
    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 1),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _slideController,
      curve: Curves.easeOutCubic,
    ));

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _fadeController,
      curve: Curves.easeIn,
    ));

    _scaleAnimation = Tween<double>(
      begin: 0.8,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _scaleController,
      curve: Curves.easeOutBack,
    ));
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

  void _toggleChatbot() {
    setState(() {
      _isChatbotVisible = !_isChatbotVisible;
    });

    if (_isChatbotVisible) {
      _slideController.forward();
      _fadeController.forward();
      _scaleController.forward();
      _startTypingAnimation();
    } else {
      _slideController.reverse();
      _fadeController.reverse();
      _scaleController.reverse();
      _stopTypingAnimation();
    }
  }

  void _startTypingAnimation() {
    for (var controller in _dotControllers) {
      controller.repeat();
    }
  }

  void _stopTypingAnimation() {
    for (var controller in _dotControllers) {
      controller.stop();
      controller.reset();
    }
  }

  void _handleSendMessage(String message) {
    if (message.trim().isEmpty) return;

    setState(() {
      _messages.add(ChatMessage(
        text: message,
        isUser: true,
        timestamp: DateTime.now(),
      ));
      _messageController.clear();
      _isTyping = true;
    });

    // Simulate bot typing
    Future.delayed(const Duration(seconds: 1), () {
      setState(() {
        _isTyping = false;
        _messages.add(ChatMessage(
          text: "Thank you for your message! I'll get back to you shortly.",
          isUser: false,
          timestamp: DateTime.now(),
        ));
      });
      _scrollToBottom();
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

  Widget _buildChatMessage(ChatMessage message) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
      child: Row(
        mainAxisAlignment:
            message.isUser ? MainAxisAlignment.end : MainAxisAlignment.start,
        children: [
          if (!message.isUser)
            const CircleAvatar(
              radius: 16,
              backgroundColor: Colors.blue,
              child: Icon(Icons.smart_toy, size: 16, color: Colors.white),
            ),
          const SizedBox(width: 8),
          Flexible(
            child: Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: message.isUser
                    ? Colors.blue.withOpacity(0.9)
                    : Colors.grey[800],
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                message.text,
                style: const TextStyle(color: Colors.white),
              ),
            ),
          ),
          const SizedBox(width: 8),
          if (message.isUser)
            const CircleAvatar(
              radius: 16,
              backgroundColor: Colors.blue,
              child: Icon(Icons.person, size: 16, color: Colors.white),
            ),
        ],
      ),
    );
  }

  Widget _buildTypingIndicator() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Row(
        children: [
          const CircleAvatar(
            radius: 16,
            backgroundColor: Colors.blue,
            child: Icon(Icons.smart_toy, size: 16, color: Colors.white),
          ),
          const SizedBox(width: 8),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.grey[800],
              borderRadius: BorderRadius.circular(20),
            ),
            child: Row(
              children: List.generate(
                  3,
                  (index) => Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 2),
                        child: ScaleTransition(
                          scale: _dotAnimations[index],
                          child: const CircleAvatar(
                            radius: 4,
                            backgroundColor: Colors.white,
                          ),
                        ),
                      )),
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
                      onPressed: _toggleChatbot,
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
          if (_isChatbotVisible)
            Positioned.fill(
              child: GestureDetector(
                onTap: _toggleChatbot,
                child: Container(
                  color: Colors.black.withOpacity(0.5),
                ),
              ),
            ),
          SlideTransition(
            position: _slideAnimation,
            child: Align(
              alignment: Alignment.bottomCenter,
              child: ScaleTransition(
                scale: _scaleAnimation,
                child: FadeTransition(
                  opacity: _fadeAnimation,
                  child: Container(
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
                                  Icons.smart_toy,
                                  color: Colors.blue,
                                ),
                              ),
                              const SizedBox(width: 12),
                              const Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "Chat Assistant",
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
                                  Icons.close,
                                  color: Colors.white,
                                ),
                                onPressed: _toggleChatbot,
                              ),
                            ],
                          ),
                        ),
                        Expanded(
                          child: ListView.builder(
                            controller: _scrollController,
                            padding: const EdgeInsets.only(top: 16),
                            itemCount: _messages.length,
                            itemBuilder: (context, index) {
                              return _buildChatMessage(_messages[index]);
                            },
                          ),
                        ),
                        if (_isTyping) _buildTypingIndicator(),
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
                                  controller: _messageController,
                                  style: const TextStyle(color: Colors.white),
                                  decoration: InputDecoration(
                                    hintText: "Type a message...",
                                    hintStyle:
                                        TextStyle(color: Colors.grey[400]),
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
                                  onSubmitted: _handleSendMessage,
                                ),
                              ),
                              const SizedBox(width: 8),
                              FloatingActionButton(
                                mini: true,
                                backgroundColor: Colors.blue,
                                child: const Icon(Icons.send),
                                onPressed: () => _handleSendMessage(
                                  _messageController.text,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
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

  @override
  void dispose() {
    _slideController.dispose();
    _fadeController.dispose();
    _scaleController.dispose();
    _messageController.dispose();
    _scrollController.dispose();
    _typingController.dispose();
    for (var controller in _dotControllers) {
      controller.dispose();
    }
    super.dispose();
  }
}
