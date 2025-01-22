import 'package:flutter/material.dart';

class DetailsSection extends StatelessWidget {
  final String details;

  const DetailsSection({
    Key? key,
    required this.details,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(
      details,
      style: TextStyle(
        color: Colors.grey[300],
        fontSize: 16,
      ),
      maxLines: 3,
      overflow: TextOverflow.ellipsis,
    );
  }
}
