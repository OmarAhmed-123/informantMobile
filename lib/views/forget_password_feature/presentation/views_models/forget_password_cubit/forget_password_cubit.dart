import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:graduation___part1/views/forget_password_feature/data/repo/forget_password_repo_implementation.dart';
import 'package:graduation___part1/views/forget_password_feature/presentation/views_models/forget_password_cubit/forget_password_cubit_states.dart';

class FpasswordCubit extends Cubit<FpasswordCubitStates> {
  FpasswordCubit() : super(FpasswordInitialState());
  static FpasswordCubit get(BuildContext context) => BlocProvider.of(context);
  Future<void> Fpassword(String password) async {
    emit(FpasswordLoadingState());
    var response = await FpasswordRepoImplemenation().Fpassword(password);
    response.fold(
      (error) => emit(FpasswordErrorState(errorMsg: error.errorMsg)),
      (value) => emit(FpasswordSuccessState(model: value)),
    );
  }
}
