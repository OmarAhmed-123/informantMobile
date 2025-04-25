import 'dart:async';
import 'package:flutter/material.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:graduation___part1/views/autoLogin.dart';
import 'package:graduation___part1/views/showConnection.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:graduation___part1/views/httpCodeG.dart';

class Connection extends StatefulWidget {
  const Connection({super.key});
  @override
  ConnectionS createState() => ConnectionS();
}

class ConnectionS extends State<Connection> {
  final Connectivity _connectivity = Connectivity();
  late StreamSubscription<ConnectivityResult> _connectivitySubscription;
  bool _isChecking = true;
  @override
  void initState() {
    super.initState();
    _initConnectivity();
  }

  @override
  void dispose() {
    _connectivitySubscription.cancel();
    super.dispose();
  }

  Future<void> _clearCache() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('cached_ads');
    await prefs.remove('cached_profiles');
    await prefs.remove('myAds');
    final allKeys = prefs.getKeys();
    for (final key in allKeys) {
      if (key.startsWith('user_profile_')) {
        await prefs.remove(key);
      }
    }
  }

  Future<void> _initConnectivity() async {
    try {
      await _checkConnection();
      _connectivitySubscription = _connectivity.onConnectivityChanged.listen(
        (result) => _checkConnection(),
      ) as StreamSubscription<ConnectivityResult>;
    } catch (e) {
      if (mounted) {
        setState(() => _isChecking = false);
        _navigateToConnectionError();
      }
    }
  }

  Future<bool> _checkConnectivity() async {
    final result = await _connectivity.checkConnectivity();
    return result != ConnectivityResult.none;
  }

  Future<void> _checkConnection() async {
    if (!mounted) return;
    setState(() => _isChecking = true);
    try {
      final isConnected = await _checkConnectivity();

      if (!mounted) return;

      if (isConnected) {
        final prefs = await SharedPreferences.getInstance();
        bool flag = prefs.getBool('open') ?? false;
        if (flag) {
          try {
            final response = await HttpRequest.post({
              "endPoint": "/user/home",
            });

            if (response.statusCode == 200) {
              _navigateToAutoLogin();
            } else if (response.statusCode == 600) {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                    builder: (context) => const ShowConnection(
                        nameOfImage: "assets/serverError.jpeg",
                        flag: false,
                        flag2: false)),
              );
            }
          } catch (e) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                  builder: (context) => const ShowConnection(
                      nameOfImage: "assets/serverError.jpeg",
                      flag: false,
                      flag2: false)),
            );
          }
        } else {
          _navigateToAutoLogin();
        }
      } else {
        _navigateToConnectionError();
      }
    } catch (e) {
      if (mounted) {
        _navigateToConnectionError();
      }
    } finally {
      if (mounted) {
        setState(() => _isChecking = false);
      }
    }
  }

  void _navigateToAutoLogin() {
    _clearCache();
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => AutoLogin()),
    );
  }

  void _navigateToConnectionError() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
          builder: (context) => const ShowConnection(
              nameOfImage: "assets/internet.jpeg", flag: true, flag2: false)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: _isChecking
            ? const Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(),
                  SizedBox(height: 20),
                  Text('Checking internet connection....'),
                ],
              )
            : const SizedBox(),
      ),
    );
  }
}
