import 'package:flutter/material.dart';
import '../../../models/ad.dart';

class AdListViewModel extends ChangeNotifier {
  final List<Map<String, dynamic>> _ads = [];
  bool _isLoading = false;
  int _currentImageIndex = 0;

  List<Map<String, dynamic>> get ads => _ads;
  bool get isLoading => _isLoading;
  int get currentImageIndex => _currentImageIndex;

  void setCurrentImageIndex(int index) {
    _currentImageIndex = index;
    notifyListeners();
  }

  void setAds(List<Map<String, dynamic>> newAds) {
    _ads.clear();
    _ads.addAll(newAds);
    notifyListeners();
  }

  void setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }

  Ad createAdFromMap(Map<String, dynamic> adMap, int index) {
    return Ad(
      id: index.toString(),
      name: adMap['name'],
      details: adMap['details'],
      images: adMap['images'],
      stars: adMap['stars'],
      potentialRevenue: adMap['potentialRevenue'].toDouble(),
      availablePlaces: adMap['availablePlaces'],
      creatorName: adMap['creatorName'],
      price: adMap['price'].toDouble(),
      createdAt: DateTime.parse(adMap['createdAt']),
      earnings: adMap['earnings'].toDouble(),
      description: adMap['description'],
    );
  }
}
