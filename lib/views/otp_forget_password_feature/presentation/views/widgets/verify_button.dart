import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../views_models/otp_forgot_password_view_model.dart';

class VerifyButton extends StatelessWidget {
  final Animation<double> animation;
  final String email;

  const VerifyButton({
    Key? key,
    required this.animation,
    required this.email,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final viewModel = Provider.of<OtpForgotPasswordViewModel>(context);

    return ScaleTransition(
      scale: animation,
      child: SizedBox(
        width: double.infinity,
        height: 55,
        child: ElevatedButton(
          onPressed: () {
            if (viewModel.formKey.currentState!.validate()) {
              //String otp = viewModel.getOtpValue();
              // Add your BlocProvider and BlocConsumer here for verification
            }
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.white,
            foregroundColor: Colors.purple[700],
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            elevation: 5,
          ),
          child: const Text(
            'Verify',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }
}
