import 'package:flutter/material.dart';
import 'package:graduation___part1/views/SHconnection/view_model/connection.dart';

class ConnectionViewModel extends ChangeNotifier {
  final AnimationController animationController;

  ConnectionViewModel({required this.animationController});

  void retryConnection(BuildContext context) {
    animationController.reverse().then((_) {
      Navigator.pushReplacement(
        context,
        PageRouteBuilder(
          pageBuilder: (context, animation, secondaryAnimation) =>
              const Connection(),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            return FadeTransition(opacity: animation, child: child);
          },
          transitionDuration: const Duration(milliseconds: 500),
        ),
      );
    });
  }

  @override
  void dispose() {
    animationController.dispose();
    super.dispose();
  }
}
