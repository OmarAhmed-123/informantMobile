import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:graduation___part1/views/login_feature/presentation/views/autoLogin.dart';
import 'package:graduation___part1/views/login_feature/animations/fade_scale_animation.dart';

import '../../views_models/login_cubit/login_cubit.dart';
import '../../views_models/login_cubit/login_cubit_states.dart';

class LoginButton extends StatelessWidget {
  final TextEditingController emailController;
  final TextEditingController passwordController;

  const LoginButton({
    Key? key,
    required this.emailController,
    required this.passwordController,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FadeScaleAnimation(
      child: SizedBox(
        width: double.infinity,
        height: 55,
        child: BlocProvider(
          create: (context) => LoginCubit(),
          child: BlocConsumer<LoginCubit, LoginCubitStates>(
            listener: (context, state) {
              if (state is LoginSuccessState) {
                _handleLoginSuccess(context);
              } else if (state is LoginErrorState) {
                Navigator.pushReplacementNamed(context, '/otp_verification');
              }
            },
            builder: (context, state) {
              if (state is LoginLoadingState) {
                return const Center(child: CircularProgressIndicator());
              }
              return _buildButton(context);
            },
          ),
        ),
      ),
    );
  }

  void _handleLoginSuccess(BuildContext context) {
    if (emailController.text.contains('@')) {
      AutoLogin.saveData("", passwordController.text, emailController.text);
    } else {
      AutoLogin.saveData(emailController.text, passwordController.text, "");
    }
    Navigator.pushReplacementNamed(context, '/home');
  }

  Widget _buildButton(BuildContext context) {
    return ElevatedButton(
      onPressed: () async => await LoginCubit.get(context)
          .userLogin(emailController.text, passwordController.text),
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.white,
        foregroundColor: Colors.purple[700],
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        elevation: 5,
      ),
      child: const Text(
        'Sign In',
        style: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
