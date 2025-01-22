import 'package:flutter/material.dart';

class AddMediaButton extends StatelessWidget {
  final Animation<double> scaleAnimation;
  final VoidCallback onTap;

  const AddMediaButton({
    Key? key,
    required this.scaleAnimation,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ScaleTransition(
      scale: scaleAnimation,
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          width: 150,
          margin: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Colors.grey[800],
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.blue[400]!, width: 2),
            boxShadow: [
              BoxShadow(
                color: Colors.blue.withOpacity(0.2),
                blurRadius: 8,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: const Icon(
            Icons.add_photo_alternate,
            size: 50,
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}
