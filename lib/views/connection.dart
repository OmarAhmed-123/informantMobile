/*
import 'package:flutter/material.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:graduation___part1/views/autoLogin.dart';
import 'package:graduation___part1/views/showConnection.dart';

class Connection extends StatefulWidget {
  const Connection({Key? key}) : super(key: key);

  @override
  ConnectionS createState() => ConnectionS();
}

class ConnectionS extends State<Connection> {
  Future<bool> check() async {
    var connectResult = await Connectivity().checkConnectivity();

    
    if (connectResult == ConnectivityResult.mobile ||
        connectResult == ConnectivityResult.wifi) {
      return true; 
    } else {
      return false;
    }
  }

  
  Future<void> checkConnection() async {
    bool isConnected = await check();
    if (isConnected) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const AutoLogin()),
      );
    } else {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const ShowConnection()),
      );
    }
  }

  @override
  void initState() {
    super.initState();
    
    WidgetsBinding.instance.addPostFrameCallback((_) {
      checkConnection();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(),
    );
  }
}
*/
import 'package:flutter/material.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:graduation___part1/views/autoLogin.dart';
import 'package:graduation___part1/views/showConnection.dart';

class Connection extends StatefulWidget {
  const Connection({super.key});

  @override
  ConnectionS createState() => ConnectionS();
}

class ConnectionS extends State<Connection> {
  Future<bool> check() async {
    var connectResult = await Connectivity().checkConnectivity();

    if (connectResult == ConnectivityResult.mobile ||
        connectResult == ConnectivityResult.wifi) {
      return true;
    } else {
      return false;
    }
  }

  Future<void> checkConnection() async {
    bool isConnected = await check();
    if (isConnected) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const AutoLogin()),
      );
    } else {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const ShowConnection()),
      );
    }
  }

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      checkConnection();
    });
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(),
    );
  }
}
