// ignore_for_file: prefer_final_fields

import 'package:flutter/foundation.dart';

class Ad {
  final String id;
  final String name;
  final String description;
  final double price;
  final String imageUrl;
  final DateTime createdAt;
  final double earnings;

  Ad(
      {required this.id,
      required this.name,
      required this.description,
      required this.price,
      required this.createdAt,
      required this.earnings,
      required this.imageUrl});
}

class AdViewModel with ChangeNotifier {
  List<Ad> _ads = [];
  double _totalIncome = 0;

  List<Ad> get ads => _ads;
  double get totalIncome => _totalIncome;

  void addAd(Ad ad) {
    _ads.add(ad);
    notifyListeners();
  }

  void removeAd(String id) {
    _ads.removeWhere((ad) => ad.id == id);
    notifyListeners();
  }

  void updateTotalIncome(double amount) {
    _totalIncome += amount;
    notifyListeners();
  }
}
