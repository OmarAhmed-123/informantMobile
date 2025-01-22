import 'package:flutter/material.dart';
import 'register_input_field.dart';
import 'register_button.dart';
import 'register_login_link.dart';

class RegisterForm extends StatefulWidget {
  const RegisterForm({Key? key}) : super(key: key);

  @override
  RegisterFormState createState() => RegisterFormState();
}

class RegisterFormState extends State<RegisterForm> {
  final _formKey = GlobalKey<FormState>();
  final _fullnameController = TextEditingController();
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  final _phoneController = TextEditingController();
  final _emailController = TextEditingController();
  bool _isPasswordVisible = false;

  @override
  void dispose() {
    _fullnameController.dispose();
    _usernameController.dispose();
    _passwordController.dispose();
    _phoneController.dispose();
    _emailController.dispose();
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
          RegisterInputField(
            controller: _fullnameController,
            label: 'Full Name',
            icon: Icons.person_outline,
          ),
          RegisterInputField(
            controller: _usernameController,
            label: 'Username',
            icon: Icons.account_circle_outlined,
          ),
          RegisterInputField(
            controller: _passwordController,
            label: 'Password',
            isPassword: true,
            isPasswordVisible: _isPasswordVisible,
            onToggleVisibility: _togglePasswordVisibility,
          ),
          RegisterInputField(
            controller: _emailController,
            label: 'Email',
            icon: Icons.email_outlined,
            keyboardType: TextInputType.emailAddress,
          ),
          RegisterInputField(
            controller: _phoneController,
            label: 'Phone Number',
            icon: Icons.phone_outlined,
            keyboardType: TextInputType.phone,
          ),
          const SizedBox(height: 24),
          RegisterButton(
            formKey: _formKey,
            controllers: {
              'fullname': _fullnameController,
              'username': _usernameController,
              'password': _passwordController,
              'email': _emailController,
              'phone': _phoneController,
            },
          ),
          const SizedBox(height: 20),
          const RegisterLoginLink(),
        ],
      ),
    );
  }
}
