import 'package:flutter/material.dart';
import 'package:graduation___part1/views/login_feature/animations/fade_scale_animation.dart';

class LoginInputField extends StatelessWidget {
  final TextEditingController controller;
  final String label;
  final bool isPassword;
  final bool? isPasswordVisible;
  final IconData? prefixIcon;
  final VoidCallback? onToggleVisibility;

  const LoginInputField({
    Key? key,
    required this.controller,
    required this.label,
    this.isPassword = false,
    this.isPasswordVisible,
    this.prefixIcon,
    this.onToggleVisibility,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FadeScaleAnimation(
      child: TextFormField(
        controller: controller,
        obscureText: isPassword && !(isPasswordVisible ?? false),
        decoration: InputDecoration(
          labelText: label,
          filled: true,
          fillColor: Colors.white.withOpacity(0.9),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: BorderSide.none,
          ),
          prefixIcon: Icon(
            prefixIcon ??
                (isPassword ? Icons.lock_outline : Icons.person_outline),
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
        validator: (value) =>
            value?.isEmpty ?? true ? 'Please enter your $label' : null,
      ),
    );
  }
}
