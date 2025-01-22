import 'package:flutter/material.dart';
import '../../view_model/profile_view_model.dart';

class ProfileHeader extends StatelessWidget {
  final ProfileViewModel viewModel;

  const ProfileHeader({Key? key, required this.viewModel}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Hero(
          tag: 'profile_image',
          child: Container(
            padding: const EdgeInsets.all(16),
            child: CircleAvatar(
              radius: 60,
              backgroundImage: viewModel.profileImage,
              backgroundColor: Colors.grey[800],
            ),
          ),
        ),
        Text(
          viewModel.username ?? "Username",
          style: const TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        const SizedBox(height: 20),
        ElevatedButton.icon(
          onPressed: () {},
          icon: const Icon(Icons.message),
          label: const Text("Contact Me"),
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.blue,
            padding: const EdgeInsets.symmetric(
              horizontal: 24,
              vertical: 12,
            ),
          ),
        ),
      ],
    );
  }
}
