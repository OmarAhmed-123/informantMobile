import 'package:flutter/material.dart';

class FadeScaleAnimation extends StatelessWidget {
  final Widget child;
  final Animation<double> fadeAnimation;
  final Animation<double> slideAnimation;

  const FadeScaleAnimation({
    Key? key,
    required this.child,
    required this.fadeAnimation,
    required this.slideAnimation,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: fadeAnimation,
      child: AnimatedBuilder(
        animation: slideAnimation,
        builder: (context, child) {
          return Transform.translate(
            offset: Offset(0, slideAnimation.value),
            child: child,
          );
        },
        child: child,
      ),
    );
  }
}
