import 'dart:async';
import 'package:flutter/material.dart';
import '../widgets/search_box.dart';

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

  bool _showSearch = false;
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
    } // Add more ad entries here.
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

  Widget horizontalList() {
    final ScrollController scrollHorizontal = ScrollController();
    bool isScrollD = false;
    Timer? autoScroll;

    void startOfAutoScroll() {
      autoScroll = Timer.periodic(const Duration(seconds: 2), (_) {
        if (!isScrollD && scrollHorizontal.hasClients) {
          final maxScroll = scrollHorizontal.position.maxScrollExtent;
          final currentScroll = scrollHorizontal.offset;

          if (currentScroll >= maxScroll) {
            // Reset to the beginning when reaching the end
            scrollHorizontal.jumpTo(0);
          } else {
            // Scroll right smoothly
            scrollHorizontal.animateTo(
              currentScroll + 330, // Adjust the scroll amount as needed
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

    // Start the auto-scroll timer when the widget is built
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
      height: 420, // Adjust height to fit horizontal layout
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        controller: scrollHorizontal,
        physics: const BouncingScrollPhysics(),
        itemCount: ads.length,
        itemBuilder: (context, index) {
          final ad = ads[index];
          return GestureDetector(
            onTapDown: (_) {
              isScrollD = true; // Stop auto-scrolling
            },
            onTapUp: (_) {
              isScrollD = false; // Resume auto-scrolling
            },
            child: AnimatedOpacity(
              duration: const Duration(milliseconds: 500),
              opacity: 1.0, // Full opacity for all items
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 8.0, vertical: 16.0),
                child: Container(
                  width: 320, // Fixed width for horizontal items
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
                        child: Image.network(
                          ad['images'][0],
                          fit: BoxFit.cover,
                          height: 150, // Adjust height for horizontal layout
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
            ),
          );
        },
      ),
    );
  }

  Widget verticalList() {
    return SizedBox(
      height: 400, // Adjust height to fit the desired grid size
      child: GridView.builder(
        scrollDirection: Axis.vertical, // Allow vertical scrolling
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3, // Three items per row
          crossAxisSpacing: 10, // Space between items in a row
          mainAxisSpacing: 20, // Space between rows
          childAspectRatio: 1, // Keep items square
        ),
        itemCount: ads.length,
        itemBuilder: (context, index) {
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
            icon: const Icon(Icons.search, color: Colors.white, size: 30.0),
            onPressed: () {
              setState(() {
                _showSearch = true;
              });
              tooltip:
              'Search';
            },
          ),
        ],
      ),
      body: Column(
        children: [
          horizontalList(),
          const SizedBox(height: 20),
          verticalList(),
        ],
      ),
    );
  }
}
