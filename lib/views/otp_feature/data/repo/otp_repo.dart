import 'package:dartz/dartz.dart';
import 'package:graduation___part1/core/errors/errors.dart';
import 'package:graduation___part1/views/otp_feature/data/models/otp_model_reponse.dart';

abstract class OtpRepo {
  Future<Either<Errors, OtpModelReponse>> otpVerify(
      String email, String otp);
}
