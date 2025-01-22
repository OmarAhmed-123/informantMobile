import 'package:dartz/dartz.dart';
import 'package:graduation___part1/core/errors/errors.dart';
import 'package:graduation___part1/views/forget_password_feature/data/models/forget_password_reponse.dart';

abstract class FpasswordRepo {
  Future<Either<Errors, FpasswordModelReponse>> Fpassword(
       String password);
}
