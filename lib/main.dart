// ignore_for_file: use_super_parameters, unused_local_variable, unused_import

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:graduation___part1/views/httpCodeG.dart';
import 'package:provider/provider.dart';
import 'view_models/auth_view_model.dart';
import 'view_models/ad_view_model.dart';
import 'views/register_view.dart';
import 'views/login_view.dart';
import 'views/home_view.dart';
import 'views/email_verification_view.dart';
import 'views/otp_verification_view.dart';
import 'services/api_service.dart';

void main() {
    HttpOverrides.global = MyHttpOverrides();//while using Not certificate ssl
  final apiService = ApiService(
      baseUrl: 'http://localhost:58824'); // Replace with your local IP address

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthViewModel()),
        //ChangeNotifierProvider(create: (_) => AdViewModel(apiService)),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Auth Demo',
      theme: ThemeData(
        primarySwatch: Colors.purple,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      initialRoute: '/login',
      routes: {
        '/signup': (context) => const RegisterView(),
        '/login': (context) => const LoginView(),
        '/email_verification': (context) => const EmailVerificationView(),
        '/otp_verification': (context) => const OtpVerificationView(),
        '/home': (context) => const HomeView(),
      },
    );
  }
}
