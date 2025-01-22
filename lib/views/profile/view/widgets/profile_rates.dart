import 'package:flutter/material.dart';
import '../../animations/profile_animations.dart';

class ProfileRates extends StatelessWidget {
  final ProfileAnimations animations;

  const ProfileRates({Key? key, required this.animations}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: animations.fadeAnimation,
      child: SlideTransition(
        position: animations.slideAnimation,
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
}
