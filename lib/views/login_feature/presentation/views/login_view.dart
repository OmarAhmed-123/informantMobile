/*
//the old version
// ignore_for_file: library_private_types_in_public_api, use_build_context_synchronously, sort_child_properties_last, prefer_const_constructors, depend_on_referenced_packages
import 'package:flutter/material.dart';
import 'package:graduation___part1/views/httpCodeG.dart';
import 'home_view.dart';
import 'register_view.dart';
import 'package:graduation___part1/views/autoLogin.dart';
import '../view_models/auth_view_model.dart';
import 'email_verification_view.dart';
import 'package:provider/provider.dart';

class LoginView extends StatefulWidget {
  const LoginView({super.key});

  @override
  loginViewSt createState() => loginViewSt();
}

class loginViewSt extends State<LoginView> with SingleTickerProviderStateMixin {
  final formKey = GlobalKey<FormState>();
  final emailController = TextEditingController();
  //final usernameController = TextEditingController();
  final passwordController = TextEditingController();
  late AnimationController animationController;
  late Animation<double> fadeAnimation;
  bool visiblePassword2 = false;

  @override
  void initState() {
    super.initState();
    animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    );
    fadeAnimation =
        Tween<double>(begin: 0.0, end: 1.0).animate(animationController);
    animationController.forward();
  }

  @override
  void dispose() {
    animationController.dispose();
    emailController.dispose();
    passwordController.dispose();
    //usernameController.dispose();
    super.dispose();
  }

  Future<void> loginFun() async {
    if (formKey.currentState!.validate()) {
      final authViewModel = Provider.of<AuthViewModel>(context, listen: false);
      HttpRequest.post({
        "endPoint": "/user/login",
        "username": emailController.text,
        "password": passwordController.text,
        //"userName": usernameController.text,
      }).then((res) => {
            if (res.statusCode == 200)
              {
                if ((emailController.text).contains('@'))
                  {
                    AutoLogin.saveData(
                        "", passwordController.text, emailController.text)
                  }
                else
                  {
                    AutoLogin.saveData(
                        emailController.text, passwordController.text, "")
                  },
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Login successful!')),
                ),
                Navigator.pushReplacement(context,
                    MaterialPageRoute(builder: (context) => const HomeView()))
              }
            else if (res.statusCode == 204)
              {
                //authViewModel.username = usernameController.text,
                authViewModel.password = passwordController.text,
                authViewModel.email = emailController.text,
                authViewModel.flag = 2,
                Navigator.pushReplacementNamed(context, '/email_verification'),
              }
            else
              {
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                    content: Text('Error: Status Code ${res.statusCode}')))
              }
          });
    }
  }

  Future<void> loginWithoutBE() async {
    AutoLogin.saveData(emailController.text, passwordController.text, "");
    AutoLogin.saveData("", passwordController.text, emailController.text);

    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (context) => const HomeView()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FadeTransition(
        opacity: fadeAnimation,
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [Colors.purple[700]!, Colors.blue[500]!],
            ),
          ),
          child: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Form(
                key: formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset(
                      'assets/login1.png',
                      width: 150,
                      height: 150,
                    ),
                    const SizedBox(height: 32),
                    const Text(
                      'Login',
                      style: TextStyle(
                          fontSize: 32,
                          fontWeight: FontWeight.bold,
                          color: Colors.white),
                    ),
                    const SizedBox(height: 32),
                    TextFormField(
                      controller: emailController,
                      decoration: InputDecoration(
                        hintText: 'Enter your username',
                        filled: true,
                        fillColor: Colors.white.withOpacity(0.7),
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12)),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your username';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: passwordController,
                      obscureText: !visiblePassword2,
                      decoration: InputDecoration(
                        labelText: 'Password',
                        filled: true,
                        fillColor: Colors.white.withOpacity(0.7),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        suffixIcon: IconButton(
                          icon: Icon(
                            visiblePassword2
                                ? Icons.visibility
                                : Icons.visibility_off,
                          ),
                          onPressed: () {
                            setState(() {
                              visiblePassword2 = !visiblePassword2;
                            });
                          },
                        ),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter a password';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 24),
                    ElevatedButton(
                      onPressed: loginFun,
                      //loginWithoutBE, //for omar to change between the connection
                      child: const Text('Sign In'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 50, vertical: 15),
                      ),
                    ),
                    const SizedBox(height: 16),
                    TextButton(
                      onPressed: () {
                        final authViewModel =
                            Provider.of<AuthViewModel>(context, listen: false);
                        authViewModel.flag = 1;
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  const EmailVerificationView()),
                        );
                      },
                      child: const Text('Forgot password?',
                          style: TextStyle(color: Colors.white)),
                    ),
                    const SizedBox(height: 16),
                    TextButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => RegisterView()),
                        );
                      },
                      child: const Text("Don't have an account? Sign up",
                          style: TextStyle(color: Colors.white70)),
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

/*
//this code include the connection by state mangement 
// ignore_for_file: library_private_types_in_public_api, use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:graduation___part1/views/autoLogin.dart';
import 'package:provider/provider.dart';

// Feature imports
import '../features/api/cubit/api_cubit.dart';
import '../view_models/auth_view_model.dart';
import 'email_verification_view.dart';
import 'home_view.dart';
import 'register_view.dart';

class LoginView extends StatefulWidget {
  const LoginView({super.key});

  @override
  LoginViewState createState() => LoginViewState();
}

class LoginViewState extends State<LoginView>
    with SingleTickerProviderStateMixin {
  // Form controllers and key
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  // Animation controllers
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;

  // UI state
  bool _isPasswordVisible = false;

  @override
  void initState() {
    super.initState();
    _initializeAnimation();
  }

  /// Initialize the fade animation
  void _initializeAnimation() {
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    );
    _fadeAnimation =
        Tween<double>(begin: 0.0, end: 1.0).animate(_animationController);
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  /// Handle successful login
  void _handleLoginSuccess(dynamic data) async {
    final email = _emailController.text;
    final password = _passwordController.text;

    // Save login credentials based on input type
    if (email.contains('@')) {
      await AutoLogin.saveData("", password, email);
    } else {
      await AutoLogin.saveData(email, password, "");
    }

    // Show success message and navigate to home
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Login successful!')),
    );
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const HomeView()),
    );
  }

  /// Handle unverified user case
  void _handleUnverifiedUser() {
    final authViewModel = Provider.of<AuthViewModel>(context, listen: false);
    authViewModel.password = _passwordController.text;
    authViewModel.email = _emailController.text;
    authViewModel.flag = 2;
    Navigator.pushReplacementNamed(context, '/email_verification');
  }

  /// Attempt login with provided credentials
  void _login() {
    if (_formKey.currentState!.validate()) {
      // BACKEND CONNECTION: Send login request
      context.read<ApiCubit>().makePostRequest(
        '/user/login',
        {
          "username": _emailController.text,
          "password": _passwordController.text,
        },
      );
    }
  }

  /// Navigate to forgot password flow
  void _navigateToForgotPassword() {
    final authViewModel = Provider.of<AuthViewModel>(context, listen: false);
    authViewModel.flag = 1;
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const EmailVerificationView()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocConsumer<ApiCubit, ApiState>(
        listener: (context, state) {
          state.when(
            initial: () {},
            loading: () {},
            success: (data) => _handleLoginSuccess(data),
            error: (error) {
              // Handle unverified user case
              if (error.statusCode == 204) {
                _handleUnverifiedUser();
                return;
              }
              // Show error message
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Error: ${error.message}')),
              );
            },
          );
        },
        builder: (context, state) {
          return FadeTransition(
            opacity: _fadeAnimation,
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [Colors.purple[700]!, Colors.blue[500]!],
                ),
              ),
              child: Center(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(16),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // Logo
                        Image.asset(
                          'assets/login1.png',
                          width: 150,
                          height: 150,
                        ),
                        const SizedBox(height: 32),

                        // Title
                        const Text(
                          'Login',
                          style: TextStyle(
                            fontSize: 32,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(height: 32),

                        // Email/Username Field
                        TextFormField(
                          controller: _emailController,
                          decoration: InputDecoration(
                            hintText: 'Enter your username',
                            filled: true,
                            fillColor: Colors.white.withOpacity(0.7),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter your username';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 16),

                        // Password Field
                        TextFormField(
                          controller: _passwordController,
                          obscureText: !_isPasswordVisible,
                          decoration: InputDecoration(
                            labelText: 'Password',
                            filled: true,
                            fillColor: Colors.white.withOpacity(0.7),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            suffixIcon: IconButton(
                              icon: Icon(
                                _isPasswordVisible
                                    ? Icons.visibility
                                    : Icons.visibility_off,
                              ),
                              onPressed: () {
                                setState(() {
                                  _isPasswordVisible = !_isPasswordVisible;
                                });
                              },
                            ),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter a password';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 24),

                        // Login Button
                        state.maybeWhen(
                          loading: () => const CircularProgressIndicator(
                            color: Colors.white,
                          ),
                          orElse: () => ElevatedButton(
                            onPressed: _login,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(
                                horizontal: 50,
                                vertical: 15,
                              ),
                            ),
                            child: const Text('Sign In'),
                          ),
                        ),
                        const SizedBox(height: 16),

                        // Forgot Password Button
                        TextButton(
                          onPressed: _navigateToForgotPassword,
                          child: const Text(
                            'Forgot password?',
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                        const SizedBox(height: 16),

                        // Register Button
                        TextButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const RegisterView(),
                              ),
                            );
                          },
                          child: const Text(
                            "Don't have an account? Sign up",
                            style: TextStyle(color: Colors.white70),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
*/

/*
// ignore_for_file: library_private_types_in_public_api, use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:graduation___part1/views/autoLogin.dart';
import 'package:provider/provider.dart';
import 'dart:math' as math;

import '../features/api/cubit/api_cubit.dart';
import '../view_models/auth_view_model.dart';
import 'email_verification_view.dart';
import 'home_view.dart';
import 'register_view.dart';

class LoginView extends StatefulWidget {
  const LoginView({super.key});

  @override
  LoginViewState createState() => LoginViewState();
}

class LoginViewState extends State<LoginView> with TickerProviderStateMixin {
  // Form controllers and key
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  // Animation controllers
  late AnimationController _fadeController;
  late AnimationController _slideController;
  late AnimationController _scaleController;
  late AnimationController _rotateController;

  // Animations
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;
  late Animation<double> _scaleAnimation;
  late Animation<double> _rotateAnimation;

  // UI state
  bool _isPasswordVisible = false;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _initializeAnimations();
  }

  /// Initialize all animations
  void _initializeAnimations() {
    // Fade animation
    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _fadeController, curve: Curves.easeIn),
    );

    // Slide animation
    _slideController = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );
    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.5),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _slideController,
      curve: Curves.elasticOut,
    ));

    // Scale animation
    _scaleController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    _scaleAnimation = Tween<double>(begin: 0.8, end: 1.0).animate(
      CurvedAnimation(parent: _scaleController, curve: Curves.easeOutBack),
    );

    // Rotate animation for logo
    _rotateController = AnimationController(
      duration: const Duration(seconds: 20),
      vsync: this,
    );
    _rotateAnimation = Tween<double>(
      begin: 0,
      end: 2 * math.pi,
    ).animate(_rotateController);

    // Start animations
    _fadeController.forward();
    _slideController.forward();
    _scaleController.forward();
    _rotateController.repeat();
  }

  @override
  void dispose() {
    _fadeController.dispose();
    _slideController.dispose();
    _scaleController.dispose();
    _rotateController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  /// Handle successful login
  Future<void> _handleLoginSuccess(dynamic data) async {
    setState(() => _isLoading = false);

    final email = _emailController.text;
    final password = _passwordController.text;

    // Save credentials
    if (email.contains('@')) {
      await AutoLogin.saveData("", password, email);
    } else {
      await AutoLogin.saveData(email, password, "");
    }

    // Show success animation and navigate
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Login successful!'),
        backgroundColor: Colors.green,
      ),
    );

    // Navigate with fade transition
    await Future.delayed(const Duration(milliseconds: 500));
    if (!mounted) return;

    Navigator.pushReplacement(
      context,
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) =>
            const HomeView(),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          return FadeTransition(opacity: animation, child: child);
        },
        transitionDuration: const Duration(milliseconds: 800),
      ),
    );
  }

  /// Handle unverified user case
  void _handleUnverifiedUser() {
    setState(() => _isLoading = false);
    final authViewModel = Provider.of<AuthViewModel>(context, listen: false);
    authViewModel.password = _passwordController.text;
    authViewModel.email = _emailController.text;
    authViewModel.flag = 2;
    Navigator.pushReplacementNamed(context, '/email_verification');
  }

/*
  Future<void> loginFun() async {
    if (formKey.currentState!.validate()) {
      final authViewModel = Provider.of<AuthViewModel>(context, listen: false);
      HttpRequest.post({
        "endPoint": "/user/login",
        "username": emailController.text,
        "password": passwordController.text,
        //"userName": usernameController.text,
      }).then((res) => {
            if (res.statusCode == 200)
              {
                if ((emailController.text).contains('@'))
                  {
                    AutoLogin.saveData(
                        "", passwordController.text, emailController.text)
                  }
                else
                  {
                    AutoLogin.saveData(
                        emailController.text, passwordController.text, "")
                  },
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Login successful!')),
                ),
                Navigator.pushReplacement(context,
                    MaterialPageRoute(builder: (context) => const HomeView()))
              }
            else if (res.statusCode == 204)
              {
                //authViewModel.username = usernameController.text,
                authViewModel.password = passwordController.text,
                authViewModel.email = emailController.text,
                authViewModel.flag = 2,
                Navigator.pushReplacementNamed(context, '/email_verification'),
              }
            else
              {
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                    content: Text('Error: Status Code ${res.statusCode}')))
              }
          });
    }
  }


*/

  /// Attempt login
  void _login() {
    if (_formKey.currentState!.validate()) {
      setState(() => _isLoading = true);
      context.read<ApiCubit>().makePostRequest(
        '/user/login',
        {
          "username": _emailController.text,
          "password": _passwordController.text,
        },
        /*
        authViewModel.password = _passwordController.text;
    authViewModel.email = _emailController.text;
    authViewModel.flag = 2;
        */
      )
          /*.then((res) => {
             _handleLoginSuccess(data),
              }
     ) ;    */
          ;
    }
  }

  /// Build a custom input field
  Widget _buildInputField({
    required TextEditingController controller,
    required String label,
    bool isPassword = false,
    String? Function(String?)? validator,
  }) {
    return ScaleTransition(
      scale: _scaleAnimation,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 10,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: TextFormField(
          controller: controller,
          obscureText: isPassword && !_isPasswordVisible,
          decoration: InputDecoration(
            labelText: label,
            filled: true,
            fillColor: Colors.white.withOpacity(0.9),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: BorderSide.none,
            ),
            prefixIcon: Icon(
              isPassword ? Icons.lock_outline : Icons.person_outline,
              color: Colors.purple[700],
            ),
            suffixIcon: isPassword
                ? IconButton(
                    icon: Icon(
                      _isPasswordVisible
                          ? Icons.visibility
                          : Icons.visibility_off,
                      color: Colors.purple[700],
                    ),
                    onPressed: () {
                      setState(() {
                        _isPasswordVisible = !_isPasswordVisible;
                      });
                    },
                  )
                : null,
          ),
          validator: validator,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocConsumer<ApiCubit, ApiState>(
        listener: (context, state) {
          state.when(
            initial: () {},
            loading: () {},
            success: (data) => _handleLoginSuccess(data),
            error: (error) {
              setState(() => _isLoading = false);
              if (error.statusCode == 204) {
                _handleUnverifiedUser();
                return;
              }
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Error: ${error.message}'),
                  backgroundColor: Colors.red,
                ),
              );
            },
          );
        },
        builder: (context, state) {
          return Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Colors.purple[900]!,
                  Colors.purple[700]!,
                  Colors.blue[500]!,
                ],
              ),
            ),
            child: FadeTransition(
              opacity: _fadeAnimation,
              child: SlideTransition(
                position: _slideAnimation,
                child: Center(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.all(24),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          // Animated Logo
                          RotationTransition(
                            turns: _rotateAnimation,
                            child: Hero(
                              tag: 'login_logo',
                              child: Image.asset(
                                'assets/login1.png',
                                width: 150,
                                height: 150,
                              ),
                            ),
                          ),
                          const SizedBox(height: 40),

                          // Title with scale animation
                          ScaleTransition(
                            scale: _scaleAnimation,
                            child: const Text(
                              'Welcome Back',
                              style: TextStyle(
                                fontSize: 32,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                                shadows: [
                                  Shadow(
                                    color: Colors.black26,
                                    offset: Offset(0, 3),
                                    blurRadius: 5,
                                  ),
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(height: 40),

                          // Input Fields
                          _buildInputField(
                            controller: _emailController,
                            label: 'Username or Email',
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter your username or email';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 20),

                          _buildInputField(
                            controller: _passwordController,
                            label: 'Password',
                            isPassword: true,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter your password';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 30),

                          // Login Button with loading state
                          ScaleTransition(
                            scale: _scaleAnimation,
                            child: SizedBox(
                              width: double.infinity,
                              height: 55,
                              child: ElevatedButton(
                                onPressed: _isLoading ? null : _login,
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.white,
                                  foregroundColor: Colors.purple[700],
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(16),
                                  ),
                                  elevation: 5,
                                ),
                                child: _isLoading
                                    ? const CircularProgressIndicator()
                                    : const Text(
                                        'Sign In',
                                        style: TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 20),

                          // Additional buttons
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              TextButton(
                                onPressed: () => Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        const EmailVerificationView(),
                                  ),
                                ),
                                child: const Text(
                                  'Forgot Password?',
                                  style: TextStyle(
                                    color: Colors.white70,
                                    fontSize: 16,
                                  ),
                                ),
                              ),
                              TextButton(
                                onPressed: () => Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => const RegisterView(),
                                  ),
                                ),
                                child: const Text(
                                  'Sign Up',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
*/

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:graduation___part1/views/login_feature/presentation/views_models/login_cubit/login_cubit.dart';
import 'package:graduation___part1/views/login_feature/presentation/views_models/login_cubit/login_cubit_states.dart';
import 'package:provider/provider.dart';
import '../../../../features/api/cubit/api_cubit.dart';
import '../../../../view_models/auth_view_model.dart';
import '../../../home_view.dart';
import '../../../register_view.dart';
import '../../../email_verification_view.dart';

class LoginView extends StatefulWidget {
  const LoginView({Key? key}) : super(key: key);

  @override
  LoginViewState createState() => LoginViewState();
}

class LoginViewState extends State<LoginView> with TickerProviderStateMixin {
  // Form controllers
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  // Animation controllers
  late AnimationController _fadeController;
  late AnimationController _slideController;
  late AnimationController _scaleController;
  late AnimationController _rotateController;

  // Animations
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;
  late Animation<double> _scaleAnimation;
  late Animation<double> _rotateAnimation;

  // UI state
  bool _isPasswordVisible = false;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _initializeAnimations();
  }

  /// Initialize all animations
  void _initializeAnimations() {
    // Fade animation setup
    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _fadeController, curve: Curves.easeIn),
    );

    // Slide animation setup
    _slideController = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );
    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.5),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _slideController,
      curve: Curves.elasticOut,
    ));

    // Scale animation setup
    _scaleController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    _scaleAnimation = Tween<double>(begin: 0.8, end: 1.0).animate(
      CurvedAnimation(parent: _scaleController, curve: Curves.easeOutBack),
    );

    // Rotate animation setup
    _rotateController = AnimationController(
      duration: const Duration(seconds: 20),
      vsync: this,
    );
    _rotateAnimation = Tween<double>(begin: 0, end: 2 * 3.14159).animate(
      CurvedAnimation(parent: _rotateController, curve: Curves.linear),
    );

    // Start animations
    _fadeController.forward();
    _slideController.forward();
    _scaleController.forward();
    _rotateController.repeat();
  }

  @override
  void dispose() {
    _fadeController.dispose();
    _slideController.dispose();
    _scaleController.dispose();
    _rotateController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  /// Handle successful login
  void _handleLoginSuccess(dynamic data) {
    setState(() => _isLoading = false);

    // Save auth data
    final authViewModel = Provider.of<AuthViewModel>(context, listen: false);
    authViewModel.email = _emailController.text;
    authViewModel.password = _passwordController.text;

    // Navigate to home
    Navigator.pushReplacement(
      context,
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) =>
            const HomeView(),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          return FadeTransition(opacity: animation, child: child);
        },
      ),
    );
  }

  /// Handle unverified user case
  void _handleUnverifiedUser() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => const EmailVerificationView()),
    );
  }

  /// Attempt login
  void _login() {
    if (_formKey.currentState!.validate()) {
      setState(() => _isLoading = true);
      context.read<ApiCubit>().makePostRequest(
        '/user/login',
        {
          "username": _emailController.text,
          "password": _passwordController.text,
        },
      );
    }
  }

  /// Build a custom input field
  Widget _buildInputField({
    required TextEditingController controller,
    required String label,
    bool isPassword = false,
    String? Function(String?)? validator,
  }) {
    return ScaleTransition(
      scale: _scaleAnimation,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 10,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: TextFormField(
          controller: controller,
          obscureText: isPassword && !_isPasswordVisible,
          decoration: InputDecoration(
            labelText: label,
            filled: true,
            fillColor: Colors.white.withOpacity(0.9),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: BorderSide.none,
            ),
            prefixIcon: Icon(
              isPassword ? Icons.lock_outline : Icons.person_outline,
              color: Colors.purple[700],
            ),
            suffixIcon: isPassword
                ? IconButton(
                    icon: Icon(
                      _isPasswordVisible
                          ? Icons.visibility
                          : Icons.visibility_off,
                      color: Colors.purple[700],
                    ),
                    onPressed: () {
                      setState(() {
                        _isPasswordVisible = !_isPasswordVisible;
                      });
                    },
                  )
                : null,
          ),
          validator: validator,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocConsumer<ApiCubit, ApiState>(
        listener: (context, state) {
          state.when(
            unverified: () {
              Navigator.pushNamed(context, '/email_verification');
            },
            initial: () {},
            loading: () {},
            success: (data) => _handleLoginSuccess(data),
            error: (error) {
              setState(() => _isLoading = false);
              if (error.toString().contains('204')) {
                _handleUnverifiedUser();
                return;
              }
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Error: $error'),
                  backgroundColor: Colors.red,
                ),
              );
            },
          );
        },
        builder: (context, state) {
          return Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Colors.purple[900]!,
                  Colors.purple[700]!,
                  Colors.blue[500]!,
                ],
              ),
            ),
            child: FadeTransition(
              opacity: _fadeAnimation,
              child: SlideTransition(
                position: _slideAnimation,
                child: Center(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.all(24),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          // Animated Logo
                          RotationTransition(
                            turns: _rotateAnimation,
                            child: Hero(
                              tag: 'login_logo',
                              child: Image.asset(
                                'assets/login1.png',
                                width: 150,
                                height: 150,
                              ),
                            ),
                          ),
                          const SizedBox(height: 40),

                          // Title
                          ScaleTransition(
                            scale: _scaleAnimation,
                            child: const Text(
                              'Welcome Back',
                              style: TextStyle(
                                fontSize: 32,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                                shadows: [
                                  Shadow(
                                    color: Colors.black26,
                                    offset: Offset(0, 3),
                                    blurRadius: 5,
                                  ),
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(height: 40),

                          // Input Fields
                          _buildInputField(
                            controller: _emailController,
                            label: 'Email',
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter your email';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 20),

                          _buildInputField(
                            controller: _passwordController,
                            label: 'Password',
                            isPassword: true,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter your password';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 30),

                          // Login Button
                          ScaleTransition(
                            scale: _scaleAnimation,
                            child: SizedBox(
                              width: double.infinity,
                              height: 55,
                              child: BlocProvider(
                                create: (context) => LoginCubit(),
                                child:
                                    BlocConsumer<LoginCubit, LoginCubitStates>(
                                        listener: (context, state) {
                                  if (state is LoginSuccessState) {
                                    //go to home
                                    print("Login successfully");
                                  } else if (state is LoginErrorState) {
                                    if (state.errorMsg
                                        .contains("")) //check the string
                                    {
                                      //go to otp
                                    }
                                  }
                                }, builder: (context, state) {
                                  if (state is LoginLoadingState) {
                                    return const Center(
                                        child: CircularProgressIndicator());
                                  } else {
                                    return ElevatedButton(
                                      onPressed: () async =>
                                          await LoginCubit.get(context)
                                              .userLogin(_emailController.text,
                                                  _passwordController.text),
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: Colors.white,
                                        foregroundColor: Colors.purple[700],
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(16),
                                        ),
                                        elevation: 5,
                                      ),
                                      child: _isLoading
                                          ? const CircularProgressIndicator()
                                          : const Text(
                                              'Sign In',
                                              style: TextStyle(
                                                fontSize: 18,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                    );
                                  }
                                }),
                              ),
                            ),
                          ),
                          const SizedBox(height: 20),

                          // Additional Links
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              TextButton(
                                onPressed: () => Navigator.pushNamed(
                                    context, '/email_verification'),
                                child: const Text(
                                  'Forgot Password?',
                                  style: TextStyle(
                                    color: Colors.white70,
                                    fontSize: 16,
                                  ),
                                ),
                              ),
                              TextButton(
                                onPressed: () => Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) => const RegisterView(),
                                  ),
                                ),
                                child: const Text(
                                  'Sign Up',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
