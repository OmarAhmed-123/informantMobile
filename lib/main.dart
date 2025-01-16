// ignore_for_file: unused_local_variable

import 'dart:io';
import 'package:graduation___part1/views/httpCodeG.dart';
import 'package:provider/provider.dart';
import 'view_models/auth_view_model.dart';
import 'views/register_view.dart';
import 'package:flutter/material.dart';
import 'views/login_view.dart';
import 'views/home_view.dart';
import 'views/autoLogin.dart';
import 'views/connection.dart';
import 'views/showConnection.dart';
import 'views/forgot_password_view.dart';
import 'views/email_verification_view.dart';
import 'views/otp_verification_view.dart';
import 'services/api_service.dart';
import 'package:no_screenshot/no_screenshot.dart';
import 'views/otpForForgotPassword.dart';
import 'views/variables.dart';

void main() {
  HttpOverrides.global = MyHttpOverrides();
  final apiService = ApiService(baseUrl: 'http://localhost:58824');

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthViewModel()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);
  @override
  MyAppS createState() => MyAppS();
}

class MyAppS extends State<MyApp> {
  final no = NoScreenshot.instance;
  @override
  void initState() {
    super.initState();
    // no.screenshotOff();
    // getAds();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: '',
      theme: ThemeData(
        primarySwatch: Colors.purple,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      initialRoute: '/connection',
      routes: {
        '/signup': (context) => const RegisterView(),
        '/login': (context) => const LoginView(),
        '/email_verification': (context) => const EmailVerificationView(),
        '/otp_verification': (context) => const OtpVerificationView(),
        '/otpForForget': (context) => const OtpForForgotPassword(),
        '/home': (context) => const HomeView(),
        '/forgot': (context) => const ForgotPasswordView(),
        '/AutoLogin': (context) => const AutoLogin(),
        '/connection': (context) => const Connection(),
        '/shConnection': (context) => const ShowConnection(),
      },
    );
  }
}
