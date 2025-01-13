import 'package:dio/dio.dart';

class ApiClient {
  static final ApiClient _instance = ApiClient._internal();
  late final Dio dio;

  // Base URLs
  static const List<String> _baseUrls = [
    'https://infinitely-native-lamprey.ngrok-free.app',
    'https://informant122.ddns.net:7125',
    'http://informant122.ddns.net:7125'
  ];

  int _currentUrlIndex = 0;

  factory ApiClient() {
    return _instance;
  }

  ApiClient._internal() {
    dio = Dio(BaseOptions(
      baseUrl: _baseUrls[_currentUrlIndex],
      connectTimeout: const Duration(seconds: 30),
      receiveTimeout: const Duration(seconds: 30),
      headers: {
        'Content-Type': 'application/json',
      },
    ));

    // Add interceptors for logging and error handling
    dio.interceptors.add(InterceptorsWrapper(
      onRequest: (options, handler) {
        print('REQUEST[${options.method}] => PATH: ${options.path}');
        return handler.next(options);
      },
      onResponse: (response, handler) {
        print(
            'RESPONSE[${response.statusCode}] => PATH: ${response.requestOptions.path}');
        return handler.next(response);
      },
      onError: (DioException e, handler) async {
        if (_shouldRetryWithNextUrl(e)) {
          final retryResponse = await _retryWithNextUrl(e.requestOptions);
          if (retryResponse != null) {
            return handler.resolve(retryResponse);
          }
        }
        return handler.next(e);
      },
    ));
  }

  bool _shouldRetryWithNextUrl(DioException error) {
    return error.type == DioExceptionType.connectionError ||
        error.type == DioExceptionType.connectionTimeout ||
        error.response?.statusCode == 503;
  }

  Future<Response?> _retryWithNextUrl(RequestOptions requestOptions) async {
    if (_currentUrlIndex < _baseUrls.length - 1) {
      _currentUrlIndex++;
      dio.options.baseUrl = _baseUrls[_currentUrlIndex];

      try {
        return await dio.request(
          requestOptions.path,
          data: requestOptions.data,
          queryParameters: requestOptions.queryParameters,
          options: Options(
            method: requestOptions.method,
            headers: requestOptions.headers,
          ),
        );
      } catch (e) {
        return null;
      }
    }
    return null;
  }

  void updateBaseUrls(List<String> newUrls) {
    if (newUrls.isNotEmpty) {
      _baseUrls.clear();
      _baseUrls.addAll(newUrls);
      _currentUrlIndex = 0;
      dio.options.baseUrl = _baseUrls[_currentUrlIndex];
    }
  }
}
