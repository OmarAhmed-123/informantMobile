import 'package:dartz/dartz.dart';
import 'package:graduation___part1/core/errors/errors.dart';
import 'package:graduation___part1/views/register_feater/data/models/register_model_reponse.dart';

abstract class RegisterRepo {
  Future<Either<Errors, RegisterModelReponse>> registerU({
    required String email,
    required String password,
    required String username,
    required String fullName,
    required String phoneNumber,
  });
}
