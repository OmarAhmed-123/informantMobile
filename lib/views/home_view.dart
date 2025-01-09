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
