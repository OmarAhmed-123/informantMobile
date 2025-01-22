import 'package:flutter/material.dart';
import 'package:graduation___part1/views/email_feature/presentation/views_models/email_verification_view_model.dart';
import 'package:provider/provider.dart';

class VerificationButton extends StatelessWidget {
  const VerificationButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<EmailVerificationViewModel>(
      builder: (context, viewModel, _) {
        if (viewModel.isLoading) {
          return const CircularProgressIndicator(color: Colors.white);
        }

        return ElevatedButton(
          style: ElevatedButton.styleFrom(
            foregroundColor: Colors.purple[700],
            backgroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(
              horizontal: 50,
              vertical: 15,
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(30),
            ),
          ),
          onPressed: () => viewModel.sendVerificationCode(context),
          child: const Text('Send Verification Code'),
        );
      },
    );
  }
}
