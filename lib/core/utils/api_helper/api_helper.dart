import 'package:dio/dio.dart';

class ApiHelper {
  final Dio dioHelper;
  ApiHelper({required this.dioHelper});

  Future<Map<String, dynamic>> postData(
      String endPoint, Map<String, dynamic> query) async {
    var response = await dioHelper.post(endPoint,
        queryParameters: query,
        options: Options(
          headers: {
            'Content-Type': 'application/json',
            'ngrok-skip-browser-warning': 'true',
          },
        ));
    return response.data;
  }
}
