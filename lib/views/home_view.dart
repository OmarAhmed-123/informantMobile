// ignore_for_file: unused_field

import 'package:flutter/material.dart';
import 'dart:async';
// import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:graduation___part1/views/variables.dart';
import 'package:graduation___part1/views/barOfHome.dart';
import 'dart:io';
import 'package:graduation___part1/views/httpCodeG.dart';
import 'package:http/http.dart' as http;

class HomeView extends StatefulWidget {
  const HomeView({super.key});
  @override
  State<HomeView> createState() => homeView();
}

class homeView extends State<HomeView> {
  late PageController verticalPage;
  late ScrollController scrollHorizontal;
  late Timer autoScroll;
  int currentIndexInV = 0;
  bool showSearch = false;

  List<Map<String, dynamic>> _ads = [];
  @override
  void initState() {
    super.initState();
    verticalPage = PageController(viewportFraction: 0.85);
    scrollHorizontal = ScrollController();
    startOfAutoScroll();
    getAds();
    setState(() {
      _ads = ads;
    });
  }

  @override
  void dispose() {
    verticalPage.dispose();
    scrollHorizontal.dispose();
    autoScroll.cancel();
    super.dispose();
  }

  void startOfAutoScroll() {
    autoScroll = Timer.periodic(const Duration(seconds: 3), (timer) {
      if (verticalPage.hasClients) {
        currentIndexInV++;
        if (currentIndexInV >= ads.length) {
          currentIndexInV = 0;
        }
        verticalPage.animateToPage(
          currentIndexInV,
          duration: const Duration(milliseconds: 500),
          curve: Curves.easeInOut,
        );
      }
    });
  }

  Widget horizontalList(double itemWidth, double itemHeight, double heightImg) {
    final ScrollController scrollHorizontal = ScrollController();
    bool isScrollD = false;
    Timer? autoScroll;

    void startOfAutoScroll() {
      autoScroll = Timer.periodic(const Duration(seconds: 2), (_) {
        if (!isScrollD && scrollHorizontal.hasClients) {
          final maxScroll = scrollHorizontal.position.maxScrollExtent;
          final currentScroll = scrollHorizontal.offset;

          if (currentScroll >= maxScroll) {
            scrollHorizontal.jumpTo(0);
          } else {
            scrollHorizontal.animateTo(
              currentScroll + itemWidth,
              duration: const Duration(milliseconds: 900),
              curve: Curves.easeInOut,
            );
          }
        }
      });
    }

    void stopAutoScroll() {
      autoScroll?.cancel();
    }

    WidgetsBinding.instance.addPostFrameCallback((_) {
      startOfAutoScroll();
    });

    @override
    void dispose() {
      stopAutoScroll();
      scrollHorizontal.dispose();
      super.dispose();
    }

    return SizedBox(
      height: itemHeight,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        controller: scrollHorizontal,
        physics: const BouncingScrollPhysics(),
        itemCount: ads.length,
        itemBuilder: (context, index) {
          final ad = ads[index];
          String imgUrl =
              "https://infinitely-native-lamprey.ngrok-free.app/files/image?imgName=${ad["images"][0]}&type=adpics";

          return FutureBuilder<http.Response>(
            future: HttpRequest.get(imgUrl), // Use your get method
            builder: (context, snapshot) {
              Widget imageWidget;

              if (snapshot.connectionState == ConnectionState.waiting) {
                imageWidget = const Center(
                  child: CircularProgressIndicator(),
                );
              } else if (snapshot.hasError ||
                  snapshot.data?.statusCode != 200) {
                imageWidget = const Icon(Icons.broken_image,
                    size: 100, color: Colors.red);
              } else {
                // Render image from raw data
                imageWidget = Image.memory(
                  snapshot.data!.bodyBytes,
                  fit: BoxFit.cover,
                  height: heightImg,
                  width: double.infinity,
                );
              }

              return GestureDetector(
                onTapDown: (_) {
                  isScrollD = true;
                },
                onTapUp: (_) {
                  isScrollD = false;
                },
                child: AnimatedOpacity(
                  duration: const Duration(milliseconds: 500),
                  opacity: 1.0,
                  child: Container(
                    width: itemWidth,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16),
                      gradient: LinearGradient(
                        colors: [Colors.blue.shade900, Colors.black87],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black54.withOpacity(0.4),
                          offset: const Offset(0, 8),
                          blurRadius: 15,
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ClipRRect(
                          borderRadius: const BorderRadius.vertical(
                              top: Radius.circular(16)),
                          child: imageWidget, // Use the dynamic image widget
                        ),
                        Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                ad['name'],
                                style: const TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                ad['details'],
                                style: const TextStyle(
                                  fontSize: 12,
                                  color: Colors.white70,
                                ),
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                              const SizedBox(height: 8),
                              Text(
                                'Potential Revenue: \$${ad['potentialRevenue']}',
                                style: const TextStyle(
                                  fontSize: 12,
                                  color: Colors.greenAccent,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }

  Widget verticalList() {
    return SizedBox(
      height: 400,
      child: GridView.count(
        crossAxisCount: 3,
        crossAxisSpacing: 10,
        mainAxisSpacing: 20,
        childAspectRatio: 1,
        shrinkWrap: true, // Prevents scrolling
        physics: const NeverScrollableScrollPhysics(), // Disables scrolling
        children: List.generate(ads.length, (index) {
          final ad = ads[index];
          String img = ad['images'][0];
          return Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ClipOval(
                child: Image.network(
                  img,
                  width: 80,
                  height: 80,
                  fit: BoxFit.cover,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                ad['name'],
                style: const TextStyle(color: Colors.white),
                textAlign: TextAlign.center,
              ),
            ],
          );
        }),
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
            icon: const Icon(Icons.search, color: Colors.white, size: 30.0),
            onPressed: () {
              setState(() {
                showSearch = true;
              });
            },
          ),
        ],
      ),
      body: Container(
        child: SingleChildScrollView(
          child: Column(
            children: [
              horizontalList(MediaQuery.of(context).size.width, 400, 190),
              const SizedBox(height: 5),
              horizontalList((MediaQuery.of(context).size.width) / 3, 240, 150),
              const SizedBox(height: 5),
              horizontalList((MediaQuery.of(context).size.width) / 3, 240, 150),
              const SizedBox(height: 20),
              verticalList(),
            ],
          ),
        ),
      ),
    );
  }
}
