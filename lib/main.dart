import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'views/startPage.dart';
import 'views/chatBot.dart';
import 'package:provider/provider.dart';
// import 'package:no_screenshot/no_screenshot.dart';
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
import 'services/api_service.dart';
import 'views/auth_cubit.dart' as auth_cubit;

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  HttpOverrides.global = MyHttpOverrides();

  const bool useLocalServer = false;

  const String baseUrl = useLocalServer
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
  const MyApp({super.key});
  @override
  MyAppState createState() => MyAppState();
}

class MyAppState extends State<MyApp> with WidgetsBindingObserver {
  // final NoScreenshot _noScreenshot = NoScreenshot.instance;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
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
      initialRoute: '/connection',
      routes: {
        '/signup': (context) => const RegisterView(),
        '/login': (context) => const LoginView(),
        '/start': (context) => const StartPage(),
        '/email_verification': (context) => const EmailVerificationView(),
        '/otp_verification': (context) => const OtpVerificationView(),
        '/home': (context) => const HomeView(),
        '/forgot': (context) => const ForgotPasswordView(),
        '/AutoLogin': (context) => AutoLogin(),
        '/connection': (context) => const Connection(),
        // '/shConnection': (context) => const ShowConnection(),
        '/chatBot': (context) => const ChatBot(),
      },
    );
  }
}
