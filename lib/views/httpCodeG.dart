import 'dart:io';
import 'package:http/http.dart' as http;
import 'dart:convert';

class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)
      ..badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
  }
}

class HttpRequest {
  static var Urls = [
    'https://infinitely-native-lamprey.ngrok-free.app'

    //'https://informant122.ddns.net:7125',
    //'http://informant122.ddns.net:7125'
  ];
  static var index = 0;
  static Future<http.Response> post(var internalBody) async {
    try {
      Urls = internalBody.Urls;
    } catch (e) {}
    ;
    final url = Uri.parse(Urls[HttpRequest.index] + internalBody['endPoint']);
    final headers = {"Content-Type": "application/json"};
    final body = jsonEncode(internalBody);
    try {
      final response = await http.post(url, headers: headers, body: body);
      return response;
    } catch (e) {
      if (index < Urls.length) {
        index++;
        return post(internalBody);
      }
      return http.Response(jsonEncode({"error": "failed"}), 600);
    }
  }

  static Future<http.Response> get(String endPoint) async {
    var URL = '';
    if (endPoint.indexOf("http") == 0)
      URL = endPoint;
    else
      URL = Urls[HttpRequest.index] + endPoint;
    final url = Uri.parse(URL);
    print("url is ${url}");
    final headers = {"Content-Type": "application/json"};
    try {
      final response = await http.get(url, headers: headers);
      return response;
    } catch (e) {
      print("gterror${e.toString()}");
      if (index < Urls.length) {
        index++;
        return get(endPoint);
      }
      return http.Response(jsonEncode({"error": "failed"}), 600);
    }
  }
}
