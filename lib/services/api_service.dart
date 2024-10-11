import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/ad.dart';

class ApiService {
  final String baseUrl;

  ApiService({required this.baseUrl});

  Future<List<Ad>> fetchAds() async {
    final response = await http.get(Uri.parse('$baseUrl/ads'));

    if (response.statusCode == 200) {
      List<dynamic> adsJson = json.decode(response.body);
      return adsJson.map((json) => Ad.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load ads');
    }
  }

  Future<Ad> createAd(Ad ad) async {
    final response = await http.post(
      Uri.parse('$baseUrl/ads'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode(ad.toJson()),
    );

    if (response.statusCode == 201) {
      return Ad.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to create ad');
    }
  }
}
