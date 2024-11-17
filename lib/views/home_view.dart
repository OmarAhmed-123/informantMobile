// ignore_for_file: avoid_print, use_super_parameters, unused_element, library_private_types_in_public_api, unused_import, duplicate_ignore

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

/*
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
*/

/*
//the old code before update the coding in home page
// ignore_for_file: await_only_futures, use_build_context_synchronously, library_private_types_in_public_api, unused_local_variable
import 'package:flutter/material.dart';
import 'package:graduation___part1/views/barOfHome.dart';
import 'package:provider/provider.dart';
import '../view_models/auth_view_model.dart';
import 'ad_list_view.dart';
import 'create_ad_view.dart';
import 'profit_view.dart';
import 'dart:async';
import '../widgets/search_box.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});
  @override
  _HomeViewState createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView>
    with SingleTickerProviderStateMixin {
  late PageController _pageController;
  late Timer _timer;
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;
  int _currentPage = 0;
  bool _showSearch = false;
  String _searchQuery = '';

  final List<Map<String, dynamic>> ads = [
    {
      "name": "Ad name",
      "details":
          "string of anything But be carefull it will contains many details",
      "stars": 5,
      "potentialRevenue": 522,
      "images": ["URL", "URL", "URL"],
      "availablePlaces": 14,
      "creatorName": "COMPANY NAME"
    },
    {
      "name": "Ali Cafe",
      "details":
          "Ali Cafe is a fast coffee brand, providing instant coffee solutions for people on the go. Known for its rich and strong flavor, it's perfect for a quick pick-me-up at any time of the day. Whether you're at home, at work, or traveling, Ali Cafe offers a convenient way to enjoy a delicious cup of coffee in seconds. Simply add hot water, stir, and you're ready to go!",
      "stars": 4,
      "potentialRevenue": 750,
      "images": [
        "https://i5.walmartimages.com/seo/Alicafe-Classic-3-In-1-Instant-Coffee-Bag-Ground-30-X-20G-600G_58d646a8-7b89-4524-a667-847665159273.a0da51f0eec72ac0cfd2f387788129da.jpeg",
        "https://m.media-amazon.com/images/I/51IozBoN4kL._SS1000_.jpg",
        "https://images.deliveryhero.io/image/product-information-management/663b03d05c2a36ba98195fe8.png?size=520"
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
    {
      "name": "Cafe C24e9e",
      "details":
          "Cafe C24e9e is known for its quick and flavorful coffee offerings. Customers love the convenience and rich taste, making it perfect for busy mornings or quick coffee breaks.",
      "stars": 4,
      "potentialRevenue": 968,
      "images": [
        "https://picsum.photos/200/300?random=85",
        "https://picsum.photos/200/300?random=1310",
        "https://picsum.photos/200/300?random=2948"
      ],
      "availablePlaces": 20,
      "creatorName": "COMPANY NAME"
    },
    {
      "name": "Cafe 3f0de5",
      "details":
          "Cafe 3f0de5 is known for its quick and flavorful coffee offerings. Customers love the convenience and rich taste, making it perfect for busy mornings or quick coffee breaks.",
      "stars": 2,
      "potentialRevenue": 514,
      "images": [
        "https://picsum.photos/200/300?random=645",
        "https://picsum.photos/200/300?random=1450",
        "https://picsum.photos/200/300?random=2238"
      ],
      "availablePlaces": 14,
      "creatorName": "COMPANY NAME"
    },
    {
      "name": "Cafe 873a62",
      "details":
          "Cafe 873a62 is known for its quick and flavorful coffee offerings. Customers love the convenience and rich taste, making it perfect for busy mornings or quick coffee breaks.",
      "stars": 3,
      "potentialRevenue": 601,
      "images": [
        "https://picsum.photos/200/300?random=197",
        "https://picsum.photos/200/300?random=1072",
        "https://picsum.photos/200/300?random=2970"
      ],
      "availablePlaces": 12,
      "creatorName": "COMPANY NAME"
    },
    {
      "name": "Cafe 53fefd",
      "details":
          "Cafe 53fefd is known for its quick and flavorful coffee offerings. Customers love the convenience and rich taste, making it perfect for busy mornings or quick coffee breaks.",
      "stars": 1,
      "potentialRevenue": 716,
      "images": [
        "https://picsum.photos/200/300?random=30",
        "https://picsum.photos/200/300?random=1592",
        "https://picsum.photos/200/300?random=2758"
      ],
      "availablePlaces": 9,
      "creatorName": "COMPANY NAME"
    },
    {
      "name": "Cafe A5de3a",
      "details":
          "Cafe A5de3a is known for its quick and flavorful coffee offerings. Customers love the convenience and rich taste, making it perfect for busy mornings or quick coffee breaks.",
      "stars": 3,
      "potentialRevenue": 776,
      "images": [
        "https://picsum.photos/200/300?random=302",
        "https://picsum.photos/200/300?random=1275",
        "https://picsum.photos/200/300?random=2995"
      ],
      "availablePlaces": 9,
      "creatorName": "COMPANY NAME"
    },
    {
      "name": "Cafe 2b6ec0",
      "details":
          "Cafe 2b6ec0 is known for its quick and flavorful coffee offerings. Customers love the convenience and rich taste, making it perfect for busy mornings or quick coffee breaks.",
      "stars": 1,
      "potentialRevenue": 299,
      "images": [
        "https://picsum.photos/200/300?random=967",
        "https://picsum.photos/200/300?random=1032",
        "https://picsum.photos/200/300?random=2163"
      ],
      "availablePlaces": 6,
      "creatorName": "COMPANY NAME"
    },
    {
      "name": "Cafe B7ae1c",
      "details":
          "Cafe B7ae1c is known for its quick and flavorful coffee offerings. Customers love the convenience and rich taste, making it perfect for busy mornings or quick coffee breaks.",
      "stars": 1,
      "potentialRevenue": 675,
      "images": [
        "https://picsum.photos/200/300?random=994",
        "https://picsum.photos/200/300?random=1851",
        "https://picsum.photos/200/300?random=2379"
      ],
      "availablePlaces": 10,
      "creatorName": "COMPANY NAME"
    }
  ];
  List<Map<String, dynamic>> get filteredAds => ads.where((ad) {
        final name = ad['name'].toString().toLowerCase();
        final details = ad['details'].toString().toLowerCase();
        final query = _searchQuery.toLowerCase();
        return name.contains(query) || details.contains(query);
      }).toList();
  @override
  @override
  void initState() {
    super.initState();
    _pageController = PageController();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );
    _scaleAnimation = Tween<double>(begin: 0.8, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeOutBack),
    );
    _startAutoScroll();
    _animationController.forward();
  }

  @override
  void dispose() {
    _pageController.dispose();
    _timer.cancel();
    _animationController.dispose();
    super.dispose();
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
  Widget build(BuildContext context) {
    final authViewModel = Provider.of<AuthViewModel>(context);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        elevation: 0,
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
          ],
        ),
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.search, color: Colors.white),
            onPressed: () {
              setState(() {
                _showSearch = true;
              });
            },
          ),
        ],
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Colors.black,
              Colors.blue.shade900.withOpacity(0.7),
              Colors.black,
            ],
            stops: const [0.0, 0.5, 1.0],
          ),
        ),
        child: Column(
          children: [
            if (_showSearch)
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: SearchBox(
                  onSearch: (query) {
                    setState(() {
                      _searchQuery = query;
                    });
                  },
                  onClose: () {
                    setState(() {
                      _showSearch = false;
                      _searchQuery = '';
                    });
                  },
                ),
              ),

            Expanded(
              child: PageView.builder(
                controller: _pageController,
                itemCount: filteredAds.length,
                onPageChanged: (index) {
                  setState(() {
                    _currentPage = index;
                  });
                  _animationController.reset();
                  _animationController.forward();
                },
                itemBuilder: (context, index) {
                  return AnimatedBuilder(
                    animation: _scaleAnimation,
                    builder: (context, child) {
                      return Transform.scale(
                        scale: _scaleAnimation.value,
                        child: _buildAdCard(filteredAds[index]),
                      );
                    },
                  );
                },
              ),
            ),
            // Page indicator
            Padding(
              padding: const EdgeInsets.only(bottom: 20.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(
                  filteredAds.length,
                  (index) => AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    margin: const EdgeInsets.symmetric(horizontal: 4),
                    height: 8,
                    width: _currentPage == index ? 24 : 8,
                    decoration: BoxDecoration(
                      color: _currentPage == index
                          ? Colors.blue.shade400
                          : Colors.grey.shade600,
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAdCard(Map<String, dynamic> ad) {
    return Card(
      elevation: 12,
      margin: const EdgeInsets.fromLTRB(20, 10, 20, 30),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Colors.blue.shade900.withOpacity(0.9),
              Colors.black87,
            ],
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius:
                  const BorderRadius.vertical(top: Radius.circular(20)),
              child: Image.network(
                ad['images'][0],
                height: 200,
                width: double.infinity,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    height: 200,
                    color: Colors.grey[850],
                    child: const Icon(Icons.error_outline,
                        color: Colors.white60, size: 50),
                  );
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          ad['name'],
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          color: Colors.blue.shade700,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Row(
                          children: [
                            const Icon(Icons.star,
                                color: Colors.amber, size: 16),
                            const SizedBox(width: 4),
                            Text(
                              '${ad['stars']}/5',
                              style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Text(
                    ad['details'],
                    style: TextStyle(
                      color: Colors.grey[300],
                      fontSize: 16,
                    ),
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Potential Revenue',
                            style: TextStyle(
                              color: Colors.grey,
                              fontSize: 14,
                            ),
                          ),
                          Text(
                            '\$${ad['potentialRevenue']}',
                            style: const TextStyle(
                              color: Colors.green,
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          color: Colors.green.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          '${ad['availablePlaces']} places left',
                          style: const TextStyle(
                            color: Colors.green,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
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

import 'package:flutter/material.dart';
import 'package:graduation___part1/views/barOfHome.dart';
import 'package:provider/provider.dart';
import '../view_models/auth_view_model.dart';
import 'dart:async';
import '../widgets/search_box.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  _HomeViewState createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> with TickerProviderStateMixin {
  late PageController _pageController;
  late Timer _timer;
  late AnimationController _profileAnimationController;
  late AnimationController _verticalListAnimationController;
  late Animation<double> _verticalSlideAnimation;
  int _currentVerticalPage = 0;
  bool _showSearch = false;
  String _searchQuery = '';

  final List<Map<String, dynamic>> ads = [
    {
      "name": "Ad name",
      "details":
          "string of anything But be carefull it will contains many details",
      "stars": 5,
      "potentialRevenue": 522,
      "images": ["URL", "URL", "URL"],
      "availablePlaces": 14,
      "creatorName": "COMPANY NAME"
    },
    {
      "name": "Ali Cafe",
      "details":
          "Ali Cafe is a fast coffee brand, providing instant coffee solutions for people on the go. Known for its rich and strong flavor, it's perfect for a quick pick-me-up at any time of the day. Whether you're at home, at work, or traveling, Ali Cafe offers a convenient way to enjoy a delicious cup of coffee in seconds. Simply add hot water, stir, and you're ready to go!",
      "stars": 4,
      "potentialRevenue": 750,
      "images": [
        "https://i5.walmartimages.com/seo/Alicafe-Classic-3-In-1-Instant-Coffee-Bag-Ground-30-X-20G-600G_58d646a8-7b89-4524-a667-847665159273.a0da51f0eec72ac0cfd2f387788129da.jpeg",
        "https://m.media-amazon.com/images/I/51IozBoN4kL._SS1000_.jpg",
        "https://images.deliveryhero.io/image/product-information-management/663b03d05c2a36ba98195fe8.png?size=520"
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
    {
      "name": "Cafe C24e9e",
      "details":
          "Cafe C24e9e is known for its quick and flavorful coffee offerings. Customers love the convenience and rich taste, making it perfect for busy mornings or quick coffee breaks.",
      "stars": 4,
      "potentialRevenue": 968,
      "images": [
        "https://picsum.photos/200/300?random=85",
        "https://picsum.photos/200/300?random=1310",
        "https://picsum.photos/200/300?random=2948"
      ],
      "availablePlaces": 20,
      "creatorName": "COMPANY NAME"
    },
    {
      "name": "Cafe 3f0de5",
      "details":
          "Cafe 3f0de5 is known for its quick and flavorful coffee offerings. Customers love the convenience and rich taste, making it perfect for busy mornings or quick coffee breaks.",
      "stars": 2,
      "potentialRevenue": 514,
      "images": [
        "https://picsum.photos/200/300?random=645",
        "https://picsum.photos/200/300?random=1450",
        "https://picsum.photos/200/300?random=2238"
      ],
      "availablePlaces": 14,
      "creatorName": "COMPANY NAME"
    },
    {
      "name": "Cafe 873a62",
      "details":
          "Cafe 873a62 is known for its quick and flavorful coffee offerings. Customers love the convenience and rich taste, making it perfect for busy mornings or quick coffee breaks.",
      "stars": 3,
      "potentialRevenue": 601,
      "images": [
        "https://picsum.photos/200/300?random=197",
        "https://picsum.photos/200/300?random=1072",
        "https://picsum.photos/200/300?random=2970"
      ],
      "availablePlaces": 12,
      "creatorName": "COMPANY NAME"
    },
    {
      "name": "Cafe 53fefd",
      "details":
          "Cafe 53fefd is known for its quick and flavorful coffee offerings. Customers love the convenience and rich taste, making it perfect for busy mornings or quick coffee breaks.",
      "stars": 1,
      "potentialRevenue": 716,
      "images": [
        "https://picsum.photos/200/300?random=30",
        "https://picsum.photos/200/300?random=1592",
        "https://picsum.photos/200/300?random=2758"
      ],
      "availablePlaces": 9,
      "creatorName": "COMPANY NAME"
    },
    {
      "name": "Cafe A5de3a",
      "details":
          "Cafe A5de3a is known for its quick and flavorful coffee offerings. Customers love the convenience and rich taste, making it perfect for busy mornings or quick coffee breaks.",
      "stars": 3,
      "potentialRevenue": 776,
      "images": [
        "https://picsum.photos/200/300?random=302",
        "https://picsum.photos/200/300?random=1275",
        "https://picsum.photos/200/300?random=2995"
      ],
      "availablePlaces": 9,
      "creatorName": "COMPANY NAME"
    },
    {
      "name": "Cafe 2b6ec0",
      "details":
          "Cafe 2b6ec0 is known for its quick and flavorful coffee offerings. Customers love the convenience and rich taste, making it perfect for busy mornings or quick coffee breaks.",
      "stars": 1,
      "potentialRevenue": 299,
      "images": [
        "https://picsum.photos/200/300?random=967",
        "https://picsum.photos/200/300?random=1032",
        "https://picsum.photos/200/300?random=2163"
      ],
      "availablePlaces": 6,
      "creatorName": "COMPANY NAME"
    },
    {
      "name": "Cafe B7ae1c",
      "details":
          "Cafe B7ae1c is known for its quick and flavorful coffee offerings. Customers love the convenience and rich taste, making it perfect for busy mornings or quick coffee breaks.",
      "stars": 1,
      "potentialRevenue": 675,
      "images": [
        "https://picsum.photos/200/300?random=994",
        "https://picsum.photos/200/300?random=1851",
        "https://picsum.photos/200/300?random=2379"
      ],
      "availablePlaces": 10,
      "creatorName": "COMPANY NAME"
    }
  ];

  List<Map<String, dynamic>> get filteredAds => ads.where((ad) {
        final name = ad['name'].toString().toLowerCase();
        final details = ad['details'].toString().toLowerCase();
        final query = _searchQuery.toLowerCase();
        return name.contains(query) || details.contains(query);
      }).toList();

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
    _profileAnimationController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    _verticalListAnimationController = AnimationController(
      duration: const Duration(milliseconds: 1200),
      vsync: this,
    );
    _verticalSlideAnimation = Tween<double>(begin: 100, end: 0).animate(
      CurvedAnimation(
          parent: _verticalListAnimationController, curve: Curves.easeOutCubic),
    );
    _startAutoScroll();
    _startAnimations();
  }

  void _startAnimations() {
    _profileAnimationController.forward();
    _verticalListAnimationController.forward();
  }

  @override
  void dispose() {
    _pageController.dispose();
    _timer.cancel();
    _profileAnimationController.dispose();
    _verticalListAnimationController.dispose();
    super.dispose();
  }

  void _startAutoScroll() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        if (filteredAds.isNotEmpty) {
          _currentVerticalPage =
              (_currentVerticalPage + 1) % filteredAds.length;
        }
      });
    });
  }

  Widget _buildProfileSection() {
    return ScaleTransition(
      scale: _profileAnimationController,
      child: Container(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Container(
              width: 120,
              height: 120,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: Colors.blue.shade400, width: 3),
                boxShadow: [
                  BoxShadow(
                    color: Colors.blue.shade900.withOpacity(0.3),
                    blurRadius: 15,
                    spreadRadius: 5,
                  ),
                ],
              ),
              child: ClipOval(
                child: Image.asset(
                  'wifi.png',
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      color: Colors.grey[850],
                      child: const Icon(Icons.person,
                          color: Colors.white, size: 50),
                    );
                  },
                ),
              ),
            ),
            const SizedBox(height: 12),
            Text(
              'informant',
              style: TextStyle(
                color: Colors.blue.shade100,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildVerticalAdList() {
    final displayAds = filteredAds.take(6).toList();
    return AnimatedBuilder(
      animation: _verticalSlideAnimation,
      builder: (context, child) {
        return Transform.translate(
          offset: Offset(0, _verticalSlideAnimation.value),
          child: Container(
            height: 400,
            child: PageView.builder(
              controller: _pageController,
              itemCount: displayAds.length,
              itemBuilder: (context, index) {
                final ad = displayAds[index];
                return AnimatedOpacity(
                  duration: const Duration(milliseconds: 600),
                  opacity: index == _currentVerticalPage ? 1.0 : 0.0,
                  child: Container(
                    margin:
                        const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          Colors.purple.shade900,
                          Colors.blue.shade900,
                        ],
                      ),
                      borderRadius: BorderRadius.circular(15),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.blue.shade900.withOpacity(0.3),
                          blurRadius: 10,
                          spreadRadius: 2,
                        ),
                      ],
                    ),
                    child: ListTile(
                      leading: CircleAvatar(
                        radius: 30,
                        backgroundImage: NetworkImage(ad['images'][0]),
                      ),
                      title: Text(
                        ad['name'],
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            ad['details'],
                            style: TextStyle(color: Colors.grey[300]),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'Revenue: \$${ad['potentialRevenue']} • ${ad['availablePlaces']} places',
                            style: TextStyle(color: Colors.green.shade300),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        );
      },
    );
  }

  Widget _buildHorizontalAdList() {
    return Container(
      height: 150,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: ads.length,
        itemBuilder: (context, index) {
          final ad = ads[index];
          return Container(
            width: 120,
            margin: const EdgeInsets.symmetric(horizontal: 8),
            child: Column(
              children: [
                Container(
                  width: 100,
                  height: 100,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.purple.shade400, width: 2),
                  ),
                  child: ClipOval(
                    child: Image.network(
                      ad['images'][0],
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return Container(
                          color: Colors.grey[850],
                          child: const Icon(Icons.image_not_supported,
                              color: Colors.white),
                        );
                      },
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  ad['name'],
                  style: const TextStyle(color: Colors.white),
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.person, color: Colors.white),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const HomeView1()),
            );
          },
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.search, color: Colors.white),
            onPressed: () {
              setState(() {
                _showSearch = true;
              });
            },
          ),
        ],
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Colors.black,
              Colors.blue.shade900.withOpacity(0.7),
              Colors.black,
            ],
            stops: const [0.0, 0.5, 1.0],
          ),
        ),
        child: SingleChildScrollView(
          child: Column(
            children: [
              if (_showSearch)
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: SearchBox(
                    onSearch: (query) {
                      setState(() {
                        _searchQuery = query;
                      });
                    },
                    onClose: () {
                      setState(() {
                        _showSearch = false;
                        _searchQuery = '';
                      });
                    },
                  ),
                ),
              _buildProfileSection(),
              const SizedBox(height: 20),
              _buildVerticalAdList(),
              const SizedBox(height: 20),
              _buildHorizontalAdList(),
            ],
          ),
        ),
      ),
    );
  }
}
