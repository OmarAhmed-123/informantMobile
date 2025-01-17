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
  //static var index = 0;
  /*
  static Future<http.Response> post(var internalBody) async {
    try {
      Urls = internalBody.Urls;
    } catch (e) {}
    ;
    final url = Uri.parse(Urls[0] + internalBody['endPoint']);
    final headers = {
      "Content-Type": "application/json",
      'ngrok-skip-browser-warning': 'true',
      "Cookie":
          "TokenCookie=${internalBody["token"] ?? ""}; pToken=${internalBody["ptoken"] ?? ""}"
    };
    final body = jsonEncode(internalBody);
    try {
      final response = await http.post(url, headers: headers, body: body);
      return response;
    } catch (e) {
      // if (index < Urls.length) {
      //   index++;
      //   return post(internalBody);
      //   //status 200 : messages.content[0] "Otp sent"
      //   //status 400 : errors["SOMEKEY"][0] "an Email with otp is sent"
      // }
      return http.Response(jsonEncode({"error": "failed"}), 600);
    }
  }*/
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















/*



import 'dart:io';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences.dart';

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
  static const String TOKEN_KEY = 'user_token';
  static const String P_TOKEN_KEY = 'p_token';

  // Store cookies in SharedPreferences
  static Future<void> storeCookies(String token, String pToken) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(TOKEN_KEY, token);
    await prefs.setString(P_TOKEN_KEY, pToken);
  }

  // Retrieve cookies from SharedPreferences
  static Future<Map<String, String>> getCookies() async {
    final prefs = await SharedPreferences.getInstance();
    return {
      'token': prefs.getString(TOKEN_KEY) ?? '',
      'pToken': prefs.getString(P_TOKEN_KEY) ?? '',
    };
  }

  // Clear stored cookies
  static Future<void> clearCookies() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(TOKEN_KEY);
    await prefs.remove(P_TOKEN_KEY);
  }

  // Extract cookies from response headers
  static void _updateCookiesFromResponse(http.Response response) async {
    String? cookies = response.headers['set-cookie'];
    if (cookies != null) {
      // Parse TokenCookie
      RegExp tokenRegex = RegExp(r'TokenCookie=([^;]+)');
      RegExp pTokenRegex = RegExp(r'pToken=([^;]+)');

      String? token = tokenRegex.firstMatch(cookies)?.group(1);
      String? pToken = pTokenRegex.firstMatch(cookies)?.group(1);

      if (token != null || pToken != null) {
        await storeCookies(token ?? '', pToken ?? '');
      }
    }
  }

  static Future<Map<String, String>> _getHeaders() async {
    final cookies = await getCookies();
    return {
      "Content-Type": "application/json",
      'ngrok-skip-browser-warning': 'true',
      "Cookie":
          "TokenCookie=${cookies['token']}; pToken=${cookies['pToken']}"
    };
  }

  static Future<http.Response> post(var internalBody) async {
    try {
      Urls = internalBody.Urls;
    } catch (e) {}

    final url = Uri.parse(Urls[0] + internalBody['endPoint']);
    final headers = await _getHeaders();
    final body = jsonEncode(internalBody);

    try {
      final response = await http.post(url, headers: headers, body: body);
      _updateCookiesFromResponse(response);
      return response;
    } catch (e) {
      return http.Response(jsonEncode({"error": "failed"}), 600);
    }
  }

  static Future<http.Response> get(String endPoint) async {
    final cookies = await getCookies();
    return HttpRequest.getCookie(endPoint, [cookies['token'] ?? '', cookies['pToken'] ?? '']);
  }

  static Future<http.Response> getCookie(
      String endPoint, List<String> token) async {
    var URL = '';
    if (endPoint.indexOf("http") == 0) {
      URL = endPoint;
    } else {
      URL = Urls[0] + endPoint;
    }
    
    final url = Uri.parse(URL);
    final headers = await _getHeaders();

    try {
      final response = await http.get(url, headers: headers);
      _updateCookiesFromResponse(response);
      return response;
    } catch (e) {
      return http.Response(jsonEncode({"error": "failed"}), 600);
    }
  }

  // Helper method to check if user is authenticated
  static Future<bool> isAuthenticated() async {
    final cookies = await getCookies();
    return cookies['token']?.isNotEmpty == true;
  }

  // Helper method to handle session expiry
  static Future<void> handleSessionExpiry(http.Response response) async {
    if (response.statusCode == 401) {
      await clearCookies();
      // You can add additional logic here like redirecting to login page
    }
  }
}

*/