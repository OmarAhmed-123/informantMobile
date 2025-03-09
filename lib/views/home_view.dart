/*
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
*/

/*
import 'package:dio/dio.dart';
import 'package:dio_cookie_manager/dio_cookie_manager.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'package:graduation___part1/views/variables.dart';
import 'package:graduation___part1/views/barOfHome.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:cookie_jar/cookie_jar.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart';
import 'package:shared_preferences/shared_preferences.dart';

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

  // ignore: unused_field
  List<Map<String, dynamic>> _ads = [];
  late Dio dio;
  late PersistCookieJar cookieJar;

  @override
  void initState() {
    super.initState();
    verticalPage = PageController(viewportFraction: 0.85);
    scrollHorizontal = ScrollController();
    startOfAutoScroll();
    initDio();

    // Use WidgetsBinding to ensure the context is valid
    WidgetsBinding.instance.addPostFrameCallback((_) {
      fetchAds();
    });
  }

  // Fetch ads using AdsCubit
  void fetchAds() {
    // Ensure the context is valid
    if (mounted) {
      BlocProvider.of<AdsCubit>(context as BuildContext).getAds();
    }
  }

  Future<void> initDio() async {
    try {
      final appDocDir = await getApplicationDocumentsDirectory();
      final cookiePath = join(appDocDir.path, 'cookies');
      cookieJar = PersistCookieJar(storage: FileStorage(cookiePath));
      dio = Dio();
      dio.interceptors.add(CookieManager(cookieJar));
    } catch (e) {
      print('Error initializing Dio: $e');
    }
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

          return FutureBuilder<Response>(
            future: dio.get(imgUrl), // Use dio for the request
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
                  snapshot.data!.data,
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
*/

import 'package:dio/dio.dart';
import 'package:dio_cookie_manager/dio_cookie_manager.dart';
import 'package:flutter/material.dart';
import 'package:graduation___part1/views/profile.dart';
import 'dart:async';
import 'dart:typed_data';
import 'package:graduation___part1/views/variables.dart';
import 'package:graduation___part1/views/barOfHome.dart';
import 'package:graduation___part1/views/editProfile.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:cookie_jar/cookie_jar.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});
  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  late PageController verticalPage;
  late ScrollController scrollHorizontal;
  late Timer autoScroll;
  int currentIndexInV = 0;
  bool showSearch = false;

  List<Map<String, dynamic>> _ads = [];
  late Dio dio;
  late PersistCookieJar cookieJar;
  bool _isDioInitialized = false;

  @override
  void initState() {
    super.initState();
    verticalPage = PageController(viewportFraction: 0.85);
    scrollHorizontal = ScrollController();
    startOfAutoScroll();
    initDio().then((_) {
      if (mounted) {
        setState(() {
          _isDioInitialized = true;
        });
        fetchAds();
      }
    });
  }

  Future<void> initDio() async {
    try {
      final appDocDir = await getApplicationDocumentsDirectory();
      final cookiePath = join(appDocDir.path, 'cookies');
      cookieJar = PersistCookieJar(storage: FileStorage(cookiePath));
      dio = Dio();
      dio.interceptors.add(CookieManager(cookieJar));
    } catch (e) {
      print('Error initializing Dio: $e');
    }
  }

  void fetchAds() {
    if (mounted) {
      BlocProvider.of<AdsCubit>(context as BuildContext).getAds();
    }
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
          String imgUrl = ad["images"][0];

          return FutureBuilder<Response>(
            future: dio.get(imgUrl,
                options: Options(responseType: ResponseType.bytes)),
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
                // Decode the image bytes into Uint8List
                Uint8List imageBytes = Uint8List.fromList(snapshot.data!.data);
                imageWidget = Image.memory(
                  imageBytes,
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
                          child: imageWidget,
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

  Widget getProfiles() {
    return SizedBox(
      height: 120, // Fixed height for the horizontal list
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.all(16.0),
        itemCount: fakeProfiles.length,
        itemBuilder: (context, index) {
          final profile = fakeProfiles[index];
          return GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ProfilePage(profile: profile),
                ),
              );
            },
            child: Container(
              margin: const EdgeInsets.only(right: 16.0),
              child: Column(
                children: [
                  CircleAvatar(
                    radius: 40,
                    backgroundColor: Colors.grey[800],
                    backgroundImage: NetworkImage(profile.imageUrl),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    profile.name,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
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
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
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
              getProfiles(),
              const SizedBox(height: 5),
              if (_isDioInitialized) ...[
                horizontalList(MediaQuery.of(context).size.width, 400, 190),
                const SizedBox(height: 5),
                horizontalList(
                    (MediaQuery.of(context).size.width) / 3, 240, 150),
                const SizedBox(height: 5),
                horizontalList(
                    (MediaQuery.of(context).size.width) / 3, 240, 150),
                const SizedBox(height: 20),
                verticalList(),
              ] else ...[
                const Center(
                  child: CircularProgressIndicator(),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
