import 'package:flutter/material.dart';

class FadeScaleAnimation extends StatelessWidget {
  final Widget child;
  final Animation<double> fadeAnimation;
  final Animation<double> scaleAnimation;
  final Animation<Offset> slideAnimation;

  const FadeScaleAnimation({
    Key? key,
    required this.child,
    required this.fadeAnimation,
    required this.scaleAnimation,
    required this.slideAnimation,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation:
          Listenable.merge([fadeAnimation, slideAnimation, scaleAnimation]),
      builder: (context, child) {
        return Transform.scale(
          scale: scaleAnimation.value,
          child: SlideTransition(
            position: slideAnimation,
            child: FadeTransition(
              opacity: fadeAnimation,
              child: child,
            ),
          ),
        );
      },
      child: child,
    );
  }
}
