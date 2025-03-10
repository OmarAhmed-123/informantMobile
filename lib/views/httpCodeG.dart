/*
import 'dart:io';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)
      ..badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
  }
}

class HttpRequest {
  static var Urls = ['https://infinitely-native-lamprey.ngrok-free.app'];
  static Future<http.Response> post(var internalBody) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = await prefs.getString('CookieToken');
    String? ptoken = await prefs.getString('pToken');
    final url = Uri.parse(Urls[0] + internalBody['endPoint']);
    var headers = {
      "Content-Type": "application/json",
      'ngrok-skip-browser-warning': 'true'
      // "ngrok-skip-browser-warning": "69420"
    };
    if (token != null && ptoken != null) {
      // headers[HttpHeaders.cookieHeader] ="TokenCookie=${token}; pToken=${ptoken}";
      headers["Authentication"] = token;
      headers["AuthenticationPtoken"] = ptoken;
    } else if (token != null) {
      // headers[HttpHeaders.cookieHeader] = "TokenCookie=${token}";
      headers["Authentication"] = token;
    } else if (ptoken != null) {
      // headers[HttpHeaders.cookieHeader] = "pToken=${"m123"}";
      headers["AuthenticationPtoken"] = ptoken;
    }
    final body = jsonEncode(internalBody);
    try {
      // print("zeft_requestBody ${internalBody}");
      // print("zeft_headers ${headers}");
      final response = await http.post(url, headers: headers, body: body);
      print("zeft_requestBody ${response.statusCode}");
      // print("zeft_requestBody ${response.body}");
      return response;
    } catch (e) {
      // print("zeft_Faild:${e.toString()}");
      return http.Response(jsonEncode({"error": "failed"}), 600);
    }
  }

  static Future<http.Response> get(String endPoint) async {
    var URL = '';
    if (endPoint.indexOf("http") == 0)
      URL = endPoint;
    else
      URL = Urls[0] + endPoint;
    final url = Uri.parse(URL);
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = await prefs.getString('CookieToken');
    String? ptoken = await prefs.getString('pToken');
    var headers = {
      "Content-Type": "application/json",
      'ngrok-skip-browser-warning': 'true',
    };
    if (token != null && ptoken != null) {
      // headers[HttpHeaders.cookieHeader] ="TokenCookie=${token}; pToken=${ptoken}";
      headers["Authentication"] = token;
      headers["AuthenticationPtoken"] = ptoken;
    } else if (token != null) {
      // headers[HttpHeaders.cookieHeader] = "TokenCookie=${token}";
      headers["Authentication"] = token;
    } else if (ptoken != null) {
      // headers[HttpHeaders.cookieHeader] = "pToken=${"m123"}";
      headers["AuthenticationPtoken"] = ptoken;
    }
    try {
      final response = await http.get(url, headers: headers);
      // print("zeft_resp:${response.statusCode}");
      return response;
    } catch (e) {
      // print("zeft_Faild:${e.toString()}");
      return http.Response(jsonEncode({"error": "failed"}), 600);
    }
  }
}
*/
import 'dart:convert';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:cookie_jar/cookie_jar.dart';
import 'package:dio_cookie_manager/dio_cookie_manager.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)
      ..badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
  }
}

class HttpRequest {
  static var Urls = ['https://infinitely-native-lamprey.ngrok-free.app'];
  static late Dio dio;
  static late PersistCookieJar cookieJar;

  static Future<void> init() async {
    final appDocDir = await getApplicationDocumentsDirectory();
    final cookiePath = join(appDocDir.path, 'cookies');
    cookieJar = PersistCookieJar(storage: FileStorage(cookiePath));
    dio = Dio();
    dio.interceptors.add(CookieManager(cookieJar));
  }

  static Future<Response> post(Map<String, dynamic> internalBody) async {
    await init();
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('CookieToken');
    String? ptoken = prefs.getString('pToken');
    final url = Urls[0] + internalBody['endPoint'];
    var headers = {
      "Content-Type": "application/json",
      'ngrok-skip-browser-warning': 'true'
    };
    if (token != null && ptoken != null) {
      headers["Authentication"] = token;
      headers["AuthenticationPtoken"] = ptoken;
    } else if (token != null) {
      headers["Authentication"] = token;
    } else if (ptoken != null) {
      headers["AuthenticationPtoken"] = ptoken;
    }
    final body = jsonEncode(internalBody);
    try {
      final response =
          await dio.post(url, data: body, options: Options(headers: headers));
      return response;
    } catch (e) {
      return Response(
          requestOptions: RequestOptions(path: url),
          statusCode: 600,
          data: {"error": "failed"});
    }
  }

  static Future<Response> get(String endPoint) async {
    await init();
    var URL = '';
    if (endPoint.indexOf("http") == 0) {
      URL = endPoint;
    } else {
      URL = Urls[0] + endPoint;
    }

    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('CookieToken');
    String? ptoken = prefs.getString('pToken');
    var headers = {
      "Content-Type": "application/json",
      'ngrok-skip-browser-warning': 'true',
    };
    if (token != null && ptoken != null) {
      headers["Authentication"] = token;
      headers["AuthenticationPtoken"] = ptoken;
    } else if (token != null) {
      headers["Authentication"] = token;
    } else if (ptoken != null) {
      headers["AuthenticationPtoken"] = ptoken;
    }
    try {
      final response = await dio.get(URL, options: Options(headers: headers));
      return response;
    } catch (e) {
      print("zeft_Faild:${e.toString()}");
      return Response(
          requestOptions: RequestOptions(path: URL),
          statusCode: 600,
          data: {"error": "failed"});
    }
  }
}
