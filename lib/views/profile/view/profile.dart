/*
// Note: ApiCubit integration removed. This version uses only SharedPreferences for data persistence.
// To add API integration later, you can implement an API service and state management solution.

import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:graduation___part1/views/collectData.dart';
import 'package:graduation___part1/views/home/view/home_view.dart';

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
  bool isLoading = true;

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
    loadProfileData();
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> loadProfileData() async {
    setState(() => isLoading = true);

    try {
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

        isLoading = false;
      });
    } catch (e) {
      debugPrint('Error loading profile: $e');
      setState(() => isLoading = false);
    }
  }

  Widget _buildContent() {
    if (isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    switch (selectedTab) {
      case 0:
        return _buildProfileDetails();
      case 1:
        return _buildRatesSection();
      case 2:
        return _buildWorksSection();
      default:
        return Container();
    }
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

  Widget _buildRatesSection() {
    return FadeTransition(
      opacity: _fadeAnimation,
      child: SlideTransition(
        position: _slideAnimation,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: const [
            Text(
              "Rates",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            SizedBox(height: 10),
            Text(
              "⭐️⭐️⭐️⭐️⭐️ - Excellent, very professional and punctual.",
              style: TextStyle(fontSize: 16, color: Colors.white),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildWorksSection() {
    return FadeTransition(
      opacity: _fadeAnimation,
      child: SlideTransition(
        position: _slideAnimation,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: const [
            Text(
              "My Works",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            SizedBox(height: 10),
            Text(
              "You can add photos or samples of your previous work here.",
              style: TextStyle(fontSize: 16, color: Colors.white),
            ),
          ],
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

              // Navigation Tabs
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _buildTabButton(0, Icons.person, "Profile"),
                  _buildTabButton(1, Icons.star, "Rates"),
                  _buildTabButton(2, Icons.work, "My Works"),
                ],
              ),

              Divider(height: 40, thickness: 1, color: Colors.grey[600]),

              // Content based on selected tab
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: _buildContent(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTabButton(int index, IconData icon, String label) {
    return Column(
      children: [
        IconButton(
          icon: Icon(icon, color: Colors.white),
          onPressed: () {
            setState(() {
              selectedTab = index;
            });
          },
        ),
        Text(
          label,
          style: const TextStyle(color: Colors.white),
        ),
      ],
    );
  }
}
*/
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../animations/profile_animations.dart';
import '../view_model/profile_view_model.dart';
import 'widgets/profile_header.dart';
import 'widgets/profile_tabs.dart';
import 'widgets/profile_details.dart';
import 'widgets/profile_rates.dart';
import 'widgets/profile_works.dart';
import '../collect_data/view/collectData.dart';
import '../../home/view/home_view.dart';

class ProfileView extends StatefulWidget {
  const ProfileView({Key? key}) : super(key: key);

  @override
  ProfileViewState createState() => ProfileViewState();
}

class ProfileViewState extends State<ProfileView>
    with TickerProviderStateMixin {
  late final ProfileAnimations _animations;

  @override
  void initState() {
    super.initState();
    _animations = ProfileAnimations(vsync: this);
    _animations.forward();
  }

  @override
  void dispose() {
    _animations.dispose();
    super.dispose();
  }

  Widget _buildContent(ProfileViewModel viewModel) {
    if (viewModel.isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    switch (viewModel.selectedTab) {
      case 0:
        return ProfileDetails(viewModel: viewModel, animations: _animations);
      case 1:
        return ProfileRates(animations: _animations);
      case 2:
        return ProfileWorks(animations: _animations);
      default:
        return Container();
    }
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => ProfileViewModel()..loadProfileData(),
      child: Consumer<ProfileViewModel>(
        builder: (context, viewModel, _) {
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
                    MaterialPageRoute(builder: (_) => const CollectDataView()),
                  ),
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
                child: Column(
                  children: [
                    ProfileHeader(viewModel: viewModel),
                    const SizedBox(height: 20),
                    ProfileTabs(viewModel: viewModel),
                    Divider(height: 40, thickness: 1, color: Colors.grey[600]),
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: _buildContent(viewModel),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
