import 'package:flutter/material.dart';
import 'package:graduation___part1/views/login_feature/presentation/views/autoLogin.dart';
import 'package:graduation___part1/views/login_feature/presentation/views/login_view.dart';

class HomeViewModel extends ChangeNotifier {
  Future<void> logout(BuildContext context) async {
    // Show loading indicator
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return const Center(child: CircularProgressIndicator());
      },
    );

    // Perform logout
    await Future.delayed(const Duration(milliseconds: 800));
    await AutoLogin.logout3();

    if (!context.mounted) return;
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
  }
}
