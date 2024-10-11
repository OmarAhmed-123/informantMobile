// ignore_for_file: use_super_parameters

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'view_models/auth_view_model.dart';
import 'view_models/ad_view_model.dart';
import 'views/register_view.dart';
import 'views/login_view.dart';
import 'views/home_view.dart';
import 'views/otp_verification_view.dart';
import 'services/api_service.dart';

void main() {
  final apiService = ApiService(
      baseUrl:
          'http://localhost:58824'); // Replace with your local IP address

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthViewModel()),
        ChangeNotifierProvider(create: (_) => AdViewModel(apiService)),
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
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      initialRoute: '/signup',
      routes: {
        '/signup': (context) => const RegisterView(),
        '/login': (context) => const LoginView(),
        '/otp_verification': (context) => const OtpVerificationView(),
        '/home': (context) => const HomeView(),
      },
    );
  }
}
