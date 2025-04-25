import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:graduation___part1/views/profile.dart';
import 'package:graduation___part1/views/editProfile.dart';
import 'package:graduation___part1/views/chatBot.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'ad_detail_view.dart';
import 'package:graduation___part1/views/auth_cubit.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});
  @override
  HomeViewS createState() => HomeViewS();
}

class HomeViewS extends State<HomeView> with TickerProviderStateMixin {
  late AnimationController fadeController;
  late AnimationController slideController;
  late Animation<double> fadeAnimation;
  late Animation<Offset> slideAnimation;
  int currentImageIndex = 0;
  List<Map<String, dynamic>> ads = [];
  List<Profile> profiles = [];
  late Map<String, dynamic> allUser;
  List<Profile> allProfiles = [];
  List<User> userProfile = [];
  bool isLoadingProfiles = true;

  @override
  void initState() {
    super.initState();
    initiAnimations();
    _loadData();
  }

  Future<void> _loadData() async {
    await _loadCachedData();
    _refreshData();
  }

  Future<void> _loadCachedData() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      isLoadingProfiles = true;
    });
    try {
      final cachedAds = prefs.getString('cached_ads');
      if (cachedAds != null) {
        final List<dynamic> decodedAds = json.decode(cachedAds);
        ads = decodedAds.map((ad) => Map<String, dynamic>.from(ad)).toList();
        context.read<AuthCubit>().setCachedAds(ads);
      }
      final cachedProfiles = prefs.getString('cached_profiles');
      if (cachedProfiles != null) {
        final Map<String, dynamic> profiles = json.decode(cachedProfiles);
        users = profiles;
        userProfile = transformUserData(users);
      }
    } catch (e) {
      debugPrint('Error loading cached data: $e');
    }

    setState(() {
      isLoadingProfiles = false;
    });
  }

  Future<void> _refreshData() async {
    await context.read<AuthCubit>().getAds();
    await context.read<AuthCubit>().getProfile();
    setState(() {
      ads = ads1;
      userProfile = transformUserData(users);
    });
    _cacheData();
  }

  Future<void> _cacheData() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      if (ads.isNotEmpty) {
        final String encodedAds = json.encode(ads);
        await prefs.setString('cached_ads', encodedAds);
      }
      if (users.isNotEmpty) {
        final String encodedProfiles = json.encode(users);
        await prefs.setString('cached_profiles', encodedProfiles);
      }
    } catch (e) {
      debugPrint('Error caching data: $e');
    }
  }

  static Future<void> clearCache() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('cached_ads');
    await prefs.remove('cached_profiles');
  }

  void initiAnimations() {
    fadeController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    slideController = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );
    fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: fadeController,
      curve: Curves.easeInOut,
    ));
    slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.2),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: slideController,
      curve: Curves.elasticOut,
    ));
    fadeController.forward();
    slideController.forward();
  }

  @override
  void dispose() {
    fadeController.dispose();
    slideController.dispose();
    super.dispose();
  }

  Widget getProfiles() {
    if (isLoadingProfiles) {
      return Container(
        padding: const EdgeInsets.all(16.0),
        child: SizedBox(
          height: 120,
          child: Center(
            child: CircularProgressIndicator(
              color: Colors.blue.shade700,
            ),
          ),
        ),
      );
    }
    if (userProfile.isEmpty) {
      return Container(
        padding: const EdgeInsets.all(16.0),
        child: SizedBox(
          height: 120,
          child: Center(
            child: Text(
              'No profiles available',
              style: TextStyle(color: Colors.grey[400]),
            ),
          ),
        ),
      );
    }
    return Container(
      padding: const EdgeInsets.all(16.0),
      child: SizedBox(
        height: 120,
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: userProfile.length,
          itemBuilder: (context, index) {
            final user1 = userProfile[index];
            return GestureDetector(
              onTap: () async {
                showDialog(
                  context: context,
                  barrierDismissible: false,
                  builder: (context) => const Center(
                    child: CircularProgressIndicator(
                      color: Colors.blue,
                    ),
                  ),
                );
                final prefs = await SharedPreferences.getInstance();
                final cachedUserDetail =
                    prefs.getString('user_profile_${user1.id}');
                Map<String, dynamic> userDetail = {};
                await prefs.setInt('appear', 1);
                if (cachedUserDetail != null) {
                  userDetail = json.decode(cachedUserDetail);
                  Navigator.pop(context);
                } else {
                  await context.read<AuthCubit>().getProfileById(user1.id);
                  userDetail = oneUser;
                  if (userDetail.isNotEmpty) {
                    await prefs.setString(
                        'user_profile_${user1.id}', json.encode(userDetail));
                  }
                  Navigator.pop(context);
                }
                if (userDetail.isNotEmpty) {
                  Profile profile = Profile(
                    name: userDetail['name'] ?? '',
                    imageUrl: userDetail['imageLink'] ?? '',
                    about: userDetail['details'] ?? '',
                    linkedin: userDetail['linkedIn'],
                    email: userDetail['email'] ?? '',
                    id: userDetail['id'] ?? '',
                    phone: '+1234567890',
                  );
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          ProfilePage(profile: profile, flag: true),
                    ),
                  );
                }
              },
              child: Container(
                margin: const EdgeInsets.only(right: 16.0),
                child: Column(
                  children: [
                    CircleAvatar(
                      radius: 40,
                      backgroundColor: Colors.grey[800],
                      backgroundImage: NetworkImage(user1.imageLink),
                    ),
                    const SizedBox(height: 5),
                    Text(
                      user1.username,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 12),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget buildAdCard(Map<String, dynamic> ad, int index) {
    return SlideTransition(
      position: slideAnimation,
      child: FadeTransition(
        opacity: fadeAnimation,
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Colors.blue.shade900,
                Colors.purple.shade900,
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: Colors.blue.shade900.withOpacity(0.3),
                blurRadius: 15,
                spreadRadius: 5,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Stack(
                children: [
                  ClipRRect(
                    borderRadius:
                        const BorderRadius.vertical(top: Radius.circular(20)),
                    child: CarouselSlider(
                      options: CarouselOptions(
                        height: 200,
                        viewportFraction: 1,
                        autoPlay: true,
                        autoPlayInterval: const Duration(seconds: 3),
                        onPageChanged: (index, reason) {
                          setState(() {
                            currentImageIndex = index;
                          });
                        },
                      ),
                      items: (ad['images'] as List).map((imageUrl) {
                        return Container(
                          width: double.infinity,
                          decoration: BoxDecoration(
                            color: Colors.grey[900],
                          ),
                          child: Image.network(
                            imageUrl,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) {
                              return const Center(
                                child: Icon(Icons.error_outline,
                                    color: Colors.white60, size: 50),
                              );
                            },
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                  Positioned(
                    bottom: 8,
                    right: 8,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: Colors.black54,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Row(
                        children: [
                          const Icon(Icons.star, color: Colors.amber, size: 16),
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
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.all(16),
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
                            color: Colors.green.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(
                            '${ad['availablePlaces']} places',
                            style: const TextStyle(
                              color: Colors.green,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(
                      ad['details'],
                      style: TextStyle(
                        color: Colors.grey[300],
                        fontSize: 16,
                      ),
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Potential Revenue',
                              style: TextStyle(color: Colors.grey[400]),
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
                        ElevatedButton(
                          onPressed: () async {
                            SharedPreferences prefs =
                                await SharedPreferences.getInstance();
                            await prefs.setInt('from', 1);
                            final adData = Map<String, dynamic>.from(ad);
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => AdDetailView(ad: adData),
                              ),
                            );
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.blue.shade700,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(
                                horizontal: 24, vertical: 12),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30),
                            ),
                            elevation: 8,
                          ),
                          child: const Text(
                            'View Details',
                            style: TextStyle(
                              fontSize: 16,
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
      ),
    );
  }

  Widget iconChatButton(BuildContext context) {
    return Container(
      height: 65,
      width: 65,
      margin: const EdgeInsets.only(bottom: 10, right: 6),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Colors.blue.shade800,
            Colors.blue.shade900,
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(22),
        boxShadow: [
          BoxShadow(
            color: Colors.blue.shade900.withOpacity(0.6),
            spreadRadius: 1,
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
          BoxShadow(
            color: Colors.black.withOpacity(0.3),
            spreadRadius: 1,
            blurRadius: 16,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(22),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const ChatBot()),
            );
          },
          child: Stack(
            alignment: Alignment.center,
            children: [
              const Icon(
                Icons.chat_bubble_rounded,
                color: Colors.white,
                size: 30,
              ),
              Positioned(
                top: 15,
                right: 16,
                child: Container(
                  width: 10,
                  height: 10,
                  decoration: BoxDecoration(
                    color: Colors.greenAccent,
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.blue.shade900, width: 1.5),
                  ),
                ),
              ),
              Positioned.fill(
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(22),
                    border: Border.all(
                      color: Colors.white.withOpacity(0.15),
                      width: 2,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: iconChatButton(context),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Colors.black,
              Colors.blue.shade900.withOpacity(0.6),
              Colors.black,
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: BlocBuilder<AuthCubit, AuthState>(
          builder: (context, state) {
            if ((state is AuthLoading) &&
                (ads.isEmpty && userProfile.isEmpty)) {
              return const Center(
                child: CircularProgressIndicator(
                  color: Colors.blue,
                ),
              );
            } else if (state is AdsLoaded || ads.isNotEmpty) {
              final displayedAds = state is AdsLoaded ? state.Ads : ads;
              return CustomScrollView(
                slivers: [
                  SliverToBoxAdapter(
                    child: getProfiles(),
                  ),
                  SliverList(
                    delegate: SliverChildBuilderDelegate(
                      (context, index) {
                        return buildAdCard(displayedAds[index], index);
                      },
                      childCount: displayedAds.length,
                    ),
                  ),
                ],
              );
            } else if (state is AuthFailure) {
              if (ads.isNotEmpty || userProfile.isNotEmpty) {
                return CustomScrollView(
                  slivers: [
                    SliverToBoxAdapter(
                      child: getProfiles(),
                    ),
                    SliverList(
                      delegate: SliverChildBuilderDelegate(
                        (context, index) {
                          return buildAdCard(ads[index], index);
                        },
                        childCount: ads.length,
                      ),
                    ),
                  ],
                );
              }
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Error: ${state.error}',
                      style: const TextStyle(color: Colors.white),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: () {
                        _refreshData();
                      },
                      child: const Text('Retry'),
                    ),
                  ],
                ),
              );
            } else if (userProfile.isNotEmpty || ads.isNotEmpty) {
              return CustomScrollView(
                slivers: [
                  SliverToBoxAdapter(
                    child: getProfiles(),
                  ),
                  SliverList(
                    delegate: SliverChildBuilderDelegate(
                      (context, index) {
                        if (index < ads.length) {
                          return buildAdCard(ads[index], index);
                        }
                        return null;
                      },
                      childCount: ads.length,
                    ),
                  ),
                ],
              );
            } else {
              return const Center(
                child: CircularProgressIndicator(
                  color: Colors.blue,
                ),
              );
            }
          },
        ),
      ),
    );
  }
}
