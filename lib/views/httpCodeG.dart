import 'dart:convert';
import 'dart:io';
import 'dart:math';
import 'package:dio/dio.dart';
import 'package:cookie_jar/cookie_jar.dart';
import 'package:dio_cookie_manager/dio_cookie_manager.dart';
import 'package:flutter/material.dart';
import 'package:graduation___part1/views/autoLogin.dart';
import 'package:graduation___part1/views/showConnection.dart';
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

  static Future<Response> get(Map<String, dynamic> internalBody) async {
    await init();
    final url = Urls[0] + internalBody['endPoint'];

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
      final response = await dio.get(url, options: Options(headers: headers));
      return response;
    } catch (e) {
      print("zeft_Faild:${e.toString()}");
      return Response(
          requestOptions: RequestOptions(path: url),
          statusCode: 600,
          data: {"error": "failed"});
    }
  }
}
