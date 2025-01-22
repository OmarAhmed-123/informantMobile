import 'package:flutter/material.dart';
import 'package:graduation___part1/views/profile/view/profile.dart';

class HomeAppBar extends StatelessWidget implements PreferredSizeWidget {
  final Animation<Offset> slideAnimation;
  final VoidCallback onClose;

  const HomeAppBar({
    Key? key,
    required this.slideAnimation,
    required this.onClose,
  }) : super(key: key);

  @override
  Size get preferredSize => const Size.fromHeight(60.0);

  @override
  Widget build(BuildContext context) {
    return SlideTransition(
      position: slideAnimation,
      child: AppBar(
        elevation: 0,
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Colors.black,
                Colors.blue.shade900,
              ],
            ),
          ),
        ),
        leading: Hero(
          tag: 'profile_icon',
          child: Material(
            color: Colors.transparent,
            child: IconButton(
              icon: const Icon(Icons.person, color: Colors.white),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const ProfileView()),
                );
              },
            ),
          ),
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
