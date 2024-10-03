import 'package:flutter/foundation.dart';

class AuthViewModel extends ChangeNotifier {
  bool _isLoggedIn = false;
  String? _username;
  String? _email; // Add this line

  bool get isLoggedIn => _isLoggedIn;
  String? get username => _username;
  String? get email => _email; // Add this getter

  Future<bool> register(
      String username, String password, String email, String creditCard) async {
    await Future.delayed(
        const Duration(seconds: 2)); // Simulating network delay
    _isLoggedIn = true;
    _username = username;
    _email = email; // Store the email
    notifyListeners();
    return true;
  }

  Future<bool> login(String username, String password) async {
    await Future.delayed(
        const Duration(seconds: 2)); // Simulating network delay
    _isLoggedIn = true;
    _username = username;
    // You may want to store the email here as well after fetching from a data source
    notifyListeners();
    return true;
  }

  void logout() {
    _isLoggedIn = false;
    _username = null;
    _email = null; // Reset email
    notifyListeners();
  }
}
