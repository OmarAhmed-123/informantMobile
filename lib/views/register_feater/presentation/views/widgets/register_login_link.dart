import 'package:flutter/material.dart';

class RegisterLoginLink extends StatelessWidget {
  const RegisterLoginLink({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: () => Navigator.pushReplacementNamed(context, '/login'),
      child: const Text(
        'Already have an account? Sign In',
        style: TextStyle(
          color: Colors.white,
          fontSize: 16,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }
}
