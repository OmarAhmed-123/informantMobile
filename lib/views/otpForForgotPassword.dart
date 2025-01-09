// ignore_for_file: file_names, unused_local_variable

import 'package:flutter/material.dart';
import 'package:graduation___part1/views/httpCodeG.dart';
import 'package:provider/provider.dart';
import '../view_models/auth_view_model.dart';

class OtpForForgotPassword extends StatefulWidget {
  const OtpForForgotPassword({Key? key}) : super(key: key);
  @override
  otpVerificationViewS createState() => otpVerificationViewS();
}

class otpVerificationViewS extends State<OtpForForgotPassword> {
  final formKey = GlobalKey<FormState>();
  final List<TextEditingController> otpControllers =
      List.generate(9, (_) => TextEditingController());

  @override
  void dispose() {
    for (var controller in otpControllers) {
      controller.dispose();
    }
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    final authViewModel = Provider.of<AuthViewModel>(context, listen: false);
    HttpRequest.get("/user/sendotp?email=${authViewModel.email}");
  }

  @override
  Widget build(BuildContext context) {
    final authViewModel = Provider.of<AuthViewModel>(context, listen: false);

    return Scaffold(
      appBar: AppBar(
        title: const Text('OTP Verification'),
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Colors.purple[700]!, Colors.blue[500]!],
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  'Enter the 9-digit code sent to your email',
                  style: TextStyle(fontSize: 18, color: Colors.white),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 24),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: List.generate(
                    9,
                    (index) => SizedBox(
                      width: 40,
                      child: TextFormField(
                        controller: otpControllers[index],
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: Colors.white.withOpacity(0.7),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        keyboardType: TextInputType.number,
                        textAlign: TextAlign.center,
                        maxLength: 1,
                        onChanged: (value) {
                          if (value.isNotEmpty && index < 8) {
                            FocusScope.of(context).nextFocus();
                          }
                        },
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return '';
                          }
                          return null;
                        },
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 32),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: Colors.purple.shade800,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 50, vertical: 15),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                  onPressed: () {
                    if (formKey.currentState!.validate()) {
                      String otp = otpControllers
                          .map((controller) => controller.text)
                          .join();
                      var response = HttpRequest.post({
                        "endPoint": "/user/verify",
                        "otp": otp,
                        "email": authViewModel.email
                      }).then((res) {
                        if (res.statusCode == 200) {
                          print('Entered OTP: $otp');
                          Navigator.pushReplacementNamed(context, 'forgot');
                        }
                      });
                    }
                  },
                  child: const Text('Verify', style: TextStyle(fontSize: 18)),
                ),
                const SizedBox(height: 16),
                TextButton(
                  onPressed: () {
                    HttpRequest.get(
                            "/user/sendotp?email=${authViewModel.email}")
                        .then((res) {
                      if (res.statusCode == 200) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('OTP is resent!')),
                        );
                      }
                    });
                  },
                  child: const Text('Resend OTP',
                      style: TextStyle(color: Colors.white70)),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
