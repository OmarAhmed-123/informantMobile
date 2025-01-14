/*
//test by dr ihab 
import 'package:flutter/material.dart';
import 'package:graduation___part1/views/httpCodeG.dart';
import 'package:provider/provider.dart';
import '../view_models/auth_view_model.dart';

class EmailVerificationView extends StatefulWidget {
  const EmailVerificationView({Key? key}) : super(key: key);

  @override
  emailVerificationViewS createState() => emailVerificationViewS();
}

class emailVerificationViewS extends State<EmailVerificationView> {
  final formKey = GlobalKey<FormState>();
  final emailController = TextEditingController();

  @override
  void dispose() {
    emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Email Verification'),
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Colors.purple[700]!, Colors.blue[500]!],
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                TextFormField(
                  controller: emailController,
                  decoration: InputDecoration(
                    labelText: 'Email',
                    filled: true,
                    fillColor: Colors.white.withOpacity(0.7),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your email';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 24),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.purple[700],
                    backgroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 50, vertical: 15),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                  onPressed: () async {
                    if (formKey.currentState!.validate()) {
                      final authViewModel =
                          Provider.of<AuthViewModel>(context, listen: false);
                      authViewModel.email = emailController.text;
                      print("omar ${emailController.text}");
                      HttpRequest.get(
                              "/user/sendotp?email=${emailController.text}"
                              //"email": emailController.text,
                              )
                          .then((res) {
                        print("the result correct ${res.body}");
                        if (res.statusCode == 200) {
                          Navigator.pushNamed(context, '/otp_verification');
                        }
                      }).catchError((error) {
                        print("Error: $error");
                      });
                    }
                  },
                  child: const Text('Send Verification Code'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
*/

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import '../features/api/cubit/api_cubit.dart';
import '../view_models/auth_view_model.dart';

class EmailVerificationView extends StatefulWidget {
  const EmailVerificationView({Key? key}) : super(key: key);

  @override
  EmailVerificationViewState createState() => EmailVerificationViewState();
}

class EmailVerificationViewState extends State<EmailVerificationView> {
  final formKey = GlobalKey<FormState>();
  final emailController = TextEditingController();

  @override
  void dispose() {
    emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Email Verification'),
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Colors.purple[700]!, Colors.blue[500]!],
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          // BlocConsumer handles both listening to state changes and building UI
          child: BlocConsumer<ApiCubit, ApiState>(
            // Backend Response Handler
            listener: (context, state) {
              state.when(
                unverified: () {},
                initial: () {},
                loading: () {},
                // Handle successful API response
                success: (data) {
                  // Navigate to OTP verification on successful email submission
                  Navigator.pushNamed(context, '/otp_verification');
                },
                // Handle API errors
                error: (error) {
                  // Show error message to user
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Error: ${error.message}'),
                      backgroundColor: Colors.red,
                    ),
                  );
                },
              );
            },
            // UI Builder
            builder: (context, state) {
              return Form(
                key: formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Email Input Field
                    TextFormField(
                      controller: emailController,
                      decoration: InputDecoration(
                        labelText: 'Email',
                        filled: true,
                        fillColor: Colors.white.withOpacity(0.7),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your email';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 24),
                    // Conditional rendering based on API state
                    state.maybeWhen(
                      // Show loading indicator during API call
                      loading: () => const CircularProgressIndicator(
                        color: Colors.white,
                      ),
                      // Show submit button when not loading
                      orElse: () => ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          foregroundColor: Colors.purple[700],
                          backgroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 50,
                            vertical: 15,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                        ),
                        onPressed: () {
                          if (formKey.currentState!.validate()) {
                            // Store email in AuthViewModel
                            final authViewModel = Provider.of<AuthViewModel>(
                              context,
                              listen: false,
                            );
                            authViewModel.email = emailController.text;

                            // BACKEND CONNECTION: Send email verification request
                            // This makes a Post request to the backend API
                            context.read<ApiCubit>().makePostRequest(
                                  '/user/sendotp?email=${emailController.text}',{}
                                );
                          }
                        },
                        child: const Text('Send Verification Code'),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
