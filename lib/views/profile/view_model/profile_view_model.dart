import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class ProfileViewModel extends ChangeNotifier {
  String? about, username, skills, linkedin, email, phone, profile;
  ImageProvider? profileImage;
  int selectedTab = 0;
  int? numOfEx;
  bool isLoading = true;

  Future<void> loadProfileData() async {
    isLoading = true;
    notifyListeners();

    try {
      final prefs = await SharedPreferences.getInstance();

      about = prefs.getString('about');
      skills = prefs.getString('skills');
      username = prefs.getString('username');
      email = prefs.getString('email');
      linkedin = prefs.getString('linkedin');
      profile = prefs.getString('profile_link');
      phone = prefs.getString('phone');
      numOfEx = prefs.getInt('experience_years');

      final base64Image = prefs.getString('profile_image');
      if (base64Image != null) {
        final bytes = base64Decode(base64Image);
        profileImage = MemoryImage(bytes);
      } else {
        profileImage = const AssetImage('assets/default_avatar.png');
      }
    } catch (e) {
      debugPrint('Error loading profile: $e');
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  void setSelectedTab(int index) {
    selectedTab = index;
    notifyListeners();
  }
}
