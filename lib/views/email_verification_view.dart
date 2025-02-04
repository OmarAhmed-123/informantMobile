/*
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:graduation___part1/views/autoLogin.dart';
import 'package:graduation___part1/views/httpCodeG.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../view_models/auth_view_model.dart';

class EmailVerificationView extends StatefulWidget {
  const EmailVerificationView({Key? key}) : super(key: key);

  @override
  emailVerificationViewS createState() => emailVerificationViewS();
}

class emailVerificationViewS extends State<EmailVerificationView> {
  final formKey = GlobalKey<FormState>();
  final emailController = TextEditingController();

  @override
  void dispose() {
    emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Email Verification'),
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
                TextFormField(
                  controller: emailController,
                  decoration: InputDecoration(
                    labelText: 'Email',
                    filled: true,
                    fillColor: Colors.white.withOpacity(0.7),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your email';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 24),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.purple[700],
                    backgroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 50, vertical: 15),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                  onPressed: () async {
                    if (formKey.currentState!.validate()) {
                      final prefs = await SharedPreferences.getInstance();
                      final authViewModel =
                          Provider.of<AuthViewModel>(context, listen: false);
                      authViewModel.email = emailController.text;
                      AutoLogin.saveEmail(emailController.text);

                      final flag = prefs.getInt("flag");
                      if (flag == 1) {
                        HttpRequest.post(
                          {
                            "endPoint":
                                "/user/forgot?email=${emailController.text}",
                          },
                        ).then((res) async {
                          print("errorzeft${res.statusCode}");
                          if (res.statusCode == 200) {
                            final Map<String, dynamic> data =
                                json.decode(res.toString());
                            await prefs.setString(
                                'pToken', data["messages"]["content"] ?? "");
                            Navigator.pushNamed(context, '/otpForForget');
                          }
                        }).catchError((error) {
                          print("Error: $error");
                        });
                      }
                      if (flag == 2) {
                        HttpRequest.post(
                          {
                            "endPoint":
                                "/user/sendotp?email=${emailController.text}",
                          },
                        ).then((res) {
                          if (res.statusCode == 204) {
                            Navigator.pushNamed(context, '/otp_verification');
                          }
                        }).catchError((error) {
                          print("Error: $error");
                        });
                      }
                    }
                  },
                  child: const Text('Send Verification Code'),
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


import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:graduation___part1/views/autoLogin.dart';
import 'package:graduation___part1/views/httpCodeG.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../view_models/auth_view_model.dart';
import 'auth_cubit.dart' as auth_cubit;

class EmailVerificationView extends StatefulWidget {
  const EmailVerificationView({Key? key}) : super(key: key);

  @override
  EmailVerificationViewState createState() => EmailVerificationViewState();
}

class EmailVerificationViewState extends State<EmailVerificationView> {
  final formKey = GlobalKey<FormState>();
  final emailController = TextEditingController();

  @override
  void dispose() {
    emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Email Verification'),
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
                TextFormField(
                  controller: emailController,
                  decoration: InputDecoration(
                    labelText: 'Email',
                    filled: true,
                    fillColor: Colors.white.withOpacity(0.7),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your email';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 24),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.purple[700],
                    backgroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 50, vertical: 15),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                  onPressed: () async {
                    if (formKey.currentState!.validate()) {
                      final prefs = await SharedPreferences.getInstance();
                      final authViewModel =
                          Provider.of<AuthViewModel>(context, listen: false);
                      authViewModel.email = emailController.text;
                      AutoLogin.saveEmail(emailController.text);

                      final flag = prefs.getInt("flag");
                      if (flag == 1) {
                        context
                            .read<auth_cubit.AuthCubit>()
                            .forgotPassword(emailController.text);
                      } else if (flag == 2) {
                        context
                            .read<auth_cubit.AuthCubit>()
                            .sendOtp(emailController.text);
                      }
                    }
                  },
                  child: const Text('Send Verification Code'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
