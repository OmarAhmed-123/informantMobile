import 'package:flutter/material.dart';

class InternetIcon extends StatelessWidget {
  final Animation<double> scaleAnimation;
  final Animation<double> rotateAnimation;

  const InternetIcon({
    Key? key,
    required this.scaleAnimation,
    required this.rotateAnimation,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ScaleTransition(
      scale: scaleAnimation,
      child: RotationTransition(
        turns: rotateAnimation,
        child: Container(
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: Colors.blue.withOpacity(0.3),
                spreadRadius: 5,
                blurRadius: 15,
              ),
            ],
          ),
          child: CircleAvatar(
            radius: 122,
            backgroundColor: Colors.white,
            child: CircleAvatar(
              radius: 120,
              backgroundImage: const AssetImage('assets/internet.jpeg'),
              backgroundColor: Colors.transparent,
            ),
          ),
        ),
      ),
    );
  }
}
