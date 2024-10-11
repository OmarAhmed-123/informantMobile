// ignore_for_file: avoid_print

import 'package:flutter/foundation.dart';
import '../models/ad.dart';
import '../services/api_service.dart';

class AdViewModel with ChangeNotifier {
  List<Ad> _ads = [];
  double _totalIncome = 0;
  final ApiService _apiService;

  AdViewModel(this._apiService);

  List<Ad> get ads => _ads;
  double get totalIncome => _totalIncome;

  Future<void> fetchAds() async {
    try {
      _ads = await _apiService.fetchAds();
      _calculateTotalIncome();
      notifyListeners();
    } catch (e) {
      print('Error fetching ads: $e');
    }
  }

  Future<void> addAd(Ad ad) async {
    try {
      final newAd = await _apiService.createAd(ad);
      _ads.add(newAd);
      _calculateTotalIncome();
      notifyListeners();
    } catch (e) {
      print('Error creating ad: $e');
    }
  }

  void removeAd(String id) {
    _ads.removeWhere((ad) => ad.id == id);
    _calculateTotalIncome();
    notifyListeners();
  }

  void _calculateTotalIncome() {
    _totalIncome = _ads.fold(0, (sum, ad) => sum + ad.earnings);
  }
}
