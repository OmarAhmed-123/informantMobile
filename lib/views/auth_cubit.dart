/*
import 'package:dio/dio.dart';
import 'package:dio_cookie_manager/dio_cookie_manager.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:cookie_jar/cookie_jar.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart';

class AuthCubit extends Cubit<AuthState> {
  AuthCubit() : super(AuthInitial());

  Future<void> login(String username, String password) async {
    emit(AuthLoading());
    try {
      final dio = Dio();
      final appDocDir = await getApplicationDocumentsDirectory();
      final cookiePath = join(appDocDir.path, 'cookies');
      final cookieJar = PersistCookieJar(storage: FileStorage(cookiePath));
      dio.interceptors.add(CookieManager(cookieJar));

      final response = await dio.post(
        'https://infinitely-native-lamprey.ngrok-free.app/login',
        data: {'username': username, 'password': password},
        options: Options(headers: {'Content-Type': 'application/json'}),
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = response.data;
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('CookieToken', data["token"] ?? "");
        await prefs.setString('pToken', data["ptoken"] ?? "");

        emit(AuthSuccess());
      } else {
        emit(AuthFailure(error: 'Login failed: ${response.statusCode}'));
      }
    } catch (e) {
      emit(AuthFailure(error: e.toString()));
    }
  }

  Future<void> register(
    String username,
    String password,
    String email,
    String phone,
    String fullName, String s,
  ) async {
    emit(AuthLoading());
    try {
      final dio = Dio();
      final appDocDir = await getApplicationDocumentsDirectory();
      final cookiePath = join(appDocDir.path, 'cookies');
      final cookieJar = PersistCookieJar(storage: FileStorage(cookiePath));
      dio.interceptors.add(CookieManager(cookieJar));

      final response = await dio.post(
        'https://infinitely-native-lamprey.ngrok-free.app/user/signup',
        data: {
          "password": password,
          "username": username,
          "email": email,
          "phoneNumber": phone,
          "fullName": fullName,
          "details": "",
          "ConfirmPassword": password,
          "linkedIn": "",
        },
        options: Options(headers: {'Content-Type': 'application/json'}),
      );

      if (response.statusCode == 204) {
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('email', email);
        emit(AuthSuccess());
      } else {
        emit(AuthFailure(error: 'Registration failed: ${response.statusCode}'));
      }
    } catch (e) {
      emit(AuthFailure(error: e.toString()));
    }
  }

  Future<void> forgotPassword(String email) async {
    emit(AuthLoading());
    try {
      final dio = Dio();
      final appDocDir = await getApplicationDocumentsDirectory();
      final cookiePath = join(appDocDir.path, 'cookies');
      final cookieJar = PersistCookieJar(storage: FileStorage(cookiePath));
      dio.interceptors.add(CookieManager(cookieJar));

      final response = await dio.post(
        'https://infinitely-native-lamprey.ngrok-free.app/forgot',
        data: {'email': email},
        options: Options(headers: {'Content-Type': 'application/json'}),
      );

      if (response.statusCode == 200) {
        emit(AuthSuccess());
      } else {
        emit(AuthFailure(
            error: 'Password reset failed: ${response.statusCode}'));
      }
    } catch (e) {
      emit(AuthFailure(error: e.toString()));
    }
  }

  Future<void> sendOtp(String email) async {
    emit(AuthLoading());
    try {
      final dio = Dio();
      final appDocDir = await getApplicationDocumentsDirectory();
      final cookiePath = join(appDocDir.path, 'cookies');
      final cookieJar = PersistCookieJar(storage: FileStorage(cookiePath));
      dio.interceptors.add(CookieManager(cookieJar));

      final response = await dio.post(
        'https://infinitely-native-lamprey.ngrok-free.app/sendotp',
        data: {'email': email},
        options: Options(headers: {'Content-Type': 'application/json'}),
      );

      if (response.statusCode == 200) {
        emit(AuthSuccess());
      } else {
        emit(AuthFailure(error: 'OTP sending failed: ${response.statusCode}'));
      }
    } catch (e) {
      emit(AuthFailure(error: e.toString()));
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
*/

import 'package:shared_preferences/shared_preferences.dart';
import 'package:dio/dio.dart';
import 'package:dio_cookie_manager/dio_cookie_manager.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:cookie_jar/cookie_jar.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart';
import 'register_view.dart';
import 'package:graduation___part1/views/autoLogin.dart';
import '../view_models/auth_view_model.dart';
import 'email_verification_view.dart';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:graduation___part1/views/httpCodeG.dart';
import 'home_view.dart';

List<Map<String, dynamic>> ads = [];
List<Map<String, dynamic>> plans = [];

class AuthCubit extends Cubit<AuthState> {
  AuthCubit() : super(AuthInitial());

  Future<Dio> getDio() async {
    final dio = Dio();
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? token = prefs.getString('Token');
    final String? ptoken = prefs.getString('pToken');
    dio.options.headers = {
      "Content-Type": "application/json",
      'ngrok-skip-browser-warning': 'true',
    };
    if (token != null && ptoken != null) {
      dio.options.headers['Token'] = token;
      dio.options.headers['pToken'] = ptoken;
    } else if (token != null) {
      dio.options.headers['Token'] = token;
    } else if (ptoken != null) {
      dio.options.headers['pToken'] = ptoken;
    }
    return dio;
  }

  Future<void> createAd({
    required String name,
    required String details,
    required String imageName,
    required String images,
    required int planNum,
    required bool setToPublic,
    required String link,
  }) async {
    try {
      final Dio dio = await getDio();
      final response = await dio.post(
        'https://infinitely-native-lamprey.ngrok-free.app/user/createAd',
        data: {
          "name": name,
          "details": details,
          "imageName": imageName,
          "images": images,
          "planNum": planNum,
          "setToPublic": setToPublic,
          "link": link,
        },
        options: Options(headers: {'Content-Type': 'application/json'}),
      );
      if (response.statusCode == 200) {
        print('Ad creation is done');
        emit(AuthSuccess());
      } else {
        throw Exception('Failed to create ad');
      }
    } catch (e) {
      // Handle exceptions
      throw Exception('Error: $e');
    }
  }

  Future<void> getAds() async {
    emit(AuthLoading());
    try {
      final Dio dio = await getDio();
      final response = await dio.post(
        'https://infinitely-native-lamprey.ngrok-free.app/user/home',
      );
      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.toString());
        if (data['messages']['content'] != null) {
          ads = List<Map<String, dynamic>>.from(data['messages']['content']);
          emit(AdsLoaded(Ads: ads));
        } else {
          throw Exception('No content found');
        }
      } else {
        emit(AuthFailure(error: 'Failed to load ads: ${response.statusCode}'));
      }
    } catch (error) {
      emit(AuthFailure(error: error.toString()));
    }
  }

  Future<void> getPlans() async {
    emit(AuthLoading());
    try {
      final Dio dio = await getDio();
      final response = await dio.post(
        'https://infinitely-native-lamprey.ngrok-free.app/user/plans',
      );
      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.toString());
        if (data['messages']['content'] != null) {
          plans = List<Map<String, dynamic>>.from(data['messages']['content']);
          emit(PlansLoaded(Plans: plans));
        } else {
          throw Exception('No plans found');
        }
      } else {
        emit(
            AuthFailure(error: 'Failed to load plans: ${response.statusCode}'));
      }
    } catch (error) {
      emit(AuthFailure(error: error.toString()));
    }
  }

  Future<void> login(
      String username, String password, BuildContext context) async {
    emit(AuthLoading());
    final prefs = await SharedPreferences.getInstance();
    try {
      final Dio dio = await getDio();
      final response = await dio.post(
        'https://infinitely-native-lamprey.ngrok-free.app/user/login',
        data: {
          "username": username,
          "password": password,
        },
        options: Options(headers: {'Content-Type': 'application/json'}),
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = response.data;
        await prefs.setString('Token', data["token"] ?? "");
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
        if (username.contains("@")) {
          await prefs.setString('email', username);
          Navigator.pushReplacementNamed(context, '/otp_verification');
        } else {
          await prefs.setInt('flag', 2);
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

  Future<void> register(
    String username,
    String password,
    String email,
    String phone,
    String fullName, String? selectedGender,
  ) async {
    emit(AuthLoading());
    try {
      final Dio dio = await getDio();
      final response = await dio.post(
        'https://infinitely-native-lamprey.ngrok-free.app/user/signup',
        data: {
          "password": password,
          "username": username,
          "email": email,
          "phoneNumber": phone,
          "fullName": fullName,
          "details": "",
          "ConfirmPassword": password,
          "linkedIn": "",
        },
        options: Options(headers: {'Content-Type': 'application/json'}),
      );
      if (response.statusCode == 204) {
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('email', email);
        emit(AuthSuccess());
      } else {
        emit(AuthFailure(error: 'Registration failed: ${response.statusCode}'));
      }
    } catch (e) {
      emit(AuthFailure(error: e.toString()));
    }
  }

  Future<void> forgotPassword(String email) async {
    emit(AuthLoading());
    try {
      final Dio dio = await getDio();
      final response = await dio.post(
        'https://infinitely-native-lamprey.ngrok-free.app/forgot',
        data: {'email': email},
        options: Options(headers: {'Content-Type': 'application/json'}),
      );
      if (response.statusCode == 200) {
        emit(AuthSuccess());
      } else {
        emit(AuthFailure(
            error: 'Password reset failed: ${response.statusCode}'));
      }
    } catch (e) {
      emit(AuthFailure(error: e.toString()));
    }
  }

  Future<void> sendOtp(String email) async {
    emit(AuthLoading());
    try {
      final Dio dio = await getDio();
      final response = await dio.post(
        'https://infinitely-native-lamprey.ngrok-free.app/sendotp',
        data: {'email': email},
        options: Options(headers: {'Content-Type': 'application/json'}),
      );
      if (response.statusCode == 200) {
        emit(AuthSuccess());
      } else {
        emit(AuthFailure(error: 'OTP sending failed: ${response.statusCode}'));
      }
    } catch (e) {
      emit(AuthFailure(error: e.toString()));
    }
  }

  Future<void> resetPassword(String newPassword) async {
    emit(AuthLoading());
    try {
      final Dio dio = await getDio();
      final response = await dio.post(
        'https://infinitely-native-lamprey.ngrok-free.app/user/editprofile',
        data: {
          "fullname": "",
          "password": newPassword,
          "phone": "",
          "email": "",
          "details": "",
        },
        options: Options(headers: {'Content-Type': 'application/json'}),
      );

      if (response.statusCode == 200) {
        // Save cookies if necessary
        final Map<String, dynamic> data = json.decode(response.toString());
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('Token', data["messages"]["content"]);
        await prefs.setString('pToken', "");
        emit(AuthSuccess());
      } else {
        emit(AuthFailure(error: 'Password reset failed'));
      }
    } catch (e) {
      emit(AuthFailure(error: e.toString()));
    }
  }

  Future<void> verifyOtp(String email, String otp) async {
    emit(AuthLoading());
    try {
      final Dio dio = await getDio();
      final response = await dio.post(
        'https://infinitely-native-lamprey.ngrok-free.app/user/verify', // Replace with your actual API URL
        data: {
          "otp": otp,
          "email": email,
        },
        options: Options(headers: {'Content-Type': 'application/json'}),
      );
      if (response.statusCode == 200 || response.statusCode == 201) {
        final Map<String, dynamic> data = response.data;
        if (data.containsKey("messages") &&
            data["messages"].containsKey("content")) {
          final prefs = await SharedPreferences.getInstance();
          await prefs.setString('pToken', data["ptoken"] ?? "");
          emit(AuthSuccess());
        } else {
          emit(AuthFailure(error: 'Invalid response structure'));
        }
      } else {
        emit(AuthFailure(
            error: 'OTP verification failed: ${response.statusCode}'));
      }
    } catch (e) {
      emit(AuthFailure(error: e.toString()));
    }
  }

  Future<void> fetchAds() async {
    emit(AuthLoading());
    try {
      final Dio dio = await getDio();
      final response = await dio.post(
        'https://infinitely-native-lamprey.ngrok-free.app/user/home',
      );
      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.toString());
        if (data['messages']['content'] != null) {
          ads = List<Map<String, dynamic>>.from(data['messages']['content']);
          emit(AdsLoaded(Ads: ads));
        } else {
          throw Exception('No content found');
        }
      } else {
        emit(AuthFailure(error: 'Failed to load ads: ${response.statusCode}'));
      }
    } catch (error) {
      emit(AuthFailure(error: error.toString()));
    }
  }

  Future<void> updateAdVisibility(int adId, bool isPublic) async {
    emit(AuthLoading());
    try {
      final Dio dio = await getDio();
      final response = await dio.post(
        'https://infinitely-native-lamprey.ngrok-free.app/user/updateAdVisibility',
        data: {
          "adId": adId,
          "isPublic": isPublic,
        },
        options: Options(headers: {'Content-Type': 'application/json'}),
      );
      if (response.statusCode == 200) {
        fetchAds(); // Refresh the list
      } else {
        emit(AuthFailure(error: 'Failed to update ad visibility'));
      }
    } catch (e) {
      emit(AuthFailure(error: e.toString()));
    }
  }
}

abstract class AuthState {}

class AuthInitial extends AuthState {}

class AuthLoading extends AuthState {}

class AuthSuccess extends AuthState {}

class AdsLoaded extends AuthState {
  final List<Map<String, dynamic>> Ads;
  AdsLoaded({required this.Ads});
}

class PlansLoaded extends AuthState {
  final List<Map<String, dynamic>> Plans;
  PlansLoaded({required this.Plans});
}

class AuthFailure extends AuthState {
  final String error;
  AuthFailure({required this.error});
}
