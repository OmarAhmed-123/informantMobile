import 'package:flutter/material.dart';

class HomeAnimations {
  late final AnimationController fadeController;
  late final AnimationController slideController;
  late final List<AnimationController> cardControllers;

  late final Animation<double> fadeAnimation;
  late final Animation<Offset> slideAnimation;
  late final List<Animation<double>> scaleAnimations;

  HomeAnimations({required TickerProvider vsync}) {
    // Initialize fade animation
    fadeController = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: vsync,
    );
    fadeAnimation = CurvedAnimation(
      parent: fadeController,
      curve: Curves.easeIn,
    );

    // Initialize slide animation
    slideController = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: vsync,
    );
    slideAnimation = Tween<Offset>(
      begin: const Offset(-1.0, 0.0),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: slideController,
      curve: Curves.easeOutCubic,
    ));

    // Initialize card animations
    cardControllers = List.generate(
      5,
      (index) => AnimationController(
        duration: Duration(milliseconds: 600 + (index * 100)),
        vsync: vsync,
      ),
    );

    scaleAnimations = cardControllers.map((controller) {
      return Tween<double>(begin: 0.0, end: 1.0).animate(
        CurvedAnimation(parent: controller, curve: Curves.easeOutBack),
      );
    }).toList();
  }

  void startAnimations() {
    fadeController.forward();
    slideController.forward();
    for (var controller in cardControllers) {
      controller.forward();
    }
  }

  void dispose() {
    fadeController.dispose();
    slideController.dispose();
    for (var controller in cardControllers) {
      controller.dispose();
    }
  }
}
