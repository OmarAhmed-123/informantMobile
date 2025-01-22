import 'package:flutter/material.dart';

class FadeScaleAnimation extends StatelessWidget {
  final Widget child;
  final Animation<double> fadeAnimation;

  const FadeScaleAnimation({
    Key? key,
    required this.child,
    required this.fadeAnimation,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: fadeAnimation,
      child: child,
    );
  }
}
