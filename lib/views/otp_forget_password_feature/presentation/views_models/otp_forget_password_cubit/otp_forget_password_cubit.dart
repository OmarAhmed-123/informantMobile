import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:graduation___part1/views/otp_forget_password_feature/data/repo/otp_forget_password_repo_implementation.dart';
import 'package:graduation___part1/views/otp_forget_password_feature/presentation/views_models/otp_forget_password_cubit/otp_forget_password_cubit_states.dart';

class OtpPasswordCubit extends Cubit<OtpPasswordCubitStates> {
  OtpPasswordCubit() : super(OtpPasswordInitialState());
  static OtpPasswordCubit get(BuildContext context) => BlocProvider.of(context);
  Future<void> otpVerify(String email, String otp) async {
    emit(OtpPasswordLoadingState());
    var response = await OtpPasswordRepoImplemenation().otpVerify(email, otp);
    response.fold(
      (error) => emit(OtpPasswordErrorState(errorMsg: error.errorMsg)),
      (value) => emit(OtpPasswordSuccessState(model: value)),
    );
  }
}
