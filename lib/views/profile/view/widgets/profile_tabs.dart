import 'package:flutter/material.dart';
import '../../view_model/profile_view_model.dart';

class ProfileTabs extends StatelessWidget {
  final ProfileViewModel viewModel;

  const ProfileTabs({Key? key, required this.viewModel}) : super(key: key);

  Widget _buildTabButton(int index, IconData icon, String label) {
    return Column(
      children: [
        IconButton(
          icon: Icon(icon, color: Colors.white),
          onPressed: () => viewModel.setSelectedTab(index),
        ),
        Text(
          label,
          style: const TextStyle(color: Colors.white),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        _buildTabButton(0, Icons.person, "Profile"),
        _buildTabButton(1, Icons.star, "Rates"),
        _buildTabButton(2, Icons.work, "My Works"),
      ],
    );
  }
}
