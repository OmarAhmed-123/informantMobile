//bar of home

// ignore_for_file: file_names, unused_local_variable, library_prefixes

import 'package:flutter/material.dart';
import 'package:graduation___part1/views/home_view.dart';
import 'package:provider/provider.dart';
import '../view_models/auth_view_model.dart';
import 'package:graduation___part1/views/ad_list_view.dart'
    as adView; // Added 'as' to prefix ad_list_view
import 'package:graduation___part1/views/create_ad_view.dart';
import 'package:graduation___part1/views/Statistics.dart';
import 'package:graduation___part1/views/autoProfile.dart';
import 'package:graduation___part1/views/profile.dart';
import 'package:graduation___part1/views/autoLogin.dart';
import 'package:graduation___part1/views/login_view.dart';

class HomeView1 extends StatelessWidget {
  const HomeView1({super.key});

  @override
  Widget build(BuildContext context) {
    final authViewModel = Provider.of<AuthViewModel>(context);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.purple[700],
        leading: IconButton(
          icon: const Icon(Icons.person, color: Colors.white),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const ProfilePage()),
            );
          },
        ),
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.close, color: Colors.white),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const HomeView()),
              );
            },
          ),
        ],
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Colors.purple[700]!, Colors.blue[500]!],
          ),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _buildActionCard(
                context,
                'Get Ads',
                'Choose an item for your ad',
                Icons.list,
                () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (_) => const adView
                            .AdListView()), // Using the prefixed AdListView
                  );
                },
              ),
              const SizedBox(height: 20),
              _buildActionCard(
                context,
                'Create Ad',
                'Create your own ad',
                Icons.add_circle,
                () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const CreateAdView()),
                  );
                },
              ),
              const SizedBox(height: 20),
              _buildActionCard(
                context,
                'My profile',
                '',
                Icons.person,
                () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const autoProfile()),
                  );
                },
              ),
              const SizedBox(height: 20),
              _buildActionCard(
                context,
                'Statistics',
                'View your ad performance',
                Icons.attach_money,
                () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const ProfitView()),
                  );
                },
              ),
              const SizedBox(height: 20),
              _buildActionCard(
                context,
                'Log Out',
                '',
                Icons.logout,
                () {
                  logOut1(context);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  void logOut1(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Confirm Logout'),
          content: Text('Are you sure you want to log out?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
                logOut2(context); // Perform logout
              },
              child: Text('Yes'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
              child: Text('Cancel'),
            ),
          ],
        );
      },
    );
  }

  void logOut2(BuildContext context) {
    // Add your logout logic here
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('You have been logged out.')),
    );
    AutoLogin.logout3();
    Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => const LoginView(),
        ));
  }

  Widget _buildActionCard(BuildContext context, String title, String subtitle,
      IconData icon, VoidCallback onTap) {
    return Card(
      elevation: 4,
      margin: const EdgeInsets.symmetric(horizontal: 20),
      child: ListTile(
        leading: Icon(icon, color: Colors.blue),
        title: Text(title),
        subtitle: Text(subtitle),
        trailing: const Icon(Icons.arrow_forward_ios),
        onTap: onTap,
      ),
    );
  }
}
