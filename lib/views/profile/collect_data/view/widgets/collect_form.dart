import 'package:flutter/material.dart';
import '../../view_model/collect_view_model.dart';

class CollectForm extends StatelessWidget {
  final CollectViewModel viewModel;
  final List<Animation<Offset>> fieldAnimations;

  const CollectForm({
    Key? key,
    required this.viewModel,
    required this.fieldAnimations,
  }) : super(key: key);

  Widget _buildField(
    int index,
    TextEditingController controller,
    String label,
    TextInputType keyboardType,
    String? Function(String?)? validator, {
    int? maxLines,
  }) {
    return SlideTransition(
      position: fieldAnimations[index],
      child: Padding(
        padding: const EdgeInsets.only(bottom: 20),
        child: TextFormField(
          controller: controller,
          style: const TextStyle(color: Color(0xff47cb42)),
          keyboardType: keyboardType,
          maxLines: maxLines ?? 1,
          decoration: InputDecoration(
            labelText: label,
            labelStyle: const TextStyle(color: Colors.white),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(15),
              borderSide: const BorderSide(color: Colors.blue, width: 2),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(15),
              borderSide: BorderSide(color: Colors.blue.shade200, width: 1),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(15),
              borderSide: const BorderSide(color: Colors.blue, width: 2),
            ),
            filled: true,
            fillColor: Colors.black.withOpacity(0.3),
          ),
          validator: validator,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: viewModel.formKey,
      child: Column(
        children: [
          _buildField(
            0,
            viewModel.linkedInController,
            "LinkedIn URL (required)",
            TextInputType.url,
            (value) {
              if (value == null || value.isEmpty) {
                return "LinkedIn URL is required";
              }
              if (!viewModel.isCorrectLink(value)) {
                return "Enter a valid LinkedIn URL";
              }
              return null;
            },
          ),
          _buildField(
            1,
            viewModel.experienceController,
            "Years of Experience (required)",
            TextInputType.number,
            (value) {
              if (value == null || value.isEmpty) {
                return "Years of experience is required";
              }
              if (int.tryParse(value) == null) {
                return "Enter a valid number";
              }
              return null;
            },
          ),
          _buildField(
            2,
            viewModel.phoneController,
            "Phone Number (optional)",
            TextInputType.phone,
            null,
          ),
          _buildField(
            3,
            viewModel.emailController,
            "Email (optional)",
            TextInputType.emailAddress,
            null,
          ),
          _buildField(
            4,
            viewModel.profileLinkController,
            "Profile Link (optional)",
            TextInputType.url,
            null,
          ),
          _buildField(
            5,
            viewModel.aboutController,
            "About You",
            TextInputType.multiline,
            (value) => value == null || value.isEmpty
                ? "Please provide details"
                : null,
            maxLines: 5,
          ),
          _buildField(
            6,
            viewModel.skillsController,
            "Your Skills",
            TextInputType.multiline,
            (value) => value == null || value.isEmpty
                ? "Please list your skills"
                : null,
            maxLines: 5,
          ),
        ],
      ),
    );
  }
}
