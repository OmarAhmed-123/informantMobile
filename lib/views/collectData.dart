import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:graduation___part1/views/profile.dart';
import 'package:graduation___part1/views/home_view.dart';
import 'package:graduation___part1/views/barOfHome.dart';

class collectData extends StatefulWidget {
  const collectData({Key? key}) : super(key: key);

  @override
  CollectDataState createState() => CollectDataState();
}

class CollectDataState extends State<collectData> {
  final formKey = GlobalKey<FormState>();
  final TextEditingController linkedInController = TextEditingController();
  final TextEditingController experienceController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController profileLinkController = TextEditingController();
  final TextEditingController aboutController = TextEditingController();
  final TextEditingController skillsController = TextEditingController();

  File? selectedImage;
  final ImagePicker pick = ImagePicker();

  // Validate LinkedIn URL
  bool isCorrectLink(String url) {
    final linkedInRegex =
        RegExp(r"^(https?:\/\/)?([\w]+\.)?linkedin\.com\/.*$");
    return linkedInRegex.hasMatch(url);
  }

  Future<void> picker(ImageSource source) async {
    final pickedFile = await pick.pickImage(source: source);

    if (pickedFile != null) {
      setState(() {
        selectedImage = File(pickedFile.path);
      });
    }
  }

  void showImage(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return SafeArea(
          child: Wrap(
            children: <Widget>[
              ListTile(
                leading: const Icon(Icons.photo_library),
                title: const Text('Select from Gallery'),
                onTap: () {
                  picker(ImageSource.gallery);
                  Navigator.of(context).pop();
                },
              ),
              ListTile(
                leading: const Icon(Icons.camera_alt),
                title: const Text('Take a Photo'),
                onTap: () {
                  picker(ImageSource.camera);
                  Navigator.of(context).pop();
                },
              ),
            ],
          ),
        );
      },
    );
  }

  Future<void> saveProfile() async {
    if (formKey.currentState!.validate()) {
      SharedPreferences objShared = await SharedPreferences.getInstance();

      // Save required fields
      await objShared.setString('linkedin', linkedInController.text.trim());
      await objShared.setInt(
          'experience_years', int.parse(experienceController.text.trim()));

      // Save optional fields
      await objShared.setString(
          'phone',
          phoneController.text.trim().isNotEmpty
              ? phoneController.text.trim()
              : "null");
      await objShared.setString(
          'email',
          emailController.text.trim().isNotEmpty
              ? emailController.text.trim()
              : "null");
      await objShared.setString(
          'profile_link',
          profileLinkController.text.trim().isNotEmpty
              ? profileLinkController.text.trim()
              : "null");
      await objShared.setString('about', aboutController.text.trim());
      await objShared.setString('skills', skillsController.text.trim());

      // Save image as Base64 string
      if (selectedImage != null) {
        final bytes = await selectedImage!.readAsBytes();
        final base64Image = base64Encode(bytes);
        await objShared.setString('profile_image', base64Image);
      }

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const ProfilePage()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.home, color: Colors.white),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const HomeView()),
            );
          },
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.close, color: Colors.white),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const HomeView1()),
              );
            },
          ),
        ],
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Colors.black,
              Colors.blue.shade900.withOpacity(0.6),
              Colors.black,
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: formKey,
            child: ListView(
              children: [
                GestureDetector(
                  onTap: () => showImage(context),
                  child: CircleAvatar(
                    radius: 60,
                    backgroundImage: selectedImage != null
                        ? FileImage(selectedImage!)
                        : const AssetImage('assets/default_avatar.png')
                            as ImageProvider,
                    child: selectedImage == null
                        ? const Icon(Icons.camera_alt,
                            size: 50, color: Colors.grey)
                        : null,
                  ),
                ),
                const SizedBox(height: 20),
                TextFormField(
                  controller: linkedInController,
                  style: TextStyle(color: Color(0xff47cb42)),
                  decoration: InputDecoration(
                    labelText: "LinkedIn URL (required)",
                    labelStyle: TextStyle(color: Colors.white),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty)
                      return "LinkedIn URL is required";
                    if (!isCorrectLink(value))
                      return "Enter a valid LinkedIn URL";
                    return null;
                  },
                ),
                const SizedBox(height: 20),
                TextFormField(
                  controller: experienceController,
                  style: TextStyle(color: Color(0xff47cb42)),
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    labelText: "Years of Experience (required)",
                    labelStyle: TextStyle(color: Colors.white),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Years of experience is required";
                    }
                    if (int.tryParse(value) == null) {
                      return "Enter a valid number";
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 20),
                TextFormField(
                  controller: phoneController,
                  style: TextStyle(color: Color(0xff47cb42)),
                  keyboardType: TextInputType.phone,
                  decoration: InputDecoration(
                    labelText: "Phone Number (optional)",
                    labelStyle: TextStyle(color: Colors.white),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                TextFormField(
                  controller: emailController,
                  style: TextStyle(color: Color(0xff47cb42)),
                  keyboardType: TextInputType.emailAddress,
                  decoration: InputDecoration(
                    labelText: "Email (optional)",
                    labelStyle: TextStyle(color: Colors.white),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                TextFormField(
                  controller: profileLinkController,
                  style: TextStyle(color: Color(0xff47cb42)),
                  decoration: InputDecoration(
                    labelText: "Profile Link (optional)",
                    labelStyle: TextStyle(color: Colors.white),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                TextFormField(
                  controller: aboutController,
                  style: TextStyle(color: Color(0xff47cb42)),
                  maxLines: 5,
                  decoration: InputDecoration(
                    labelText: "About You",
                    labelStyle: TextStyle(color: Colors.white),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  validator: (value) => value == null || value.isEmpty
                      ? "Please provide details"
                      : null,
                ),
                const SizedBox(height: 20),
                TextFormField(
                  controller: skillsController,
                  style: TextStyle(color: Color(0xff47cb42)),
                  maxLines: 5,
                  decoration: InputDecoration(
                    labelText: "Your Skills",
                    labelStyle: TextStyle(color: Colors.white),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  validator: (value) => value == null || value.isEmpty
                      ? "Please list your skills"
                      : null,
                ),
                const SizedBox(height: 30),
                ElevatedButton(
                  onPressed: saveProfile,
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 15),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    backgroundColor: Colors.blue,
                  ),
                  child: const Text(
                    "Save Profile",
                    style: TextStyle(fontSize: 18, color: Colors.white),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
