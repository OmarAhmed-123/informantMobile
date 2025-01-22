import 'package:flutter/material.dart';

class HomeViewModel extends ChangeNotifier {
  final List<Map<String, dynamic>> _ads = [];
  bool _showSearch = false;
  int _currentIndex = 0;

  List<Map<String, dynamic>> get ads => _ads;
  bool get showSearch => _showSearch;
  int get currentIndex => _currentIndex;

  void setCurrentIndex(int index) {
    _currentIndex = index;
    notifyListeners();
  }

  void toggleSearch() {
    _showSearch = !_showSearch;
    notifyListeners();
  }

  void loadAds(List<Map<String, dynamic>> newAds) {
    _ads.clear();
    _ads.addAll(newAds);
    notifyListeners();
  }
}
