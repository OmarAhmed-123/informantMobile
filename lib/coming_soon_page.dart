import 'package:flutter/material.dart';

// number 11 in pdf

class ComingSoonPage extends StatelessWidget {
  const ComingSoonPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          const Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'coming soon',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 10),
                Text(
                  'track your own ads and know how you collect money',
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
          Positioned(
            top: 40,
            left: 10,
            child: IconButton(
              icon: const Icon(Icons.home, color: Colors.white),
              onPressed: () {
                // Home button functionality here
              },
            ),
          ),
          Positioned(
            top: 40,
            right: 60,
            child: IconButton(
              icon: const Icon(Icons.vpn_key, color: Colors.redAccent),
              onPressed: () {
                // Key icon functionality here
              },
            ),
          ),
          Positioned(
            top: 40,
            right: 10,
            child: IconButton(
              icon: const Icon(Icons.person, color: Colors.white),
              onPressed: () {
                // Profile icon functionality here
              },
            ),
          ),
        ],
      ),
    );
  }
}
