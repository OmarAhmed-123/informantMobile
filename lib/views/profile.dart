import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:graduation___part1/views/chat_cubit.dart';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:graduation___part1/views/collectData.dart';
import 'package:graduation___part1/views/home_view.dart';
import 'chat_service.dart';
import 'package:url_launcher/url_launcher.dart';
import 'chat_window.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  ProfilePageState createState() => ProfilePageState();
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

  // Define currentUser and handleLogout
  final ChatUser currentUser = ChatUser(
    userId: 'currentUserId', // Replace with actual user ID
    username: 'Current User', // Replace with actual username
    profileImage: null,
    isOnline: true,
  );

  void handleLogout() {
    // Implement logout logic here
    print('User logged out');
  }

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
                child: ChatApp(
                  username: currentUser.username,
                  userId: currentUser.userId,
                  onLogout: handleLogout,
                ),
              ),
            ),
        ],
      ),
    );
  }

  Future<void> _makePhoneCall(String phoneNumber) async {
    final Uri launchUri = Uri(
      scheme: 'tel',
      path: phoneNumber,
    );
    await launchUrl(launchUri);
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
