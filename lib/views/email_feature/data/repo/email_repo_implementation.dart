import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:graduation___part1/core/errors/errors.dart';
import 'package:graduation___part1/core/utils/api_helper/api_constants.dart';
import 'package:graduation___part1/core/utils/api_helper/api_helper.dart';
import 'package:graduation___part1/core/utils/api_helper/dio_variables.dart';
import 'package:graduation___part1/views/email_feature/data/models/email_model_reponse.dart';
import 'package:graduation___part1/views/email_feature/data/repo/email_repo.dart';

class EmailRepoImplemenation extends EmailRepo {
  @override
  Future<Either<Errors, EmailModelReponse>> emailVerify(
      String email) async {
    try {
      var response = await ApiHelper(dioHelper: DioVariables.informant)
          .postData(ApiConstants.userVerifier,
              {"email": email});
      return right(EmailModelReponse.fromJson(response));
    } on Exception catch (e) {
      if (e is DioException) {
        return left(ServerError.fromDioError(e));
      }
      return left(ServerError(errorMsg: e.toString()));
    }
  }
}
