import 'package:flutter/material.dart';

class CollectAppBar extends StatelessWidget implements PreferredSizeWidget {
  final Animation<Offset> slideAnimation;
  final VoidCallback onHome;
  final VoidCallback onClose;

  const CollectAppBar({
    Key? key,
    required this.slideAnimation,
    required this.onHome,
    required this.onClose,
  }) : super(key: key);

  @override
  Size get preferredSize => const Size.fromHeight(60.0);

  @override
  Widget build(BuildContext context) {
    return SlideTransition(
      position: slideAnimation,
      child: AppBar(
        backgroundColor: Colors.black,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.home, color: Colors.white),
          onPressed: onHome,
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.close, color: Colors.white),
            onPressed: onClose,
          ),
        ],
      ),
    );
  }
}
