/*
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:video_player/video_player.dart';
import 'auth_cubit.dart';
import 'create_ad_view.dart'; // Import the CreateAdView to access ad data

class MyAdsPage extends StatefulWidget {
  @override
  _MyAdsPageState createState() => _MyAdsPageState();
}

class _MyAdsPageState extends State<MyAdsPage> with TickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();

    // Initialize animations
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeInOut,
      ),
    );

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0.0, 0.5),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeOutBack,
      ),
    );

    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Ads'),
        backgroundColor: Colors.black,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.add, color: Colors.white),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => CreateAdView()),
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
            colors: [
              Colors.black,
              Colors.blue.shade900.withOpacity(0.6),
              Colors.black,
            ],
            stops: const [0.0, 0.5, 1.0],
          ),
        ),
        child: BlocBuilder<AuthCubit, AuthState>(
          builder: (context, state) {
            if (state is AdsLoaded) {
              final ads = state.ads;

              return ListView.builder(
                padding: const EdgeInsets.all(16.0),
                itemCount: ads.length,
                itemBuilder: (context, index) {
                  final ad = ads[index];
                  return FadeTransition(
                    opacity: _fadeAnimation,
                    child: SlideTransition(
                      position: _slideAnimation,
                      child: _buildAdCard(ad, context),
                    ),
                  );
                },
              );
            } else if (state is AdsLoading) {
              return const Center(child: CircularProgressIndicator());
            } else {
              return const Center(child: Text('No ads found.'));
            }
          },
        ),
      ),
    );
  }

  Widget _buildAdCard(Ad ad, BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      elevation: 5,
      color: Colors.grey[900],
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  ad.name,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Switch(
                  value: ad.isPublic,
                  onChanged: ad.isPublic
                      ? null // Disable switch if ad is public
                      : (value) {
                          setState(() {
                            ad.isPublic = value;
                          });
                          context.read<AuthCubit>().updateAdVisibility(
                                ad.id,
                                value,
                              );
                        },
                  activeColor: Colors.blue,
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              ad.description,
              style: TextStyle(
                color: Colors.grey[400],
                fontSize: 16,
              ),
            ),
            const SizedBox(height: 8),
            if (ad.link.isNotEmpty)
              Text(
                'Link: ${ad.link}',
                style: TextStyle(
                  color: Colors.blue[300],
                  fontSize: 14,
                ),
              ),
            const SizedBox(height: 16),
            if (ad.mediaFiles.isNotEmpty)
              SizedBox(
                height: 150,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: ad.mediaFiles.length,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.only(right: 8.0),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: ad.video[index]
                            ? AspectRatio(
                                aspectRatio: 16 / 9,
                                child: VideoPlayer(ad.videoControllers[index]!),
                              )
                            : Image.file(
                                ad.mediaFiles[index],
                                fit: BoxFit.cover,
                              ),
                      ),
                    );
                  },
                ),
              ),
            const SizedBox(height: 16),
            if (!ad.isPublic)
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => CreateAdView(ad: ad),
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue[800],
                  padding:
                      const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: const Text(
                  'Edit Ad',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
*/
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:video_player/video_player.dart';
import 'auth_cubit.dart';
import 'create_ad_view.dart'; // Import the CreateAdView to access ad data

class MyAdsPage extends StatefulWidget {
  const MyAdsPage({super.key});

  @override
  _MyAdsPageState createState() => _MyAdsPageState();
}

class _MyAdsPageState extends State<MyAdsPage> with TickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();

    // Initialize animations
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeInOut,
      ),
    );

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0.0, 0.5),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeOutBack,
      ),
    );

    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Ads'),
        backgroundColor: Colors.black,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.add, color: Colors.white),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const CreateAdView()),
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
            colors: [
              Colors.black,
              Colors.blue.shade900.withOpacity(0.6),
              Colors.black,
            ],
            stops: const [0.0, 0.5, 1.0],
          ),
        ),
        child: BlocBuilder<AuthCubit, AuthState>(
          builder: (context, state) {
            if (state is AdsLoaded) {
              final ads = state.Ads; // Corrected to use 'Ads' instead of 'ads'

              return ListView.builder(
                padding: const EdgeInsets.all(16.0),
                itemCount: ads.length,
                itemBuilder: (context, index) {
                  final ad = ads[index];
                  return FadeTransition(
                    opacity: _fadeAnimation,
                    child: SlideTransition(
                      position: _slideAnimation,
                      child: _buildAdCard(ad, context),
                    ),
                  );
                },
              );
            } else if (state is AuthLoading) {
              // Corrected to use 'AuthLoading' instead of 'AdsLoading'
              return const Center(child: CircularProgressIndicator());
            } else {
              return const Center(child: Text('No ads found.'));
            }
          },
        ),
      ),
    );
  }

  Widget _buildAdCard(Map<String, dynamic> ad, BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      elevation: 5,
      color: Colors.grey[900],
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  ad['name'],
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Switch(
                  value: ad['isPublic'] ?? false,
                  onChanged: ad['isPublic'] ?? false
                      ? null // Disable switch if ad is public
                      : (value) {
                          setState(() {
                            ad['isPublic'] = value;
                          });
                          context.read<AuthCubit>().updateAdVisibility(
                                ad['id'],
                                value,
                              );
                        },
                  activeColor: Colors.blue,
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              ad['description'],
              style: TextStyle(
                color: Colors.grey[400],
                fontSize: 16,
              ),
            ),
            const SizedBox(height: 8),
            if (ad['link'] != null && ad['link'].isNotEmpty)
              Text(
                'Link: ${ad['link']}',
                style: TextStyle(
                  color: Colors.blue[300],
                  fontSize: 14,
                ),
              ),
            const SizedBox(height: 16),
            if (ad['mediaFiles'] != null && ad['mediaFiles'].isNotEmpty)
              SizedBox(
                height: 150,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: ad['mediaFiles'].length,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.only(right: 8.0),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: ad['video'][index]
                            ? AspectRatio(
                                aspectRatio: 16 / 9,
                                child:
                                    VideoPlayer(ad['videoControllers'][index]!),
                              )
                            : Image.file(
                                ad['mediaFiles'][index],
                                fit: BoxFit.cover,
                              ),
                      ),
                    );
                  },
                ),
              ),
            const SizedBox(height: 16),
            if (!ad['isPublic'])
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const CreateAdView(),
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue[800],
                  padding:
                      const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: const Text(
                  'Edit Ad',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
