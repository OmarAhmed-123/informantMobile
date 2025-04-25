import 'package:graduation___part1/views/ad_list_view.dart';

import 'package:graduation___part1/views/editProfile.dart';

import 'package:graduation___part1/views/home_view.dart';

import 'package:graduation___part1/views/settings.dart';

import 'package:graduation___part1/views/profile.dart';

import 'package:flutter/material.dart';

import 'package:graduation___part1/views/create_ad_view.dart';

import 'package:graduation___part1/views/auth_cubit.dart';

import 'package:graduation___part1/views/chat_cubit.dart';

import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:shared_preferences/shared_preferences.dart';

class StartPage extends StatefulWidget {
  const StartPage({super.key});

  @override
  _StartPageState createState() => _StartPageState();
}

class _StartPageState extends State<StartPage> {
  int _currentIndex = 2;

  late Profile myProfile;

  final List<Widget> _pages = [
    AdListView(),
    HomeView(),
    CreateAdView(),
  ];

  bool _isProfileLoaded = false;

  late ChatCubit _chatCubit;

  @override
  void initState() {
    super.initState();

    myProfile = Profile(
      name: "Loading...",
      imageUrl: "https://via.placeholder.com/150",
      about: "Loading...",
      linkedin: "",
      id: -1,
      email: "",
      phone: "",
    );

    _loadProfileData();
  }

  Future<void> _loadProfileData() async {
    try {
      final authCubit = BlocProvider.of<AuthCubit>(context);

      await authCubit.getProfileById("my");

      final prefs = await SharedPreferences.getInstance();

      await prefs.setInt('appear', 0);

      _chatCubit = ChatCubit(myProfile);

      _chatCubit.connectToSignalR();

      setState(() {
        myProfile = profile;

        _isProfileLoaded = true;
      });
    } catch (e) {
      print('Error loading profile: $e');
    }
  }

  void _navigateToProfile() {
    if (_isProfileLoaded) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => ProfilePage(profile: myProfile, flag: false),
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Loading profile data, please wait...')),
      );

      _loadProfileData().then((_) {
        if (_isProfileLoaded) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => ProfilePage(profile: myProfile, flag: false),
            ),
          );
        }
      });
    }
  }

  Future<bool?> _showExitConfirmationDialog() {
    return showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (context) => Dialog(
        elevation: 0,
        backgroundColor: Colors.transparent,
        child: Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surface,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Exit Application',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
              ),
              const SizedBox(height: 16),
              Text(
                'Are you sure you want to exit the application?',
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              const SizedBox(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  OutlinedButton(
                    onPressed: () => Navigator.of(context).pop(false),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: Theme.of(context).colorScheme.primary,
                      side: BorderSide(
                          color: Theme.of(context).colorScheme.primary),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 12),
                    ),
                    child: const Text('Cancel'),
                  ),
                  const SizedBox(width: 12),
                  ElevatedButton(
                    onPressed: () => Navigator.of(context).pop(true),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 12),
                    ),
                    child: const Text('Exit'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        return await _showExitConfirmationDialog() ?? false;
      },
      child: Scaffold(
        appBar: AppBar(
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Container(
                    width: 45,
                    height: 45,
                    decoration: BoxDecoration(
                      image: const DecorationImage(
                        image: AssetImage('assets/informant.jpeg'),
                        fit: BoxFit.cover,
                      ),
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.2),
                          spreadRadius: 2,
                          blurRadius: 5,
                          offset: const Offset(0, 3),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(
                      width: 8), // Add some spacing between the image and text

                  Text(
                    'Informant',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
              Row(
                children: [
                  IconButton(
                    icon: Icon(Icons.add, color: Colors.white),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => const CreateAdView()),
                      );
                    },
                  ),
                  IconButton(
                    icon: Icon(Icons.search, color: Colors.white),
                    onPressed: () {},
                  ),
                ],
              ),
            ],
          ),
          backgroundColor: Color(0xff093050),
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
          child: _getPage(),
        ),
        bottomNavigationBar: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Colors.blue.shade900,
                Colors.black,
              ],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black26,
                blurRadius: 8.0,
                spreadRadius: 0.0,
                offset: Offset(0.0, -2.0),
              ),
            ],
          ),
          child: BottomNavigationBar(
            currentIndex: _currentIndex,
            onTap: (index) {
              if (index == 1) {
                _navigateToProfile();
              } else if (index == 4) {
                final bool flag = true;

                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => SettingsPage(flag: flag),
                  ),
                );
              } else if (index == 3) {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => CreateAdView(),
                  ),
                );
              } else {
                setState(() {
                  _currentIndex = index;
                });
              }
            },
            type: BottomNavigationBarType.fixed,
            backgroundColor: Colors.transparent,
            selectedItemColor: Colors.white,
            unselectedItemColor: Colors.grey[400],
            showSelectedLabels: true,
            showUnselectedLabels: true,
            selectedLabelStyle: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 14,
            ),
            unselectedLabelStyle: TextStyle(
              fontSize: 12,
            ),
            items: [
              BottomNavigationBarItem(
                icon: Icon(Icons.ads_click_outlined, size: 30),
                activeIcon: Icon(Icons.ads_click, size: 30),
                label: 'Ads',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.person_outline, size: 30),
                activeIcon: Icon(Icons.person, size: 30),
                label: 'Profile',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.home_outlined, size: 30),
                activeIcon: Icon(Icons.home, size: 30),
                label: 'Home',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.add_outlined, size: 30),
                activeIcon: Icon(Icons.add, size: 30),
                label: 'Create Ad',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.menu, size: 30),
                activeIcon: Icon(Icons.menu, size: 30),
                label: 'Settings',
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _getPage() {
    if (_currentIndex == 0) {
      return _pages[0];
    } else if (_currentIndex == 2) {
      return _pages[1];
    } else if (_currentIndex == 3) {
      return _pages[2];
    }

    return _pages[1];
  }
}
