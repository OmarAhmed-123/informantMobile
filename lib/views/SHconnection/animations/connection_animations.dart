import 'package:flutter/material.dart';

class ConnectionAnimations {
  final AnimationController controller;
  late final Animation<double> fadeIn;
  late final Animation<double> scale;
  late final Animation<Offset> slide;
  late final Animation<double> rotate;

  ConnectionAnimations({required this.controller}) {
    _initializeAnimations();
  }

  void _initializeAnimations() {
    fadeIn = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: controller,
      curve: const Interval(0.0, 0.5, curve: Curves.easeIn),
    ));

    scale = Tween<double>(
      begin: 0.5,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: controller,
      curve: const Interval(0.3, 0.8, curve: Curves.elasticOut),
    ));

    slide = Tween<Offset>(
      begin: const Offset(0.0, 1.0),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: controller,
      curve: const Interval(0.6, 1.0, curve: Curves.easeOut),
    ));

    rotate = Tween<double>(
      begin: 0.0,
      end: 2 * 3.14159,
    ).animate(CurvedAnimation(
      parent: controller,
      curve: const Interval(0.4, 0.9, curve: Curves.easeInOut),
    ));
  }
}
