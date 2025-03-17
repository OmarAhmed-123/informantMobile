// import 'package:flutter/material.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// import 'package:informant/views/collectData.dart';
// import 'package:informant/views/profile.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// import 'editProfile.dart';

// late Profile profile;

// class AutoProfile extends StatelessWidget {
//   const AutoProfile({Key? key}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       debugShowCheckedModeBanner: false,
//       home: const CheckUserStatus(),
//     );
//   }
// }

// class CheckUserStatus extends StatelessWidget {
//   const CheckUserStatus({Key? key}) : super(key: key);
//   // late Profile profile;

//   Future<bool> isSaved() async {
//     SharedPreferences objShared = await SharedPreferences.getInstance();

//     profile = Profile(
//       name: objShared
//           .getString('username')!, // Replace with actual name if available
//       imageUrl: objShared.getString('profile_image')!, // Fallback image URL
//       about: objShared.getString('about')!,
//       skills: objShared.getString('skills')!,
//       linkedin: objShared.getString('linkedin')!,
//       email: objShared.getString('email')!,
//       phone: objShared.getString('phone')!,
//       numOfEx: objShared.getInt('experience_years')!,
//     );
//     return objShared.getString('about') != null;
//   }

//   @override
//   Widget build(BuildContext context) {
//     return FutureBuilder<bool>(
//       future: isSaved(),
//       builder: (context, snapshot) {
//         if (snapshot.connectionState == ConnectionState.waiting) {
//           return const Center(child: CircularProgressIndicator());
//         }

//         if (snapshot.data == true) {
//           return const ProfileDetailsPage(profile: profile);
//         } else {
//           return const collectData();
//         }
//       },
//     );
//   }
// }
import 'package:flutter/material.dart';
import 'package:graduation___part1/views/collectData.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:graduation___part1/views/profile.dart'; // Import your ProfileDetailsPage
import 'package:graduation___part1/views/editProfile.dart'; // Import your EditProfilePage

class AutoProfile extends StatelessWidget {
  const AutoProfile({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: CheckUserStatus(),
    );
  }
}

class CheckUserStatus extends StatelessWidget {
  const CheckUserStatus({super.key});

  Future<Profile?> getProfileData() async {
    SharedPreferences objShared = await SharedPreferences.getInstance();

    final about = objShared.getString('about');
    final skills = objShared.getString('skills');
    final linkedin = objShared.getString('linkedin');
    final email = objShared.getString('email');
    final phone = objShared.getString('phone');
    final numOfEx = objShared.getInt('experience_years');
    final profileImage = objShared.getString('profile_image');
    final username = objShared.getString('username');
    // Check if required fields are present

    if (about == null ||
        skills == null ||
        linkedin == null ||
        numOfEx == null ||
        username == null) {
      return null; // Return null if required fields are missing
    }

    return Profile(
      name: username,
      imageUrl: profileImage!, // Fallback image URL
      about: about,
      skills: skills,
      linkedin: linkedin,
      email: email ?? "null",
      phone: phone ?? "null",
      numOfEx: numOfEx,
    );
  }

  Future<bool> isSaved() async {
    SharedPreferences objShared = await SharedPreferences.getInstance();

    return objShared.getString('about') != null; // Check if profile data exists
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<bool>(
      future: isSaved(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
              child: CircularProgressIndicator()); // Show loading indicator
        }

        if (snapshot.data == true) {
          return FutureBuilder<Profile?>(
            future: getProfileData(),
            builder: (context, profileSnapshot) {
              if (profileSnapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }

              if (profileSnapshot.hasData && profileSnapshot.data != null) {
                return ProfilePage(
                    profile: profileSnapshot
                        .data!); // Navigate to ProfileDetailsPage
              } else {
                return const collectData(); // Fallback to collectData if profile data is incomplete
              }
            },
          );
        } else {
          return const collectData(); // Navigate to collectData if no data is saved
        }
      },
    );
  }
}
