import 'package:flutter/material.dart';

class ResendButton extends StatelessWidget {
  final Animation<double> animation;
  final VoidCallback onPressed;

  const ResendButton({
    Key? key,
    required this.animation,
    required this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: animation,
      child: TextButton(
        onPressed: onPressed,
        style: TextButton.styleFrom(
          foregroundColor: Colors.white70,
          padding: const EdgeInsets.symmetric(
            horizontal: 30,
            vertical: 10,
          ),
        ),
        child: const Text(
          'Resend OTP',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }
}
