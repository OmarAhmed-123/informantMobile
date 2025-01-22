import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:graduation___part1/views/email_feature/data/repo/email_repo_implementation.dart';
import 'package:graduation___part1/views/email_feature/presentation/views_models/email_cubit/email_cubit_states.dart';

class EmailCubit extends Cubit<EmailCubitStates> {
  EmailCubit() : super(EmailInitialState());
  static EmailCubit get(BuildContext context) => BlocProvider.of(context);
  Future<void> emailVerify(String email) async {
    emit(EmailLoadingState());
    var response = await EmailRepoImplemenation().emailVerify(email);
    response.fold(
      (error) => emit(EmailErrorState(errorMsg: error.errorMsg)),
      (value) => emit(EmailSuccessState(model: value)),
    );
  }
}
