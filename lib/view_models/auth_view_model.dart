import 'package:flutter/foundation.dart';

class AuthViewModel extends ChangeNotifier {
  bool _isLoggedIn = false;
  String? _username;
  String? _email;
  String? _password;
  int? _flag;
  bool get isLoggedIn => _isLoggedIn;
  String? get username => _username;
  String? get email => _email;
  int? get flag => _flag;
  String? get password => _password;

  set email(String? value) {
    _email = value;
    notifyListeners(); // Notify listeners about the change
  }

  set username(String? value) {
    _username = value;
    notifyListeners(); // Notify listeners about the change
  }

  set password(String? value) {
    _password = value;
    notifyListeners(); // Notify listeners about the change
  }

  set flag(int? value) {
    _flag = value;
    notifyListeners(); // Notify listeners about the change
  }

  Future<bool> register(String fullname, String username, String password,
      String email, String phoneNumber) async {
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

  // Add this method to check email registration
  Future<bool> checkEmailRegistration(String email) async {
    // Simulate a network request
    await Future.delayed(const Duration(seconds: 1));
    // For demonstration purposes, let's assume the email is registered if it contains '@'
    return email.contains('@');
  }
}
