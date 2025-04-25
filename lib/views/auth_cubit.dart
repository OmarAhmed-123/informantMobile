import 'package:graduation___part1/views/PaymentPage.dart';
import 'package:graduation___part1/views/editProfile.dart';
import 'package:graduation___part1/views/showConnection.dart';
import 'otp_verification_view.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:graduation___part1/views/httpCodeG.dart';
import 'package:graduation___part1/views/startPage.dart';
import 'package:graduation___part1/views/autoLogin.dart';

List<Map<String, dynamic>> ads1 = [];
Map<String, dynamic> statistics = {};
List<dynamic> myAds = [];
List<Map<String, dynamic>> plans = [];
Map<String, dynamic> users = {};
Map<String, dynamic> oneUser = {};
List<Profile> profiles = [];
List<String> allId = [];
late Profile profile;

class AuthCubit extends Cubit<AuthState> {
  AuthCubit() : super(AuthInitial());
  Future<void> getProfile() async {
    if (users.isEmpty) {
      emit(AuthLoading());
    }
    try {
      final response = await HttpRequest.get({
        "endPoint": "/user/users",
      });

      if (response.statusCode == 200) {
        users = response.data;
        emit(AuthSuccess());
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('cached_profiles', json.encode(users));
      } else {
        emit(
            AuthFailure(error: 'failed to load users: ${response.statusCode}'));
      }
    } catch (e) {
      emit(AuthFailure(error: e.toString()));
    }
  }

  void setCachedAds(List<Map<String, dynamic>> cachedAds) {
    if (cachedAds.isNotEmpty) {
      ads1 = cachedAds;
      emit(AdsLoaded(Ads: ads1));
    }
  }

  Future<void> getAds() async {
    if (ads1.isEmpty) {
      emit(AuthLoading());
    }
    try {
      final response = await HttpRequest.post({
        "endPoint": "/user/home",
      });

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.toString());
        if (data['messages']['content'] != null) {
          ads1 = List<Map<String, dynamic>>.from(data['messages']['content']);
          final prefs = await SharedPreferences.getInstance();
          await prefs.setString('cached_ads', json.encode(ads1));
          emit(AdsLoaded(Ads: ads1));
        } else {
          throw Exception('No content found');
        }
      } else {
        emit(AuthFailure(error: 'Failed to load ads: ${response.statusCode}'));
      }
    } catch (error) {
      emit(AuthFailure(error: error.toString()));
    }
  }

  Future<void> createAd({
    required String name,
    required String details,
    required List<String> imageName,
    required int planNum,
    required bool setToPublic,
    required String link,
    required List<String> medias,
    required BuildContext context,
  }) async {
    emit(AuthLoading());
    try {
      final response = await HttpRequest.post(
        {
          "endPoint": "/user/createAd",
          "name": name,
          "details": details,
          "imagesName": imageName,
          "imagesStr64": medias,
          "planNum": planNum,
          "setToPublic": setToPublic,
          "link": link,
        },
      );
      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.toString());
        if (data['messages']['content']['value'] != null) {
          final String payUrl = data['messages']['content']['value']['payUrl'];
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => PaymentPage(url: payUrl),
            ),
          );
        } else {
          debugPrint('Error: ${response.data} ');
          throw Exception('Invalid response');
        }
        emit(AuthSuccess());
      } else {
        throw Exception('Failed to create ad: ${response.statusCode}');
      }
    } catch (e) {
      emit(AuthFailure(error: 'Error: $e'));
      SnackBar(
        content: Text('Failed to create ad: $e'),
        backgroundColor: Colors.red,
      );
    }
  }

  Future<void> getStatistics(int id) async {
    emit(AuthLoading());
    try {
      final response = await HttpRequest.post({
        "endPoint": "/user/statistics?adId=${id}",
      });
      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.toString());
        if (data['messages']['content'] != null && data['messages'] != null) {
          statistics = Map<String, dynamic>.from(data['messages']['content']);
        } else {
          throw Exception('No statistics found');
        }
      } else {
        emit(AuthFailure(
            error: 'Failed to load statistics: ${response.statusCode}'));
      }
    } catch (error) {
      emit(AuthFailure(error: error.toString()));
    }
  }

  Future<void> logOutApp(BuildContext context) async {
    emit(AuthLoading());
    try {
      final response = await HttpRequest.post({
        "endPoint": "/user/logout",
      });
      if (response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('You have been logged out.')),
        );
        SharedPreferences prefs = await SharedPreferences.getInstance();
        prefs.clear();
        Navigator.of(context).pushNamedAndRemoveUntil(
          '/login',
          (route) => false,
        );
      } else {
        emit(AuthFailure(
            error: 'Failed to load my ads: ${response.statusCode}'));
      }
    } catch (error) {
      emit(AuthFailure(error: 'Error loading my ads: ${error.toString()}'));
    }
  }

  Future loadMyAds() async {
    emit(AuthLoading());
    try {
      final sharedPrefs = await SharedPreferences.getInstance();
      final cachedAdsJson = sharedPrefs.getString('myAds');

      if (cachedAdsJson != null) {
        final cachedAds = List<Map<String, dynamic>>.from(
            jsonDecode(cachedAdsJson)
                .map((item) => Map<String, dynamic>.from(item)));
        myAds = cachedAds;
        emit(MyAdsLoaded(MyAds: myAds));
      }

      final response = await HttpRequest.post({
        "endPoint": "/user/myAds",
      });

      if (response.statusCode == 200) {
        myAds = response.data;
        await sharedPrefs.setString('myAds', jsonEncode(myAds));
        emit(MyAdsLoaded(MyAds: myAds));
      } else {
        if (cachedAdsJson == null) {
          emit(AuthFailure(
              error: 'Failed to load my ads: ${response.statusCode}'));
        }
      }
    } catch (error) {
      final sharedPrefs = await SharedPreferences.getInstance();
      final cachedAdsJson = sharedPrefs.getString('myAds');

      if (cachedAdsJson != null && myAds.isEmpty) {
        final cachedAds = List<Map<String, dynamic>>.from(
            jsonDecode(cachedAdsJson)
                .map((item) => Map<String, dynamic>.from(item)));
        myAds = cachedAds;
        emit(MyAdsLoaded(MyAds: myAds));
      } else {
        emit(AuthFailure(error: 'Error loading my ads: ${error.toString()}'));
      }
    }
  }

  Future<void> getPlans() async {
    emit(AuthLoading());
    try {
      final response = await HttpRequest.post({
        "endPoint": "/user/plans",
      });
      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.toString());
        if (data['messages']['content'] != null) {
          plans = List<Map<String, dynamic>>.from(data['messages']['content']);
          emit(PlansLoaded(Plans: plans));
        } else {
          throw Exception('No plans found');
        }
      } else {
        emit(
            AuthFailure(error: 'Failed to load plans: ${response.statusCode}'));
      }
    } catch (error) {
      emit(AuthFailure(error: error.toString()));
    }
  }

  Future<void> login(
      String username, String password, BuildContext context) async {
    emit(AuthLoading());
    final prefs = await SharedPreferences.getInstance();
    try {
      final response = await HttpRequest.post({
        "endPoint": "/user/login",
        "username": username,
        "password": password
      });

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.toString());

        await prefs.setString('Token', data["token"] ?? "");

        await prefs.setString('pToken', data["ptoken"] ?? "");
        await prefs.setString('username1', username);
        await prefs.setString('password', password);
        await prefs.setBool('open', true);
        AutoLogin.saveData(username, password);
        emit(AuthSuccess());

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const StartPage()),
        );
      } else if (response.statusCode == 401) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
              builder: (context) => const ShowConnection(
                  nameOfImage: "assets/ban.jpg", flag: false, flag2: true)),
        );
      } else if (response.statusCode == 204) {
        if (username.contains("@")) {
          await prefs.setString('email', username);
          Navigator.pushReplacementNamed(context, '/otp_verification');
        } else {
          await prefs.setInt('flag', 2);
          Navigator.pushReplacementNamed(context, '/email_verification');
        }
      } else {
        emit(AuthFailure(error: 'Error: Status Code ${response.statusCode}'));
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: Status Code ${response.statusCode}')),
        );
      }
    } catch (error) {
      emit(AuthFailure(error: error.toString()));
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $error')),
      );
    }
  }

  Future<void> register(
    String username,
    String password,
    String email,
    String phone,
    String fullName,
    String? selectedGender,
  ) async {
    emit(AuthLoading());
    try {
      final response = await HttpRequest.post({
        "endPoint": "/user/signup",
        "password": password,
        "username": username,
        "email": email,
        "phoneNumber": phone,
        "FullName": fullName,
        "details": "",
        "ConfirmPassword": password,
        "linkedIn": "",
        "gender": selectedGender,
      });
      if (response.statusCode == 204) {
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('fullName', fullName);
        await prefs.setString('email', email);
        await prefs.setString('password', password);
        await prefs.setString('phone', phone);
        await prefs.setString('username1', username);
        await prefs.setBool('open', true);
        emit(AuthSuccess());
      } else {
        emit(AuthFailure(error: 'Registration failed: ${response.statusCode}'));
      }
    } catch (e) {
      emit(AuthFailure(error: e.toString()));
    }
  }

  Future<void> forgotPassword(BuildContext context, String email) async {
    emit(AuthLoading());
    try {
      final prefs = await SharedPreferences.getInstance();
      final response =
          await HttpRequest.post({"endPoint": "/user/forgot?email=${email}"});
      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.toString());
        await prefs.setString('Token', data["token"] ?? "");

        await prefs.setString('pToken', data["ptoken"] ?? "");
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => OtpVerificationView(),
          ),
        );
        emit(AuthSuccess());
      } else {
        emit(AuthFailure(
            error: 'Password reset failed: ${response.statusCode}'));
      }
    } catch (e) {
      emit(AuthFailure(error: e.toString()));
    }
  }

  Future<void> sendOtp(String email, BuildContext context) async {
    emit(AuthLoading());
    try {
      final response = await HttpRequest.post({
        "endPoint": "/user/sendotp?email=${email}",
      });
      if (response.statusCode == 200) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => OtpVerificationView(),
          ),
        );
        emit(AuthSuccess());
      } else {
        emit(AuthFailure(error: 'OTP sending failed: ${response.statusCode}'));
      }
    } catch (e) {
      emit(AuthFailure(error: e.toString()));
    }
  }

  Future<void> resetPassword(String fullname, String newPassword, String phone,
      String email, String details, String? image) async {
    emit(AuthLoading());
    try {
      final response = await HttpRequest.post({
        "endPoint": "/user/editprofile",
        "fullname": fullname,
        "password": newPassword,
        "phone": phone,
        "email": email,
        "details": details,
        "image": image ?? "",
      });
      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.toString());
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('Token', data["messages"]["content"]);
        await prefs.setString('pToken', "");
        emit(AuthSuccess());
      } else {
        emit(AuthFailure(error: 'Password reset failed'));
      }
    } catch (e) {
      emit(AuthFailure(error: e.toString()));
    }
  }

  Future<void> verifyOtp(String email, String otp) async {
    emit(AuthLoading());
    try {
      final response = await HttpRequest.post({
        "endPoint": "/user/verify",
        "otp": otp,
        "email": email,
      });
      if (response.statusCode == 200 || response.statusCode == 201) {
        final Map<String, dynamic> data = response.data;
        if (data.containsKey("messages") &&
            data["messages"].containsKey("content")) {
          final prefs = await SharedPreferences.getInstance();
          await prefs.setString('pToken', data["ptoken"] ?? "");
          emit(AuthSuccess());
        } else {
          emit(AuthFailure(error: 'Invalid response structure'));
        }
      } else {
        emit(AuthFailure(
            error: 'OTP verification failed: ${response.statusCode}'));
      }
    } catch (e) {
      emit(AuthFailure(error: e.toString()));
    }
  }

  Future<void> updateAdVisibility(int adId, bool isPublic) async {
    emit(AuthLoading());
    try {
      final response = await HttpRequest.post({
        "endPoint": "/user/updateAdVisibility",
        "adId": adId,
        "isPublic": isPublic,
      });
      if (response.statusCode == 200) {
        getAds();
      } else {
        emit(AuthFailure(error: 'Failed to update ad visibility'));
      }
    } catch (e) {
      emit(AuthFailure(error: e.toString()));
    }
  }

  Future<void> getProfileById(String id) async {
    final prefs = await SharedPreferences.getInstance();
    final cachedProfile = prefs.getString('user_profile_$id');
    if (cachedProfile != null) {
      oneUser = json.decode(cachedProfile);
      emit(AuthSuccess());
      return;
    }
    emit(AuthLoading());
    try {
      oneUser = {};
      final response;
      if (id == "my") {
        response = await HttpRequest.get({
          "endPoint": "/user/profile",
        });
      } else {
        response = await HttpRequest.get({
          "endPoint": "/user/profile?id=$id",
        });
      }
      if (response.statusCode == 200) {
        oneUser = response.data;
        if (id == "my") {
          await prefs.setString('phone', '+1234567890');
          await prefs.setString('email', oneUser["email"] ?? "");
          await prefs.setInt('id', oneUser["id"] ?? "");
          await prefs.setString('linkedin', oneUser["linkedIn"] ?? "");
          await prefs.setString('about', oneUser["details"] ?? "");
          await prefs.setString('profile_image', oneUser["imageLink"] ?? "");
          await prefs.setString('username', oneUser["name"] ?? "");
          profile = Profile(
            name: prefs.getString('username') ?? "Guest",
            imageUrl: prefs.getString('profile_image') ??
                "https://via.placeholder.com/150",
            about: prefs.getString('about') ?? "No information provided",
            linkedin: prefs.getString('linkedin'),
            email: prefs.getString('email') ?? "",
            id: prefs.getInt('id') ?? -1,
            phone: prefs.getString('phone') ?? "",
          );
        } else {
          await prefs.setString('user_profile_$id', json.encode(oneUser));
        }
        emit(AuthSuccess());
      } else {
        emit(
            AuthFailure(error: 'failed to load users: ${response.statusCode}'));
      }
    } catch (e) {
      emit(AuthFailure(error: e.toString()));
    }
  }
}

abstract class AuthState {}

class AuthInitial extends AuthState {}

class AuthLoading extends AuthState {}

class AuthSuccess extends AuthState {}

class AdsLoaded extends AuthState {
  final List<dynamic> Ads;
  AdsLoaded({required this.Ads});
}

class MyAdsLoaded extends AuthState {
  final List<dynamic> MyAds;
  MyAdsLoaded({required this.MyAds});
}

class PlansLoaded extends AuthState {
  final List<Map<String, dynamic>> Plans;
  PlansLoaded({required this.Plans});
}

class AuthFailure extends AuthState {
  final String error;
  AuthFailure({required this.error});
}
