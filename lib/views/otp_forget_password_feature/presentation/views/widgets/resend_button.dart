import 'package:flutter/material.dart';

class ResendButton extends StatelessWidget {
  final VoidCallback onPressed;

  const ResendButton({
    Key? key,
    required this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextButton(
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
    );
  }
}
