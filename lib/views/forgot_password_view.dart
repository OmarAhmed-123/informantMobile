/*
// ignore_for_file: library_private_types_in_public_api, sort_child_properties_last

import 'package:flutter/material.dart';
import 'package:graduation___part1/views/httpCodeG.dart';

class ForgotPasswordView extends StatefulWidget {
  const ForgotPasswordView({super.key});

  @override
  forgotPasswordViewS createState() => forgotPasswordViewS();
}

class forgotPasswordViewS extends State<ForgotPasswordView>
    with SingleTickerProviderStateMixin {
  final formKey = GlobalKey<FormState>();
  final newPasswordController = TextEditingController();
  final confirmPasswordController = TextEditingController();
  late AnimationController animationController;
  late Animation<double> fadeAnimation;
  bool visiblePassword3 = false;
  bool visiblePassword4 = false;
  @override
  void initState() {
    super.initState();
    animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    );
    fadeAnimation =
        Tween<double>(begin: 0.0, end: 1.0).animate(animationController);
    animationController.forward();
  }

  @override
  void dispose() {
    animationController.dispose();
    newPasswordController.dispose();
    confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Reset Password'),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      extendBodyBehindAppBar: true,
      body: FadeTransition(
        opacity: fadeAnimation,
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [Colors.purple[700]!, Colors.blue[500]!],
            ),
          ),
          child: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Form(
                key: formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      'Reset Password',
                      style: TextStyle(
                          fontSize: 32,
                          fontWeight: FontWeight.bold,
                          color: Colors.white),
                    ),
                    const SizedBox(height: 32),
                    TextFormField(
                      controller: newPasswordController,
                      obscureText: !visiblePassword3,
                      decoration: InputDecoration(
                        hintText: 'Enter your new Password',
                        filled: true,
                        fillColor: Colors.white.withOpacity(0.1),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        suffixIcon: IconButton(
                          icon: Icon(
                            visiblePassword3
                                ? Icons.visibility
                                : Icons.visibility_off,
                            color: Colors.white70,
                          ),
                          onPressed: () {
                            setState(() {
                              visiblePassword3 = !visiblePassword3;
                            });
                          },
                        ),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your new password';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: confirmPasswordController,
                      obscureText: !visiblePassword4,
                      decoration: InputDecoration(
                        hintText: 'Re-enter your new Password',
                        filled: true,
                        fillColor: Colors.white.withOpacity(0.1),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        suffixIcon: IconButton(
                          icon: Icon(
                            visiblePassword4
                                ? Icons.visibility
                                : Icons.visibility_off,
                            color: Colors.white70,
                          ),
                          onPressed: () {
                            setState(() {
                              visiblePassword4 = !visiblePassword4;
                            });
                          },
                        ),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please re-enter your new password';
                        }
                        if (value != newPasswordController.text) {
                          return 'Passwords do not match';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 24),
                    ElevatedButton(
                      onPressed: () {
                        if (formKey.currentState!.validate()) {
                          HttpRequest.post({
                            "endPoint": "/user/editprofile",
                            "fullname": "",
                            "password": newPasswordController.text,
                            "phone": "",
                            "email": "",
                            "details": "",
                          }).then((res) {
                            if (res.statusCode == 200) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                    content: Text('Password reset successful')),
                              );
                              Navigator.pushNamed(context, '/login');
                            }
                          }).catchError((error) {
                            print("Error: $error");
                          });
                        }
                      },
                      child: const Text('Submit'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 50, vertical: 15),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

*/

// ignore_for_file: library_private_types_in_public_api, sort_child_properties_last

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:graduation___part1/views/httpCodeG.dart';
import 'package:shared_preferences/shared_preferences.dart';

// Global navigator key to handle navigation outside the widget tree
import 'package:graduation___part1/views/variables.dart'; // Import the shared variables file

class ForgotPasswordView extends StatefulWidget {
  const ForgotPasswordView({super.key});

  @override
  forgotPasswordViewS createState() => forgotPasswordViewS();
}

class forgotPasswordViewS extends State<ForgotPasswordView>
    with SingleTickerProviderStateMixin {
  final formKey = GlobalKey<FormState>();
  final newPasswordController = TextEditingController();
  final confirmPasswordController = TextEditingController();
  late AnimationController animationController;
  late Animation<double> fadeAnimation;
  bool visiblePassword3 = false;
  bool visiblePassword4 = false;

  @override
  void initState() {
    super.initState();
    // Initialize animation controller and fade animation
    animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    );
    fadeAnimation =
        Tween<double>(begin: 0.0, end: 1.0).animate(animationController);
    animationController.forward();
  }

  @override
  void dispose() {
    // Dispose animation controller and text controllers
    animationController.dispose();
    newPasswordController.dispose();
    confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Reset Password'),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      extendBodyBehindAppBar: true,
      body: FadeTransition(
        opacity: fadeAnimation,
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [Colors.purple[700]!, Colors.blue[500]!],
            ),
          ),
          child: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Form(
                key: formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      'Reset Password',
                      style: TextStyle(
                          fontSize: 32,
                          fontWeight: FontWeight.bold,
                          color: Colors.white),
                    ),
                    const SizedBox(height: 32),
                    // New Password Field
                    TextFormField(
                      controller: newPasswordController,
                      obscureText: !visiblePassword3,
                      decoration: InputDecoration(
                        hintText: 'Enter your new Password',
                        filled: true,
                        fillColor: Colors.white.withOpacity(0.1),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        suffixIcon: IconButton(
                          icon: Icon(
                            visiblePassword3
                                ? Icons.visibility
                                : Icons.visibility_off,
                            color: Colors.white70,
                          ),
                          onPressed: () {
                            setState(() {
                              visiblePassword3 = !visiblePassword3;
                            });
                          },
                        ),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your new password';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),
                    // Confirm Password Field
                    TextFormField(
                      controller: confirmPasswordController,
                      obscureText: !visiblePassword4,
                      decoration: InputDecoration(
                        hintText: 'Re-enter your new Password',
                        filled: true,
                        fillColor: Colors.white.withOpacity(0.1),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        suffixIcon: IconButton(
                          icon: Icon(
                            visiblePassword4
                                ? Icons.visibility
                                : Icons.visibility_off,
                            color: Colors.white70,
                          ),
                          onPressed: () {
                            setState(() {
                              visiblePassword4 = !visiblePassword4;
                            });
                          },
                        ),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please re-enter your new password';
                        }
                        if (value != newPasswordController.text) {
                          return 'Passwords do not match';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 24),
                    // Submit Button
                    ElevatedButton(
                      onPressed: () {
                        if (formKey.currentState!.validate()) {
                          // Use Cubit to handle password reset
                          context.read<AuthCubit>().resetPassword(
                                newPasswordController.text,
                              );
                        }
                      },
                      child: const Text('Submit'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 50, vertical: 15),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// AuthCubit for handling password reset logic
class AuthCubit extends Cubit<AuthState> {
  AuthCubit() : super(AuthInitial());

  // Method to reset password
  Future<void> resetPassword(String newPassword) async {
    emit(AuthLoading()); // Emit loading state
    try {
      final response = await HttpRequest.post({
        "endPoint": "/user/editprofile",
        "fullname": "",
        "password": newPassword,
        "phone": "",
        "email": "",
        "details": "",
      });

      if (response.statusCode == 200) {
        // Save cookies if necessary
        final Map<String, dynamic> data = json.decode(response.toString());
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('CookieToken', data["messages"]["content"]);
        await prefs.setString('pToken', "");

        emit(AuthSuccess()); // Emit success state
        // Show success message and navigate to login screen using the global navigator key
        navigatorKey.currentState?.pushNamed('/login');
        ScaffoldMessenger.of(navigatorKey.currentContext!).showSnackBar(
          const SnackBar(content: Text('Password reset successful')),
        );
      } else {
        emit(AuthFailure(error: 'Password reset failed')); // Emit failure state
      }
    } catch (e) {
      emit(AuthFailure(error: e.toString())); // Emit error state
    }
  }
}

// AuthState definitions
abstract class AuthState {}

class AuthInitial extends AuthState {}

class AuthLoading extends AuthState {}

class AuthSuccess extends AuthState {}

class AuthFailure extends AuthState {
  final String error;
  AuthFailure({required this.error});
}
