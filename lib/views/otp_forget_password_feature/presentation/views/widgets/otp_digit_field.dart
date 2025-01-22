import 'package:flutter/material.dart';

class OtpDigitField extends StatelessWidget {
  final TextEditingController controller;
  final Animation<double> animation;
  final Function(String) onChanged;
  final String? Function(String?) validator;

  const OtpDigitField({
    Key? key,
    required this.controller,
    required this.animation,
    required this.onChanged,
    required this.validator,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ScaleTransition(
      scale: animation,
      child: SizedBox(
        width: 40,
        child: TextFormField(
          controller: controller,
          decoration: InputDecoration(
            filled: true,
            fillColor: Colors.white.withOpacity(0.9),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide.none,
            ),
            counterText: '',
            errorStyle: const TextStyle(height: 0),
          ),
          keyboardType: TextInputType.number,
          textAlign: TextAlign.center,
          maxLength: 1,
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
          onChanged: onChanged,
          validator: validator,
        ),
      ),
    );
  }
}