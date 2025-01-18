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