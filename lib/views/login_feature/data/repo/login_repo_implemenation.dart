import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:graduation___part1/core/errors/errors.dart';
import 'package:graduation___part1/core/utils/api_helper/api_constants.dart';
import 'package:graduation___part1/core/utils/api_helper/api_helper.dart';
import 'package:graduation___part1/core/utils/api_helper/dio_variables.dart';
import 'package:graduation___part1/views/login_feature/data/models/login_model_reponse.dart';
import 'package:graduation___part1/views/login_feature/data/repo/login_repo.dart';

class LoginRepoImplemenation extends LoginRepo {
  @override
  Future<Either<Errors, LoginModelReponse>> userLogin(
      String email, String password) async {
    try {
      var response = await ApiHelper(dioHelper: DioVariables.informant)
          .postData(ApiConstants.userVerifier,
              {"username": email, "password": password});
      return right(LoginModelReponse.fromJson(response));
    } on Exception catch (e) {
      if (e is DioException) {
        return left(ServerError.fromDioError(e));
      }
      return left(ServerError(errorMsg: e.toString()));
    }
  }
}
