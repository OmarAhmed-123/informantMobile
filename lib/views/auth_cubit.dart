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
    String fullName,
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
