import 'package:flutter/material.dart';

class CollectAnimations {
  late final AnimationController fadeController;
  late final AnimationController slideController;
  late final List<AnimationController> fieldControllers;
  late final AnimationController avatarController;
  late final AnimationController buttonController;

  late final Animation<double> fadeAnimation;
  late final Animation<Offset> slideAnimation;
  late final List<Animation<Offset>> fieldAnimations;
  late final Animation<double> avatarScaleAnimation;
  late final Animation<double> buttonScaleAnimation;

  CollectAnimations({required TickerProvider vsync}) {
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

    // Initialize field animations
    fieldControllers = List.generate(
      7,
      (index) => AnimationController(
        duration: Duration(milliseconds: 500 + (index * 100)),
        vsync: vsync,
      ),
    );

    fieldAnimations = fieldControllers.map((controller) {
      return Tween<Offset>(
        begin: const Offset(1.0, 0.0),
        end: Offset.zero,
      ).animate(CurvedAnimation(
        parent: controller,
        curve: Curves.easeOutCubic,
      ));
    }).toList();

    // Initialize avatar animation
    avatarController = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: vsync,
    );
    avatarScaleAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: avatarController,
      curve: Curves.elasticOut,
    ));

    // Initialize button animation
    buttonController = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: vsync,
    );
    buttonScaleAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: buttonController,
      curve: Curves.easeOutBack,
    ));
  }

  void startAnimations() {
    fadeController.forward();
    slideController.forward();
    avatarController.forward();
    for (var controller in fieldControllers) {
      controller.forward();
    }
    Future.delayed(const Duration(milliseconds: 1500), () {
      buttonController.forward();
    });
  }

  void dispose() {
    fadeController.dispose();
    slideController.dispose();
    for (var controller in fieldControllers) {
      controller.dispose();
    }
    avatarController.dispose();
    buttonController.dispose();
  }
}
