/*
// ignore_for_file: depend_on_referenced_packages

import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/ad.dart';

class ApiService {
  final String baseUrl;

  ApiService({required this.baseUrl});

  Future<List<Ad>> fetchAds() async {
    final response = await http.get(Uri.parse('$baseUrl/ads'));

    if (response.statusCode == 200) {
      List<dynamic> adsJson = json.decode(response.body);
      return adsJson.map((json) => Ad.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load ads');
    }
  }

  Future<Ad> createAd(Ad ad) async {
    final response = await http.post(
      Uri.parse('$baseUrl/ads'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode(ad.toJson()),
    );

    if (response.statusCode == 201) {
      return Ad.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to create ad');
    }
  }
}
*/

import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// ApiService handles all network requests and response handling
class ApiService {
  final Dio _dio;
  static const String baseUrl =
      'https://infinitely-native-lamprey.ngrok-free.app';

  ApiService() : _dio = Dio() {
    _dio.options.baseUrl = baseUrl;
    _dio.options.connectTimeout = const Duration(seconds: 30);
    _dio.options.receiveTimeout = const Duration(seconds: 30);
    _dio.interceptors.add(_createInterceptor());
  }

  /// Create interceptor for handling tokens and errors
  Interceptor _createInterceptor() {
    return InterceptorsWrapper(
      onRequest: (options, handler) async {
        // Add auth token if available
        final token = await _getToken();
        if (token != null) {
          options.headers['Authorization'] = 'Bearer $token';
        }
        return handler.next(options);
      },
      onResponse: (response, handler) async {
        // Handle successful responses
        if (response.statusCode == 200) {
          // Save token if provided
          final token = response.headers.value('Authorization');
          if (token != null) {
            await _saveToken(token);
          }
        }
        return handler.next(response);
      },
      onError: (error, handler) async {
        // Handle different error codes
        DioError newError;
        switch (error.response?.statusCode) {
          case 401:
            // Handle unauthorized access
            await _handleUnauthorized();
            newError = error.copyWith(
              error: 'Unauthorized access',
            );
            break;
          case 404:
            // Handle not found
            newError = error.copyWith(
              error: 'Resource not found',
            );
            break;
          case 500:
            // Handle server error
            newError = error.copyWith(
              error: 'Server error occurred',
            );
            break;
          case 204:
            // Handle OTP requirement
            newError = error.copyWith(
              error: 'OTP verification required',
            );
            break;
          default:
            newError = error;
        }
        return handler.next(newError);
      },
    );
  }

  /// Get stored auth token
  Future<String?> _getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('auth_token');
  }

  /// Save auth token
  Future<void> _saveToken(String token) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('auth_token', token);
  }

  /// Handle unauthorized access
  Future<void> _handleUnauthorized() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('auth_token');
    // Navigate to login screen
  }

  /// Make GET request
  Future<Response> get(String path) async {
    try {
      return await _dio.get(path);
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  /// Make POST request
  Future<Response> post(String path, dynamic data) async {
    try {
      return await _dio.post(path, data: data);
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  /// Handle Dio errors
  Exception _handleError(DioException error) {
    switch (error.type) {
      case DioExceptionType.connectionTimeout:
        return Exception('Connection timeout');
      case DioExceptionType.receiveTimeout:
        return Exception('Receive timeout');
      case DioExceptionType.connectionError:
        return Exception('No internet connection');
      default:
        return Exception(error.message ?? 'An error occurred');
    }
  }
}
