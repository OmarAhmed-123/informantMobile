import 'package:flutter/material.dart';

class Profile {
  final String name;
  final String imageUrl;
  final String about;
  final String skills;
  final String linkedin;
  final String email;
  final String phone;
  final int numOfEx;

  Profile({
    required this.name,
    required this.imageUrl,
    required this.about,
    required this.skills,
    required this.linkedin,
    required this.email,
    required this.phone,
    required this.numOfEx,
  });
}

/// Fake Data

final List<Profile> fakeProfiles = [
  Profile(
    name: "Mohamed",
    imageUrl:
        "https://i5.walmartimages.com/seo/Alicafe-Classic-3-In-1-Instant-Coffee-Bag-Ground-30-X-20G-600G_58d646a8-7b89-4524-a667-847665159273.a0da51f0eec72ac0cfd2f387788129da.jpeg",
    about: "Software Engineer with 5+ years of experience in Flutter and Dart.",
    skills: "Flutter, Dart, Firebase, REST APIs",
    linkedin: "https://linkedin.com/in/johndoe",
    email: "john.doe@example.com",
    phone: "+1234567890",
    numOfEx: 5,
  ),
  Profile(
    name: "Ahmed",
    imageUrl:
        "https://i5.walmartimages.com/seo/Alicafe-Classic-3-In-1-Instant-Coffee-Bag-Ground-30-X-20G-600G_58d646a8-7b89-4524-a667-847665159273.a0da51f0eec72ac0cfd2f387788129da.jpeg",
    about: "UI/UX Designer with a passion for creating beautiful interfaces.",
    skills: "Figma, Adobe XD, Sketch, Prototyping",
    linkedin: "https://linkedin.com/in/janesmith",
    email: "jane.smith@example.com",
    phone: "+0987654321",
    numOfEx: 3,
  ),
  Profile(
    name: "Ali",
    imageUrl:
        "https://i5.walmartimages.com/seo/Alicafe-Classic-3-In-1-Instant-Coffee-Bag-Ground-30-X-20G-600G_58d646a8-7b89-4524-a667-847665159273.a0da51f0eec72ac0cfd2f387788129da.jpeg",
    about: "Data Scientist specializing in machine learning and AI.",
    skills: "Python, TensorFlow, Pandas, NumPy",
    linkedin: "https://linkedin.com/in/alicejohnson",
    email: "alice.johnson@example.com",
    phone: "+1122334455",
    numOfEx: 7,
  ),
  Profile(
    name: "omar",
    imageUrl:
        "https://i5.walmartimages.com/seo/Alicafe-Classic-3-In-1-Instant-Coffee-Bag-Ground-30-X-20G-600G_58d646a8-7b89-4524-a667-847665159273.a0da51f0eec72ac0cfd2f387788129da.jpeg",
    about: "Mobile Developer with expertise in Android and iOS development.",
    skills: "Kotlin, Swift, Java, Flutter",
    linkedin: "https://linkedin.com/in/bobbrown",
    email: "bob.brown@example.com",
    phone: "+4455667788",
    numOfEx: 4,
  ),
  Profile(
    name: "noor",
    imageUrl:
        "https://i5.walmartimages.com/seo/Alicafe-Classic-3-In-1-Instant-Coffee-Bag-Ground-30-X-20G-600G_58d646a8-7b89-4524-a667-847665159273.a0da51f0eec72ac0cfd2f387788129da.jpeg",
    about: "Backend Developer specializing in Node.js and MongoDB.",
    skills: "Node.js, MongoDB, Express, REST APIs",
    linkedin: "https://linkedin.com/in/charliedavis",
    email: "charlie.davis@example.com",
    phone: "+9988776655",
    numOfEx: 6,
  ),
];
