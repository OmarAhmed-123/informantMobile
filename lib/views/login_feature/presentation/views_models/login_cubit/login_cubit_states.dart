import 'package:graduation___part1/views/login_feature/data/models/login_model_reponse.dart';

abstract class LoginCubitStates {}

class LoginInitialState extends LoginCubitStates {}

class LoginSuccessState extends LoginCubitStates {
  final LoginModelReponse model;

  LoginSuccessState({required this.model});
}

class LoginErrorState extends LoginCubitStates {
  final String errorMsg;

  LoginErrorState({required this.errorMsg});
}

class LoginLoadingState extends LoginCubitStates {}
