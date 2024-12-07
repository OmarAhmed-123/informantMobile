import 'package:flutter/material.dart';
import 'package:graduation___part1/views/login_view.dart';
import 'package:graduation___part1/views/home_view.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:local_auth/local_auth.dart';

class AutoLogin extends StatelessWidget {
  const AutoLogin({Key? key}) : super(key: key);

  // Instantiate LocalAuthentication in a method
  LocalAuthentication get auth => LocalAuthentication();

  // Fetch user credentials from SharedPreferences
  Future<bool> getData() async {
    try {
      SharedPreferences objShared = await SharedPreferences.getInstance();
      final username = objShared.getString('username');
      final password = objShared.getString('password');

      // Debugging logs for FlutLab console
      debugPrint("Retrieved username: $username, password: $password");

      // Return true if both username and password are available
      return username != null && password != null;
    } catch (e) {
      debugPrint("Error retrieving data from SharedPreferences: $e");
      return false;
    }
  }

  // Biometric Authentication Logic
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

  static Future<void> logout3() async {
    SharedPreferences objShared = await SharedPreferences.getInstance();
    objShared.clear();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<bool>(
      future: getData(),
      builder: (context, snapshot) {
        debugPrint(
            "FutureBuilder Connection State: ${snapshot.connectionState}");

        // Handle loading state
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          );
        }

        // Handle errors
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

        // Handle successful completion
        if (snapshot.connectionState == ConnectionState.done) {
          if (snapshot.data == true) {
            // Authenticate user before navigating to home
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
                  return const HomeView(); // Go to home if authentication succeeds
                } else {
                  return Scaffold(
                    body: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text(
                            'Informant \n\n\n Verification Needed',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: Colors.blue,
                              fontWeight: FontWeight.bold,
                              fontSize:
                                  18, // Slightly larger size for the title
                            ),
                          ),
                          const SizedBox(height: 10),
                          const Text(
                            'We were unable to verify your face ID, fingerprint, or pattern.',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: Colors.red,
                              fontSize: 16,
                            ),
                          ),
                          const SizedBox(height: 20),
                          ElevatedButton(
                            onPressed: () {
                              // Navigate back to AutoLogin screen
                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => const AutoLogin()),
                              );
                            },
                            child: const Text('Try Again'),
                          ),
                        ],
                      ),
                    ),
                  );
                }
              },
            );
          } else {
            return const LoginView(); // Go to login if credentials are missing
          }
        }

        // Fallback widget
        return const Scaffold(
          body: Center(
            child: Text('Unexpected state'),
          ),
        );
      },
    );
  }
}
