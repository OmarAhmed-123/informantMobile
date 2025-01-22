import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:graduation___part1/views/login_feature/data/repo/login_repo_implemenation.dart';
import 'package:graduation___part1/views/login_feature/presentation/views_models/login_cubit/login_cubit_states.dart';

class LoginCubit extends Cubit<LoginCubitStates> {
  LoginCubit() : super(LoginInitialState());
  static LoginCubit get(BuildContext context) => BlocProvider.of(context);
  Future<void> userLogin(String username, String password) async {
    emit(LoginLoadingState());
    var response = await LoginRepoImplemenation().userLogin(username, password);
    response.fold(
      (error) => emit(LoginErrorState(errorMsg: error.errorMsg)),
      (value) => emit(LoginSuccessState(model: value)),
    );
  }
}
