import 'package:flutter/material.dart';

class ProfitAnimations {
  final AnimationController controller;
  late final Animation<double> fadeAnimation;
  late final Animation<double> slideAnimation;

  ProfitAnimations({required this.controller}) {
    _initializeAnimations();
  }

  void _initializeAnimations() {
    fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: controller, curve: Curves.easeOut),
    );

    slideAnimation = Tween<double>(begin: 50.0, end: 0.0).animate(
      CurvedAnimation(parent: controller, curve: Curves.elasticOut),
    );
  }

  void dispose() {
    controller.dispose();
  }
}
