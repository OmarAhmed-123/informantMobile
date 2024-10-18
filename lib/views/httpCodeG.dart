import 'package:http/http.dart' as http;
import 'dart:convert';

class HttpRequest {
  static Future<http.Response> post(var internalBody) async {
    final url = Uri.parse('http://192.168.1.5:7125' + internalBody['endPoint']);
    final headers = {"Content-Type": "application/json"};
    final body = jsonEncode(internalBody);

    try {
      final response = await http.post(url, headers: headers, body: body);
      if (response.statusCode == 307 || response.statusCode == 302) {
        final newLocation = response.headers['location'];
        if (newLocation != null) {
          final newUrl = Uri.parse(newLocation);
          final redirectedResponse = await http.post(newUrl, headers: headers, body: body);
          return redirectedResponse;
        }
      }
      return response;
    } catch (e) {
      return http.Response(jsonEncode({"error": "failed"}), 1);
    }
  }

  static Future<http.Response> get(String endPoint) async {
    final url = Uri.parse('http://192.168.1.5:7125' + endPoint);
    final headers = {"Content-Type": "application/json"};

    try {
      final response = await http.get(url, headers: headers);
      if (response.statusCode == 307 || response.statusCode == 302) {
        final newLocation = response.headers['location'];
        if (newLocation != null) {
          final newUrl = Uri.parse(newLocation);
          final redirectedResponse = await http.get(newUrl, headers: headers);
          return redirectedResponse;
        }
      }
      return response;
    } catch (e) {
      return http.Response(jsonEncode({"error": "failed"}), 500);
    }
  }
}
