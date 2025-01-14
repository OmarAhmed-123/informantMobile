import 'package:dio/dio.dart';
import 'package:graduation___part1/core/utils/api_helper/api_constants.dart';

abstract class DioVariables {
  static Dio informant = Dio(
    BaseOptions(
      baseUrl: ApiConstants.baseUrl,
      receiveDataWhenStatusError: true,
    ),
  );
}
