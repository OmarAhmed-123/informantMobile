import 'package:http/http.dart' as http;
import 'dart:convert';

class HttpRequest {
  static Future<http.Response> post(var internalBody) async {
    final url = Uri.parse('https://localhost:7124'+ internalBody['endPoint']);
    final headers = {"Content-Type": "application/json"};
    final body = jsonEncode(internalBody);
    try {
      final response = await http.post(url, headers: headers, body: body);
      return response;
    } catch (e) {
      return http.Response(jsonEncode({"error":"faild"}), 1);
    }
  }
    static Future<http.Response> get(String endPoint) async {
    final url = Uri.parse('https://localhost:7124' + endPoint);
    final headers = {"Content-Type": "application/json"};

    try {
      final response = await http.get(url, headers: headers);
      return response;
    } catch (e) {
      return http.Response(jsonEncode({"error": "failed"}), 500);
    }
  }
}
