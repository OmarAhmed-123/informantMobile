/*
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
import 'package:flutter_bloc/flutter_bloc.dart'; // Import flutter_bloc

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
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      navigatorKey: navigatorKey, // Use the single global navigatorKey
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
        '/home': (context) => BlocProvider(
              create: (context) => AdsCubit(), // Provide AdsCubit here
              child: const HomeView(),
            ),
        '/forgot': (context) => const ForgotPasswordView(),
        '/AutoLogin': (context) => const AutoLogin(),
        '/connection': (context) => const Connection(),
        '/shConnection': (context) => const ShowConnection(),
      },
    );
  }
}
*/

import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import 'package:no_screenshot/no_screenshot.dart';
import 'view_models/auth_view_model.dart';
import 'views/httpCodeG.dart';
import 'views/register_view.dart';
import 'views/login_view.dart';
import 'views/home_view.dart';
import 'views/autoLogin.dart';
import 'views/connection.dart';
import 'views/showConnection.dart';
import 'views/forgot_password_view.dart';
import 'views/email_verification_view.dart';
import 'views/otp_verification_view.dart';
import 'views/otpForForgotPassword.dart';
import 'views/variables.dart';
import 'services/api_service.dart';
import 'views/auth_cubit.dart' as auth_cubit;

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  HttpOverrides.global = MyHttpOverrides();

  const bool useLocalServer = false;
  final String baseUrl = useLocalServer
      ? 'http://localhost:58824'
      : 'https://infinitely-native-lamprey.ngrok-free.app';

  final apiService = ApiService(baseUrl: baseUrl);

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthViewModel()),
        Provider<ApiService>.value(value: apiService),
        BlocProvider(create: (context) => auth_cubit.AuthCubit()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  MyAppState createState() => MyAppState();
}

class MyAppState extends State<MyApp> {
  final NoScreenshot _noScreenshot = NoScreenshot.instance;

  @override
  void initState() {
    super.initState();
    // _noScreenshot.screenshotOff(); // Uncomment if needed
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      navigatorKey: navigatorKey,
      debugShowCheckedModeBanner: false,
      title: 'Informat',
      theme: ThemeData(
        primarySwatch: Colors.purple,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      initialRoute: '/home',
      routes: {
        '/signup': (context) => const RegisterView(),
        '/login': (context) => const LoginView(),
        '/email_verification': (context) => const EmailVerificationView(),
        '/otp_verification': (context) => const OtpVerificationView(),
        '/otpForForget': (context) => const OtpForForgotPassword(),
        '/home': (context) => BlocProvider(
              create: (context) => AdsCubit(),
              child: const HomeView(),
            ),
        '/forgot': (context) => const ForgotPasswordView(),
        '/AutoLogin': (context) => const AutoLogin(),
        '/connection': (context) => const Connection(),
        '/shConnection': (context) => const ShowConnection(),
      },
    );
  }
}
