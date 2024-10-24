// ignore_for_file: avoid_print

/*
// ignore_for_file: await_only_futures, use_build_context_synchronously, library_private_types_in_public_api, unused_local_variable
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../view_models/auth_view_model.dart';
import 'ad_list_view.dart';
import 'create_ad_view.dart';
import 'profit_view.dart';
import 'dart:async';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  _HomeViewState createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  late PageController _pageController;
  late Timer _timer;
  int _currentPage = 0;

  final List<Map<String, dynamic>> ads = [
    {
      "name": "Ali Cafe",
      "details": "Ali Cafe is a fast coffee brand...",
      "stars": 4,
      "potentialRevenue": 750,
      "images": [
        "https://i5.walmartimages.com/seo/Alicafe-Classic-3-In-1-Instant-Coffee-Bag-Ground-30-X-20G-600G_58d646a8-7b89-4524-a667-847665159273.a0da51f0eec72ac0cfd2f387788129da.jpeg",
      ],
      "availablePlaces": 12,
      "creatorName": "COMPANY NAME"
    },
    {
      "name": "Cafe 5438dc",
      "details":
          "Cafe 5438dc is known for its quick and flavorful coffee offerings. Customers love the convenience and rich taste, making it perfect for busy mornings or quick coffee breaks.",
      "stars": 1,
      "potentialRevenue": 569,
      "images": [
        "https://picsum.photos/200/300?random=40",
        "https://picsum.photos/200/300?random=177",
        "https://picsum.photos/200/300?random=230"
      ],
      "availablePlaces": 15,
      "creatorName": "COMPANY NAME"
    },
    // Add more ads similarly...
  ];

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
    _startAutoScroll();
  }

  void _startAutoScroll() {
    _timer = Timer.periodic(const Duration(seconds: 3), (timer) {
      if (_currentPage < ads.length - 1) {
        _currentPage++;
      } else {
        _currentPage = 0;
      }
      _pageController.animateToPage(
        _currentPage,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeIn,
      );
    });
  }

  @override
  void dispose() {
    _pageController.dispose();
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final authViewModel = Provider.of<AuthViewModel>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('Welcome, ${authViewModel.username ?? "User"}!'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () {
              authViewModel.logout();
              Navigator.of(context).pushReplacementNamed('/login');
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
              Expanded(
                child: PageView.builder(
                  controller: _pageController,
                  itemCount: ads.length,
                  itemBuilder: (context, index) {
                    return _buildAdCard(ads[index]);
                  },
                ),
              ),
              const SizedBox(height: 20),
              _buildActionCard(
                context,
                'Get Ads',
                'Choose an item for your ad',
                Icons.list,
                () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const AdListView()),
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

  Widget _buildAdCard(Map<String, dynamic> ad) {
    return AnimatedScale(
      scale: 1.0,
      duration: const Duration(milliseconds: 300),
      child: Card(
        elevation: 8,
        margin: const EdgeInsets.all(16),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                ad['name'],
                style:
                    const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              Text(ad['details']),
              const SizedBox(height: 8),
              Image.network(ad['images'][0], height: 100, fit: BoxFit.cover),
              const SizedBox(height: 8),
              Text('Stars: ${ad['stars']}'),
              Text('Potential Revenue: \$${ad['potentialRevenue']}'),
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

// NavigationBarOfHome
class NavigationBarOfHome extends StatelessWidget {
  const NavigationBarOfHome({super.key});

  @override
  Widget build(BuildContext context) {
    final authViewModel = Provider.of<AuthViewModel>(context);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        leading: IconButton(
          icon: Image.asset(
              '../../assets/wifi.png'), // Update with the correct path to assets
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
      body: const HomeView(), // Assuming you are reusing the HomeView here
    );
  }
}
*/
//home of view

// ignore_for_file: await_only_futures, use_build_context_synchronously, unused_local_variable

import 'package:flutter/material.dart';
import 'package:graduation___part1/views/barOfHome.dart';

import 'package:provider/provider.dart';
import '../view_models/auth_view_model.dart';
import 'ad_list_view.dart';
import 'create_ad_view.dart';
import 'profit_view.dart';

class HomeView extends StatelessWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    final authViewModel = Provider.of<AuthViewModel>(context);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        leading: Row(
          children: [
            IconButton(
              icon: const Icon(Icons.person, color: Colors.white),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const HomeView1()),
                );
              },
            ),
            IconButton(
              icon: Image.asset(
                '../../assets/wifi.png', // Ensure this path is correct
                width: 24, // Set the width of the image
                height: 24, // Set the height of the image
              ),
              onPressed: () {
                // Add your search functionality here
                print("Searching for something...");
              },
            ),
          ],
        ),
        actions: <Widget>[
          Row(
            children: [
              IconButton(
                icon: const Icon(Icons.search, color: Colors.white),
                onPressed: () {
                  // Add your search functionality here
                  print("Search icon clicked");
                },
              ),
              IconButton(
                icon: Image.asset(
                  'assets/wifi.png', // Ensure this path is correct
                  width: 24, // Set the width of the image
                  height: 24, // Set the height of the image
                ),
                onPressed: () {
                  // Add your search functionality here
                  print("Searching for something...");
                },
              ),
            ],
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
                  Navigator.push(context,
                      MaterialPageRoute(builder: (_) => const AdListView()));
                },
              ),
              const SizedBox(height: 20),
              _buildActionCard(
                context,
                'Create Ad',
                'Create your own ad',
                Icons.add_circle,
                () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (_) => const CreateAdView()));
                },
              ),
              const SizedBox(height: 20),
              _buildActionCard(
                context,
                'Profit',
                'Review your earnings',
                Icons.attach_money,
                () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (_) => const ProfitView()));
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
