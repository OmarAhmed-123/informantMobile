import 'package:flutter/material.dart';

class ProfitViewModel extends ChangeNotifier {
  List<Map<String, dynamic>> _ads = [];
  bool _isLoading = false;
  String? _error;

  List<Map<String, dynamic>> get ads => _ads;
  bool get isLoading => _isLoading;
  String? get error => _error;

  double get totalRevenue => _ads.fold<double>(
        0,
        (sum, ad) => sum + (ad['potentialRevenue'] as num).toDouble(),
      );

  Future<void> fetchAds() async {
    try {
      _isLoading = true;
      notifyListeners();

      // Simulated API call - replace with actual implementation
      await Future.delayed(const Duration(seconds: 1));
      _ads = [
        {
          "name": "Sample Ad 1",
          "potentialRevenue": 1000,
          "stars": 4,
          "availablePlaces": 5,
          "images": ["https://example.com/image1.jpg"]
        },
        // Add more sample data as needed
      ];

      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _error = e.toString();
      _isLoading = false;
      notifyListeners();
    }
  }
}
