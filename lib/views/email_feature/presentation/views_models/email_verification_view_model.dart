import 'package:flutter/material.dart';

class EmailVerificationViewModel extends ChangeNotifier {
  final formKey = GlobalKey<FormState>();
  final emailController = TextEditingController();
  bool _isLoading = false;

  bool get isLoading => _isLoading;

  void setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  String? validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter your email';
    }
    return null;
  }

  Future<void> sendVerificationCode(BuildContext context) async {
    if (formKey.currentState!.validate()) {
      setLoading(true);
      try {
        // Add your email verification logic here
        await Future.delayed(const Duration(seconds: 2)); // Simulated delay
        Navigator.pushReplacementNamed(context, '/otp_verification');
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error: $e'),
            backgroundColor: Colors.red,
          ),
        );
      } finally {
        setLoading(false);
      }
    }
  }

  @override
  void dispose() {
    emailController.dispose();
    super.dispose();
  }
}
