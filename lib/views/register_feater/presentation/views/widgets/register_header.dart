import 'package:flutter/material.dart';
import 'package:graduation___part1/views/login_feature/animations/fade_scale_animation.dart';


class RegisterHeader extends StatelessWidget {
  const RegisterHeader({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        FadeScaleAnimation(
          child: Image.asset(
            'assets/login1.png',
            width: 120,
            height: 120,
          ),
        ),
        const SizedBox(height: 24),
        FadeScaleAnimation(
          child: const Text(
            'Create Account',
            style: TextStyle(
              fontSize: 32,
              fontWeight: FontWeight.bold,
              color: Colors.white,
              shadows: [
                Shadow(
                  color: Colors.black26,
                  offset: Offset(0, 3),
                  blurRadius: 5,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
