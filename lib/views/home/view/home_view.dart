/*
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:graduation___part1/views/barOfHome.dart';

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
  final List<Map<String, dynamic>> ads = [
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

  @override
  void initState() {
    super.initState();
    verticalPage = PageController(viewportFraction: 0.85);
    scrollHorizontal = ScrollController();

    startOfAutoScroll();
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

  Widget horizontalList(double itemWidth, double itemHeight) {
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
              currentScroll + itemWidth, // Auto scroll by the item width
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
      height:
          itemHeight, // Set the height of the list to the provided itemHeight
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        controller: scrollHorizontal,
        physics: const BouncingScrollPhysics(),
        itemCount: ads.length,
        itemBuilder: (context, index) {
          final ad = ads[index];
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
                width: itemWidth, // Set width to the provided itemWidth
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
                      borderRadius:
                          const BorderRadius.vertical(top: Radius.circular(16)),
                      child: Image.network(
                        ad['images'][0],
                        fit: BoxFit.cover,
                        height: 150,
                        width: double.infinity,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            ad['name'],
                            style: const TextStyle(
                              fontSize: 16,
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
          return Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ClipOval(
                child: Image.network(
                  ad['images'][0],
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
              horizontalList(MediaQuery.of(context).size.width, 420),
              const SizedBox(height: 5),
              horizontalList((MediaQuery.of(context).size.width) / 3, 220),
              const SizedBox(height: 5),
              horizontalList((MediaQuery.of(context).size.width) / 3, 220),
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
//old version
import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:graduation___part1/views/barOfHome.dart';
import 'package:graduation___part1/views/httpCodeG.dart';

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
  Future<Map<String, dynamic>> fetchHomeData() async {
    final response = await HttpRequest.get("/user/home");
    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to load home data');
    }
  }

  late Map<String, dynamic> ads = {};
  @override
  void initState() {
    super.initState();
    verticalPage = PageController(viewportFraction: 0.85);
    scrollHorizontal = ScrollController();
    startOfAutoScroll();
    fetchHomeData().then((data) {
      setState(() {
        ads = data;
      });
    }).catchError((error) {
      print('Error fetching data: $error');
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

  Widget horizontalList(double itemWidth, double itemHeight) {
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
          String img =
              "https://infinitely-native-lamprey.ngrok-free/files/image?imgName=${ad['images'][0]}&type=adpics";
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
                      borderRadius:
                          const BorderRadius.vertical(top: Radius.circular(16)),
                      child: Image.network(
                        img,
                        fit: BoxFit.cover,
                        height: 150,
                        width: double.infinity,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            ad['name'],
                            style: const TextStyle(
                              fontSize: 16,
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
          String img =
              "https://infinitely-native-lamprey.ngrok-free/files/image?imgName=${ad['images'][0]}&type=adpics";
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
              horizontalList(MediaQuery.of(context).size.width, 420),
              const SizedBox(height: 5),
              horizontalList((MediaQuery.of(context).size.width) / 3, 220),
              const SizedBox(height: 5),
              horizontalList((MediaQuery.of(context).size.width) / 3, 220),
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
//the code include the new connection only
// ignore_for_file: camel_case_types

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'dart:async';

// Feature imports
import '../features/api/cubit/api_cubit.dart';
import 'barOfHome.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => homeView();
}

class homeView extends State<HomeView> {
  // Controllers
  late PageController _verticalPage;
  late ScrollController _scrollHorizontal;
  late Timer _autoScroll;

  // State variables
  int _currentIndexInV = 0;
  bool _showSearch = false;
  Map<String, dynamic> _ads = {};

  @override
  void initState() {
    super.initState();
    _initializeControllers();
    _fetchHomeData();
  }

  /// Initialize controllers and auto-scroll
  void _initializeControllers() {
    _verticalPage = PageController(viewportFraction: 0.85);
    _scrollHorizontal = ScrollController();
    _startAutoScroll();
  }

  /// Fetch home data using ApiCubit
  void _fetchHomeData() {
    // BACKEND CONNECTION: Fetch home data
    context.read<ApiCubit>().makeGetRequest('/user/home');
  }

  @override
  void dispose() {
    _verticalPage.dispose();
    _scrollHorizontal.dispose();
    _autoScroll.cancel();
    super.dispose();
  }

  /// Start auto-scroll timer for vertical page view
  void _startAutoScroll() {
    _autoScroll = Timer.periodic(const Duration(seconds: 3), (timer) {
      if (_verticalPage.hasClients) {
        _currentIndexInV++;
        if (_currentIndexInV >= _ads.length) {
          _currentIndexInV = 0;
        }
        _verticalPage.animateToPage(
          _currentIndexInV,
          duration: const Duration(milliseconds: 500),
          curve: Curves.easeInOut,
        );
      }
    });
  }

  /// Build horizontal scrolling list
  Widget _buildHorizontalList(double itemWidth, double itemHeight) {
    final ScrollController scrollController = ScrollController();
    bool isScrolling = false;
    Timer? autoScroll;

    void startAutoScroll() {
      autoScroll = Timer.periodic(const Duration(seconds: 2), (_) {
        if (!isScrolling && scrollController.hasClients) {
          final maxScroll = scrollController.position.maxScrollExtent;
          final currentScroll = scrollController.offset;

          if (currentScroll >= maxScroll) {
            scrollController.jumpTo(0);
          } else {
            scrollController.animateTo(
              currentScroll + itemWidth,
              duration: const Duration(milliseconds: 900),
              curve: Curves.easeInOut,
            );
          }
        }
      });
    }

    WidgetsBinding.instance.addPostFrameCallback((_) {
      startAutoScroll();
    });

    return SizedBox(
      height: itemHeight,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        controller: scrollController,
        physics: const BouncingScrollPhysics(),
        itemCount: _ads.length,
        itemBuilder: (context, index) {
          final ad = _ads[index];
          final imageUrl =
              "https://infinitely-native-lamprey.ngrok-free/files/image?imgName=${ad['images'][0]}&type=adpics";

          return GestureDetector(
            onTapDown: (_) => isScrolling = true,
            onTapUp: (_) => isScrolling = false,
            child: _buildAdCard(imageUrl, ad, itemWidth),
          );
        },
      ),
    );
  }

  /// Build advertisement card
  Widget _buildAdCard(String imageUrl, Map<String, dynamic> ad, double width) {
    return AnimatedOpacity(
      duration: const Duration(milliseconds: 500),
      opacity: 1.0,
      child: Container(
        width: width,
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
              borderRadius:
                  const BorderRadius.vertical(top: Radius.circular(16)),
              child: Image.network(
                imageUrl,
                fit: BoxFit.cover,
                height: 150,
                width: double.infinity,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    ad['name'],
                    style: const TextStyle(
                      fontSize: 16,
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
    );
  }

  /// Build vertical grid list
  Widget _buildVerticalList() {
    return SizedBox(
      height: 400,
      child: GridView.count(
        crossAxisCount: 3,
        crossAxisSpacing: 10,
        mainAxisSpacing: 20,
        childAspectRatio: 1,
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        children: List.generate(_ads.length, (index) {
          final ad = _ads[index];
          final imageUrl =
              "https://infinitely-native-lamprey.ngrok-free/files/image?imgName=${ad['images'][0]}&type=adpics";

          return Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ClipOval(
                child: Image.network(
                  imageUrl,
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
            onPressed: () => setState(() => _showSearch = true),
          ),
        ],
      ),
      body: BlocConsumer<ApiCubit, ApiState>(
        listener: (context, state) {
          state.when(
            initial: () {},
            loading: () {},
            success: (data) => setState(() => _ads = data),
            error: (error) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Error: ${error.message}')),
              );
            },
          );
        },
        builder: (context, state) {
          return state.maybeWhen(
            loading: () => const Center(
              child: CircularProgressIndicator(color: Colors.white),
            ),
            orElse: () => SingleChildScrollView(
              child: Column(
                children: [
                  _buildHorizontalList(MediaQuery.of(context).size.width, 420),
                  const SizedBox(height: 5),
                  _buildHorizontalList(
                      MediaQuery.of(context).size.width / 3, 220),
                  const SizedBox(height: 5),
                  _buildHorizontalList(
                      MediaQuery.of(context).size.width / 3, 220),
                  const SizedBox(height: 20),
                  _buildVerticalList(),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
*/

/*
//this code include the both new connection and more animation
// ignore_for_file: camel_case_types
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'dart:async';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';

// Feature imports
import '../features/api/cubit/api_cubit.dart';
import 'barOfHome.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> with TickerProviderStateMixin {
  // Controllers
  late PageController _verticalPage;
  late ScrollController _scrollHorizontal;
  late Timer _autoScroll;
  late AnimationController _fadeController;
  late AnimationController _scaleController;

  // Animations
  late Animation<double> _fadeAnimation;
  late Animation<double> _scaleAnimation;

  // State variables
  int _currentIndexInV = 0;
  bool _showSearch = false;
  Map<String, dynamic> _ads = {};

  @override
  void initState() {
    super.initState();
    _initializeControllers();
    _initializeAnimations();
    _fetchHomeData();
  }

  /// Initialize animations
  void _initializeAnimations() {
    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    _scaleController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _fadeController, curve: Curves.easeIn),
    );

    _scaleAnimation = Tween<double>(begin: 0.8, end: 1.0).animate(
      CurvedAnimation(parent: _scaleController, curve: Curves.easeOutBack),
    );

    _fadeController.forward();
    _scaleController.forward();
  }

  /// Initialize controllers and auto-scroll
  void _initializeControllers() {
    _verticalPage = PageController(viewportFraction: 0.85);
    _scrollHorizontal = ScrollController();
    _startAutoScroll();
  }

  /// Fetch home data using ApiCubit
  void _fetchHomeData() {
    context.read<ApiCubit>().makePostRequest('/user/home', _ads);

    
  }

  @override
  void dispose() {
    _verticalPage.dispose();
    _scrollHorizontal.dispose();
    _autoScroll.cancel();
    _fadeController.dispose();
    _scaleController.dispose();
    super.dispose();
  }

  /// Start auto-scroll timer for vertical page view
  void _startAutoScroll() {
    _autoScroll = Timer.periodic(const Duration(seconds: 3), (timer) {
      if (_verticalPage.hasClients) {
        _currentIndexInV = (_currentIndexInV + 1) % _ads.length;
        _verticalPage.animateToPage(
          _currentIndexInV,
          duration: const Duration(milliseconds: 500),
          curve: Curves.easeInOut,
        );
      }
    });
  }

  /// Build horizontal scrolling list with enhanced animations
  Widget _buildHorizontalList(double itemWidth, double itemHeight) {
    final ScrollController scrollController = ScrollController();
    bool isScrolling = false;
    Timer? autoScroll;

    void startAutoScroll() {
      autoScroll = Timer.periodic(const Duration(seconds: 2), (_) {
        if (!isScrolling && scrollController.hasClients) {
          final maxScroll = scrollController.position.maxScrollExtent;
          final currentScroll = scrollController.offset;

          if (currentScroll >= maxScroll) {
            scrollController.jumpTo(0);
          } else {
            scrollController.animateTo(
              currentScroll + itemWidth,
              duration: const Duration(milliseconds: 900),
              curve: Curves.easeInOut,
            );
          }
        }
      });
    }

    WidgetsBinding.instance.addPostFrameCallback((_) => startAutoScroll());

    return AnimationConfiguration.synchronized(
      duration: const Duration(milliseconds: 800),
      child: SlideAnimation(
        horizontalOffset: 50.0,
        child: FadeInAnimation(
          child: SizedBox(
            height: itemHeight,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              controller: scrollController,
              physics: const BouncingScrollPhysics(),
              itemCount: _ads.length,
              itemBuilder: (context, index) {
                final ad = _ads[index];
                final imageUrl =
                    "https://infinitely-native-lamprey.ngrok-free/files/image?imgName=${ad['images'][0]}&type=adpics";

                return AnimationConfiguration.staggeredList(
                  position: index,
                  duration: const Duration(milliseconds: 500),
                  child: SlideAnimation(
                    horizontalOffset: 50.0,
                    child: FadeInAnimation(
                      child: GestureDetector(
                        onTapDown: (_) => isScrolling = true,
                        onTapUp: (_) => isScrolling = false,
                        child: _buildAdCard(imageUrl, ad, itemWidth),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ),
      ),
    );
  }

  /// Build advertisement card with enhanced animations
  Widget _buildAdCard(String imageUrl, Map<String, dynamic> ad, double width) {
    return AnimatedBuilder(
      animation: _scaleAnimation,
      builder: (context, child) {
        return Transform.scale(
          scale: _scaleAnimation.value,
          child: Container(
            width: width,
            margin: const EdgeInsets.all(8.0),
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
            child: FadeTransition(
              opacity: _fadeAnimation,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Hero(
                    tag: 'ad_image_${ad['id']}',
                    child: ClipRRect(
                      borderRadius:
                          const BorderRadius.vertical(top: Radius.circular(16)),
                      child: Image.network(
                        imageUrl,
                        fit: BoxFit.cover,
                        height: 150,
                        width: double.infinity,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          ad['name'],
                          style: const TextStyle(
                            fontSize: 16,
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
                        ShaderMask(
                          shaderCallback: (bounds) => const LinearGradient(
                            colors: [Colors.greenAccent, Colors.tealAccent],
                          ).createShader(bounds),
                          child: Text(
                            'Potential Revenue: \$${ad['potentialRevenue']}',
                            style: const TextStyle(
                              fontSize: 12,
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
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
  }

  /// Build vertical grid list with staggered animations
  Widget _buildVerticalList() {
    return SizedBox(
      height: 400,
      child: AnimationLimiter(
        child: GridView.count(
          crossAxisCount: 3,
          crossAxisSpacing: 10,
          mainAxisSpacing: 20,
          childAspectRatio: 1,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          children: List.generate(_ads.length, (index) {
            final ad = _ads[index];
            final imageUrl =
                "https://infinitely-native-lamprey.ngrok-free/files/image?imgName=${ad['images'][0]}&type=adpics";

            return AnimationConfiguration.staggeredGrid(
              position: index,
              duration: const Duration(milliseconds: 500),
              columnCount: 3,
              child: ScaleAnimation(
                child: FadeInAnimation(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      TweenAnimationBuilder(
                        tween: Tween<double>(begin: 0, end: 1),
                        duration: const Duration(milliseconds: 500),
                        builder: (context, double value, child) {
                          return Transform.scale(
                            scale: value,
                            child: child,
                          );
                        },
                        child: ClipOval(
                          child: Image.network(
                            imageUrl,
                            width: 80,
                            height: 80,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        ad['name'],
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w500,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
              ),
            );
          }),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: TweenAnimationBuilder(
          tween: Tween<double>(begin: 0, end: 1),
          duration: const Duration(milliseconds: 500),
          builder: (context, double value, child) {
            return Transform.scale(
              scale: value,
              child: child,
            );
          },
          child: IconButton(
            icon: const Icon(Icons.person, color: Colors.white),
            onPressed: () {
              Navigator.push(
                context,
                PageRouteBuilder(
                  pageBuilder: (context, animation, secondaryAnimation) =>
                      const HomeView1(),
                  transitionsBuilder:
                      (context, animation, secondaryAnimation, child) {
                    return FadeTransition(
                      opacity: animation,
                      child: child,
                    );
                  },
                ),
              );
            },
          ),
        ),
        actions: [
          TweenAnimationBuilder(
            tween: Tween<double>(begin: 0, end: 1),
            duration: const Duration(milliseconds: 500),
            builder: (context, double value, child) {
              return Transform.scale(
                scale: value,
                child: child,
              );
            },
            child: IconButton(
              icon: const Icon(Icons.search, color: Colors.white, size: 30.0),
              onPressed: () => setState(() => _showSearch = true),
            ),
          ),
        ],
      ),
      body: BlocConsumer<ApiCubit, ApiState>(
        listener: (context, state) {
          state.when(
            unverified: () {},
            initial: () {},
            loading: () {},
            success: (data) => setState(() => _ads = data),
            error: (error) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Error: ${error.message}')),
              );
            },
          );
        },
        builder: (context, state) {
          return state.maybeWhen(
            loading: () => const Center(
              child: CircularProgressIndicator(color: Colors.white),
            ),
            orElse: () => SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: AnimationLimiter(
                child: Column(
                  children: AnimationConfiguration.toStaggeredList(
                    duration: const Duration(milliseconds: 600),
                    childAnimationBuilder: (widget) => SlideAnimation(
                      verticalOffset: 50.0,
                      child: FadeInAnimation(child: widget),
                    ),
                    children: [
                      _buildHorizontalList(
                          MediaQuery.of(context).size.width, 420),
                      const SizedBox(height: 5),
                      _buildHorizontalList(
                          MediaQuery.of(context).size.width / 3, 220),
                      const SizedBox(height: 5),
                      _buildHorizontalList(
                          MediaQuery.of(context).size.width / 3, 220),
                      const SizedBox(height: 20),
                      _buildVerticalList(),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
*/

/*
// ignore_for_file: camel_case_types
import 'package:flutter/material.dart';
import 'dart:async';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:graduation___part1/variables.dart';

// Local data import
import '../../barOfHome.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> with TickerProviderStateMixin {
  // Controllers
  late PageController _verticalPage;
  late ScrollController _scrollHorizontal;
  late Timer _autoScroll;
  late AnimationController _fadeController;
  late AnimationController _scaleController;
  late AnimationController _slideController;

  // Animations
  late Animation<double> _fadeAnimation;
  late Animation<double> _scaleAnimation;
  late Animation<Offset> _slideAnimation;

  // State variables
  int _currentIndexInV = 0;
  bool _showSearch = false;
  List<Map<String, dynamic>> _ads = [];

  @override
  void initState() {
    super.initState();
    _initializeControllers();
    _initializeAnimations();
    setState(() {
      _ads = ads;
    });
  }

  /// Initialize animations with enhanced timing and curves
  void _initializeAnimations() {
    // Fade animation controller
    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );

    // Scale animation controller
    _scaleController = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );

    // Slide animation controller
    _slideController = AnimationController(
      duration: const Duration(milliseconds: 700),
      vsync: this,
    );

    // Initialize animations with custom curves
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _fadeController, curve: Curves.easeIn),
    );

    _scaleAnimation = Tween<double>(begin: 0.95, end: 1.0).animate(
      CurvedAnimation(parent: _scaleController, curve: Curves.elasticOut),
    );

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0.2, 0),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(parent: _slideController, curve: Curves.easeOutCubic),
    );

    // Start animations
    _fadeController.forward();
    _scaleController.forward();
    _slideController.forward();
  }

  /// Initialize controllers with optimized settings
  void _initializeControllers() {
    _verticalPage = PageController(
      viewportFraction: 0.85,
      initialPage: 0,
    );
    _scrollHorizontal = ScrollController();
    _startAutoScroll();
  }

  @override
  void dispose() {
    _verticalPage.dispose();
    _scrollHorizontal.dispose();
    _autoScroll.cancel();
    _fadeController.dispose();
    _scaleController.dispose();
    _slideController.dispose();
    super.dispose();
  }

  /// Enhanced auto-scroll with smooth transitions
  void _startAutoScroll() {
    _autoScroll = Timer.periodic(const Duration(seconds: 4), (timer) {
      if (_verticalPage.hasClients) {
        _currentIndexInV = (_currentIndexInV + 1) % _ads.length;
        _verticalPage.animateToPage(
          _currentIndexInV,
          duration: const Duration(milliseconds: 800),
          curve: Curves.easeInOutCubic,
        );
      }
    });
  }

  /// Build optimized horizontal list with enhanced animations
  Widget _buildHorizontalList(double itemWidth, double itemHeight) {
    final ScrollController scrollController = ScrollController();
    bool isScrolling = false;
    Timer? autoScroll;

    void startAutoScroll() {
      autoScroll = Timer.periodic(const Duration(seconds: 3), (_) {
        if (!isScrolling && scrollController.hasClients) {
          final maxScroll = scrollController.position.maxScrollExtent;
          final currentScroll = scrollController.offset;

          if (currentScroll >= maxScroll) {
            scrollController.animateTo(
              0,
              duration: const Duration(milliseconds: 1200),
              curve: Curves.easeInOutCubic,
            );
          } else {
            scrollController.animateTo(
              currentScroll + itemWidth,
              duration: const Duration(milliseconds: 800),
              curve: Curves.easeInOutCubic,
            );
          }
        }
      });
    }

    WidgetsBinding.instance.addPostFrameCallback((_) => startAutoScroll());

    return SizedBox(
      height: itemHeight,
      child: AnimationLimiter(
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          controller: scrollController,
          physics: const BouncingScrollPhysics(),
          itemCount: _ads.length,
          itemBuilder: (context, index) {
            return AnimationConfiguration.staggeredList(
              position: index,
              duration: const Duration(milliseconds: 600),
              child: SlideAnimation(
                horizontalOffset: 50.0,
                child: FadeInAnimation(
                  child: GestureDetector(
                    onTapDown: (_) => isScrolling = true,
                    onTapUp: (_) => isScrolling = false,
                    child: _buildAdCard(
                      _ads[index]['images'][0],
                      _ads[index],
                      itemWidth * 0.9, // Reduced card width
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  /// Build optimized ad card with enhanced visual effects
  Widget _buildAdCard(String imageUrl, Map<String, dynamic> ad, double width) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
      child: Container(
        width: width,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          gradient: LinearGradient(
            colors: [
              Colors.blue.shade900.withOpacity(0.9),
              Colors.black87.withOpacity(0.95),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black26,
              offset: const Offset(0, 4),
              blurRadius: 12,
              spreadRadius: 2,
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image section with hero animation
            Hero(
              tag: 'ad_image_${ad['name']}',
              child: ClipRRect(
                borderRadius:
                    const BorderRadius.vertical(top: Radius.circular(12)),
                child: Image.network(
                  imageUrl,
                  height: 120, // Reduced image height
                  width: double.infinity,
                  fit: BoxFit.cover,
                  loadingBuilder: (context, child, loadingProgress) {
                    if (loadingProgress == null) return child;
                    return Container(
                      height: 120,
                      color: Colors.grey[850],
                      child: const Center(
                        child: CircularProgressIndicator(
                          valueColor:
                              AlwaysStoppedAnimation<Color>(Colors.white),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
            // Content section with optimized padding
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Title with gradient effect
                  ShaderMask(
                    shaderCallback: (bounds) => LinearGradient(
                      colors: [Colors.white, Colors.white.withOpacity(0.9)],
                    ).createShader(bounds),
                    child: Text(
                      ad['name'],
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  const SizedBox(height: 4),
                  // Details with optimized style
                  Text(
                    ad['details'],
                    style: TextStyle(
                      fontSize: 11,
                      color: Colors.grey[300],
                      height: 1.2,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 6),
                  // Revenue display with animated gradient
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          Colors.green.withOpacity(0.3),
                          Colors.teal.withOpacity(0.3),
                        ],
                      ),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Text(
                      '\$${ad['potentialRevenue']}',
                      style: const TextStyle(
                        fontSize: 11,
                        color: Colors.greenAccent,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Build optimized vertical grid with staggered animations
  Widget _buildVerticalList() {
    return SizedBox(
      height: 350, // Reduced height
      child: AnimationLimiter(
        child: GridView.count(
          crossAxisCount: 3,
          crossAxisSpacing: 8, // Reduced spacing
          mainAxisSpacing: 16,
          childAspectRatio: 0.9, // Adjusted for better proportions
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          children: List.generate(_ads.length, (index) {
            final ad = _ads[index];
            return AnimationConfiguration.staggeredGrid(
              position: index,
              duration: const Duration(milliseconds: 500),
              columnCount: 3,
              child: ScaleAnimation(
                scale: 0.9,
                child: FadeInAnimation(
                  child: _buildGridItem(ad),
                ),
              ),
            );
          }),
        ),
      ),
    );
  }

  /// Build optimized grid item with enhanced visuals
  Widget _buildGridItem(Map<String, dynamic> ad) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        // Circular image with shadow
        Container(
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: Colors.black26,
                blurRadius: 8,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: ClipOval(
            child: Image.network(
              ad['images'][0],
              width: 70, // Reduced size
              height: 70,
              fit: BoxFit.cover,
            ),
          ),
        ),
        const SizedBox(height: 6),
        // Title with optimized style
        Text(
          ad['name'],
          style: const TextStyle(
            color: Colors.white,
            fontSize: 12,
            fontWeight: FontWeight.w500,
          ),
          textAlign: TextAlign.center,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      extendBodyBehindAppBar: true,
      appBar: _buildAnimatedAppBar(),
      body: _buildAnimatedBody(),
    );
  }

  /// Build animated app bar with enhanced transitions
  PreferredSizeWidget _buildAnimatedAppBar() {
    return AppBar(
      backgroundColor: Colors.transparent,
      elevation: 0,
      leading: _buildAnimatedIcon(
        icon: Icons.person,
        onPressed: () => Navigator.push(
          context,
          PageRouteBuilder(
            pageBuilder: (context, animation, secondaryAnimation) =>
                const HomeView1(),
            transitionsBuilder:
                (context, animation, secondaryAnimation, child) {
              return FadeTransition(opacity: animation, child: child);
            },
            transitionDuration: const Duration(milliseconds: 400),
          ),
        ),
      ),
      actions: [
        _buildAnimatedIcon(
          icon: Icons.search,
          onPressed: () => setState(() => _showSearch = true),
          size: 30.0,
        ),
      ],
    );
  }

  /// Build animated icon with scale animation
  Widget _buildAnimatedIcon({
    required IconData icon,
    required VoidCallback onPressed,
    double size = 24.0,
  }) {
    return ScaleTransition(
      scale: _scaleAnimation,
      child: IconButton(
        icon: Icon(icon, color: Colors.white, size: size),
        onPressed: onPressed,
      ),
    );
  }

  /// Build animated body with staggered animations
  Widget _buildAnimatedBody() {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      child: AnimationLimiter(
        child: Column(
          children: AnimationConfiguration.toStaggeredList(
            duration: const Duration(milliseconds: 600),
            childAnimationBuilder: (widget) => SlideAnimation(
              verticalOffset: 30.0,
              child: FadeInAnimation(child: widget),
            ),
            children: [
              _buildHorizontalList(MediaQuery.of(context).size.width, 300),
              const SizedBox(height: 4),
              _buildHorizontalList(
                  MediaQuery.of(context).size.width / 2.2, 200),
              const SizedBox(height: 4),
              _buildHorizontalList(
                  MediaQuery.of(context).size.width / 2.2, 200),
              const SizedBox(height: 16),
              _buildVerticalList(),
            ],
          ),
        ),
      ),
    );
  }
}

*/
import 'package:flutter/material.dart';
import 'package:graduation___part1/views/home/Bar_home/view/barOfHome.dart';
import 'package:provider/provider.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import '../view_model/home_view_model.dart';
import 'widgets/horizontal_list.dart';
import 'widgets/vertical_grid.dart';

class HomeView extends StatefulWidget {
  const HomeView({Key? key}) : super(key: key);

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> with TickerProviderStateMixin {
  late AnimationController _fadeController;
  late AnimationController _scaleController;
  late AnimationController _slideController;
  late Animation<double> _fadeAnimation;
  late Animation<double> _scaleAnimation;
  late Animation<Offset> _slideAnimation;
  late HomeViewModel _viewModel;

  @override
  void initState() {
    super.initState();
    _initializeAnimations();
    _viewModel = HomeViewModel();
  }

  void _initializeAnimations() {
    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );
    _scaleController = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );
    _slideController = AnimationController(
      duration: const Duration(milliseconds: 700),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _fadeController, curve: Curves.easeIn),
    );
    _scaleAnimation = Tween<double>(begin: 0.95, end: 1.0).animate(
      CurvedAnimation(parent: _scaleController, curve: Curves.elasticOut),
    );
    _slideAnimation = Tween<Offset>(
      begin: const Offset(0.2, 0),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(parent: _slideController, curve: Curves.easeOutCubic),
    );

    _fadeController.forward();
    _scaleController.forward();
    _slideController.forward();
  }

  @override
  void dispose() {
    _fadeController.dispose();
    _scaleController.dispose();
    _slideController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
      value: _viewModel,
      child: Consumer<HomeViewModel>(
        builder: (context, viewModel, _) {
          return Scaffold(
            backgroundColor: Colors.black,
            extendBodyBehindAppBar: true,
            appBar: _buildAppBar(viewModel),
            body: _buildBody(viewModel),
          );
        },
      ),
    );
  }

  PreferredSizeWidget _buildAppBar(HomeViewModel viewModel) {
    return AppBar(
      backgroundColor: Colors.transparent,
      elevation: 0,
      leading: ScaleTransition(
        scale: _scaleAnimation,
        child: IconButton(
          icon: const Icon(Icons.person, color: Colors.white),
          //onPressed: () => Navigator.pushNamed(context, '/profile'),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const HomeView1()),
            );
          },
        ),
      ),
      actions: [
        ScaleTransition(
          scale: _scaleAnimation,
          child: IconButton(
            icon: const Icon(Icons.search, color: Colors.white, size: 30),
            onPressed: viewModel.toggleSearch,
          ),
        ),
      ],
    );
  }

  Widget _buildBody(HomeViewModel viewModel) {
    final size = MediaQuery.of(context).size;

    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      child: AnimationLimiter(
        child: Column(
          children: AnimationConfiguration.toStaggeredList(
            duration: const Duration(milliseconds: 600),
            childAnimationBuilder: (widget) => SlideAnimation(
              verticalOffset: 30.0,
              child: FadeInAnimation(child: widget),
            ),
            children: [
              HorizontalList(
                itemWidth: size.width,
                itemHeight: 300,
                ads: viewModel.ads,
              ),
              const SizedBox(height: 4),
              HorizontalList(
                itemWidth: size.width / 2.2,
                itemHeight: 200,
                ads: viewModel.ads,
              ),
              const SizedBox(height: 4),
              HorizontalList(
                itemWidth: size.width / 2.2,
                itemHeight: 200,
                ads: viewModel.ads,
              ),
              const SizedBox(height: 16),
              VerticalGrid(ads: viewModel.ads),
            ],
          ),
        ),
      ),
    );
  }
}
