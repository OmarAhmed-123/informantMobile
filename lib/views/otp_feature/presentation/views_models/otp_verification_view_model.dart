import 'package:flutter/material.dart';

class OtpVerificationViewModel extends ChangeNotifier {
  final formKey = GlobalKey<FormState>();
  final List<TextEditingController> otpControllers = List.generate(
    9,
    (_) => TextEditingController(),
  );

  late AnimationController animationController;
  late Animation<double> fadeAnimation;
  late Animation<double> slideAnimation;
  final List<Animation<double>> digitAnimations = [];

  void initializeAnimations(TickerProvider vsync) {
    animationController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: vsync,
    );

    fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: animationController,
        curve: const Interval(0.0, 0.5, curve: Curves.easeIn),
      ),
    );

    slideAnimation = Tween<double>(begin: 50.0, end: 0.0).animate(
      CurvedAnimation(
        parent: animationController,
        curve: const Interval(0.3, 0.8, curve: Curves.easeOut),
      ),
    );

    for (int i = 0; i < 9; i++) {
      digitAnimations.add(
        Tween<double>(begin: 0.0, end: 1.0).animate(
          CurvedAnimation(
            parent: animationController,
            curve: Interval(
              0.1 * i,
              0.1 * i + 0.6,
              curve: Curves.elasticOut,
            ),
          ),
        ),
      );
    }

    animationController.forward();
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
    animationController.dispose();
    for (var controller in otpControllers) {
      controller.dispose();
    }
  }
  */
}
