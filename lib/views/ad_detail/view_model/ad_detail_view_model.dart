import 'package:carousel_slider/carousel_options.dart';
import 'package:flutter/material.dart';
import '../../../models/ad.dart';

class AdDetailViewModel extends ChangeNotifier {
  final Ad ad;
  final carouselOptions = CarouselOptions(
    height: 300,
    viewportFraction: 1,
    autoPlay: true,
    autoPlayInterval: const Duration(seconds: 3),
  );

  AdDetailViewModel({required this.ad});

  void purchaseAd(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Ad purchased successfully!'),
        backgroundColor: Colors.green,
      ),
    );
  }
}
