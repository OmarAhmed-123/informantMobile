import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:graduation___part1/views/register_feater/data/repo/register_repo_implementation.dart';
import 'package:graduation___part1/views/register_feater/presentation/views_models/register_cubit/register_cubit_states.dart';

class RegisterCubit extends Cubit<RegisterCubitStates> {
  RegisterCubit() : super(RegisterInitialState());
  static RegisterCubit get(BuildContext context) => BlocProvider.of(context);
  /*

  */
  Future<void> RegisterU(
    String password,
    String email,
    String username,
    String fullName,
    String phoneNumber,
  ) async {
    emit(RegisterLoadingState());
    var response = await RegisterRepoImplementation().registerU(
      username: username,
      password: password,
      email: email,
      fullName: fullName,
      phoneNumber: phoneNumber,
    );

    response.fold(
      (error) => emit(RegisterErrorState(errorMsg: error.errorMsg)),
      (value) => emit(RegisterSuccessState(model: value)),
    );
  }
}
