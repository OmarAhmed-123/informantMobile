/*
//the old version not include the connection by stat mangement and add animation

// ignore_for_file: unused_import, use_super_parameters, library_private_types_in_public_api, unused_local_variable, unused_element, dead_code, avoid_print, empty_statements

import 'package:flutter/material.dart';
import 'package:graduation___part1/views/httpCodeG.dart';
import 'package:graduation___part1/views/autoLogin.dart';
import 'package:provider/provider.dart';
import '../view_models/auth_view_model.dart';

class OtpVerificationView extends StatefulWidget {
  const OtpVerificationView({Key? key}) : super(key: key);
  @override
  otpVerificationViewS createState() => otpVerificationViewS();
}

class otpVerificationViewS extends State<OtpVerificationView> {
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
                      final authViewModel =
                          Provider.of<AuthViewModel>(context, listen: false);
                      String name = authViewModel.username!;
                      String pass = authViewModel.password!;
                      String email = authViewModel.email!;
                      String otp = otpControllers
                          .map((controller) => controller.text)
                          .join();
                      var response = HttpRequest.post({
                        "endPoint": "/user/verify",
                        "otp": otp,
                        "email": "${authViewModel.email}"
                      }).then((res) {
                        if (res.statusCode == 200) {
                          print('Entered OTP: $otp');
                          AutoLogin.saveData(name, pass, email);
                          Navigator.pushReplacementNamed(context, '/home');
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
// ignore_for_file: library_private_types_in_public_api
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:graduation___part1/views/otp_feature/presentation/views_models/otp_cubit/otp_cubit.dart';
import 'package:graduation___part1/views/otp_feature/presentation/views_models/otp_cubit/otp_cubit_states.dart';
import 'package:provider/provider.dart';
import '../../../../view_models/auth_view_model.dart';
import '../../../../features/api/cubit/api_cubit.dart';
import '../../../autoLogin.dart';

class OtpVerificationView extends StatefulWidget {
  const OtpVerificationView({super.key});

  @override
  State<OtpVerificationView> createState() => _OtpVerificationViewState();
}

class _OtpVerificationViewState extends State<OtpVerificationView>
    with SingleTickerProviderStateMixin {
  final formKey = GlobalKey<FormState>();
  final List<TextEditingController> otpControllers =
      List.generate(9, (_) => TextEditingController());

  // Animation controllers
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<double> _slideAnimation;
  final List<Animation<double>> _digitAnimations = [];

  @override
  void initState() {
    super.initState();
    _initializeAnimations();
    _sendInitialOtp();
  }

  /// Initialize all animations for the view
  void _initializeAnimations() {
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: const Interval(0.0, 0.5, curve: Curves.easeIn),
      ),
    );

    _slideAnimation = Tween<double>(begin: 50.0, end: 0.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: const Interval(0.3, 0.8, curve: Curves.easeOut),
      ),
    );

    // Create staggered animations for each digit field
    for (int i = 0; i < 9; i++) {
      _digitAnimations.add(
        Tween<double>(begin: 0.0, end: 1.0).animate(
          CurvedAnimation(
            parent: _animationController,
            curve: Interval(
              0.1 * i,
              0.1 * i + 0.6,
              curve: Curves.elasticOut,
            ),
          ),
        ),
      );
    }

    _animationController.forward();
  }

  /// Send initial OTP request
  void _sendInitialOtp() {
    final authViewModel = Provider.of<AuthViewModel>(context, listen: false);
    context.read<ApiCubit>().makePostRequest(
      'user/verfiy',
      {
        'email': authViewModel.email,
      },
    );
  }

  /// Handle OTP verification
  void _verifyOtp() {
    if (formKey.currentState!.validate()) {
      final authViewModel = Provider.of<AuthViewModel>(context, listen: false);
      String otp = otpControllers.map((controller) => controller.text).join();

      context.read<ApiCubit>().makePostRequest(
          '/user/verify', {'otp': otp, 'email': authViewModel.email});
    }
  }

  /// Handle OTP resend
  void _resendOtp() {
    final authViewModel = Provider.of<AuthViewModel>(context, listen: false);
    context.read<ApiCubit>().makePostRequest(
      '/user/sendotp',
      {
        'email': authViewModel.email,
      },
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    for (var controller in otpControllers) {
      controller.dispose();
    }
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
        title: FadeTransition(
          opacity: _fadeAnimation,
          child: const Text('OTP Verification'),
        ),
      ),
      body: BlocListener<ApiCubit, ApiState>(
        listener: (context, state) {
          state.whenOrNull(
            success: (data) {
              if (data['message'] == 'OTP verified successfully') {
                AutoLogin.saveData(
                  authViewModel.username!,
                  authViewModel.password!,
                  authViewModel.email!,
                );
                Navigator.pushReplacementNamed(context, '/home');
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
              stops: const [0.3, 0.7],
            ),
          ),
          child: AnimatedBuilder(
            animation: _slideAnimation,
            builder: (context, child) {
              return Transform.translate(
                offset: Offset(0, _slideAnimation.value),
                child: child,
              );
            },
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Form(
                key: formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    FadeTransition(
                      opacity: _fadeAnimation,
                      child: const Text(
                        'Enter the 9-digit code sent to your email',
                        style: TextStyle(
                          fontSize: 18,
                          color: Colors.white,
                          fontWeight: FontWeight.w500,
                          letterSpacing: 0.5,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    const SizedBox(height: 32),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: List.generate(
                        9,
                        (index) => ScaleTransition(
                          scale: _digitAnimations[index],
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
                      create: (context) => OtpCubit(),
                      child: BlocConsumer<OtpCubit, OtpCubitStates>(
                        listener: (context, state) {
                          if (state is OtpSuccessState) {
                            // Navigate to OTP verification page on successful registration
                            Navigator.pushReplacementNamed(
                                context, '/home');
                            print("Verification successful");
                          } else if (state is OtpErrorState) {
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
                                  OtpCubit.get(context)
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
                    const SizedBox(height: 20),
                    FadeTransition(
                      opacity: _fadeAnimation,
                      child: TextButton(
                        onPressed: _resendOtp,
                        style: TextButton.styleFrom(
                          foregroundColor: Colors.white70,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 30,
                            vertical: 10,
                          ),
                        ),
                        child: const Text(
                          'Resend OTP',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
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
import 'package:graduation___part1/views/otp_feature/animations/fade_scale_animation.dart';
import 'package:graduation___part1/views/otp_feature/presentation/views_models/otp_verification_view_model.dart';
import 'package:provider/provider.dart';
import 'widgets/otp_digit_field.dart';
import 'widgets/verify_button.dart';
import 'widgets/resend_button.dart';

class OtpVerificationView extends StatefulWidget {
  const OtpVerificationView({Key? key}) : super(key: key);

  @override
  State<OtpVerificationView> createState() => _OtpVerificationViewState();
}

class _OtpVerificationViewState extends State<OtpVerificationView>
    with SingleTickerProviderStateMixin {
  late OtpVerificationViewModel _viewModel;

  @override
  void initState() {
    super.initState();
    _viewModel = OtpVerificationViewModel();
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
          title: FadeTransition(
            opacity: _viewModel.fadeAnimation,
            child: const Text('OTP Verification'),
          ),
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
            slideAnimation: _viewModel.slideAnimation,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Form(
                key: _viewModel.formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    FadeTransition(
                      opacity: _viewModel.fadeAnimation,
                      child: const Text(
                        'Enter the 9-digit code sent to your email',
                        style: TextStyle(
                          fontSize: 18,
                          color: Colors.white,
                          fontWeight: FontWeight.w500,
                          letterSpacing: 0.5,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    const SizedBox(height: 32),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: List.generate(
                        9,
                        (index) => OtpDigitField(
                          controller: _viewModel.otpControllers[index],
                          animation: _viewModel.digitAnimations[index],
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
                      onPressed: () {
                        if (_viewModel.formKey.currentState!.validate()) {
                          // Add your verification logic here
                        }
                      },
                    ),
                    const SizedBox(height: 20),
                    ResendButton(
                      animation: _viewModel.fadeAnimation,
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
