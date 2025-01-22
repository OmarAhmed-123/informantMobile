import 'package:flutter/material.dart';
import 'input_field.dart';

class FormFields extends StatelessWidget {
  final TextEditingController nameController;
  final TextEditingController descriptionController;
  final TextEditingController priceController;
  final Animation<double> scaleAnimation;

  const FormFields({
    Key? key,
    required this.nameController,
    required this.descriptionController,
    required this.priceController,
    required this.scaleAnimation,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        InputField(
          controller: nameController,
          label: 'Ad Name',
          scaleAnimation: scaleAnimation,
          validator: (value) {
            if (value?.isEmpty ?? true) return 'Please enter an ad name';
            return null;
          },
        ),
        const SizedBox(height: 16),
        InputField(
          controller: descriptionController,
          label: 'Description',
          maxLines: 3,
          scaleAnimation: scaleAnimation,
          validator: (value) {
            if (value?.isEmpty ?? true) return 'Please enter a description';
            return null;
          },
        ),
        const SizedBox(height: 16),
        InputField(
          controller: priceController,
          label: 'Price',
          keyboardType: TextInputType.number,
          scaleAnimation: scaleAnimation,
          validator: (value) {
            if (value?.isEmpty ?? true) return 'Please enter a price';
            if (double.tryParse(value!) == null) {
              return 'Please enter a valid number';
            }
            return null;
          },
        ),
      ],
    );
  }
}
