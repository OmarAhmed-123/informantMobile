/*
import 'package:dio/dio.dart';
import 'package:cookie_jar/cookie_jar.dart';
import 'package:dio_cookie_manager/dio_cookie_manager.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';

class ApiClient {
  // Singleton instance
  static final ApiClient _instance = ApiClient._internal();
  late final Dio dio;
  late final PersistCookieJar cookieJar;

  // Base URLs for API endpoints
  static const List<String> _baseUrls = [
    'https://infinitely-native-lamprey.ngrok-free.app'
    /*
    'https://informant122.ddns.net:7125',
    'http://informant122.ddns.net:7125'
    */
  ];

  int _currentUrlIndex = 0;

  // Factory constructor to return singleton instance
  factory ApiClient() {
    return _instance;
  }

  // Private constructor for singleton pattern
  ApiClient._internal() {
    _initializeDio();
  }

  /// Initialize Dio client with configurations and interceptors
  Future<void> _initializeDio() async {
    dio = Dio(BaseOptions(
      baseUrl: _baseUrls[_currentUrlIndex],
      connectTimeout: const Duration(seconds: 30),
      receiveTimeout: const Duration(seconds: 30),
      headers: {
        'Content-Type': 'application/json',
      },
      // Enable cookie handling
      validateStatus: (status) => true,
      receiveDataWhenStatusError: true,
    ));

    // Initialize persistent cookie jar
    final appDocDir = await getApplicationDocumentsDirectory();
    final appDocPath = appDocDir.path;
    cookieJar = PersistCookieJar(
      ignoreExpires: true,
      storage: FileStorage("$appDocPath/.cookies/"),
    );

    // Add cookie manager interceptor
    dio.interceptors.add(CookieManager(cookieJar));

    // Add logging and error handling interceptor
    dio.interceptors.add(InterceptorsWrapper(
      onRequest: (options, handler) {
        print('REQUEST[${options.method}] => PATH: ${options.path}');
        // Log cookies being sent
        cookieJar.loadForRequest(options.uri).then((cookies) {
          if (cookies.isNotEmpty) {
            print(
                'Cookies sent: ${cookies.map((c) => '${c.name}=${c.value}').join('; ')}');
          }
        });
        return handler.next(options);
      },
      onResponse: (response, handler) {
        print(
            'RESPONSE[${response.statusCode}] => PATH: ${response.requestOptions.path}');
        // Log cookies received
        final cookies = response.headers.map['set-cookie'];
        if (cookies != null && cookies.isNotEmpty) {
          print('Cookies received: ${cookies.join('; ')}');
        }
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

  /// Check if request should be retried with next URL
  bool _shouldRetryWithNextUrl(DioException error) {
    return error.type == DioExceptionType.connectionError ||
        error.type == DioExceptionType.connectionTimeout ||
        error.response?.statusCode == 503;
  }

  /// Retry request with next available URL
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

  /// Update base URLs and reset client
  void updateBaseUrls(List<String> newUrls) {
    if (newUrls.isNotEmpty) {
      _baseUrls.clear();
      _baseUrls.addAll(newUrls);
      _currentUrlIndex = 0;
      dio.options.baseUrl = _baseUrls[_currentUrlIndex];
    }
  }

  /// Clear all stored cookies
  Future<void> clearCookies() async {
    await cookieJar.deleteAll();
  }

  /// Get all stored cookies for a specific URL
  Future<List<Cookie>> getCookies(String url) async {
    return await cookieJar.loadForRequest(Uri.parse(url));
  }
}
*/

/*
import 'package:dio/dio.dart';
import 'package:cookie_jar/cookie_jar.dart';
import 'package:dio_cookie_manager/dio_cookie_manager.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';

/// ApiClient handles all network requests using Dio
/// Implements cookie persistence and automatic retry logic
class ApiClient {
  static final ApiClient _instance = ApiClient._internal();
  late final Dio dio;
  late final PersistCookieJar cookieJar;

  // Base URLs for API endpoints with failover support
  static const List<String> _baseUrls = [
    'https://infinitely-native-lamprey.ngrok-free.app'
  ];

  int _currentUrlIndex = 0;

  factory ApiClient() => _instance;

  ApiClient._internal() {
    _initializeDio();
  }

  /// Initialize Dio client with configurations and interceptors
  Future<void> _initializeDio() async {
    dio = Dio(BaseOptions(
      baseUrl: _baseUrls[_currentUrlIndex],
      connectTimeout: const Duration(seconds: 30),
      receiveTimeout: const Duration(seconds: 30),
      headers: {'Content-Type': 'application/json'},
      validateStatus: (status) => true,
      receiveDataWhenStatusError: true,
    ));

    // Initialize persistent cookie jar
    final appDocDir = await getApplicationDocumentsDirectory();
    cookieJar = PersistCookieJar(
      ignoreExpires: true,
      storage: FileStorage("${appDocDir.path}/.cookies/"),
    );

    // Add interceptors
    dio.interceptors.addAll([
      CookieManager(cookieJar),
      _createLoggingInterceptor(),
      _createErrorInterceptor(),
    ]);
  }

  /// Create logging interceptor for request/response debugging
  Interceptor _createLoggingInterceptor() {
    return InterceptorsWrapper(
      onRequest: (options, handler) {
        print('REQUEST[${options.method}] => PATH: ${options.path}');
        cookieJar.loadForRequest(options.uri).then((cookies) {
          if (cookies.isNotEmpty) {
            print(
                'Cookies sent: ${cookies.map((c) => '${c.name}=${c.value}').join('; ')}');
          }
        });
        return handler.next(options);
      },
      onResponse: (response, handler) {
        print(
            'RESPONSE[${response.statusCode}] => PATH: ${response.requestOptions.path}');
        final cookies = response.headers.map['set-cookie'];
        if (cookies != null && cookies.isNotEmpty) {
          print('Cookies received: ${cookies.join('; ')}');
        }
        return handler.next(response);
      },
    );
  }

  /// Create error interceptor for handling network errors
  Interceptor _createErrorInterceptor() {
    return InterceptorsWrapper(
      onError: (DioException e, handler) async {
        if (_shouldRetryWithNextUrl(e)) {
          final retryResponse = await _retryWithNextUrl(e.requestOptions);
          if (retryResponse != null) {
            return handler.resolve(retryResponse);
          }
        }
        return handler.next(e);
      },
    );
  }

  /// Check if request should be retried with next URL
  bool _shouldRetryWithNextUrl(DioException error) {
    return error.type == DioExceptionType.connectionError ||
        error.type == DioExceptionType.connectionTimeout ||
        error.response?.statusCode == 503;
  }

  /// Retry request with next available URL
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

  /// Update base URLs and reset client
  void updateBaseUrls(List<String> newUrls) {
    if (newUrls.isNotEmpty) {
      _baseUrls.clear();
      _baseUrls.addAll(newUrls);
      _currentUrlIndex = 0;
      dio.options.baseUrl = _baseUrls[_currentUrlIndex];
    }
  }

  /// Clear all stored cookies
  Future<void> clearCookies() async {
    await cookieJar.deleteAll();
  }

  /// Get all stored cookies for a specific URL
  Future<List<Cookie>> getCookies(String url) async {
    return await cookieJar.loadForRequest(Uri.parse(url));
  }
}
*/
import 'package:dio/dio.dart';
import 'package:cookie_jar/cookie_jar.dart';
import 'package:dio_cookie_manager/dio_cookie_manager.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';
import 'network_exceptions.dart';

/// ApiClient handles all network requests using Dio
class ApiClient {
  static final ApiClient _instance = ApiClient._internal();
  late Dio dio;
  late PersistCookieJar cookieJar;

  // Base URLs for API endpoints with failover support
  static const List<String> _baseUrls = [
    'https://infinitely-native-lamprey.ngrok-free.app'
  ];

  int _currentUrlIndex = 0;

  factory ApiClient() {
    return _instance;
  }

  ApiClient._internal() {
    _initDio();
  }

  // Initialize Dio synchronously first
  void _initDio() {
    dio = Dio(BaseOptions(
      baseUrl: _baseUrls[_currentUrlIndex],
      connectTimeout: const Duration(seconds: 30),
      receiveTimeout: const Duration(seconds: 30),
      headers: {'Content-Type': 'application/json'},
      validateStatus: (status) => true,
      receiveDataWhenStatusError: true,
    ));

    // Add initial interceptors that don't require async initialization
    dio.interceptors.add(_createLoggingInterceptor());
    dio.interceptors.add(_createErrorInterceptor());

    // Initialize cookie jar and other async components
    _initializeAsync();
  }

  /// Initialize async components
  Future<void> _initializeAsync() async {
    try {
      final appDocDir = await getApplicationDocumentsDirectory();
      final cookiesPath = "${appDocDir.path}/.cookies/";

      cookieJar = PersistCookieJar(
        ignoreExpires: false,
        storage: FileStorage(cookiesPath),
      );

      // Add interceptors that require async initialization
      dio.interceptors.insert(0, CookieManager(cookieJar));
      dio.interceptors.insert(1, await _createAuthInterceptor());
    } catch (e) {
      print('Error initializing ApiClient: $e');
    }
  }

  /// Create auth interceptor to handle authentication
  Future<Interceptor> _createAuthInterceptor() async {
    return InterceptorsWrapper(
      onRequest: (options, handler) async {
        try {
          final cookies = await cookieJar.loadForRequest(options.uri);
          final hasAuthCookie = cookies.any((cookie) =>
              cookie.name == 'auth_token' || cookie.name == 'session_id');

          if (!hasAuthCookie &&
              !options.path.contains('/login') &&
              !options.path.contains('/register')) {
            return handler.reject(
              DioException(
                requestOptions: options,
                type: DioExceptionType.unknown,
                error: NetworkException(
                  message: 'Unauthorized access',
                  statusCode: 401,
                ),
              ),
            );
          }
        } catch (e) {
          print('Error in auth interceptor: $e');
        }
        return handler.next(options);
      },
      onResponse: (response, handler) async {
        try {
          final cookies = response.headers.map['set-cookie'];
          if (cookies != null && cookies.isNotEmpty) {
            await cookieJar.saveFromResponse(
              response.requestOptions.uri,
              cookies.map((c) => Cookie.fromSetCookieValue(c)).toList(),
            );
          }
        } catch (e) {
          print('Error saving cookies: $e');
        }
        return handler.next(response);
      },
    );
  }

  /// Create logging interceptor for request/response debugging
  Interceptor _createLoggingInterceptor() {
    return InterceptorsWrapper(
      onRequest: (options, handler) {
        print('REQUEST[${options.method}] => PATH: ${options.path}');
        return handler.next(options);
      },
      onResponse: (response, handler) {
        print(
            'RESPONSE[${response.statusCode}] => PATH: ${response.requestOptions.path}');
        return handler.next(response);
      },
      onError: (error, handler) {
        print('ERROR[${error.response?.statusCode}] => ${error.message}');
        return handler.next(error);
      },
    );
  }

  /// Create error interceptor for handling network errors
  Interceptor _createErrorInterceptor() {
    return InterceptorsWrapper(
      onError: (DioException e, handler) async {
        if (_shouldRetryWithNextUrl(e)) {
          final retryResponse = await _retryWithNextUrl(e.requestOptions);
          if (retryResponse != null) {
            return handler.resolve(retryResponse);
          }
        }
        return handler.next(e);
      },
    );
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
        print('Error retrying request: $e');
        return null;
      }
    }
    return null;
  }

  /// Update base URLs and reset client
  void updateBaseUrls(List<String> newUrls) {
    if (newUrls.isNotEmpty) {
      _baseUrls.clear();
      _baseUrls.addAll(newUrls);
      _currentUrlIndex = 0;
      dio.options.baseUrl = _baseUrls[_currentUrlIndex];
    }
  }

  /// Clear all stored cookies
  Future<void> clearCookies() async {
    try {
      await cookieJar.deleteAll();
    } catch (e) {
      print('Error clearing cookies: $e');
    }
  }

  /// Get all stored cookies for a specific URL
  Future<List<Cookie>> getCookies(String url) async {
    try {
      return await cookieJar.loadForRequest(Uri.parse(url));
    } catch (e) {
      print('Error getting cookies: $e');
      return [];
    }
  }
}
