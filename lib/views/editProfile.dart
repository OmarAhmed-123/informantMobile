import 'package:flutter/material.dart';

class Profile {
  final String name;

  final String imageUrl;
  final int id;

  final String about;

  final String? linkedin;

  final String email;

  final String phone;

  Profile({
    required this.name,
    required this.imageUrl,
    required this.about,
    required this.id,
    this.linkedin,
    required this.email,
    required this.phone,
  });
  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'imageUrl': imageUrl,
      'about': about,
      'linkedin': linkedin,
      'email': email,
      'phone': phone,
      'id': id,
    };
  }

  factory Profile.fromJson(Map<String, dynamic> json) {
    return Profile(
      name: json['name'] ?? '',
      imageUrl: json['imageUrl'] ?? '',
      about: json['about'] ?? '',
      linkedin: json['linkedin'],
      email: json['email'] ?? '',
      phone: json['phone'] ?? '',
      id: json['id'] ?? '',
    );
  }
}

class User {
  final String username;

  final String imageLink;

  final String id;

  User({required this.username, required this.imageLink, required this.id});

  factory User.fromJson(Map json) {
    return User(
      username: json['username'] ?? '',
      imageLink: json['imageLink'] ?? '',
      id: json['id'] ?? '',
    );
  }

  Map toJson() {
    return {
      'username': username,
      'imageLink': imageLink,
      'id': id,
    };
  }
}

List<User> transformUserData(Map originalData) {
  List<User> userList = [];

  originalData.forEach((key, value) {
    userList.add(User.fromJson(value));
  });
  return userList;
}
