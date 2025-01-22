
import 'package:graduation___part1/views/forget_password_feature/data/models/forget_password_reponse.dart';

abstract class FpasswordCubitStates {}

class FpasswordInitialState extends FpasswordCubitStates {}

class FpasswordSuccessState extends FpasswordCubitStates {
  final FpasswordModelReponse model;

  FpasswordSuccessState({required this.model});
}

class FpasswordErrorState extends FpasswordCubitStates {
  final String errorMsg;

  FpasswordErrorState({required this.errorMsg});
}

class FpasswordLoadingState extends FpasswordCubitStates {}
