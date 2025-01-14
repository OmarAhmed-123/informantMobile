// ignore_for_file: unused_import

/*
//the old version not include the connection by state mangement


import 'package:flutter/material.dart';
import 'dart:convert'; // For Base64 encoding/decoding
import 'package:shared_preferences/shared_preferences.dart';
import 'package:graduation___part1/views/collectData.dart';
import 'package:graduation___part1/views/home_view.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  profilePageS createState() => profilePageS();
}

class profilePageS extends State<ProfilePage> {
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
            const Text(
              "linkedin Link : ",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              linkedin ?? "No.",
              textAlign: TextAlign.justify,
              style: const TextStyle(fontSize: 16, color: Colors.white),
            ),
            const SizedBox(height: 20),
            const Text(
              "Number of years of experience:",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              numOfEx.toString(),
              textAlign: TextAlign.justify,
              style: const TextStyle(fontSize: 16, color: Colors.white),
            ),
            const SizedBox(height: 20),
            const Text(
              "email : ",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              email.toString(),
              textAlign: TextAlign.justify,
              style: const TextStyle(fontSize: 16, color: Colors.white),
            ),
            const SizedBox(height: 20),
            const Text(
              "phone : ",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              phone.toString(),
              textAlign: TextAlign.justify,
              style: const TextStyle(fontSize: 16, color: Colors.white),
            ),
            const SizedBox(height: 20),
            const Text(
              "Profile Link",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              profile.toString(),
              textAlign: TextAlign.justify,
              style: const TextStyle(fontSize: 16, color: Colors.white),
            ),
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
      body: Container(
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
                Container(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.5),
                        blurRadius: 10,
                        offset: const Offset(0, 5),
                      ),
                    ],
                  ),
                  child: CircleAvatar(
                    radius: 60,
                    backgroundColor: Colors.grey[800],
                    backgroundImage: profileImage,
                  ),
                ),
                const SizedBox(height: 10),
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
                  onPressed: () {},
                  icon: const Icon(Icons.message),
                  label: const Text("Contact Me"),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blueGrey,
                  ),
                ),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Column(
                      children: [
                        IconButton(
                          icon: const Icon(Icons.person, color: Colors.white),
                          onPressed: () {
                            setState(() {
                              selectedTab = 0;
                            });
                          },
                        ),
                        const Text("Profile",
                            style: TextStyle(color: Colors.white)),
                      ],
                    ),
                    Column(
                      children: [
                        IconButton(
                          icon: const Icon(Icons.star, color: Colors.white),
                          onPressed: () {
                            setState(() {
                              selectedTab = 1;
                            });
                          },
                        ),
                        const Text("Rates",
                            style: TextStyle(color: Colors.white)),
                      ],
                    ),
                    Column(
                      children: [
                        IconButton(
                          icon: const Icon(Icons.work, color: Colors.white),
                          onPressed: () {
                            setState(() {
                              selectedTab = 2;
                            });
                          },
                        ),
                        const Text("My Works",
                            style: TextStyle(color: Colors.white)),
                      ],
                    ),
                  ],
                ),
                Divider(height: 40, thickness: 1, color: Colors.grey[600]),
                _buildContent(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
*/

//import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:graduation___part1/features/api/cubit/api_cubit.dart';
import 'package:graduation___part1/views/collectData.dart';
import 'package:graduation___part1/views/home_view.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  ProfilePageState createState() => ProfilePageState();
}

class ProfilePageState extends State<ProfilePage>
    with SingleTickerProviderStateMixin {
  // Profile data
  String? about, username, skills, linkedin, email, phone, profile;
  ImageProvider? profileImage;
  int selectedTab = 0;
  int? numOfEx;

  // Animation controllers
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();

    // Initialize animations
    _controller = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeIn),
    );

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.5),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut));

    // Load profile data
    _loadProfileData();
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _loadProfileData() async {
    final apiCubit = context.read<ApiCubit>();

    try {
      // Make API request to get profile data
      await apiCubit.makePostRequest('/api/profile', {});

      // Load cached data while waiting for API response
      await getProfileData();
    } catch (e) {
      debugPrint('Error loading profile: $e');
    }
  }

  Future<void> getProfileData() async {
    final prefs = await SharedPreferences.getInstance();

    setState(() {
      about = prefs.getString('about');
      skills = prefs.getString('skills');
      username = prefs.getString('username');
      email = prefs.getString('email');
      linkedin = prefs.getString('linkedin');
      profile = prefs.getString('profile_link');
      phone = prefs.getString('phone');
      numOfEx = prefs.getInt('experience_years');

      final base64Image = prefs.getString('profile_image');
      if (base64Image != null) {
        final bytes = base64Decode(base64Image);
        profileImage = MemoryImage(bytes);
      } else {
        profileImage = const AssetImage('assets/default_avatar.png');
      }
    });
  }

  Widget _buildProfileContent() {
    return BlocBuilder<ApiCubit, ApiState>(
      builder: (context, state) {
        return state.when(
          unverified: () =>
              const Center(child: CircularProgressIndicator.adaptive()),
          initial: () => const Center(child: Text('Loading...')),
          loading: () => const Center(child: CircularProgressIndicator()),
          success: (data) => _buildProfileDetails(),
          error: (error) => Center(
            child: Text('Error: ${error.message}',
                style: const TextStyle(color: Colors.red)),
          ),
        );
      },
    );
  }

  Widget _buildProfileDetails() {
    return FadeTransition(
      opacity: _fadeAnimation,
      child: SlideTransition(
        position: _slideAnimation,
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Colors.blue.withOpacity(0.1),
                Colors.purple.withOpacity(0.1),
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(16),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildInfoSection("About Me", about),
              _buildInfoSection("My Skills", skills),
              _buildInfoSection("LinkedIn", linkedin),
              _buildInfoSection("Experience", "${numOfEx ?? 0} years"),
              _buildInfoSection("Email", email),
              _buildInfoSection("Phone", phone),
              _buildInfoSection("Profile Link", profile),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInfoSection(String title, String? content) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Column(
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
          const SizedBox(height: 8),
          Text(
            content ?? "Not provided",
            style: const TextStyle(
              fontSize: 16,
              color: Colors.white70,
            ),
          ),
          const Divider(color: Colors.white24),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.home),
          onPressed: () => Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (_) => const HomeView()),
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const collectData()),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Profile Header
            Hero(
              tag: 'profile_image',
              child: Container(
                padding: const EdgeInsets.all(16),
                child: CircleAvatar(
                  radius: 60,
                  backgroundImage: profileImage,
                  backgroundColor: Colors.grey[800],
                ),
              ),
            ),

            // Username
            Text(
              username ?? "Username",
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),

            const SizedBox(height: 20),

            // Contact Button
            ElevatedButton.icon(
              onPressed: () {},
              icon: const Icon(Icons.message),
              label: const Text("Contact Me"),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 12,
                ),
              ),
            ),

            const SizedBox(height: 20),

            // Profile Content
            _buildProfileContent(),
          ],
        ),
      ),
    );
  }
}
