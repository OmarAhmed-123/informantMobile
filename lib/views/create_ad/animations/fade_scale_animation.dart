import 'package:flutter/material.dart';

class FadeScaleAnimation {
  late AnimationController controller;
  late Animation<double> scaleAnimation;
  late Animation<double> fadeAnimation;

  FadeScaleAnimation({required TickerProvider vsync}) {
    controller = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: vsync,
    );

    scaleAnimation = Tween<double>(
      begin: 0.8,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: controller,
      curve: Curves.easeOutBack,
    ));

    fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: controller,
      curve: Curves.easeIn,
    ));
  }

  void dispose() {
    controller.dispose();
  }

  void forward() {
    controller.forward();
  }

  void reset() {
    controller.reset();
  }
}
