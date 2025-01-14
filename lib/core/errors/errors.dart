import 'package:dio/dio.dart';

abstract class Errors {
  final String errorMsg;
  Errors({required this.errorMsg});
}

class ServerError extends Errors {
  ServerError({required super.errorMsg});

  static ServerError fromDioError(DioException exp) {
    switch (exp.type) {
      case DioExceptionType.connectionTimeout:
        return ServerError(errorMsg: "Connection Timeout");
      case DioExceptionType.sendTimeout:
        return ServerError(errorMsg: "Send Timeout");
      case DioExceptionType.receiveTimeout:
        return ServerError(errorMsg: "Receive Timeout");
      case DioExceptionType.badCertificate:
        return ServerError(errorMsg: "Bad Certificate");
      case DioExceptionType.badResponse:
        return badResponseError(exp.response!.statusCode, exp.response);
      case DioExceptionType.cancel:
        return ServerError(errorMsg: "Connection Cancelled");
      case DioExceptionType.connectionError:
        return ServerError(errorMsg: "Connection Error");
      case DioExceptionType.unknown:
        return ServerError(
            errorMsg: "Opps was an error , please try again later...😃");
    }
  }

  static ServerError badResponseError(int? statusCode, dynamic response) {
    var res = response.data;
    String error = "";
    for (var i in res['errors'].entries) {
      error = res['errors'][i][0];
    }
    switch (statusCode) {
      case 400:
        return ServerError(errorMsg: error);
      case 401:
        return ServerError(errorMsg: error);
      case 402:
        return ServerError(errorMsg: error);
      case 403:
        return ServerError(errorMsg: error);
      case 404:
        return ServerError(
            errorMsg: "Your Request not found , please try again later...😃");
      case 500:
        return ServerError(errorMsg: "Internal server error");
      default:
        return ServerError(
            errorMsg: "Opps was an error , please try again later...😃");
    }
  }
}
