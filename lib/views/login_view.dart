/*
// ignore_for_file: library_private_types_in_public_api, use_build_context_synchronously, sort_child_properties_last, prefer_const_constructors, depend_on_referenced_packages, body_might_complete_normally_catch_error
import 'dart:convert';
import 'dart:js_interop';

import 'package:flutter/material.dart';
import 'package:graduation___part1/views/httpCodeG.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'home_view.dart';
import 'register_view.dart';
import 'package:graduation___part1/views/autoLogin.dart';
import '../view_models/auth_view_model.dart';
import 'email_verification_view.dart';
import 'package:provider/provider.dart';

class LoginView extends StatefulWidget {
  const LoginView({super.key});

  @override
  loginViewSt createState() => loginViewSt();
}

class loginViewSt extends State<LoginView> with SingleTickerProviderStateMixin {
  final formKey = GlobalKey<FormState>();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  late AnimationController animationController;
  late Animation<double> fadeAnimation;
  bool visiblePassword2 = false;
  late String str;
  late bool flag;
  late String message;

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
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  Future<void> loginFun() async {
    final prefs = await SharedPreferences.getInstance();
    if (formKey.currentState!.validate()) {
      final authViewModel = Provider.of<AuthViewModel>(context, listen: false);
      HttpRequest.post({
        "endPoint": "/user/login",
        "username": emailController.text,
        "password": passwordController.text
      }).then((res) async {
        if (res.statusCode == 200) {
          final Map<String, dynamic> data = json.decode(res.body);
          await prefs.setString('CookieToken', data["token"] ?? "");
          await prefs.setString('pToken', data["ptoken"] ?? "");
          AutoLogin.saveData(emailController.text, passwordController.text);
          ScaffoldMessenger.of(context)
              .showSnackBar(const SnackBar(content: Text('Login successful!')));
          Navigator.pushReplacement(context,
              MaterialPageRoute(builder: (context) => const HomeView()));
        } else if (res.statusCode == 204) {
          authViewModel.password = passwordController.text;
          if ((emailController.text).contains("@")) {
            await prefs.setString('email', emailController.text);
            Navigator.pushReplacementNamed(context, '/otp_verification');
          } else {
            authViewModel.flag = 2;
            authViewModel.username = emailController.text;
            Navigator.pushReplacementNamed(context, '/email_verification');
          }
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Error: Status Code ${res.statusCode}')));
        }
      }).catchError((error) {
        print("Error: $error");
      });
    }
  }

  Future<void> loginWithoutBE() async {
    AutoLogin.saveData(emailController.text, passwordController.text);
    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (context) => const HomeView()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                    Image.asset(
                      'assets/login1.png',
                      width: 150,
                      height: 150,
                    ),
                    const SizedBox(height: 32),
                    const Text(
                      'Login',
                      style: TextStyle(
                          fontSize: 32,
                          fontWeight: FontWeight.bold,
                          color: Colors.white),
                    ),
                    const SizedBox(height: 32),
                    TextFormField(
                      controller: emailController,
                      decoration: InputDecoration(
                        hintText: 'Enter your username',
                        filled: true,
                        fillColor: Colors.white.withOpacity(0.7),
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12)),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your username';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: passwordController,
                      obscureText: !visiblePassword2,
                      decoration: InputDecoration(
                        labelText: 'Password',
                        filled: true,
                        fillColor: Colors.white.withOpacity(0.7),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        suffixIcon: IconButton(
                          icon: Icon(
                            visiblePassword2
                                ? Icons.visibility
                                : Icons.visibility_off,
                          ),
                          onPressed: () {
                            setState(() {
                              visiblePassword2 = !visiblePassword2;
                            });
                          },
                        ),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter a password';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 24),
                    ElevatedButton(
                      onPressed: loginFun,
                      // loginWithoutBE, //for omar
                      child: const Text('Sign In'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 50, vertical: 15),
                      ),
                    ),
                    const SizedBox(height: 16),
                    TextButton(
                      onPressed: () async {
                        final authViewModel =
                            Provider.of<AuthViewModel>(context, listen: false);
                        authViewModel.flag = 1;
                        final prefs = await SharedPreferences.getInstance();
                        await prefs.setInt('flag', 1);
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  const EmailVerificationView()),
                        );
                      },
                      child: const Text('Forgot password?',
                          style: TextStyle(color: Colors.white)),
                    ),
                    const SizedBox(height: 16),
                    TextButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => RegisterView()),
                        );
                      },
                      child: const Text("Don't have an account? Sign up",
                          style: TextStyle(color: Colors.white70)),
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
// ignore_for_file: library_private_types_in_public_api, use_build_context_synchronously, sort_child_properties_last, prefer_const_constructors, depend_on_referenced_packages
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'home_view.dart';
import 'register_view.dart';
import 'package:graduation___part1/views/autoLogin.dart';
import '../view_models/auth_view_model.dart';
import 'email_verification_view.dart';
import 'package:provider/provider.dart';

// Cubit for handling authentication logic
class AuthCubit extends Cubit<AuthState> {
  AuthCubit() : super(AuthInitial());

  Future<void> login(String username, String password) async {
    emit(AuthLoading()); // Emit loading state
    try {
      // Replace this with your actual API call to the backend
      final response = await _simulateBackendLogin(username, password);

      if (response['status'] == 'success') {
        // Save tokens and user data locally
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('CookieToken', response['token']);
        await prefs.setString('pToken', response['ptoken']);
        AutoLogin.saveData(username, password);

        emit(AuthSuccess()); // Emit success state
      } else {
        // If the backend fails to store data or credentials are invalid
        emit(AuthFailure(error: response['message']));
      }
    } catch (e) {
      emit(AuthFailure(error: e.toString())); // Emit failure state with error
    }
  }

  // Simulate a backend API call (replace with your actual API call)
  Future<Map<String, dynamic>> _simulateBackendLogin(
      String username, String password) async {
    await Future.delayed(Duration(seconds: 2)); // Simulate network delay

    // Simulate backend response
    if (username == "validUser" && password == "validPassword") {
      return {
        'status': 'success',
        'token': 'simulated_token',
        'ptoken': 'simulated_ptoken',
        'message': 'Login successful',
      };
    } else {
      return {
        'status': 'error',
        'message': 'Invalid username or password',
      };
    }
  }
}

// Auth State
abstract class AuthState {}

class AuthInitial extends AuthState {} // Initial state

class AuthLoading extends AuthState {} // Loading state

class AuthSuccess extends AuthState {} // Success state

class AuthFailure extends AuthState {
  final String error;
  AuthFailure({required this.error}); // Failure state with error message
}

class LoginView extends StatefulWidget {
  const LoginView({super.key});

  @override
  loginViewSt createState() => loginViewSt();
}

class loginViewSt extends State<LoginView> with SingleTickerProviderStateMixin {
  final formKey = GlobalKey<FormState>(); // Form key for validation
  final emailController = TextEditingController(); // Controller for email input
  final passwordController =
      TextEditingController(); // Controller for password input
  late AnimationController
      animationController; // Animation controller for fade effect
  late Animation<double> fadeAnimation; // Fade animation
  bool visiblePassword2 = false; // Toggle password visibility

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
    animationController.forward(); // Start the animation
  }

  @override
  void dispose() {
    // Dispose controllers and animation to avoid memory leaks
    animationController.dispose();
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                    // Logo or image
                    Image.asset(
                      'assets/login1.png',
                      width: 150,
                      height: 150,
                    ),
                    const SizedBox(height: 32),
                    // Login title
                    const Text(
                      'Login',
                      style: TextStyle(
                          fontSize: 32,
                          fontWeight: FontWeight.bold,
                          color: Colors.white),
                    ),
                    const SizedBox(height: 32),
                    // Email input field
                    TextFormField(
                      controller: emailController,
                      decoration: InputDecoration(
                        hintText: 'Enter your username',
                        filled: true,
                        fillColor: Colors.white.withOpacity(0.7),
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12)),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your username';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),
                    // Password input field
                    TextFormField(
                      controller: passwordController,
                      obscureText: !visiblePassword2,
                      decoration: InputDecoration(
                        labelText: 'Password',
                        filled: true,
                        fillColor: Colors.white.withOpacity(0.7),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        suffixIcon: IconButton(
                          icon: Icon(
                            visiblePassword2
                                ? Icons.visibility
                                : Icons.visibility_off,
                          ),
                          onPressed: () {
                            setState(() {
                              visiblePassword2 =
                                  !visiblePassword2; // Toggle password visibility
                            });
                          },
                        ),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter a password';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 24),
                    // Login button wrapped with BlocProvider
                    BlocProvider(
                      create: (context) =>
                          AuthCubit(), // Provide AuthCubit instance
                      child: BlocConsumer<AuthCubit, AuthState>(
                        listener: (context, state) {
                          // Handle state changes
                          if (state is AuthSuccess) {
                            ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                    content: Text('Login successful!')));
                            Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => const HomeView()));
                          } else if (state is AuthFailure) {
                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                content: Text('Error: ${state.error}')));
                          }
                        },
                        builder: (context, state) {
                          if (state is AuthLoading) {
                            return const CircularProgressIndicator(); // Show loading indicator
                          }
                          return ElevatedButton(
                            onPressed: () {
                              if (formKey.currentState!.validate()) {
                                // Trigger login function
                                context.read<AuthCubit>().login(
                                    emailController.text,
                                    passwordController.text);
                              }
                            },
                            child: const Text('Sign In'),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 50, vertical: 15),
                            ),
                          );
                        },
                      ),
                    ),
                    const SizedBox(height: 16),
                    // Forgot password button
                    TextButton(
                      onPressed: () async {
                        final authViewModel =
                            Provider.of<AuthViewModel>(context, listen: false);
                        authViewModel.flag = 1;
                        final prefs = await SharedPreferences.getInstance();
                        await prefs.setInt('flag', 1);
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  const EmailVerificationView()),
                        );
                      },
                      child: const Text('Forgot password?',
                          style: TextStyle(color: Colors.white)),
                    ),
                    const SizedBox(height: 16),
                    // Sign up button
                    TextButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => RegisterView()),
                        );
                      },
                      child: const Text("Don't have an account? Sign up",
                          style: TextStyle(color: Colors.white70)),
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
