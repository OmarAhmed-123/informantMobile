/*
// ignore_for_file: depend_on_referenced_packages

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
*/
import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:cookie_jar/cookie_jar.dart';
import 'package:dio_cookie_manager/dio_cookie_manager.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart';
import '../models/ad.dart';

class ApiService {
  final String baseUrl;
  late Dio dio;
  late PersistCookieJar cookieJar;

  ApiService({required this.baseUrl}) {
    init();
  }

  Future<void> init() async {
    // Get the directory for storing cookies
    final appDocDir = await getApplicationDocumentsDirectory();
    final cookiePath = join(appDocDir.path, 'cookies');

    // Initialize the cookie jar
    cookieJar = PersistCookieJar(storage: FileStorage(cookiePath));

    // Initialize Dio with the cookie manager
    dio = Dio();
    dio.interceptors.add(CookieManager(cookieJar));
  }

  Future<List<Ad>> fetchAds() async {
    final response = await dio.get('$baseUrl/ads');

    if (response.statusCode == 200) {
      List<dynamic> adsJson = response.data;
      return adsJson.map((json) => Ad.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load ads');
    }
  }

  Future<Ad> createAd(Ad ad) async {
    final response = await dio.post(
      '$baseUrl/ads',
      data: json.encode(ad.toJson()),
      options: Options(headers: {'Content-Type': 'application/json'}),
    );

    if (response.statusCode == 201) {
      return Ad.fromJson(response.data);
    } else {
      throw Exception('Failed to create ad');
    }
  }
}
