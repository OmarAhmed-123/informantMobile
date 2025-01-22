import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:graduation___part1/views/otp_feature/data/repo/otp_repo_implementation.dart';
import 'package:graduation___part1/views/otp_feature/presentation/views_models/otp_cubit/otp_cubit_states.dart';

class OtpCubit extends Cubit<OtpCubitStates> {
  OtpCubit() : super(OtpInitialState());
  static OtpCubit get(BuildContext context) => BlocProvider.of(context);
  Future<void> otpVerify(String email, String otp) async {
    emit(OtpLoadingState());
    var response = await OtpRepoImplemenation().otpVerify(email, otp);
    response.fold(
      (error) => emit(OtpErrorState(errorMsg: error.errorMsg)),
      (value) => emit(OtpSuccessState(model: value)),
    );
  }
}
