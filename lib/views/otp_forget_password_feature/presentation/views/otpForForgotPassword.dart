/*
//the old version not include the connection by state mangement
// ignore_for_file: file_names, unused_local_variable

import 'package:flutter/material.dart';
import 'package:graduation___part1/views/httpCodeG.dart';
import 'package:provider/provider.dart';
import '../view_models/auth_view_model.dart';

class OtpForForgotPassword extends StatefulWidget {
  const OtpForForgotPassword({Key? key}) : super(key: key);
  @override
  otpVerificationViewS createState() => otpVerificationViewS();
}

class otpVerificationViewS extends State<OtpForForgotPassword> {
  final formKey = GlobalKey<FormState>();
  final List<TextEditingController> otpControllers =
      List.generate(9, (_) => TextEditingController());

  @override
  void dispose() {
    for (var controller in otpControllers) {
      controller.dispose();
    }
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    final authViewModel = Provider.of<AuthViewModel>(context, listen: false);
    HttpRequest.get("/user/sendotp?email=${authViewModel.email}");
  }

  @override
  Widget build(BuildContext context) {
    final authViewModel = Provider.of<AuthViewModel>(context, listen: false);

    return Scaffold(
      appBar: AppBar(
        title: const Text('OTP Verification'),
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
                const Text(
                  'Enter the 9-digit code sent to your email',
                  style: TextStyle(fontSize: 18, color: Colors.white),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 24),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: List.generate(
                    9,
                    (index) => SizedBox(
                      width: 40,
                      child: TextFormField(
                        controller: otpControllers[index],
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: Colors.white.withOpacity(0.7),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        keyboardType: TextInputType.number,
                        textAlign: TextAlign.center,
                        maxLength: 1,
                        onChanged: (value) {
                          if (value.isNotEmpty && index < 8) {
                            FocusScope.of(context).nextFocus();
                          }
                        },
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return '';
                          }
                          return null;
                        },
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 32),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: Colors.purple.shade800,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 50, vertical: 15),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                  onPressed: () {
                    if (formKey.currentState!.validate()) {
                      String otp = otpControllers
                          .map((controller) => controller.text)
                          .join();
                      var response = HttpRequest.post({
                        "endPoint": "/user/verify",
                        "otp": otp,
                        "email": authViewModel.email
                      }).then((res) {
                        if (res.statusCode == 200) {
                          print('Entered OTP: $otp');
                          Navigator.pushReplacementNamed(context, 'forgot');
                        }
                      });
                    }
                  },
                  child: const Text('Verify', style: TextStyle(fontSize: 18)),
                ),
                const SizedBox(height: 16),
                TextButton(
                  onPressed: () {
                    HttpRequest.get(
                            "/user/sendotp?email=${authViewModel.email}")
                        .then((res) {
                      if (res.statusCode == 200) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('OTP is resent!')),
                        );
                      }
                    });
                  },
                  child: const Text('Resend OTP',
                      style: TextStyle(color: Colors.white70)),
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
/*
// ignore_for_file: file_names
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:graduation___part1/views/otp_forget_password_feature/presentation/views_models/otp_forget_password_cubit/otp_forget_password_cubit.dart';
import 'package:graduation___part1/views/otp_forget_password_feature/presentation/views_models/otp_forget_password_cubit/otp_forget_password_cubit_states.dart';
import 'package:provider/provider.dart';
import '../../../../view_models/auth_view_model.dart';
import '../../../../features/api/cubit/api_cubit.dart';

class OtpForForgotPassword extends StatefulWidget {
  const OtpForForgotPassword({Key? key}) : super(key: key);
  @override
  State<OtpForForgotPassword> createState() => _OtpForForgotPasswordState();
}

class _OtpForForgotPasswordState extends State<OtpForForgotPassword>
    with SingleTickerProviderStateMixin {
  final formKey = GlobalKey<FormState>();
  final List<TextEditingController> otpControllers =
      List.generate(9, (_) => TextEditingController());

  // Animation controllers
  late AnimationController _fadeController;
  late Animation<double> _fadeAnimation;
  final List<Animation<double>> _scaleAnimations = [];

  @override
  void initState() {
    super.initState();
    _initializeAnimations();
    // _sendInitialOtp();
  }

  /// Initialize animations for the view
  void _initializeAnimations() {
    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _fadeController, curve: Curves.easeIn),
    );

    // Create individual scale animations for each OTP field
    for (int i = 0; i < 9; i++) {
      _scaleAnimations.add(
        Tween<double>(begin: 0.0, end: 1.0).animate(
          CurvedAnimation(
            parent: _fadeController,
            curve: Interval(
              0.1 * i, // Stagger the animations
              0.1 * i + 0.5,
              curve: Curves.elasticOut,
            ),
          ),
        ),
      );
    }

    _fadeController.forward();
  }

  /// Send initial OTP request
  // void _sendInitialOtp() {
  //   final authViewModel = Provider.of<AuthViewModel>(context, listen: false);
  //   context
  //       .read<ApiCubit>()
  //       .makePostRequest('/user/sendotp?email=${authViewModel.email}', {});
  // }

  /// Handle OTP verification
  // void _verifyOtp() {
  //   if (formKey.currentState!.validate()) {
  //     final authViewModel = Provider.of<AuthViewModel>(context, listen: false);
  //     String otp = otpControllers.map((controller) => controller.text).join();

  //     context.read<ApiCubit>().makePostRequest(
  //         '/user/verify', {'otp': otp, 'email': authViewModel.email});
  //   }
  // }

  /// Handle OTP resend
  void _resendOtp() {
    final authViewModel = Provider.of<AuthViewModel>(context, listen: false);
    context
        .read<ApiCubit>()
        .makePostRequest('user/sendotp?email=${authViewModel.email}', {});
  }

  @override
  void dispose() {
    for (var controller in otpControllers) {
      controller.dispose();
    }
    _fadeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final authViewModel = Provider.of<AuthViewModel>(context, listen: false);
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text('OTP Verification'),
      ),
      body: BlocListener<ApiCubit, ApiState>(
        listener: (context, state) {
          state.whenOrNull(
            success: (data) {
              if (data['message'] == 'OTP verified successfully') {
                Navigator.pushReplacementNamed(context, 'forgot');
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('OTP sent successfully!')),
                );
              }
            },
            error: (error) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(error.message)),
              );
            },
          );
        },
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [Colors.purple[700]!, Colors.blue[500]!],
            ),
          ),
          child: FadeTransition(
            opacity: _fadeAnimation,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Form(
                key: formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    TweenAnimationBuilder<double>(
                      tween: Tween(begin: 0.0, end: 1.0),
                      duration: const Duration(milliseconds: 800),
                      builder: (context, value, child) {
                        return Transform.scale(
                          scale: value,
                          child: child,
                        );
                      },
                      child: const Text(
                        'Enter the 9-digit code sent to your email',
                        style: TextStyle(
                          fontSize: 18,
                          color: Colors.white,
                          fontWeight: FontWeight.w500,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    const SizedBox(height: 24),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: List.generate(
                        9,
                        (index) => ScaleTransition(
                          scale: _scaleAnimations[index],
                          child: SizedBox(
                            width: 40,
                            child: TextFormField(
                              controller: otpControllers[index],
                              decoration: InputDecoration(
                                filled: true,
                                fillColor: Colors.white.withOpacity(0.9),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                  borderSide: BorderSide.none,
                                ),
                                counterText: '',
                                errorStyle: const TextStyle(height: 0),
                              ),
                              keyboardType: TextInputType.number,
                              textAlign: TextAlign.center,
                              maxLength: 1,
                              style: const TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                              onChanged: (value) {
                                if (value.isNotEmpty && index < 8) {
                                  FocusScope.of(context).nextFocus();
                                }
                              },
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return '';
                                }
                                return null;
                              },
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 40),
                    BlocProvider(
                      create: (context) => OtpPasswordCubit(),
                      child: BlocConsumer<OtpPasswordCubit,
                          OtpPasswordCubitStates>(
                        listener: (context, state) {
                          if (state is OtpPasswordSuccessState) {
                            Navigator.pushReplacementNamed(context, '/forgot');
                            print("Verification successful");
                          } else if (state is OtpPasswordErrorState) {
                            print("Verification failed: ${state.errorMsg}");
                          }
                        },
                        builder: (context, state) {
                          return ScaleTransition(
                            scale: _fadeAnimation,
                            child: SizedBox(
                              width: double.infinity,
                              height: 55,
                              child: ElevatedButton(
                                onPressed: () {
                                  String otp = otpControllers
                                      .map((controller) => controller.text)
                                      .join();
                                  // Trigger the OTP verification process
                                  OtpPasswordCubit.get(context)
                                      .otpVerify(authViewModel.email!, otp);
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.white,
                                  foregroundColor: Colors.purple[700],
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(16),
                                  ),
                                  elevation: 5,
                                ),
                                child: const Text(
                                  'Verify',
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                    const SizedBox(height: 16),
                    TweenAnimationBuilder<double>(
                      tween: Tween(begin: 0.0, end: 1.0),
                      duration: const Duration(milliseconds: 800),
                      builder: (context, value, child) {
                        return Opacity(
                          opacity: value,
                          child: child,
                        );
                      },
                      child: TextButton(
                        onPressed: _resendOtp,
                        child: const Text(
                          'Resend OTP',
                          style: TextStyle(
                            color: Colors.white70,
                            fontSize: 16,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
*/


import 'package:flutter/material.dart';
import 'package:graduation___part1/views/otp_forget_password_feature/animations/fade_scale_animation.dart';
import 'package:provider/provider.dart';
import '../views_models/otp_forgot_password_view_model.dart';
import 'widgets/otp_digit_field.dart';
import 'widgets/verify_button.dart';
import 'widgets/resend_button.dart';

class OtpForgotPasswordView extends StatefulWidget {
  const OtpForgotPasswordView({Key? key}) : super(key: key);

  @override
  State<OtpForgotPasswordView> createState() => _OtpForgotPasswordViewState();
}

class _OtpForgotPasswordViewState extends State<OtpForgotPasswordView>
    with SingleTickerProviderStateMixin {
  late OtpForgotPasswordViewModel _viewModel;

  @override
  void initState() {
    super.initState();
    _viewModel = OtpForgotPasswordViewModel();
    _viewModel.initializeAnimations(this);
  }

  @override
  void dispose() {
    _viewModel.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
      value: _viewModel,
      child: Scaffold(
        extendBodyBehindAppBar: true,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          title: const Text('OTP Verification'),
        ),
        body: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [Colors.purple[700]!, Colors.blue[500]!],
            ),
          ),
          child: FadeScaleAnimation(
            fadeAnimation: _viewModel.fadeAnimation,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Form(
                key: _viewModel.formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      'Enter the 9-digit code sent to your email',
                      style: TextStyle(
                        fontSize: 18,
                        color: Colors.white,
                        fontWeight: FontWeight.w500,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 24),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: List.generate(
                        9,
                        (index) => OtpDigitField(
                          controller: _viewModel.otpControllers[index],
                          animation: _viewModel.scaleAnimations[index],
                          onChanged: (value) {
                            if (value.isNotEmpty && index < 8) {
                              FocusScope.of(context).nextFocus();
                            }
                          },
                          validator: _viewModel.validateOtpDigit,
                        ),
                      ),
                    ),
                    const SizedBox(height: 40),
                    VerifyButton(
                      animation: _viewModel.fadeAnimation,
                      email: 'user@example.com', // Replace with actual email
                    ),
                    const SizedBox(height: 16),
                    ResendButton(
                      onPressed: () {
                        // Add your resend logic here
                      },
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
