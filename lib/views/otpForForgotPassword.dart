/*
// ignore_for_file: file_names, unused_local_variable

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:graduation___part1/views/httpCodeG.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
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
                  onPressed: () async {
                    final prefs = await SharedPreferences.getInstance();
                    if (formKey.currentState!.validate()) {
                      SharedPreferences objShared =
                          await SharedPreferences.getInstance();
                      final email = objShared.getString('email');
                      String otp = otpControllers
                          .map((controller) => controller.text)
                          .join();
                      HttpRequest.post({
                        "endPoint": "/user/verify",
                        "otp": otp,
                        "email": email
                      }).then((res) async {
                        print('Entered OTP: $otp');
                        if (res.statusCode == 201) {
                          final Map<String, dynamic> data =
                              json.decode(res.toString());
                          await prefs.setString(
                              'CookieToken', data["messages"]["content"]);
                          await prefs.setString('pToken', "");
                          Navigator.pushReplacementNamed(context, '/forgot');
                        } else {
                          print(res.statusCode);
                          print(json.decode(res.toString()));
                        }
                      });
                    }
                  },
                  child: const Text('Verify', style: TextStyle(fontSize: 18)),
                ),
                const SizedBox(height: 16),
                TextButton(
                  onPressed: () async {
                    SharedPreferences objShared =
                        await SharedPreferences.getInstance();
                    final email = objShared.getString('email');
                    HttpRequest.post({
                      "endPoint": "/user/sendotp?email=${email}",
                    }).then((res) {
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

*/
// ignore_for_file: file_names, unused_local_variable

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:graduation___part1/views/httpCodeG.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../view_models/auth_view_model.dart';
import 'auth_cubit.dart'; // Import the AuthCubit

class OtpForForgotPassword extends StatefulWidget {
  const OtpForForgotPassword({super.key});
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
                  onPressed: () async {
                    if (formKey.currentState!.validate()) {
                      SharedPreferences objShared =
                          await SharedPreferences.getInstance();
                      final email = objShared.getString('email');
                      String otp = otpControllers
                          .map((controller) => controller.text)
                          .join();

                      // Use Cubit to handle the OTP verification
                      context.read<AuthCubit>().verifyOtp(email!, otp);
                    }
                  },
                  child: const Text('Verify', style: TextStyle(fontSize: 18)),
                ),
                const SizedBox(height: 16),
                TextButton(
                  onPressed: () async {
                    SharedPreferences objShared =
                        await SharedPreferences.getInstance();
                    final email = objShared.getString('email');

                    // Use Cubit to handle the OTP resend
                    context.read<AuthCubit>().resendOtp(email!);
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

// AuthCubit implementation
class AuthCubit extends Cubit<AuthState> {
  AuthCubit() : super(AuthInitial());

  Future<void> verifyOtp(String email, String otp) async {
    emit(AuthLoading());
    try {
      final response = await HttpRequest.post(
          {"endPoint": "/user/verify", "otp": otp, "email": email});

      if (response.statusCode == 201) {
        final Map<String, dynamic> data = json.decode(response.toString());
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('CookieToken', data["messages"]["content"]);
        await prefs.setString('pToken', "");
        emit(AuthSuccess());
      } else {
        emit(AuthFailure(error: 'OTP verification failed'));
      }
    } catch (e) {
      emit(AuthFailure(error: e.toString()));
    }
  }

  Future<void> resendOtp(String email) async {
    emit(AuthLoading());
    try {
      final response = await HttpRequest.post({
        "endPoint": "/user/sendotp?email=$email",
      });

      if (response.statusCode == 200) {
        emit(AuthOtpResent());
      } else {
        emit(AuthFailure(error: 'Failed to resend OTP'));
      }
    } catch (e) {
      emit(AuthFailure(error: e.toString()));
    }
  }
}

// AuthState definitions
abstract class AuthState {}

class AuthInitial extends AuthState {}

class AuthLoading extends AuthState {}

class AuthSuccess extends AuthState {}

class AuthOtpResent extends AuthState {}

class AuthFailure extends AuthState {
  final String error;
  AuthFailure({required this.error});
}
