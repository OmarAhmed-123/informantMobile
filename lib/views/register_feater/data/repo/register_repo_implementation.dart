import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:graduation___part1/core/errors/errors.dart';
import 'package:graduation___part1/core/utils/api_helper/api_constants.dart';
import 'package:graduation___part1/core/utils/api_helper/api_helper.dart';
import 'package:graduation___part1/core/utils/api_helper/dio_variables.dart';
import 'package:graduation___part1/views/register_feater/data/models/register_model_reponse.dart';
import 'package:graduation___part1/views/register_feater/data/repo/register_repo.dart';

class RegisterRepoImplementation extends RegisterRepo {
  @override
  Future<Either<Errors, RegisterModelReponse>> registerU({
    required String password,
    required String email,
    required String username,
    required String fullName,
    required String phoneNumber,
  }) async {
    try {
      var response =
          await ApiHelper(dioHelper: DioVariables.informant).postData(
        ApiConstants.register,
        {
          "email": email,
          "password": password,
          "username": username,
          "details": '',
          "confirmPassword": password,
          "fullName": fullName,
          "phoneNumber": phoneNumber,
          "linkedIn": '',
        },
      );
      return right(RegisterModelReponse.fromJson(response));
    } on Exception catch (e) {
      if (e is DioException) {
        return left(ServerError.fromDioError(e));
      }
      return left(ServerError(errorMsg: e.toString()));
    }
  }
}
