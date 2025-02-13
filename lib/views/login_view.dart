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

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:graduation___part1/views/httpCodeG.dart';
import 'home_view.dart';
import 'register_view.dart';
import 'package:graduation___part1/views/autoLogin.dart';
import '../view_models/auth_view_model.dart';
import 'email_verification_view.dart';
import 'package:provider/provider.dart';

class AuthCubit extends Cubit<AuthState> {
  AuthCubit() : super(AuthInitial());

  Future<void> login(
      String username, String password, BuildContext context) async {
    emit(AuthLoading());

    final prefs = await SharedPreferences.getInstance();
    final authViewModel = Provider.of<AuthViewModel>(context, listen: false);

    try {
      final response = await HttpRequest.post({
        "endPoint": "/user/login",
        "username": username,
        "password": password,
      });

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.toString());
        await prefs.setString('CookieToken', data["token"] ?? "");
        await prefs.setString('pToken', data["ptoken"] ?? "");
        AutoLogin.saveData(username, password);

        emit(AuthSuccess());
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Login successful!')),
        );
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const HomeView()),
        );
      } else if (response.statusCode == 204) {
        authViewModel.password = password;
        if (username.contains("@")) {
          await prefs.setString('email', username);
          Navigator.pushReplacementNamed(context, '/otp_verification');
        } else {
          authViewModel.flag = 2;
          authViewModel.username = username;
          Navigator.pushReplacementNamed(context, '/email_verification');
        }
      } else {
        emit(AuthFailure(error: 'Error: Status Code ${response.statusCode}'));
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: Status Code ${response.statusCode}')),
        );
      }
    } catch (error) {
      emit(AuthFailure(error: error.toString()));
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $error')),
      );
    }
  }
}

abstract class AuthState {}

class AuthInitial extends AuthState {}

class AuthLoading extends AuthState {}

class AuthSuccess extends AuthState {}

class AuthFailure extends AuthState {
  final String error;
  AuthFailure({required this.error});
}

class LoginView extends StatefulWidget {
  const LoginView({super.key});

  @override
  _LoginViewState createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView>
    with SingleTickerProviderStateMixin {
  final formKey = GlobalKey<FormState>();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  late AnimationController animationController;
  late Animation<double> fadeAnimation;
  bool visiblePassword2 = false;

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
                    BlocProvider(
                      create: (context) => AuthCubit(),
                      child: BlocConsumer<AuthCubit, AuthState>(
                        listener: (context, state) {
                          if (state is AuthSuccess) {
                            ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                    content: Text('Login successful!')));
                          } else if (state is AuthFailure) {
                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                content: Text('Error: ${state.error}')));
                          }
                        },
                        builder: (context, state) {
                          if (state is AuthLoading) {
                            return const CircularProgressIndicator();
                          }
                          return ElevatedButton(
                            onPressed: () {
                              if (formKey.currentState!.validate()) {
                                context.read<AuthCubit>().login(
                                    emailController.text,
                                    passwordController.text,
                                    context);
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
