import 'package:flutter/material.dart';

class ProfileAnimations {
  late final AnimationController controller;
  late final Animation<double> fadeAnimation;
  late final Animation<Offset> slideAnimation;

  ProfileAnimations({required TickerProvider vsync}) {
    controller = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: vsync,
    );

    fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: controller, curve: Curves.easeIn),
    );

    slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.5),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: controller, curve: Curves.easeOut));
  }

  void dispose() {
    controller.dispose();
  }

  void forward() {
    controller.forward();
  }
}
