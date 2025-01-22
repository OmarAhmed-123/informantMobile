import 'package:flutter/material.dart';

class RegisterViewModel extends ChangeNotifier {
  bool _isLoading = false;
  String? _errorMessage;

  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  void setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  void setError(String? message) {
    _errorMessage = message;
    notifyListeners();
  }

  Future<bool> validateForm(Map<String, String> formData) async {
    if (formData.values.any((value) => value.isEmpty)) {
      setError('Please fill in all fields');
      return false;
    }

    if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$')
        .hasMatch(formData['email']!)) {
      setError('Please enter a valid email address');
      return false;
    }

    if (!RegExp(r'^\+?[0-9]{10,15}$').hasMatch(formData['phone']!)) {
      setError('Please enter a valid phone number');
      return false;
    }

    return true;
  }

  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }
}
