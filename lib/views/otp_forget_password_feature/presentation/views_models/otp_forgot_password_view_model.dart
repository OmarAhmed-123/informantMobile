import 'package:flutter/material.dart';

class OtpForgotPasswordViewModel extends ChangeNotifier {
  final formKey = GlobalKey<FormState>();
  final List<TextEditingController> otpControllers = List.generate(
    9,
    (_) => TextEditingController(),
  );

  late AnimationController fadeController;
  late Animation<double> fadeAnimation;
  final List<Animation<double>> scaleAnimations = [];

  void initializeAnimations(TickerProvider vsync) {
    fadeController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: vsync,
    );

    fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: fadeController, curve: Curves.easeIn),
    );

    for (int i = 0; i < 9; i++) {
      scaleAnimations.add(
        Tween<double>(begin: 0.0, end: 1.0).animate(
          CurvedAnimation(
            parent: fadeController,
            curve: Interval(0.1 * i, 0.1 * i + 0.5, curve: Curves.elasticOut),
          ),
        ),
      );
    }

    fadeController.forward();
  }

  String getOtpValue() {
    return otpControllers.map((controller) => controller.text).join();
  }

  String? validateOtpDigit(String? value) {
    if (value == null || value.isEmpty) {
      return '';
    }
    return null;
  }
/*
  void dispose() {
    fadeController.dispose();
    for (var controller in otpControllers) {
      controller.dispose();
    }
  }
  */
}
