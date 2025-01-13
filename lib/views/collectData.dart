/*
//not include the animation

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
*/
// ignore_for_file: file_names
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

class CollectDataState extends State<collectData>
    with TickerProviderStateMixin {
  // Form key and controllers
  final formKey = GlobalKey<FormState>();
  final TextEditingController linkedInController = TextEditingController();
  final TextEditingController experienceController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController profileLinkController = TextEditingController();
  final TextEditingController aboutController = TextEditingController();
  final TextEditingController skillsController = TextEditingController();

  // Image picker
  File? selectedImage;
  final ImagePicker pick = ImagePicker();

  // Animation controllers
  late AnimationController _fadeController;
  late AnimationController _slideController;
  late List<AnimationController> _fieldControllers;
  late AnimationController _avatarController;
  late AnimationController _buttonController;

  // Animations
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;
  late List<Animation<Offset>> _fieldAnimations;
  late Animation<double> _avatarScaleAnimation;
  late Animation<double> _buttonScaleAnimation;

  @override
  void initState() {
    super.initState();

    // Initialize fade animation
    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );
    _fadeAnimation = CurvedAnimation(
      parent: _fadeController,
      curve: Curves.easeIn,
    );

    // Initialize slide animation
    _slideController = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );
    _slideAnimation = Tween<Offset>(
      begin: const Offset(-1.0, 0.0),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _slideController,
      curve: Curves.easeOutCubic,
    ));

    // Initialize field animations
    _fieldControllers = List.generate(
      7,
      (index) => AnimationController(
        duration: Duration(milliseconds: 500 + (index * 100)),
        vsync: this,
      ),
    );

    _fieldAnimations = _fieldControllers.map((controller) {
      return Tween<Offset>(
        begin: const Offset(1.0, 0.0),
        end: Offset.zero,
      ).animate(CurvedAnimation(
        parent: controller,
        curve: Curves.easeOutCubic,
      ));
    }).toList();

    // Initialize avatar animation
    _avatarController = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );
    _avatarScaleAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _avatarController,
      curve: Curves.elasticOut,
    ));

    // Initialize button animation
    _buttonController = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );
    _buttonScaleAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _buttonController,
      curve: Curves.easeOutBack,
    ));

    // Start animations
    _fadeController.forward();
    _slideController.forward();
    _avatarController.forward();
    for (var controller in _fieldControllers) {
      controller.forward();
    }
    Future.delayed(const Duration(milliseconds: 1500), () {
      _buttonController.forward();
    });
  }

  @override
  void dispose() {
    _fadeController.dispose();
    _slideController.dispose();
    for (var controller in _fieldControllers) {
      controller.dispose();
    }
    _avatarController.dispose();
    _buttonController.dispose();
    super.dispose();
  }

  // Validate LinkedIn URL
  bool isCorrectLink(String url) {
    final linkedInRegex =
        RegExp(r"^(https?:\/\/)?([\w]+\.)?linkedin\.com\/.*$");
    return linkedInRegex.hasMatch(url);
  }

  // Image picker methods
  Future<void> picker(ImageSource source) async {
    final pickedFile = await pick.pickImage(source: source);
    if (pickedFile != null) {
      setState(() {
        selectedImage = File(pickedFile.path);
      });
      // Animate avatar when new image is selected
      _avatarController.reset();
      _avatarController.forward();
    }
  }

  void showImage(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (BuildContext context) {
        return Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
          ),
          child: SafeArea(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                const SizedBox(height: 10),
                Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
                const SizedBox(height: 20),
                ListTile(
                  leading: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.blue.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Icon(Icons.photo_library, color: Colors.blue),
                  ),
                  title: const Text('Select from Gallery'),
                  onTap: () {
                    picker(ImageSource.gallery);
                    Navigator.of(context).pop();
                  },
                ),
                ListTile(
                  leading: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.blue.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Icon(Icons.camera_alt, color: Colors.blue),
                  ),
                  title: const Text('Take a Photo'),
                  onTap: () {
                    picker(ImageSource.camera);
                    Navigator.of(context).pop();
                  },
                ),
                const SizedBox(height: 20),
              ],
            ),
          ),
        );
      },
    );
  }

  // Save profile data
  Future<void> saveProfile() async {
    if (formKey.currentState!.validate()) {
      // Show loading indicator
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return const Center(child: CircularProgressIndicator());
        },
      );

      try {
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

        // Remove loading indicator
        Navigator.of(context).pop();

        // Show success message
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('Profile saved successfully!'),
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            backgroundColor: Colors.green,
          ),
        );

        // Navigate to profile page with animation
        Navigator.pushReplacement(
          context,
          PageRouteBuilder(
            pageBuilder: (context, animation, secondaryAnimation) =>
                const ProfilePage(),
            transitionsBuilder:
                (context, animation, secondaryAnimation, child) {
              return FadeTransition(
                opacity: animation,
                child: SlideTransition(
                  position: Tween<Offset>(
                    begin: const Offset(0.0, 1.0),
                    end: Offset.zero,
                  ).animate(animation),
                  child: child,
                ),
              );
            },
            transitionDuration: const Duration(milliseconds: 500),
          ),
        );
      } catch (e) {
        // Remove loading indicator
        Navigator.of(context).pop();

        // Show error message
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('Error saving profile. Please try again.'),
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Animated AppBar
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(60.0),
        child: SlideTransition(
          position: _slideAnimation,
          child: AppBar(
            backgroundColor: Colors.black,
            elevation: 0,
            leading: IconButton(
              icon: const Icon(Icons.home, color: Colors.white),
              onPressed: () {
                Navigator.push(
                  context,
                  PageRouteBuilder(
                    pageBuilder: (context, animation, secondaryAnimation) =>
                        const HomeView(),
                    transitionsBuilder:
                        (context, animation, secondaryAnimation, child) {
                      return FadeTransition(
                        opacity: animation,
                        child: child,
                      );
                    },
                  ),
                );
              },
            ),
            actions: [
              IconButton(
                icon: const Icon(Icons.close, color: Colors.white),
                onPressed: () {
                  Navigator.push(
                    context,
                    PageRouteBuilder(
                      pageBuilder: (context, animation, secondaryAnimation) =>
                          const HomeView1(),
                      transitionsBuilder:
                          (context, animation, secondaryAnimation, child) {
                        return FadeTransition(
                          opacity: animation,
                          child: child,
                        );
                      },
                    ),
                  );
                },
              ),
            ],
          ),
        ),
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
        child: FadeTransition(
          opacity: _fadeAnimation,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Form(
              key: formKey,
              child: ListView(
                children: [
                  // Animated Avatar
                  ScaleTransition(
                    scale: _avatarScaleAnimation,
                    child: GestureDetector(
                      onTap: () => showImage(context),
                      child: Hero(
                        tag: 'profile_image',
                        child: Container(
                          width: 120,
                          height: 120,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: Colors.blue.shade400,
                              width: 3,
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.blue.withOpacity(0.3),
                                spreadRadius: 2,
                                blurRadius: 10,
                              ),
                            ],
                          ),
                          child: CircleAvatar(
                            radius: 60,
                            backgroundImage: selectedImage != null
                                ? FileImage(selectedImage!)
                                : const AssetImage('assets/default_avatar.png')
                                    as ImageProvider,
                            child: selectedImage == null
                                ? Icon(
                                    Icons.camera_alt,
                                    size: 50,
                                    color: Colors.grey.withOpacity(0.7),
                                  )
                                : null,
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 30),

                  // Animated Form Fields
                  ..._buildAnimatedFields(),

                  const SizedBox(height: 30),

                  // Animated Save Button
                  ScaleTransition(
                    scale: _buttonScaleAnimation,
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15),
                        gradient: LinearGradient(
                          colors: [
                            Colors.blue.shade400,
                            Colors.blue.shade700,
                          ],
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.blue.withOpacity(0.3),
                            spreadRadius: 1,
                            blurRadius: 8,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: ElevatedButton(
                        onPressed: saveProfile,
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 15),
                          backgroundColor: Colors.transparent,
                          shadowColor: Colors.transparent,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15),
                          ),
                        ),
                        child: const Text(
                          "Save Profile",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  // Build animated form fields
  List<Widget> _buildAnimatedFields() {
    final fields = [
      _buildField(
        0,
        linkedInController,
        "LinkedIn URL (required)",
        TextInputType.url,
        (value) {
          if (value == null || value.isEmpty) return "LinkedIn URL is required";
          if (!isCorrectLink(value)) return "Enter a valid LinkedIn URL";
          return null;
        },
      ),
      _buildField(
        1,
        experienceController,
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
        phoneController,
        "Phone Number (optional)",
        TextInputType.phone,
        null,
      ),
      _buildField(
        3,
        emailController,
        "Email (optional)",
        TextInputType.emailAddress,
        null,
      ),
      _buildField(
        4,
        profileLinkController,
        "Profile Link (optional)",
        TextInputType.url,
        null,
      ),
      _buildField(
        5,
        aboutController,
        "About You",
        TextInputType.multiline,
        (value) =>
            value == null || value.isEmpty ? "Please provide details" : null,
        maxLines: 5,
      ),
      _buildField(
        6,
        skillsController,
        "Your Skills",
        TextInputType.multiline,
        (value) =>
            value == null || value.isEmpty ? "Please list your skills" : null,
        maxLines: 5,
      ),
    ];

    return List.generate(
      fields.length,
      (index) => Padding(
        padding: const EdgeInsets.only(bottom: 20),
        child: SlideTransition(
          position: _fieldAnimations[index],
          child: fields[index],
        ),
      ),
    );
  }

  // Build individual form field
  Widget _buildField(
    int index,
    TextEditingController controller,
    String label,
    TextInputType keyboardType,
    String? Function(String?)? validator, {
    int? maxLines,
  }) {
    return TextFormField(
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
    );
  }
}
