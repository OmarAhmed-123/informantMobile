//bar of home
/*
//not include the animation

// ignore_for_file: file_names, unused_local_variable, library_prefixes

import 'package:flutter/material.dart';
import 'package:graduation___part1/views/home_view.dart';
import 'package:provider/provider.dart';
import '../view_models/auth_view_model.dart';
import 'package:graduation___part1/views/ad_list_view.dart' as adView;
import 'package:graduation___part1/views/create_ad_view.dart';
import 'package:graduation___part1/views/Statistics.dart';
import 'package:graduation___part1/views/autoProfile.dart';
import 'package:graduation___part1/views/profile.dart';
import 'package:graduation___part1/views/autoLogin.dart';
import 'package:graduation___part1/views/login_view.dart';

class HomeView1 extends StatelessWidget {
  const HomeView1({super.key});

  @override
  Widget build(BuildContext context) {
    final authViewModel = Provider.of<AuthViewModel>(context);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        leading: IconButton(
          icon: const Icon(Icons.person, color: Colors.white),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const ProfilePage()),
            );
          },
        ),
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.close, color: Colors.white),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const HomeView()),
              );
            },
          ),
        ],
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Colors.black,
              Colors.blue.shade900.withOpacity(0.6),
              Colors.black,
            ],
          ),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              buildActionCard(
                context,
                'Get Ads',
                'Choose an item for your ad',
                Icons.list,
                () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (_) => const adView.AdListView()),
                  );
                },
              ),
              const SizedBox(height: 20),
              buildActionCard(
                context,
                'Create Ad',
                'Create your own ad',
                Icons.add_circle,
                () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const CreateAdView()),
                  );
                },
              ),
              const SizedBox(height: 20),
              buildActionCard(
                context,
                'My Profile',
                '',
                Icons.person,
                () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const AutoProfile()),
                  );
                },
              ),
              const SizedBox(height: 20),
              buildActionCard(
                context,
                'Statistics',
                'View your ad performance',
                Icons.attach_money,
                () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const ProfitView()),
                  );
                },
              ),
              const SizedBox(height: 20),
              buildActionCard(
                context,
                'Log Out',
                '',
                Icons.logout,
                () {
                  logOut1(context);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  void logOut1(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Confirm Logout'),
          content: Text('Are you sure you want to log out?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
                logOut2(context); // Perform logout
              },
              child: Text('Yes'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
              child: Text('Cancel'),
            ),
          ],
        );
      },
    );
  }

  void logOut2(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('You have been logged out.')),
    );
    AutoLogin.logout3();
    Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => const LoginView(),
        ));
  }

  Widget buildActionCard(BuildContext context, String title, String subtitle,
      IconData icon, VoidCallback onTap) {
    return Card(
      elevation: 4,
      margin: const EdgeInsets.symmetric(horizontal: 20),
      child: ListTile(
        leading: Icon(icon, color: Colors.blue),
        title: Text(title),
        subtitle: Text(subtitle),
        trailing: const Icon(Icons.arrow_forward_ios),
        onTap: onTap,
      ),
    );
  }
}
*/
// ignore_for_file: file_names
import 'package:flutter/material.dart';
import 'package:graduation___part1/views/home_view.dart';
import 'package:provider/provider.dart';
import '../view_models/auth_view_model.dart';
import 'package:graduation___part1/views/ad_list_view.dart' as adView;
import 'package:graduation___part1/views/create_ad_view.dart';
import 'package:graduation___part1/views/Statistics.dart';
import 'package:graduation___part1/views/autoProfile.dart';
import 'package:graduation___part1/views/profile.dart';
import 'package:graduation___part1/views/autoLogin.dart';
import 'package:graduation___part1/views/login_view.dart';

class HomeView1 extends StatefulWidget {
  const HomeView1({super.key});

  @override
  State<HomeView1> createState() => _HomeView1State();
}

class _HomeView1State extends State<HomeView1> with TickerProviderStateMixin {
  // Animation controllers
  late AnimationController _fadeController;
  late AnimationController _slideController;
  late List<AnimationController> _cardControllers;

  // Animations
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;
  late List<Animation<double>> _scaleAnimations;

  @override
  void initState() {
    super.initState();

    // Initialize fade animation
    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );
    _fadeAnimation = CurvedAnimation(
      parent: _fadeController,
      curve: Curves.easeIn,
    );

    // Initialize slide animation
    _slideController = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );
    _slideAnimation = Tween<Offset>(
      begin: const Offset(-1.0, 0.0),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _slideController,
      curve: Curves.easeOutCubic,
    ));

    // Initialize card animations
    _cardControllers = List.generate(
      5,
      (index) => AnimationController(
        duration: Duration(milliseconds: 600 + (index * 100)),
        vsync: this,
      ),
    );

    _scaleAnimations = _cardControllers.map((controller) {
      return Tween<double>(begin: 0.0, end: 1.0).animate(
        CurvedAnimation(parent: controller, curve: Curves.easeOutBack),
      );
    }).toList();

    // Start animations
    _fadeController.forward();
    _slideController.forward();
    for (var controller in _cardControllers) {
      controller.forward();
    }
  }

  @override
  void dispose() {
    _fadeController.dispose();
    _slideController.dispose();
    for (var controller in _cardControllers) {
      controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final authViewModel = Provider.of<AuthViewModel>(context);

    return Scaffold(
      // Animated AppBar with custom design
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(60.0),
        child: SlideTransition(
          position: _slideAnimation,
          child: AppBar(
            elevation: 0,
            flexibleSpace: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    Colors.black,
                    Colors.blue.shade900,
                  ],
                ),
              ),
            ),
            leading: Hero(
              tag: 'profile_icon',
              child: Material(
                color: Colors.transparent,
                child: IconButton(
                  icon: const Icon(Icons.person, color: Colors.white),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const ProfilePage()),
                    );
                  },
                ),
              ),
            ),
            actions: <Widget>[
              IconButton(
                icon: const Icon(Icons.close, color: Colors.white),
                onPressed: () {
                  // Animate out before navigation
                  _fadeController.reverse().then((_) {
                    Navigator.push(
                      context,
                      PageRouteBuilder(
                        pageBuilder: (context, animation, secondaryAnimation) =>
                            const HomeView(),
                        transitionsBuilder:
                            (context, animation, secondaryAnimation, child) {
                          return FadeTransition(
                            opacity: animation,
                            child: child,
                          );
                        },
                      ),
                    );
                  });
                },
              ),
            ],
          ),
        ),
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Colors.black,
              Colors.blue.shade900.withOpacity(0.8),
              Colors.black,
            ],
          ),
        ),
        child: FadeTransition(
          opacity: _fadeAnimation,
          child: Center(
            child: ListView(
              padding: const EdgeInsets.symmetric(vertical: 20),
              children: [
                // Animated action cards
                _buildAnimatedCard(
                    0, 'Get Ads', 'Choose an item for your ad', Icons.list, () {
                  _navigateWithAnimation(context, const adView.AdListView());
                }),
                _buildAnimatedCard(
                    1, 'Create Ad', 'Create your own ad', Icons.add_circle, () {
                  _navigateWithAnimation(context, const CreateAdView());
                }),
                _buildAnimatedCard(2, 'My Profile', '', Icons.person, () {
                  _navigateWithAnimation(context, const AutoProfile());
                }),
                _buildAnimatedCard(3, 'Statistics', 'View your ad performance',
                    Icons.attach_money, () {
                  _navigateWithAnimation(context, const ProfitView());
                }),
                _buildAnimatedCard(4, 'Log Out', '', Icons.logout, () {
                  logOut1(context);
                }),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // Animated card builder with scale animation
  Widget _buildAnimatedCard(int index, String title, String subtitle,
      IconData icon, VoidCallback onTap) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: ScaleTransition(
        scale: _scaleAnimations[index],
        child: Card(
          elevation: 8,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15),
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Colors.white,
                  Colors.blue.shade50,
                ],
              ),
            ),
            child: ListTile(
              contentPadding:
                  const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              leading: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.blue.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(icon, color: Colors.blue.shade700, size: 30),
              ),
              title: Text(
                title,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              subtitle: subtitle.isNotEmpty
                  ? Text(
                      subtitle,
                      style: TextStyle(color: Colors.grey.shade600),
                    )
                  : null,
              trailing: Icon(Icons.arrow_forward_ios,
                  color: Colors.blue.shade300, size: 20),
              onTap: () {
                // Add tap animation
                _cardControllers[index].reverse().then((_) {
                  _cardControllers[index].forward();
                  onTap();
                });
              },
            ),
          ),
        ),
      ),
    );
  }

  // Animated navigation helper
  void _navigateWithAnimation(BuildContext context, Widget destination) {
    Navigator.push(
      context,
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) => destination,
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          return FadeTransition(
            opacity: animation,
            child: SlideTransition(
              position: Tween<Offset>(
                begin: const Offset(1.0, 0.0),
                end: Offset.zero,
              ).animate(animation),
              child: child,
            ),
          );
        },
        transitionDuration: const Duration(milliseconds: 500),
      ),
    );
  }

  // Enhanced logout dialog
  void logOut1(BuildContext context) {
    showGeneralDialog(
      context: context,
      barrierDismissible: true,
      barrierLabel: '',
      transitionDuration: const Duration(milliseconds: 300),
      pageBuilder: (context, animation, secondaryAnimation) {
        return ScaleTransition(
          scale: Tween<double>(begin: 0.5, end: 1.0).animate(
            CurvedAnimation(parent: animation, curve: Curves.easeOutBack),
          ),
          child: AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            title: const Text(
              'Confirm Logout',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            content: const Text('Are you sure you want to log out?'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  logOut2(context);
                },
                child: const Text('Yes'),
              ),
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text('Cancel'),
              ),
            ],
          ),
        );
      },
    );
  }

  // Enhanced logout implementation
  void logOut2(BuildContext context) {
    // Show loading indicator
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return const Center(
          child: CircularProgressIndicator(),
        );
      },
    );

    // Perform logout
    Future.delayed(const Duration(milliseconds: 800), () {
      AutoLogin.logout3();
      Navigator.of(context).pop(); // Remove loading indicator

      // Show success message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('You have been logged out successfully'),
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          backgroundColor: Colors.green,
        ),
      );

      // Navigate to login
      Navigator.pushReplacement(
        context,
        PageRouteBuilder(
          pageBuilder: (context, animation, secondaryAnimation) =>
              const LoginView(),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            return FadeTransition(
              opacity: animation,
              child: SlideTransition(
                position: Tween<Offset>(
                  begin: const Offset(0.0, 1.0),
                  end: Offset.zero,
                ).animate(animation),
                child: child,
              ),
            );
          },
          transitionDuration: const Duration(milliseconds: 500),
        ),
      );
    });
  }
}
