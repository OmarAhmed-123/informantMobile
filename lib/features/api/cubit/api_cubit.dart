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
