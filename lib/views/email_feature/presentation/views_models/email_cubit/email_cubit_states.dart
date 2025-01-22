import 'package:graduation___part1/views/email_feature/data/models/email_model_reponse.dart';

abstract class EmailCubitStates {}

class EmailInitialState extends EmailCubitStates {}

class EmailSuccessState extends EmailCubitStates {
  final EmailModelReponse model;

  EmailSuccessState({required this.model});
}

class EmailErrorState extends EmailCubitStates {
  final String errorMsg;

  EmailErrorState({required this.errorMsg});
}

class EmailLoadingState extends EmailCubitStates {}
