import 'package:flutter/material.dart';
import 'package:graduation___part1/views/login_view.dart';
import 'package:graduation___part1/views/home_view.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:local_auth/local_auth.dart';

class AutoLogin extends StatelessWidget {
  const AutoLogin({super.key});

  LocalAuthentication get auth => LocalAuthentication();

  Future<bool> getData() async {
    try {
      SharedPreferences objShared = await SharedPreferences.getInstance();
      final username = objShared.getString('email');
      final password = objShared.getString('password');

      return username != null && password != null;
    } catch (e) {
      debugPrint("Error from SharedPreferences: $e");
      return false;
    }
  }

  Future<bool> Authenticate() async {
    try {
      final bool authBio = await auth.canCheckBiometrics;
      if (authBio) {
        final bool didAuthenticate = await auth.authenticate(
          localizedReason: 'Please authenticate to access the app',
          options: const AuthenticationOptions(
            biometricOnly: false,
          ),
        );
        return didAuthenticate;
      }
    } catch (e) {
      debugPrint("Authentication error: $e");
    }
    return false;
  }

  static Future<void> saveData(String username, String password) async {
    SharedPreferences objShared = await SharedPreferences.getInstance();
    objShared.setString('username', username);
    objShared.setString('password', password);
  }

  static Future<void> saveEmail(String email) async {
    SharedPreferences objShared = await SharedPreferences.getInstance();

    objShared.setString('email', email);
  }

  static Future<void> logout3() async {
    SharedPreferences objShared = await SharedPreferences.getInstance();
    objShared.clear();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<bool>(
      future: getData(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          );
        }

        if (snapshot.hasError) {
          return Scaffold(
            body: Center(
              child: Text(
                'Error: ${snapshot.error}',
                style: const TextStyle(color: Colors.red),
              ),
            ),
          );
        }

        if (snapshot.connectionState == ConnectionState.done) {
          if (snapshot.data == true) {
            return FutureBuilder<bool>(
              future: Authenticate(),
              builder: (context, authSnapshot) {
                if (authSnapshot.connectionState == ConnectionState.waiting) {
                  return const Scaffold(
                    body: Center(
                      child: CircularProgressIndicator(),
                    ),
                  );
                }

                if (authSnapshot.connectionState == ConnectionState.done &&
                    authSnapshot.data == true) {
                  return const HomeView();
                } else {
                  return Scaffold(
                    body: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const SizedBox(height: 80), // Space at the top
                        Center(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              // Image
                              Container(
                                width: 60,
                                height: 60,
                                decoration: const BoxDecoration(
                                  image: DecorationImage(
                                    image: AssetImage(
                                        'assets/informant.jpeg'), // Your image path
                                    fit: BoxFit.cover,
                                  ),
                                  shape: BoxShape.circle, // Circular background
                                ),
                              ),
                              const SizedBox(
                                  width: 10), // Space between image and text
                              // Text
                              const Text(
                                'Informant',
                                style: TextStyle(
                                  color: Colors.blueAccent,
                                  fontSize: 22,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 40),
                        const Spacer(),
                        const Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              // Icons
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.face,
                                    size: 80,
                                    color: Colors.red,
                                  ),
                                  SizedBox(width: 20),
                                  Icon(
                                    Icons.fingerprint,
                                    size: 80,
                                    color: Colors.red,
                                  ),
                                ],
                              ),
                              SizedBox(height: 20),
                              // Title
                              Text(
                                'Verification needed',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.deepPurple,
                                ),
                              ),
                              SizedBox(height: 10),
                              // Description
                              Text(
                                'We were unable to verify your Face ID or Fingerprint.',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.black54,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const Spacer(),

                        Padding(
                          padding: const EdgeInsets.only(bottom: 55),
                          child: ElevatedButton(
                            onPressed: () {
                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => const AutoLogin()),
                              );
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.blue,
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 40, vertical: 15),
                              shape: RoundedRectangleBorder(
                                borderRadius:
                                    BorderRadius.circular(8), // Rounded corners
                              ),
                            ),
                            child: const Text(
                              'Try Again',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                }
              },
            );
          } else {
            return const LoginView();
          }
        }

        return const Scaffold(
          body: Center(
            child: Text('Unexpected state'),
          ),
        );
      },
    );
  }
}
