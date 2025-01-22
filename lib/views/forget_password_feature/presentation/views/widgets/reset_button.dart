import 'package:flutter/material.dart';
import 'package:graduation___part1/views/forget_password_feature/presentation/views_models/forgot_password_view_model.dart';
import 'package:provider/provider.dart';

class ResetButton extends StatelessWidget {
  const ResetButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<ForgotPasswordViewModel>(
      builder: (context, viewModel, _) {
        if (viewModel.isLoading) {
          return const CircularProgressIndicator(color: Colors.white);
        }

        return ElevatedButton(
          onPressed: () => viewModel.resetPassword(context),
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.blue,
            padding: const EdgeInsets.symmetric(
              horizontal: 50,
              vertical: 15,
            ),
          ),
          child: const Text('Submit'),
        );
      },
    );
  }
}
