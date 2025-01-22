import 'package:graduation___part1/views/otp_feature/data/models/otp_model_reponse.dart';

abstract class OtpCubitStates {}

class OtpInitialState extends OtpCubitStates {}

class OtpSuccessState extends OtpCubitStates {
  final OtpModelReponse model;

  OtpSuccessState({required this.model});
}

class OtpErrorState extends OtpCubitStates {
  final String errorMsg;

  OtpErrorState({required this.errorMsg});
}

class OtpLoadingState extends OtpCubitStates {}
