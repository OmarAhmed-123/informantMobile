//this part is the static of the graphic
/*
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:graduation___part1/views/home_view.dart';
import 'package:graduation___part1/views/barOfHome.dart';

class ProfitView extends StatefulWidget {
  const ProfitView({Key? key}) : super(key: key);

  @override
  profitViewS createState() => profitViewS();
}

class profitViewS extends State<ProfitView>
    with SingleTickerProviderStateMixin {
  late AnimationController animationController;
  late Animation<double> fadeAnimation;
  late Animation<double> slideAnimation;

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

  @override
  void initState() {
    super.initState();
    initiAnimations();
  }

  void initiAnimations() {
    animationController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );

    fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: animationController, curve: Curves.easeOut),
    );

    slideAnimation = Tween<double>(begin: 50.0, end: 0.0).animate(
      CurvedAnimation(parent: animationController, curve: Curves.elasticOut),
    );

    animationController.forward();
  }

  Widget buildCard() {
    final totalRevenue = ads.fold<double>(
      0,
      (sum, ad) => sum + (ad['potentialRevenue'] as num).toDouble(),
    );

    return AnimatedBuilder(
      animation: slideAnimation,
      builder: (context, child) {
        return Transform.translate(
          offset: Offset(0, slideAnimation.value),
          child: Container(
            margin: const EdgeInsets.all(16),
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.blue.shade900, Colors.purple.shade900],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: Colors.blue.shade900.withOpacity(0.3),
                  blurRadius: 15,
                  spreadRadius: 5,
                ),
              ],
            ),
            child: Column(
              children: [
                const Text(
                  'Total Potential Revenue',
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: 18,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  '\$${NumberFormat('#,##0.00').format(totalRevenue)}',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 42,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1.2,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget buildChart() {
    return Container(
      height: 300,
      padding: const EdgeInsets.all(16),
      child: LineChart(
        LineChartData(
          gridData: FlGridData(
            show: true,
            drawVerticalLine: false,
            horizontalInterval: 200,
            getDrawingHorizontalLine: (value) {
              return FlLine(
                color: Colors.white10,
                strokeWidth: 1,
              );
            },
          ),
          titlesData: FlTitlesData(
            show: true,
            rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
            topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
            leftTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                getTitlesWidget: (value, meta) {
                  return Text(
                    '\$${value.toInt()}',
                    style: TextStyle(
                      color: Colors.white70,
                      fontSize: 12,
                    ),
                  );
                },
                interval: 200,
              ),
            ),
          ),
          borderData: FlBorderData(show: false),
          lineBarsData: [
            LineChartBarData(
              spots: ads.asMap().entries.map((entry) {
                return FlSpot(
                  entry.key.toDouble(),
                  (entry.value['potentialRevenue'] as num).toDouble(),
                );
              }).toList(),
              isCurved: true,
              gradient: LinearGradient(
                colors: [Colors.blue.shade400, Colors.purple.shade400],
              ),
              barWidth: 4,
              isStrokeCapRound: true,
              dotData: FlDotData(
                show: true,
                getDotPainter: (spot, percent, barData, index) {
                  return FlDotCirclePainter(
                    radius: 6,
                    color: Colors.white,
                    strokeWidth: 3,
                    strokeColor: Colors.blue.shade400,
                  );
                },
              ),
              belowBarData: BarAreaData(
                show: true,
                gradient: LinearGradient(
                  colors: [
                    Colors.blue.shade900.withOpacity(0.3),
                    Colors.purple.shade900.withOpacity(0.1),
                  ],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildAdList() {
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: ads.length,
      itemBuilder: (context, index) {
        final ad = ads[index];
        return AnimatedBuilder(
          animation: fadeAnimation,
          builder: (context, child) {
            return Opacity(
              opacity: fadeAnimation.value,
              child: Container(
                margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Colors.grey.shade900,
                      Colors.black87,
                    ],
                  ),
                  borderRadius: BorderRadius.circular(15),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black26,
                      blurRadius: 8,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: ListTile(
                  contentPadding: const EdgeInsets.all(16),
                  leading: CircleAvatar(
                    radius: 25,
                    backgroundImage: NetworkImage(ad['images'][0]),
                    backgroundColor: Colors.grey[850],
                  ),
                  title: Text(
                    ad['name'],
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 4),
                      Row(
                        children: List.generate(
                          ad['stars'] as int,
                          (index) =>
                              Icon(Icons.star, color: Colors.amber, size: 14),
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '${ad['availablePlaces']} places available',
                        style: TextStyle(color: Colors.green.shade400),
                      ),
                    ],
                  ),
                  trailing: Text(
                    '\$${NumberFormat('#,##0').format(ad['potentialRevenue'])}',
                    style: const TextStyle(
                      color: Colors.green,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.home, color: Colors.white),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const HomeView()),
            );
          },
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.close, color: Colors.white),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const HomeView1()),
              );
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            buildCard(),
            buildChart(),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Text(
                'Ad Performance',
                style: TextStyle(
                  color: Colors.grey[400],
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            buildAdList(),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    animationController.dispose();
    super.dispose();
  }
}
*/
//this part is real time grphic not static
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:http/http.dart' as http;
import 'package:web_socket_channel/web_socket_channel.dart';
import 'dart:convert';
import 'package:graduation___part1/views/home_view.dart';
import 'package:graduation___part1/views/barOfHome.dart';

class ProfitView extends StatefulWidget {
  const ProfitView({Key? key}) : super(key: key);

  @override
  ProfitViewState createState() => ProfitViewState();
}

class ProfitViewState extends State<ProfitView>
    with SingleTickerProviderStateMixin {
  late AnimationController animationController;
  late Animation<double> fadeAnimation;
  late Animation<double> slideAnimation;
  late WebSocketChannel channel;
  List<Map<String, dynamic>> ads = [];

  @override
  void initState() {
    super.initState();
    initWebSocket();
    initiAnimations();
    fetchAds();
  }

  void initWebSocket() {
    channel = WebSocketChannel.connect(
      Uri.parse('YOUR_WEBSOCKET_ENDPOINT'),
    );
    channel.stream.listen((message) {
      final data = json.decode(message);
      updateAdsData(data);
    });
  }

  void updateAdsData(dynamic data) {
    setState(() {
      if (data['type'] == 'add') {
        ads.add(Map<String, dynamic>.from(data['ad']));
      } else if (data['type'] == 'update') {
        final index = ads.indexWhere((ad) => ad['id'] == data['ad']['id']);
        if (index != -1) {
          ads[index] = Map<String, dynamic>.from(data['ad']);
        }
      } else if (data['type'] == 'delete') {
        ads.removeWhere((ad) => ad['id'] == data['adId']);
      }
    });
  }

  Future<void> fetchAds() async {
    try {
      final response = await http.get(Uri.parse('YOUR_API_ENDPOINT/ads'));
      if (response.statusCode == 200) {
        setState(() {
          ads = List<Map<String, dynamic>>.from(json.decode(response.body));
        });
      }
    } catch (e) {
      print('Error fetching ads: $e');
    }
  }

  void initiAnimations() {
    animationController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );

    fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: animationController, curve: Curves.easeOut),
    );

    slideAnimation = Tween<double>(begin: 50.0, end: 0.0).animate(
      CurvedAnimation(parent: animationController, curve: Curves.elasticOut),
    );

    animationController.forward();
  }

  Widget buildCard() {
    final totalRevenue = ads.fold<double>(
      0,
      (sum, ad) => sum + (ad['potentialRevenue'] as num).toDouble(),
    );

    return AnimatedBuilder(
      animation: slideAnimation,
      builder: (context, child) {
        return Transform.translate(
          offset: Offset(0, slideAnimation.value),
          child: Container(
            margin: const EdgeInsets.all(16),
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.blue.shade900, Colors.purple.shade900],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: Colors.blue.shade900.withOpacity(0.3),
                  blurRadius: 15,
                  spreadRadius: 5,
                ),
              ],
            ),
            child: Column(
              children: [
                const Text(
                  'Total Revenue',
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: 18,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  '\$${NumberFormat('#,##0.00').format(totalRevenue)}',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 42,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1.2,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget buildChart() {
    return Container(
      height: 300,
      padding: const EdgeInsets.all(16),
      child: LineChart(
        LineChartData(
          gridData: FlGridData(
            show: true,
            drawVerticalLine: false,
            horizontalInterval: 200,
            getDrawingHorizontalLine: (value) {
              return FlLine(
                color: Colors.white10,
                strokeWidth: 1,
              );
            },
          ),
          titlesData: FlTitlesData(
            show: true,
            rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
            topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
            leftTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                getTitlesWidget: (value, meta) {
                  return Text(
                    '\$${value.toInt()}',
                    style: const TextStyle(
                      color: Colors.white70,
                      fontSize: 12,
                    ),
                  );
                },
                interval: 200,
              ),
            ),
          ),
          borderData: FlBorderData(show: false),
          lineTouchData: LineTouchData(
            enabled: true,
            touchTooltipData: LineTouchTooltipData(
              fitInsideHorizontally: true,
              fitInsideVertically: true,
              showOnTopOfTheChartBoxArea: true,
              tooltipPadding: const EdgeInsets.all(8),
              tooltipRoundedRadius: 8,
              tooltipMargin: 0,
              getTooltipItems: (List<LineBarSpot> touchedBarSpots) {
                return touchedBarSpots.map((barSpot) {
                  final index = barSpot.x.toInt();
                  final ad = ads[index];
                  return LineTooltipItem(
                    '${ad['name']}\n\$${NumberFormat('#,##0').format(ad['potentialRevenue'])}',
                    const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  );
                }).toList();
              },
            ),
          ),
          lineBarsData: [
            LineChartBarData(
              spots: ads.asMap().entries.map((entry) {
                return FlSpot(
                  entry.key.toDouble(),
                  (entry.value['potentialRevenue'] as num).toDouble(),
                );
              }).toList(),
              isCurved: true,
              gradient: LinearGradient(
                colors: [Colors.blue.shade400, Colors.purple.shade400],
              ),
              barWidth: 4,
              isStrokeCapRound: true,
              dotData: FlDotData(
                show: true,
                getDotPainter: (spot, percent, barData, index) {
                  return FlDotCirclePainter(
                    radius: 6,
                    color: Colors.white,
                    strokeWidth: 3,
                    strokeColor: Colors.blue.shade400,
                  );
                },
              ),
              belowBarData: BarAreaData(
                show: true,
                gradient: LinearGradient(
                  colors: [
                    Colors.blue.shade900.withOpacity(0.3),
                    Colors.purple.shade900.withOpacity(0.1),
                  ],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildAdList() {
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: ads.length,
      itemBuilder: (context, index) {
        final ad = ads[index];
        return AnimatedBuilder(
          animation: fadeAnimation,
          builder: (context, child) {
            return Opacity(
              opacity: fadeAnimation.value,
              child: Container(
                margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Colors.grey.shade900,
                      Colors.black87,
                    ],
                  ),
                  borderRadius: BorderRadius.circular(15),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black26,
                      blurRadius: 8,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: ListTile(
                  contentPadding: const EdgeInsets.all(16),
                  leading: CircleAvatar(
                    radius: 25,
                    backgroundImage: NetworkImage(ad['images'][0]),
                    backgroundColor: Colors.grey[850],
                  ),
                  title: Text(
                    ad['name'],
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 4),
                      Row(
                        children: List.generate(
                          ad['stars'] as int,
                          (index) => const Icon(Icons.star,
                              color: Colors.amber, size: 14),
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '${ad['availablePlaces']} places available',
                        style: TextStyle(color: Colors.green.shade400),
                      ),
                    ],
                  ),
                  trailing: Text(
                    '\$${NumberFormat('#,##0').format(ad['potentialRevenue'])}',
                    style: const TextStyle(
                      color: Colors.green,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.home, color: Colors.white),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const HomeView()),
            );
          },
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.close, color: Colors.white),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const HomeView1()),
              );
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            buildCard(),
            buildChart(),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Text(
                'Ad Performance',
                style: TextStyle(
                  color: Colors.grey[400],
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            buildAdList(),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    animationController.dispose();
    channel.sink.close();
    super.dispose();
  }
}
