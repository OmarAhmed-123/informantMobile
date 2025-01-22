import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:graduation___part1/core/errors/errors.dart';
import 'package:graduation___part1/core/utils/api_helper/api_constants.dart';
import 'package:graduation___part1/core/utils/api_helper/api_helper.dart';
import 'package:graduation___part1/core/utils/api_helper/dio_variables.dart';
import 'package:graduation___part1/views/otp_feature/data/models/otp_model_reponse.dart';
import 'package:graduation___part1/views/otp_feature/data/repo/otp_repo.dart';

class OtpRepoImplemenation extends OtpRepo {
  @override
  Future<Either<Errors, OtpModelReponse>> otpVerify(
      String email, String otp) async {
    try {
      var response = await ApiHelper(dioHelper: DioVariables.informant)
          .postData(ApiConstants.verify, {"email": email, "otp": otp});
      return right(OtpModelReponse.fromJson(response));
    } on Exception catch (e) {
      if (e is DioException) {
        return left(ServerError.fromDioError(e));
      }
      return left(ServerError(errorMsg: e.toString()));
    }
  }
}
