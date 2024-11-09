//bar of home

// ignore_for_file: file_names, unused_local_variable, library_prefixes

import 'package:flutter/material.dart';
import 'package:graduation___part1/views/home_view.dart';
import 'package:provider/provider.dart';
import '../view_models/auth_view_model.dart';
import 'ad_list_view.dart' as adView; // Added 'as' to prefix ad_list_view
import 'create_ad_view.dart';
import 'profit_view.dart';

class HomeView1 extends StatelessWidget {
  const HomeView1({super.key});

  @override
  Widget build(BuildContext context) {
    final authViewModel = Provider.of<AuthViewModel>(context);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        leading: IconButton(
          icon: Image.asset('assets/wifi.png'),
          onPressed: () {},
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
            colors: [Colors.blue[900]!, Colors.black],
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
                'Profit',
                'Review your earnings',
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
                'Statistics',
                'View your ad performance',
                Icons.bar_chart,
                () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Coming soon!')),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
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
