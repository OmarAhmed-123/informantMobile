import 'package:dartz/dartz.dart';
import 'package:graduation___part1/core/errors/errors.dart';
import 'package:graduation___part1/views/email_feature/data/models/email_model_reponse.dart';

abstract class EmailRepo {
  Future<Either<Errors, EmailModelReponse>> emailVerify(String email);
}
