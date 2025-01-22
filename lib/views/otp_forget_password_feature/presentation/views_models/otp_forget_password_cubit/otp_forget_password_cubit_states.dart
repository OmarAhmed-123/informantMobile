import 'package:graduation___part1/views/otp_forget_password_feature/data/models/otp_forget_password_model_reponse.dart';

abstract class OtpPasswordCubitStates {}

class OtpPasswordInitialState extends OtpPasswordCubitStates {}

class OtpPasswordSuccessState extends OtpPasswordCubitStates {
  final OtpPasswordModelReponse model;

  OtpPasswordSuccessState({required this.model});
}

class OtpPasswordErrorState extends OtpPasswordCubitStates {
  final String errorMsg;

  OtpPasswordErrorState({required this.errorMsg});
}

class OtpPasswordLoadingState extends OtpPasswordCubitStates {}
