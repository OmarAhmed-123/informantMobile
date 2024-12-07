import 'package:flutter/material.dart';
import 'dart:convert'; // For Base64 encoding/decoding
import 'package:shared_preferences/shared_preferences.dart';
import 'package:graduation___part1/views/collectData.dart';
import 'package:graduation___part1/views/home_view.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  String? about;
  String? username;
  String? skills;
  ImageProvider? _profileImage;
  int selectedTab = 0;
  String? linkedin;
  int? numOfEx;
  String? email;
  String? phone;
  String? profile;
  @override
  void initState() {
    super.initState();
    _loadProfileData();
  }

  Future<void> _loadProfileData() async {
    SharedPreferences objShared = await SharedPreferences.getInstance();

    setState(() {
      about = objShared.getString('about');
      skills = objShared.getString('skills');
      username = objShared.getString('username');
      final base64Image = objShared.getString('profile_image');

      email = objShared.getString('email');
      linkedin = objShared.getString('linkedin');
      profile = objShared.getString('profile_link');
      phone = objShared.getString('phone');
      numOfEx = objShared.getInt('experience_years');

      if (base64Image != null) {
        final bytes = base64Decode(base64Image);
        _profileImage = MemoryImage(bytes);
      } else {
        _profileImage = const AssetImage('assets/default_avatar.png');
      }
    });
  }

  Widget _buildContent() {
    switch (selectedTab) {
      case 0:
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "About Me",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              about ?? "No information provided.",
              textAlign: TextAlign.justify,
              style: const TextStyle(fontSize: 16, color: Colors.white),
            ),
            const SizedBox(height: 20),
            const Text(
              "My Skills",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              skills ?? "No skills added.",
              textAlign: TextAlign.justify,
              style: const TextStyle(fontSize: 16, color: Colors.white),
            ),
            const SizedBox(height: 20),
            const Text(
              "linkedin Link : ",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              linkedin ?? "No.",
              textAlign: TextAlign.justify,
              style: const TextStyle(fontSize: 16, color: Colors.white),
            ),
            const SizedBox(height: 20),
            const Text(
              "Number of years of experience:",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              numOfEx.toString(),
              textAlign: TextAlign.justify,
              style: const TextStyle(fontSize: 16, color: Colors.white),
            ),
            const SizedBox(height: 20),
            const Text(
              "email : ",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              email.toString(),
              textAlign: TextAlign.justify,
              style: const TextStyle(fontSize: 16, color: Colors.white),
            ),
            const SizedBox(height: 20),
            const Text(
              "phone : ",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              phone.toString(),
              textAlign: TextAlign.justify,
              style: const TextStyle(fontSize: 16, color: Colors.white),
            ),
            const SizedBox(height: 20),
            const Text(
              "Profile Link",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              profile.toString(),
              textAlign: TextAlign.justify,
              style: const TextStyle(fontSize: 16, color: Colors.white),
            ),
          ],
        );
      case 1:
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Rates",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 10),
            const Text(
              "⭐️⭐️⭐️⭐️⭐️ - Excellent, very professional and punctual.",
              style: TextStyle(fontSize: 16, color: Colors.white),
            ),
          ],
        );
      case 2:
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "My Works",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 10),
            const Text(
              "You can add photos or samples of your previous work here.",
              style: TextStyle(fontSize: 16, color: Colors.white),
            ),
          ],
        );
      default:
        return Container();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Color(0xff3d3d3d),
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
            icon: const Icon(Icons.edit, color: Colors.white),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const collectData()),
              );
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.5),
                      blurRadius: 10,
                      offset: const Offset(0, 5),
                    ),
                  ],
                ),
                child: CircleAvatar(
                  radius: 60,
                  backgroundColor: Colors.grey[800],
                  backgroundImage: _profileImage,
                ),
              ),
              const SizedBox(height: 10),
              Text(
                username ?? "Username",
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 20),
              ElevatedButton.icon(
                onPressed: () {},
                icon: const Icon(Icons.message),
                label: const Text("Contact Me"),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blueGrey,
                ),
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Column(
                    children: [
                      IconButton(
                        icon: const Icon(Icons.person, color: Colors.white),
                        onPressed: () {
                          setState(() {
                            selectedTab = 0;
                          });
                        },
                      ),
                      const Text("Profile",
                          style: TextStyle(color: Colors.white)),
                    ],
                  ),
                  Column(
                    children: [
                      IconButton(
                        icon: const Icon(Icons.star, color: Colors.white),
                        onPressed: () {
                          setState(() {
                            selectedTab = 1;
                          });
                        },
                      ),
                      const Text("Rates",
                          style: TextStyle(color: Colors.white)),
                    ],
                  ),
                  Column(
                    children: [
                      IconButton(
                        icon: const Icon(Icons.work, color: Colors.white),
                        onPressed: () {
                          setState(() {
                            selectedTab = 2;
                          });
                        },
                      ),
                      const Text("My Works",
                          style: TextStyle(color: Colors.white)),
                    ],
                  ),
                ],
              ),
              Divider(height: 40, thickness: 1, color: Colors.grey[600]),
              _buildContent(),
            ],
          ),
        ),
      ),
    );
  }
}
