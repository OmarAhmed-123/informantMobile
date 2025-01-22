import 'package:flutter/material.dart';
import 'login_input_field.dart';
import 'login_button.dart';
import 'login_links.dart';

class LoginForm extends StatefulWidget {
  const LoginForm({Key? key}) : super(key: key);

  @override
  LoginFormState createState() => LoginFormState();
}

class LoginFormState extends State<LoginForm> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isPasswordVisible = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _togglePasswordVisibility() {
    setState(() => _isPasswordVisible = !_isPasswordVisible);
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          LoginInputField(
            controller: _emailController,
            label: 'Email',
            prefixIcon: Icons.person_outline,
          ),
          const SizedBox(height: 20),
          LoginInputField(
            controller: _passwordController,
            label: 'Password',
            isPassword: true,
            isPasswordVisible: _isPasswordVisible,
            onToggleVisibility: _togglePasswordVisibility,
          ),
          const SizedBox(height: 30),
          LoginButton(
            emailController: _emailController,
            passwordController: _passwordController,
          ),
          const SizedBox(height: 20),
          const LoginLinks(),
        ],
      ),
    );
  }
}
