import 'package:flutter/material.dart';
import 'dart:convert';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CollectViewModel extends ChangeNotifier {
  final formKey = GlobalKey<FormState>();
  final linkedInController = TextEditingController();
  final experienceController = TextEditingController();
  final phoneController = TextEditingController();
  final emailController = TextEditingController();
  final profileLinkController = TextEditingController();
  final aboutController = TextEditingController();
  final skillsController = TextEditingController();

  File? selectedImage;
  final ImagePicker _picker = ImagePicker();

  bool isCorrectLink(String url) {
    final linkedInRegex =
        RegExp(r"^(https?:\/\/)?([\w]+\.)?linkedin\.com\/.*$");
    return linkedInRegex.hasMatch(url);
  }

  Future<void> pickImage(ImageSource source) async {
    final pickedFile = await _picker.pickImage(source: source);
    if (pickedFile != null) {
      selectedImage = File(pickedFile.path);
      notifyListeners();
    }
  }

  Future<void> saveProfile(BuildContext context) async {
    if (formKey.currentState!.validate()) {
      try {
        SharedPreferences prefs = await SharedPreferences.getInstance();

        // Save required fields
        await prefs.setString('linkedin', linkedInController.text.trim());
        await prefs.setInt(
            'experience_years', int.parse(experienceController.text.trim()));

        // Save optional fields
        await prefs.setString('phone', phoneController.text.trim());
        await prefs.setString('email', emailController.text.trim());
        await prefs.setString(
            'profile_link', profileLinkController.text.trim());
        await prefs.setString('about', aboutController.text.trim());
        await prefs.setString('skills', skillsController.text.trim());

        // Save image
        if (selectedImage != null) {
          final bytes = await selectedImage!.readAsBytes();
          final base64Image = base64Encode(bytes);
          await prefs.setString('profile_image', base64Image);
        }

        if (!context.mounted) return;

        // Show success message and navigate
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Profile saved successfully!')),
        );

        Navigator.pushReplacementNamed(context, '/profile');
      } catch (e) {
        if (!context.mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e')),
        );
      }
    }
  }

  @override
  void dispose() {
    linkedInController.dispose();
    experienceController.dispose();
    phoneController.dispose();
    emailController.dispose();
    profileLinkController.dispose();
    aboutController.dispose();
    skillsController.dispose();
    super.dispose();
  }
}
