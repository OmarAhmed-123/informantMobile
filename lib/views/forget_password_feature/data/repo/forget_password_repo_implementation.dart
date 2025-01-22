import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:graduation___part1/core/errors/errors.dart';
import 'package:graduation___part1/core/utils/api_helper/api_constants.dart';
import 'package:graduation___part1/core/utils/api_helper/api_helper.dart';
import 'package:graduation___part1/core/utils/api_helper/dio_variables.dart';
import 'package:graduation___part1/views/forget_password_feature/data/models/forget_password_reponse.dart';
import 'package:graduation___part1/views/forget_password_feature/data/repo/forget_password_repo.dart';

class FpasswordRepoImplemenation extends FpasswordRepo {
  @override
  Future<Either<Errors, FpasswordModelReponse>> Fpassword( String password) async {
    try {
      var response = await ApiHelper(dioHelper: DioVariables.informant)
          .postData(ApiConstants.editPassword,
              {"password": password});
      return right(FpasswordModelReponse.fromJson(response));
    } on Exception catch (e) {
      if (e is DioException) {
        return left(ServerError.fromDioError(e));
      }
      return left(ServerError(errorMsg: e.toString()));
    }
  }
}
