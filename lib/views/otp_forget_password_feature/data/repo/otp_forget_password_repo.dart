import 'package:dartz/dartz.dart';
import 'package:graduation___part1/core/errors/errors.dart';
import 'package:graduation___part1/views/otp_forget_password_feature/data/models/otp_forget_password_model_reponse.dart';


abstract class OtpPasswordRepo {
  Future<Either<Errors, OtpPasswordModelReponse>> otpVerify(
      String email, String otp);
}
