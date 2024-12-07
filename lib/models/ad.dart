// ignore_for_file: recursive_getters

/*
class Ad {
  final String id;
  final String name;
  final String description;
  final double price;
  final String imageUrl;
  final DateTime createdAt;
  final double earnings;

  Ad({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    required this.createdAt,
    required this.earnings,
    required this.imageUrl,
  });

  factory Ad.fromJson(Map<String, dynamic> json) {
    return Ad(
      id: json['id'],
      name: json['name'],
      description: json['description'],
      price: json['price'].toDouble(),
      imageUrl: json['imageUrl'],
      createdAt: DateTime.parse(json['createdAt']),
      earnings: json['earnings'].toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'price': price,
      'imageUrl': imageUrl,
      'createdAt': createdAt.toIso8601String(),
      'earnings': earnings,
    };
  }
}
*/

import 'dart:io';

class Ad {
  final String id;
  final String name;
  final String details;
  final double price;
  final List<String>? imageUrl; // Make imageUrl nullable
  final DateTime createdAt;
  final double earnings;
  final int stars;
  final double potentialRevenue;
  final int availablePlaces;
  final String creatorName;
  final String description;
  final File? imageFile;
  final List<String>? images;

  Ad({
    required this.id,
    required this.name,
    required this.details,
    required this.price,
    this.imageUrl, // imageUrl is now optional
    required this.createdAt,
    required this.earnings,
    required this.stars,
    required this.potentialRevenue,
    required this.availablePlaces,
    required this.creatorName,
    required this.description,
    this.imageFile,
    this.images,
  });

  factory Ad.fromJson(Map<String, dynamic> json) {
    return Ad(
      id: json['id'] ?? DateTime.now().toString(),
      name: json['name'],
      description: json['description'] ?? '',
      imageFile: json['imageFile'] != null ? File(json['imageFile']) : null,
      details: json['details'],
      price: (json['price'] ?? 0.0).toDouble(),
      imageUrl: json['imageUrl'] != null
          ? List<String>.from(json['imageUrl'])
          : null, // Handle nullable imageUrl
      createdAt: json['createdAt'] != null
          ? DateTime.parse(json['createdAt'])
          : DateTime.now(),
      earnings: (json['earnings'] ?? 0.0).toDouble(),
      stars: json['stars'] ?? 0,
      potentialRevenue: (json['potentialRevenue'] ?? 0.0).toDouble(),
      availablePlaces: json['availablePlaces'] ?? 0,
      creatorName: json['creatorName'] ?? '',
      images: List<String>.from(json['images']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'imageFile': imageFile?.path,
      'details': details,
      'price': price,
      'imageUrl': imageUrl, // Serialize imageUrl, even if null
      'createdAt': createdAt.toIso8601String(),
      'earnings': earnings,
      'stars': stars,
      'potentialRevenue': potentialRevenue,
      'availablePlaces': availablePlaces,
      'creatorName': creatorName,
    };
  }

  String get imageUrll => (imageUrl != null && imageUrl!.isNotEmpty)
      ? imageUrl![0]
      : 'https://via.placeholder.com/150'; // Default image if imageUrl is null or empty
}
