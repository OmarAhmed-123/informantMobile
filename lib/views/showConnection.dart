/*
import 'package:flutter/material.dart';
import 'package:graduation___part1/views/connection.dart';

class ShowConnection extends StatefulWidget {
  const ShowConnection({Key? key}) : super(key: key);

  @override
  ShowConnectionS createState() => ShowConnectionS();
}

class ShowConnectionS extends State<ShowConnection> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const SizedBox(height: 80),
          Center(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: 60,
                  height: 60,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage('assets/graduation___part1.jpeg'),
                      fit: BoxFit.cover,
                    ),
                    shape: BoxShape.circle,
                  ),
                ),
                const SizedBox(width: 10),
                const Text(
                  'Graduation___part1',
                  style: TextStyle(
                    color: Colors.blueAccent,
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 40),
          const Spacer(),
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CircleAvatar(
                  radius: 122,
                  backgroundColor: Colors.white,
                  child: CircleAvatar(
                    radius: 120,
                    backgroundImage: AssetImage('assets/internet.jpeg'),
                  ),
                ),
                const SizedBox(height: 20),
                // Title
                const Text(
                  'No Internet Connection',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.red,
                  ),
                ),
                const SizedBox(height: 10),
                const Text(
                  'Try:\n•Turning off airplane mode\n•Turning on mobile data or Wi-Fi\n•Checking the signal in your area.\n',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.black54,
                  ),
                ),
                const SizedBox(height: 20),
              ],
            ),
          ),
          const Spacer(),
          Padding(
            padding: const EdgeInsets.only(bottom: 55),
            child: ElevatedButton(
              onPressed: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const Connection(),
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
                padding:
                    const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: const Text(
                'Try Again',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
*/

import 'package:flutter/material.dart';
import 'package:graduation___part1/views/connection.dart';

class ShowConnection extends StatefulWidget {
  const ShowConnection({super.key});

  @override
  ShowConnectionState createState() => ShowConnectionState();
}

class ShowConnectionState extends State<ShowConnection>
    with SingleTickerProviderStateMixin {
  // Animation controller for managing all animations
  late AnimationController _controller;

  // Individual animations for different elements
  late Animation<double> _fadeInAnimation;
  late Animation<double> _scaleAnimation;
  late Animation<Offset> _slideAnimation;
  late Animation<double> _rotateAnimation;

  @override
  void initState() {
    super.initState();

    // Initialize animation controller
    _controller = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    );

    // Fade in animation for text elements
    _fadeInAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: const Interval(0.0, 0.5, curve: Curves.easeIn),
    ));

    // Scale animation for the image
    _scaleAnimation = Tween<double>(
      begin: 0.5,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: const Interval(0.3, 0.8, curve: Curves.elasticOut),
    ));

    // Slide animation for the button
    _slideAnimation = Tween<Offset>(
      begin: const Offset(0.0, 1.0),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: const Interval(0.6, 1.0, curve: Curves.easeOut),
    ));

    // Rotation animation for the internet icon
    _rotateAnimation = Tween<double>(
      begin: 0.0,
      end: 2 * 3.14159,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: const Interval(0.4, 0.9, curve: Curves.easeInOut),
    ));

    // Start the animation
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFFF5F5F5), Colors.white],
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 80),

            // App Logo and Title
            FadeTransition(
              opacity: _fadeInAnimation,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: 60,
                    height: 60,
                    decoration: BoxDecoration(
                      image: const DecorationImage(
                        image: AssetImage('assets/graduation___part1.jpeg'),
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
                  const SizedBox(width: 15),
                  const Text(
                    'Graduation___part1',
                    style: TextStyle(
                      color: Colors.blueAccent,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1.2,
                    ),
                  ),
                ],
              ),
            ),

            const Spacer(),

            // Main Content
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Animated Internet Icon
                  ScaleTransition(
                    scale: _scaleAnimation,
                    child: RotationTransition(
                      turns: _rotateAnimation,
                      child: Container(
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.blue.withOpacity(0.3),
                              spreadRadius: 5,
                              blurRadius: 15,
                            ),
                          ],
                        ),
                        child: const CircleAvatar(
                          radius: 122,
                          backgroundColor: Colors.white,
                          child: CircleAvatar(
                            radius: 120,
                            backgroundImage: AssetImage('assets/internet.jpeg'),
                            backgroundColor: Colors.transparent,
                          ),
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 30),

                  // Error Message
                  FadeTransition(
                    opacity: _fadeInAnimation,
                    child: const Text(
                      'No Internet Connection',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.red,
                        letterSpacing: 0.5,
                      ),
                    ),
                  ),

                  const SizedBox(height: 20),

                  // Troubleshooting Steps
                  FadeTransition(
                    opacity: _fadeInAnimation,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 15,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(15),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.1),
                            spreadRadius: 2,
                            blurRadius: 8,
                            offset: const Offset(0, 3),
                          ),
                        ],
                      ),
                      child: const Text(
                        'Try:\n'
                        '• Turning off airplane mode\n'
                        '• Turning on mobile data or Wi-Fi\n'
                        '• Checking the signal in your area',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.black54,
                          height: 1.5,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const Spacer(),

            // Try Again Button
            Padding(
              padding: const EdgeInsets.only(bottom: 55),
              child: SlideTransition(
                position: _slideAnimation,
                child: ElevatedButton(
                  onPressed: () {
                    // Add button press animation
                    _controller.reverse().then((_) {
                      Navigator.pushReplacement(
                        context,
                        PageRouteBuilder(
                          pageBuilder:
                              (context, animation, secondaryAnimation) =>
                                  const Connection(),
                          transitionsBuilder:
                              (context, animation, secondaryAnimation, child) {
                            return FadeTransition(
                              opacity: animation,
                              child: child,
                            );
                          },
                          transitionDuration: const Duration(milliseconds: 500),
                        ),
                      );
                    });
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 50,
                      vertical: 15,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                    elevation: 5,
                    shadowColor: Colors.blue.withOpacity(0.5),
                  ),
                  child: const Text(
                    'Try Again',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      letterSpacing: 1.0,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
