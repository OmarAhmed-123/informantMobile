import 'package:graduation___part1/views/register_feater/data/models/register_model_reponse.dart';

abstract class RegisterCubitStates {}

class RegisterInitialState extends RegisterCubitStates {}

class RegisterSuccessState extends RegisterCubitStates {
  final RegisterModelReponse model;

  RegisterSuccessState({required this.model});
}

class RegisterErrorState extends RegisterCubitStates {
  final String errorMsg;

  RegisterErrorState({required this.errorMsg});
}

class RegisterLoadingState extends RegisterCubitStates {}
