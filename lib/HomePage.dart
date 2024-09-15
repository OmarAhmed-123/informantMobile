// ignore_for_file: file_names, library_private_types_in_public_api

import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

// number 8 in the pdf
class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  File? _imageFile;
  final _picker = ImagePicker();

  // Method to pick image from gallery or camera
  Future<void> _pickImage() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _imageFile = File(pickedFile.path);
      });
    }
  }

  Widget _buildOptionCard(String title, String subtitle, String buttonText,
      IconData icon, Color buttonColor, Function()? onPressed) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Card(
        color: Colors.grey[900],
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        child: ListTile(
          contentPadding: const EdgeInsets.all(20),
          leading: Icon(icon, size: 50, color: Colors.white),
          title: Text(
            title,
            style: const TextStyle(
                color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
          ),
          subtitle:
              Text(subtitle, style: const TextStyle(color: Colors.white54)),
          trailing: ElevatedButton(
            onPressed: onPressed,
            style: ElevatedButton.styleFrom(
              backgroundColor: buttonColor,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
            ),
            child: Text(buttonText),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: const Text("Ad Creation", style: TextStyle(color: Colors.white)),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Profile image picker
            Center(
              child: GestureDetector(
                onTap: _pickImage,
                child: CircleAvatar(
                  radius: 60,
                  backgroundColor: Colors.grey[800],
                  child: _imageFile != null
                      ? ClipOval(
                          child: Image.file(
                            _imageFile!,
                            fit: BoxFit.cover,
                            width: 120,
                            height: 120,
                          ),
                        )
                      : const Icon(
                          Icons.camera_alt,
                          color: Colors.white,
                          size: 50,
                        ),
                ),
              ),
            ),
            const SizedBox(height: 20),

            // Welcome text
            const Center(
              child: Text(
                'Welcome, First name!',
                style: TextStyle(color: Colors.white, fontSize: 24),
              ),
            ),
            const SizedBox(height: 20),

            // Options (Get Ads, Create Ad, Profit, Statistics)
            _buildOptionCard(
              'Get Ads',
              'Choose ad from our ads library',
              'Get',
              Icons.cloud_download,
              Colors.lightBlue,
              () {
                // Navigate to Get Ads
              },
            ),
            _buildOptionCard(
              'Create Ad',
              'Create your own Ad to be added to a massive library of Ads',
              'Create',
              Icons.add_circle_outline,
              Colors.lightBlue,
              () {
                // Navigate to Create Ad
              },
            ),
            _buildOptionCard(
              'Profit',
              'Follow your profit of your advertisement',
              'show info',
              Icons.attach_money,
              Colors.lightBlue,
              () {
                // Navigate to Profit info
              },
            ),
            _buildOptionCard(
              'Statistics',
              'Follow what your created Ads do',
              'Coming soon',
              Icons.bar_chart,
              Colors.grey,
              null, // No action for coming soon
            ),
          ],
        ),
      ),
    );
  }
}
