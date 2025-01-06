import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:graduation___part1/views/collectData.dart';
import 'package:graduation___part1/views/profile.dart';

class AutoProfile extends StatelessWidget {
  const AutoProfile({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: const CheckUserStatus(),
    );
  }
}

class CheckUserStatus extends StatelessWidget {
  const CheckUserStatus({Key? key}) : super(key: key);

  Future<bool> isSaved() async {
    SharedPreferences objShared = await SharedPreferences.getInstance();
    return objShared.getString('about') != null;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<bool>(
      future: isSaved(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (snapshot.data == true) {
          return const ProfilePage();
        } else {
          return const collectData();
        }
      },
    );
  }
}
