// ignore_for_file: use_super_parameters

import 'package:flutter/material.dart';
import '../../view_models/auth_view_model.dart';
import '../ad_list_view.dart';
import '../create_ad_view.dart';
import '../Statistics.dart';

class UserDrawer extends StatelessWidget {
  final AuthViewModel authViewModel;

  const UserDrawer({Key? key, required this.authViewModel}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          UserAccountsDrawerHeader(
            accountName: Text(authViewModel.username ?? "User"),
            accountEmail: Text(authViewModel.email ?? ""),
            currentAccountPicture: CircleAvatar(
              backgroundColor: Colors.white,
              child: IconButton(
                icon: const Icon(Icons.camera_alt),
                onPressed: () {
                  // Implement profile picture change logic
                },
              ),
            ),
          ),
          _buildDrawerItem(
            context,
            'Get Ads',
            Icons.list,
            () => Navigator.push(
                context, MaterialPageRoute(builder: (_) => const AdListView())),
          ),
          _buildDrawerItem(
            context,
            'Create Ad',
            Icons.add_circle,
            () => Navigator.push(context,
                MaterialPageRoute(builder: (_) => const CreateAdView())),
          ),
          _buildDrawerItem(
            context,
            'Statistics',
            Icons.attach_money,
            () => Navigator.push(
                context, MaterialPageRoute(builder: (_) => const ProfitView())),
          ),
          _buildDrawerItem(context, 'Log Out', Icons.logout, () {}),
        ],
      ),
    );
  }

  Widget _buildDrawerItem(
      BuildContext context, String title, IconData icon, VoidCallback onTap) {
    return ListTile(
      leading: Icon(icon),
      title: Text(title),
      onTap: onTap,
    );
  }
}
