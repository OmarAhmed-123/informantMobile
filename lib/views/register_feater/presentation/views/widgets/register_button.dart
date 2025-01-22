import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:graduation___part1/views/login_feature/presentation/views/autoLogin.dart';
import 'package:graduation___part1/views/login_feature/animations/fade_scale_animation.dart';
import 'package:graduation___part1/views/register_feater/presentation/views_models/register_cubit/register_cubit.dart';
import 'package:graduation___part1/views/register_feater/presentation/views_models/register_cubit/register_cubit_states.dart';

class RegisterButton extends StatelessWidget {
  final GlobalKey<FormState> formKey;
  final Map<String, TextEditingController> controllers;

  const RegisterButton({
    Key? key,
    required this.formKey,
    required this.controllers,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FadeScaleAnimation(
      child: SizedBox(
        width: double.infinity,
        height: 55,
        child: BlocProvider(
          create: (context) => RegisterCubit(),
          child: BlocConsumer<RegisterCubit, RegisterCubitStates>(
            listener: (context, state) {
              if (state is RegisterSuccessState) {
                _handleSuccess(context);
              }
            },
            builder: (context, state) {
              if (state is RegisterLoadingState) {
                return const Center(child: CircularProgressIndicator());
              }
              return _buildButton(context);
            },
          ),
        ),
      ),
    );
  }

  void _handleSuccess(BuildContext context) async {
    await AutoLogin.saveData(
      controllers['username']!.text,
      controllers['password']!.text,
      controllers['email']!.text,
    );
    Navigator.pushReplacementNamed(context, '/otp_verification');
  }

  Widget _buildButton(BuildContext context) {
    return ElevatedButton(
      onPressed: () async {
        if (formKey.currentState!.validate()) {
          await RegisterCubit.get(context).RegisterU(
            controllers['username']!.text,
            controllers['password']!.text,
            controllers['email']!.text,
            controllers['fullname']!.text,
            controllers['phone']!.text,
          );
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
        'Create Account',
        style: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
