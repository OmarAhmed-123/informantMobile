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
  static var Urls = ['https://infinitely-native-lamprey.ngrok-free.app'];
  //static var index = 0;
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
  }

  static Future<http.Response> get(String endPoint) async {
    return HttpRequest.getCookie(endPoint, ["", ""]);
  }

  static Future<http.Response> getCookie(
      String endPoint, List<String> token) async {
    var URL = '';
    if (endPoint.indexOf("http") == 0)
      URL = endPoint;
    else
      URL = Urls[0] + endPoint;
    final url = Uri.parse(URL);
    final headers = {
      "Content-Type": "application/json",
      'ngrok-skip-browser-warning': 'true',
      "Cookie": "TokenCookie=${token[0]}; pToken=${token[1] ?? ""}"
    };
    try {
      final response = await http.get(url, headers: headers);
      return response;
    } catch (e) {
      // if (index < Urls.length) {
      //   index++;
      //   return get(endPoint);
      // }
      return http.Response(jsonEncode({"error": "failed"}), 600);
    }
  }
}
