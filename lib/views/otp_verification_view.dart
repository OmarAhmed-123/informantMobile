import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:graduation___part1/views/auth_cubit.dart';
import 'package:shared_preferences/shared_preferences.dart';

class OtpVerificationView extends StatefulWidget {
  const OtpVerificationView({Key? key}) : super(key: key);

  @override
  OtpVerificationViewState createState() => OtpVerificationViewState();
}

class OtpVerificationViewState extends State<OtpVerificationView>
    with TickerProviderStateMixin {
  final formKey = GlobalKey<FormState>();
  final List<TextEditingController> otpControllers =
      List.generate(9, (_) => TextEditingController());
  final List<FocusNode> focusNodes = List.generate(9, (_) => FocusNode());

  late AnimationController _fadeController;
  late Animation<double> _fadeAnimation;
  late AnimationController _slideController;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();

    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
        CurvedAnimation(parent: _fadeController, curve: Curves.easeIn));
    _slideController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    _slideAnimation =
        Tween<Offset>(begin: const Offset(0, 0.2), end: Offset.zero).animate(
            CurvedAnimation(
                parent: _slideController, curve: Curves.easeOutQuart));
    _fadeController.forward();
    _slideController.forward();

    // Add listeners to controllers for backspace detection
    for (int i = 0; i < 9; i++) {
      otpControllers[i].addListener(() {
        _handleBackspace(i);
      });
    }
  }

  void _handleBackspace(int index) {
    // Get the current text value
    String currentValue = otpControllers[index].text;

    // Check if text was deleted (backspace pressed)
    // This is detected when the controller has an empty value and has focus
    if (currentValue.isEmpty && focusNodes[index].hasFocus) {
      // This is a bit of a hack but works reliably
      // Check if the last operation was a deletion by storing previous lengths
      // If it's a fresh focus, don't move back
      if (index > 0 && !_isInitialFocus) {
        // Move focus to previous field
        focusNodes[index - 1].requestFocus();
      }
    }
  }

  bool _isInitialFocus = false;

  @override
  void dispose() {
    for (var controller in otpControllers) {
      controller.dispose();
    }
    for (var node in focusNodes) {
      node.dispose();
    }
    _fadeController.dispose();
    _slideController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: const Text('Verification',
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 22,
            )),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      extendBodyBehindAppBar: true,
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Colors.black,
              Colors.blue.shade900.withOpacity(0.8),
              Colors.black,
            ],
            stops: const [0.0, 0.5, 1.0],
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
            child: FadeTransition(
              opacity: _fadeAnimation,
              child: SlideTransition(
                position: _slideAnimation,
                child: Form(
                  key: formKey,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(
                        Icons.lock_outline,
                        size: 80,
                        color: Colors.white70,
                      ),
                      const SizedBox(height: 32),
                      const Text(
                        'Enter Verification Code',
                        style: TextStyle(
                          fontSize: 24,
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 16),
                      const Text(
                        'We\'ve sent a 9-digit code to your email',
                        style: TextStyle(fontSize: 16, color: Colors.white70),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 48),
                      _buildOtpFields(),
                      const SizedBox(height: 48),
                      _buildVerifyButton(),
                      const SizedBox(height: 24),
                      _buildResendButton(),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildOtpFields() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Wrap(
        spacing: 8.0,
        runSpacing: 16.0,
        alignment: WrapAlignment.center,
        children: List.generate(
          9,
          (index) => Container(
            width: 40,
            height: 50,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Colors.blue.shade900.withOpacity(0.3),
                  blurRadius: 10,
                  spreadRadius: 1,
                ),
              ],
            ),
            child: TextFormField(
              controller: otpControllers[index],
              focusNode: focusNodes[index],
              decoration: InputDecoration(
                filled: true,
                fillColor: Colors.white.withOpacity(0.1),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: Colors.blue.shade800),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: Colors.blue.shade800),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: Colors.blue.shade400, width: 2),
                ),
                counterText: '',
              ),
              style: const TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
              keyboardType: TextInputType.number,
              textAlign: TextAlign.center,
              maxLength: 1,
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              onChanged: (value) {
                // If a digit is entered, move to next field
                if (value.isNotEmpty && index < 8) {
                  focusNodes[index + 1].requestFocus();
                }
              },
              onTap: () {
                // Mark this as a fresh focus to avoid immediate backward movement
                _isInitialFocus = true;
                // Schedule this to happen after the current frame
                Future.delayed(Duration.zero, () {
                  _isInitialFocus = false;
                });
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
    );
  }

  // Special key handler for text fields
  Widget _buildTextField(int index) {
    return RawKeyboardListener(
      focusNode: FocusNode(),
      onKey: (event) {
        if (event.runtimeType == RawKeyDownEvent &&
            (event.logicalKey == LogicalKeyboardKey.backspace ||
                event.logicalKey == LogicalKeyboardKey.delete)) {
          if (otpControllers[index].text.isEmpty && index > 0) {
            FocusScope.of(context).previousFocus();
          }
        }
      },
      child: TextFormField(
        controller: otpControllers[index],
        // Other properties...
      ),
    );
  }

  Widget _buildVerifyButton() {
    return BlocProvider(
      create: (context) => AuthCubit(),
      child: BlocConsumer<AuthCubit, AuthState>(
        listener: (context, state) async {
          if (state is AuthSuccess) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Verification successful!'),
                backgroundColor: Colors.green,
              ),
            );
            final prefs = await SharedPreferences.getInstance();
            final flag = prefs.getInt("flag");
            if (flag == 1) {
              Navigator.pushReplacementNamed(context, '/forgot');
            } else if (flag == 2) {
              Navigator.pushReplacementNamed(context, '/home');
            }
          } else if (state is AuthFailure) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('Error: ${state.error}'),
                backgroundColor: Colors.red,
              ),
            );
          }
        },
        builder: (context, state) {
          return Container(
            width: double.infinity,
            height: 56,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.blue.shade600, Colors.blue.shade900],
              ),
              borderRadius: BorderRadius.circular(30),
              boxShadow: [
                BoxShadow(
                  color: Colors.blue.shade900.withOpacity(0.5),
                  blurRadius: 10,
                  spreadRadius: 2,
                ),
              ],
            ),
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.transparent,
                shadowColor: Colors.transparent,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
              ),
              onPressed: state is AuthLoading
                  ? null
                  : () async {
                      if (formKey.currentState!.validate()) {
                        SharedPreferences objShared =
                            await SharedPreferences.getInstance();
                        final email = objShared.getString('email');
                        String otp = otpControllers
                            .map((controller) => controller.text)
                            .join();
                        context.read<AuthCubit>().verifyOtp(email!, otp);
                      }
                    },
              child: state is AuthLoading
                  ? const SizedBox(
                      width: 24,
                      height: 24,
                      child: CircularProgressIndicator(
                        color: Colors.white,
                        strokeWidth: 2,
                      ),
                    )
                  : const Text(
                      'Verify Code',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildResendButton() {
    return BlocProvider(
      create: (context) => AuthCubit(),
      child: BlocConsumer<AuthCubit, AuthState>(
        listener: (context, state) {
          if (state is AuthSuccess) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('New code sent to your email'),
                backgroundColor: Colors.green,
              ),
            );
          } else if (state is AuthFailure) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('Error: ${state.error}'),
                backgroundColor: Colors.red,
              ),
            );
          }
        },
        builder: (context, state) {
          return TextButton(
            onPressed: state is AuthLoading
                ? null
                : () async {
                    SharedPreferences prefs =
                        await SharedPreferences.getInstance();
                    final email = prefs.getString('email')!;
                    final flag = prefs.getInt("flag");
                    if (flag == 1) {
                      context.read<AuthCubit>().forgotPassword(context, email);
                    } else if (flag == 2) {
                      context.read<AuthCubit>().sendOtp(email, context);
                    }
                  },
            child: Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                state is AuthLoading
                    ? const SizedBox(
                        width: 16,
                        height: 16,
                        child: CircularProgressIndicator(
                          color: Colors.white70,
                          strokeWidth: 2,
                        ),
                      )
                    : const Icon(Icons.refresh, color: Colors.white70),
                const SizedBox(width: 8),
                const Text(
                  'Resend Code',
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
