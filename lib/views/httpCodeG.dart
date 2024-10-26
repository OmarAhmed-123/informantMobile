import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)
      ..badCertificateCallback = (X509Certificate cert, String host, int port) => true;
  }
}

class HttpRequest {
  static Future<http.Response> post(var internalBody) async {
    final url = Uri.parse('https://informant122.ddns.net:7125' + internalBody['endPoint']);
    final headers = {"Content-Type": "application/json"};
    final body = jsonEncode(internalBody);
    try {
      final response = await http.post(url, headers: headers, body: body);
      return response;
    } catch (e) {
      return http.Response(jsonEncode({"error": "failed"}), 600);
    }
  }

  static Future<http.Response> get(String endPoint) async {
    final url = Uri.parse('https://informant122.ddns.net:7125' + endPoint);
    final headers = {"Content-Type": "application/json"};
    try {
      final response = await http.get(url, headers: headers);
      return response;
    } catch (e) {
      return http.Response(jsonEncode({"error": "failed"}), 600);
    }
  }
}