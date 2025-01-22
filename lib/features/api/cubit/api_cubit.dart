/*
import 'package:bloc/bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:dio/dio.dart';
import '../../../core/network/api_client.dart';
import '../../../core/network/network_exceptions.dart';

part 'api_state.dart';
part 'api_cubit.freezed.dart';

class ApiCubit extends Cubit<ApiState> {
  final ApiClient _apiClient;

  ApiCubit({ApiClient? apiClient})
      : _apiClient = apiClient ?? ApiClient(),
        super(const ApiState.initial());

  Future<void> makeGetRequest(String endpoint) async {
    emit(const ApiState.loading());

    try {
      final response = await _apiClient.dio.get(endpoint);
      emit(ApiState.success(data: response.data));
    } on DioException catch (e) {
      emit(ApiState.error(error: _handleDioError(e)));
    } catch (e) {
      emit(ApiState.error(error: NetworkException(message: e.toString())));
    }
  }

  Future<void> makePostRequest(
      String endpoint, Map<String, dynamic> data) async {
    emit(const ApiState.loading());

    try {
      final response = await _apiClient.dio.post(endpoint, data: data);
      emit(ApiState.success(data: response.data));
    } on DioException catch (e) {
      emit(ApiState.error(error: _handleDioError(e)));
    } catch (e) {
      emit(ApiState.error(error: NetworkException(message: e.toString())));
    }
  }

  NetworkException _handleDioError(DioException error) {
    switch (error.type) {
      case DioExceptionType.connectionTimeout:
        return NetworkException(
          message: 'Connection timeout',
          statusCode: error.response?.statusCode,
        );
      case DioExceptionType.receiveTimeout:
        return NetworkException(
          message: 'Receive timeout',
          statusCode: error.response?.statusCode,
        );
      case DioExceptionType.connectionError:
        return NetworkException(
          message: 'No internet connection',
          statusCode: error.response?.statusCode,
        );
      default:
        return NetworkException(
          message: error.response?.statusMessage ?? 'Something went wrong',
          statusCode: error.response?.statusCode,
        );
    }
  }

  void updateBaseUrls(List<String> newUrls) {
    _apiClient.updateBaseUrls(newUrls);
  }
}
*/

import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:dio/dio.dart';
import 'dart:io';
import '../../../core/network/api_client.dart';
import '../../../core/network/network_exceptions.dart';
import '../../../core/network/api_result.dart';

part 'api_state.dart';
part 'api_cubit.freezed.dart';

/// ApiCubit handles state management for API requests
class ApiCubit extends Cubit<ApiState> {
  final ApiClient _apiClient;

  ApiCubit({required ApiClient apiClient})
      : _apiClient = apiClient,
        super(const ApiState.initial());

  /// Handle login request
  Future<ApiResult<Map<String, dynamic>>> login(
      String username, String password) async {
    emit(const ApiState.loading());

    try {
      final response = await _apiClient.dio.post(
        '/user/login',
        data: {
          "username": username,
          "password": password,
        },
        options: Options(
          validateStatus: (status) => true,
          headers: {
            'Content-Type': 'application/json',
          },
        ),
      );

      // Store cookies from response
      final cookies = response.headers.map['set-cookie'];
      if (cookies != null && cookies.isNotEmpty) {
        await _apiClient.cookieJar.saveFromResponse(
          Uri.parse(_apiClient.dio.options.baseUrl + '/user/login'),
          cookies.map((cookie) => Cookie.fromSetCookieValue(cookie)).toList(),
        );
      }

      switch (response.statusCode) {
        case 200:
          emit(ApiState.success(data: response.data));
          return ApiResult.success(data: response.data as Map<String, dynamic>);

        case 204:
          emit(const ApiState.unverified());
          // Navigate to the '/email_verification' page
          //Navigator.pushNamed(context, '/email_verification');
          /*
          Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => const ()),
                              );
                            }
                            */
          return ApiResult.failure(message: 'Email verification required');


        case 401:
          await _apiClient.clearCookies();
          final error = NetworkException(
            message: 'Invalid credentials',
            statusCode: 401,
          );
          emit(ApiState.error(error: error));
          return ApiResult.failure(message: error.message);

        case 404:
          final error = NetworkException(
            message: 'User not found',
            statusCode: 404,
          );
          emit(ApiState.error(error: error));
          return ApiResult.failure(message: error.message);

        case 500:
          final error = NetworkException(
            message: 'Server error',
            statusCode: 500,
          );
          emit(ApiState.error(error: error));
          return ApiResult.failure(message: error.message);

        default:
          final error = NetworkException(
            message: 'Unexpected error',
            statusCode: response.statusCode,
          );
          emit(ApiState.error(error: error));
          return ApiResult.failure(message: error.message);
      }
    } on DioException catch (e) {
      final error = _handleDioError(e);
      emit(ApiState.error(error: error));
      return ApiResult.failure(message: error.message);
    } catch (e) {
      final error = NetworkException(message: e.toString());
      emit(ApiState.error(error: error));
      return ApiResult.failure(message: error.message);
    }
  }

  /// Handle generic GET request
  Future<ApiResult<T>> makeGetRequest<T>(String endpoint) async {
    emit(const ApiState.loading());

    try {
      final response = await _apiClient.dio.get(
        endpoint,
        options: Options(
          validateStatus: (status) => true,
          headers: {
            'Content-Type': 'application/json',
          },
        ),
      );

      switch (response.statusCode) {
        case 200:
          emit(ApiState.success(data: response.data));
          return ApiResult.success(data: response.data as T);

        case 204:
          emit(const ApiState.unverified());
          return ApiResult.failure(message: 'OTP verification required');

        case 401:
          await _apiClient.clearCookies();
          final error = NetworkException(
            message: 'Unauthorized access. Please login again.',
            statusCode: 401,
          );
          emit(ApiState.error(error: error));
          return ApiResult.failure(message: error.message);

        case 404:
          final error = NetworkException(
            message: 'Resource not found',
            statusCode: 404,
          );
          emit(ApiState.error(error: error));
          return ApiResult.failure(message: error.message);

        case 500:
          final error = NetworkException(
            message: 'Server error occurred',
            statusCode: 500,
          );
          emit(ApiState.error(error: error));
          return ApiResult.failure(message: error.message);

        default:
          final error = NetworkException(
            message: 'Unexpected error occurred',
            statusCode: response.statusCode,
          );
          emit(ApiState.error(error: error));
          return ApiResult.failure(message: error.message);
      }
    } on DioException catch (e) {
      final error = _handleDioError(e);
      emit(ApiState.error(error: error));
      return ApiResult.failure(message: error.message);
    } catch (e) {
      final error = NetworkException(message: e.toString());
      emit(ApiState.error(error: error));
      return ApiResult.failure(message: error.message);
    }
  }

  /// Handle generic POST request
  Future<ApiResult<T>> makePostRequest<T>(
      String endpoint, Map<String, dynamic> data) async {
    emit(const ApiState.loading());

    try {
      final response = await _apiClient.dio.post(
        endpoint,
        data: data,
        options: Options(
          validateStatus: (status) => true,
          headers: {
            'Content-Type': 'application/json',
          },
        ),
      );

      // Store cookies from response
      final cookies = response.headers.map['set-cookie'];
      if (cookies != null && cookies.isNotEmpty) {
        await _apiClient.cookieJar.saveFromResponse(
          Uri.parse(_apiClient.dio.options.baseUrl + endpoint),
          cookies.map((cookie) => Cookie.fromSetCookieValue(cookie)).toList(),
        );
      }

      switch (response.statusCode) {
        case 200:
          emit(ApiState.success(data: response.data));
          return ApiResult.success(data: response.data as T);

        case 204:
          emit(const ApiState.unverified());
          return ApiResult.failure(message: 'OTP verification required');

        case 401:
          await _apiClient.clearCookies();
          final error = NetworkException(
            message: 'Unauthorized access. Please login again.',
            statusCode: 401,
          );
          emit(ApiState.error(error: error));
          return ApiResult.failure(message: error.message);

        case 404:
          final error = NetworkException(
            message: 'Resource not found',
            statusCode: 404,
          );
          emit(ApiState.error(error: error));
          return ApiResult.failure(message: error.message);

        case 500:
          final error = NetworkException(
            message: 'Server error occurred',
            statusCode: 500,
          );
          emit(ApiState.error(error: error));
          return ApiResult.failure(message: error.message);

        default:
          final error = NetworkException(
            message: 'Unexpected error occurred',
            statusCode: response.statusCode,
          );
          emit(ApiState.error(error: error));
          return ApiResult.failure(message: error.message);
      }
    } on DioException catch (e) {
      final error = _handleDioError(e);
      emit(ApiState.error(error: error));
      return ApiResult.failure(message: error.message);
    } catch (e) {
      final error = NetworkException(message: e.toString());
      emit(ApiState.error(error: error));
      return ApiResult.failure(message: error.message);
    }
  }

  /// Handle Dio errors
  NetworkException _handleDioError(DioException error) {
    switch (error.type) {
      case DioExceptionType.connectionTimeout:
        return NetworkException(
          message: 'Connection timeout',
          statusCode: error.response?.statusCode,
        );
      case DioExceptionType.receiveTimeout:
        return NetworkException(
          message: 'Receive timeout',
          statusCode: error.response?.statusCode,
        );
      case DioExceptionType.connectionError:
        return NetworkException(
          message: 'No internet connection',
          statusCode: error.response?.statusCode,
        );
      default:
        return NetworkException(
          message: error.response?.statusMessage ?? 'Something went wrong',
          statusCode: error.response?.statusCode,
        );
    }
  }
}
