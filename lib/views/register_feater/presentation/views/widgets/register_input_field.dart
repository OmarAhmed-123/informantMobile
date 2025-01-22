import 'package:flutter/material.dart';
import 'package:graduation___part1/views/login_feature/animations/fade_scale_animation.dart';

class RegisterInputField extends StatelessWidget {
  final TextEditingController controller;
  final String label;
  final IconData? icon;
  final bool isPassword;
  final bool? isPasswordVisible;
  final VoidCallback? onToggleVisibility;
  final TextInputType? keyboardType;

  const RegisterInputField({
    Key? key,
    required this.controller,
    required this.label,
    this.icon,
    this.isPassword = false,
    this.isPasswordVisible,
    this.onToggleVisibility,
    this.keyboardType,
  }) : super(key: key);

  String? _validateField(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter your $label';
    }
    if (label == 'Email' &&
        !RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value)) {
      return 'Please enter a valid email address';
    }
    if (label == 'Phone Number' &&
        !RegExp(r'^\+?[0-9]{10,15}$').hasMatch(value)) {
      return 'Please enter a valid phone number';
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return FadeScaleAnimation(
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 10,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: TextFormField(
          controller: controller,
          obscureText: isPassword && !(isPasswordVisible ?? false),
          keyboardType: keyboardType,
          decoration: InputDecoration(
            labelText: label,
            filled: true,
            fillColor: Colors.white.withOpacity(0.9),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: BorderSide.none,
            ),
            prefixIcon: Icon(
              icon ?? (isPassword ? Icons.lock_outline : Icons.input),
              color: Colors.purple[700],
            ),
            suffixIcon: isPassword
                ? IconButton(
                    icon: Icon(
                      isPasswordVisible ?? false
                          ? Icons.visibility
                          : Icons.visibility_off,
                      color: Colors.purple[700],
                    ),
                    onPressed: onToggleVisibility,
                  )
                : null,
          ),
          validator: _validateField,
        ),
      ),
    );
  }
}
