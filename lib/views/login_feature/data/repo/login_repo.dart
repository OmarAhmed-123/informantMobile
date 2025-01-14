import 'package:dartz/dartz.dart';
import 'package:graduation___part1/core/errors/errors.dart';
import 'package:graduation___part1/views/login_feature/data/models/login_model_reponse.dart';

abstract class LoginRepo {
  Future<Either<Errors, LoginModelReponse>> userLogin(
      String email, String password);
}
