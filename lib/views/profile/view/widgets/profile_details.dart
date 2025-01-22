import 'package:flutter/material.dart';
import '../../animations/profile_animations.dart';
import '../../view_model/profile_view_model.dart';

class ProfileDetails extends StatelessWidget {
  final ProfileViewModel viewModel;
  final ProfileAnimations animations;

  const ProfileDetails({
    Key? key,
    required this.viewModel,
    required this.animations,
  }) : super(key: key);

  Widget _buildInfoSection(String title, String? content) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            content ?? "Not provided",
            style: const TextStyle(
              fontSize: 16,
              color: Colors.white70,
            ),
          ),
          const Divider(color: Colors.white24),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: animations.fadeAnimation,
      child: SlideTransition(
        position: animations.slideAnimation,
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Colors.blue.withOpacity(0.1),
                Colors.purple.withOpacity(0.1),
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(16),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildInfoSection("About Me", viewModel.about),
              _buildInfoSection("My Skills", viewModel.skills),
              _buildInfoSection("LinkedIn", viewModel.linkedin),
              _buildInfoSection(
                  "Experience", "${viewModel.numOfEx ?? 0} years"),
              _buildInfoSection("Email", viewModel.email),
              _buildInfoSection("Phone", viewModel.phone),
              _buildInfoSection("Profile Link", viewModel.profile),
            ],
          ),
        ),
      ),
    );
  }
}
