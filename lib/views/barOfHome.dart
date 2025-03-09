// barOfHome.dart
import 'package:flutter/material.dart';
import 'package:graduation___part1/views/home_view.dart';
import 'package:provider/provider.dart';
import '../view_models/auth_view_model.dart';
import 'package:graduation___part1/views/ad_list_view.dart' as adView;
import 'package:graduation___part1/views/create_ad_view.dart';
import 'package:graduation___part1/views/Statistics.dart';
import 'package:graduation___part1/views/autoProfile.dart';
import 'package:graduation___part1/views/profile.dart';
import 'package:graduation___part1/views/autoLogin.dart';
import 'package:graduation___part1/views/login_view.dart';
import 'package:signalr_core/signalr_core.dart'; // Import SignalR package
import 'package:shared_preferences/shared_preferences.dart';
import 'editProfile.dart';

class HomeView1 extends StatefulWidget {
  const HomeView1({super.key});

  @override
  State<HomeView1> createState() => _HomeView1State();
}

class _HomeView1State extends State<HomeView1> with TickerProviderStateMixin {
  // Animation controllers
  late AnimationController _fadeController;
  late AnimationController _slideController;
  late List<AnimationController> _cardControllers;

  // Animations
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;
  late List<Animation<double>> _scaleAnimations;

  // Chatbot state
  bool _isChatbotVisible = false;
  final TextEditingController _chatController = TextEditingController();
  final List<Map<String, String>> _chatMessages = [];

  // SignalR hub connection
  late HubConnection _hubConnection;

  @override
  void initState() {
    super.initState();

    // Initialize animations
    _initializeAnimations();

    // Initialize SignalR connection
    _initializeSignalR();
  }

  void _initializeAnimations() {
    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );
    _fadeAnimation = CurvedAnimation(
      parent: _fadeController,
      curve: Curves.easeIn,
    );

    _slideController = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );
    _slideAnimation = Tween<Offset>(
      begin: const Offset(-1.0, 0.0),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _slideController,
      curve: Curves.easeOutCubic,
    ));

    _cardControllers = List.generate(
      5,
      (index) => AnimationController(
        duration: Duration(milliseconds: 600 + (index * 100)),
        vsync: this,
      ),
    );

    _scaleAnimations = _cardControllers.map((controller) {
      return Tween<double>(begin: 0.0, end: 1.0).animate(
        CurvedAnimation(parent: controller, curve: Curves.easeOutBack),
      );
    }).toList();

    // Start animations
    _fadeController.forward();
    _slideController.forward();
    for (var controller in _cardControllers) {
      controller.forward();
    }
  }

  void _initializeSignalR() {
    // Create SignalR connection
    _hubConnection = HubConnectionBuilder()
        .withUrl(
            'https://your-signalr-hub-url') // Replace with your SignalR hub URL
        .build();

    // Start the connection
    _hubConnection.start()?.then((_) {
      print("SignalR Connected");

      // Listen for incoming messages
      _hubConnection.on('ReceiveMessage', (message) {
        setState(() {
          _chatMessages.add({'sender': 'bot', 'text': message?[0]});
        });
      });
    }).catchError((err) {
      print("SignalR Connection Error: $err");
    });
  }

  @override
  void dispose() {
    _fadeController.dispose();
    _slideController.dispose();
    for (var controller in _cardControllers) {
      controller.dispose();
    }
    _chatController.dispose();
    _hubConnection.stop(); // Stop SignalR connection
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final authViewModel = Provider.of<AuthViewModel>(context);

    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(60.0),
        child: SlideTransition(
          position: _slideAnimation,
          child: AppBar(
            elevation: 0,
            flexibleSpace: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    Colors.black,
                    Colors.blue.shade900,
                  ],
                ),
              ),
            ),
            leading: Hero(
              tag: 'profile_icon',
              child: Material(
                color: Colors.transparent,
                child: IconButton(
                  icon: const Icon(Icons.person, color: Colors.white),
                  onPressed: () async {
                    SharedPreferences objShared =
                        await SharedPreferences.getInstance();
                    final profile = Profile(
                      name: objShared.getString('username') ??
                          "NULL", // Replace with actual name if available
                      imageUrl: objShared.getString('profile_image') ??
                          "NULL", // Fallback image URL
                      about: objShared.getString('about') ?? "NULL",
                      skills: objShared.getString('skills') ?? "NULL",
                      linkedin: objShared.getString('linkedin') ?? "NULL",
                      email: objShared.getString('email') ?? "NULL",
                      phone: objShared.getString('phone') ?? "NULL",
                      numOfEx: objShared.getInt('experience_years') ?? 0,
                    );
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ProfilePage(profile: profile),
                      ),
                    );
                  },
                ),
              ),
            ),
            actions: <Widget>[
              IconButton(
                icon: const Icon(Icons.close, color: Colors.white),
                onPressed: () {
                  _fadeController.reverse().then((_) {
                    Navigator.push(
                      context,
                      PageRouteBuilder(
                        pageBuilder: (context, animation, secondaryAnimation) =>
                            const HomeView(),
                        transitionsBuilder:
                            (context, animation, secondaryAnimation, child) {
                          return FadeTransition(
                            opacity: animation,
                            child: child,
                          );
                        },
                      ),
                    );
                  });
                },
              ),
            ],
          ),
        ),
      ),
      body: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.black,
                  Colors.blue.shade900.withOpacity(0.8),
                  Colors.black,
                ],
              ),
            ),
            child: FadeTransition(
              opacity: _fadeAnimation,
              child: Center(
                child: ListView(
                  padding: const EdgeInsets.symmetric(vertical: 20),
                  children: [
                    _buildAnimatedCard(
                        0, 'Get Ads', 'Choose an item for your ad', Icons.list,
                        () {
                      _navigateWithAnimation(
                          context, const adView.AdListView());
                    }),
                    _buildAnimatedCard(
                        1, 'Create Ad', 'Create your own ad', Icons.add_circle,
                        () {
                      _navigateWithAnimation(context, const CreateAdView());
                    }),
                    _buildAnimatedCard(2, 'My Profile', '', Icons.person, () {
                      _navigateWithAnimation(context, const AutoProfile());
                    }),
                    _buildAnimatedCard(3, 'Statistics',
                        'View your ad performance', Icons.attach_money, () {
                      _navigateWithAnimation(context, const ProfitView());
                    }),
                    _buildAnimatedCard(4, 'Log Out', '', Icons.logout, () {
                      logOut1(context);
                    }),
                  ],
                ),
              ),
            ),
          ),
          // Chatbot UI
          if (_isChatbotVisible)
            Positioned(
              bottom: 50,
              right: 10,
              child: _buildChatbot(),
            ),
          // Chatbot toggle button
          Positioned(
            bottom: 20,
            right: 20,
            child: FloatingActionButton(
              onPressed: () {
                setState(() {
                  _isChatbotVisible = !_isChatbotVisible;
                });
              },
              child: const Icon(Icons.chat_outlined),
              backgroundColor: Colors.blue.shade900,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildChatbot() {
    return Container(
      width: 300,
      height: 400,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: 10,
            spreadRadius: 5,
          ),
        ],
      ),
      child: Column(
        children: [
          // Chatbot header
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: Colors.blue.shade900,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(15),
                topRight: Radius.circular(15),
              ),
            ),
            child: Row(
              children: [
                const Icon(Icons.chat_outlined, color: Colors.white),
                const SizedBox(width: 10),
                const Text(
                  'Chatbot',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const Spacer(),
                IconButton(
                  icon: const Icon(Icons.close, color: Colors.white),
                  onPressed: () {
                    setState(() {
                      _isChatbotVisible = false;
                    });
                  },
                ),
              ],
            ),
          ),
          // Chat messages
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(10),
              itemCount: _chatMessages.length,
              itemBuilder: (context, index) {
                final message = _chatMessages[index];
                return Align(
                  alignment: message['sender'] == 'user'
                      ? Alignment.centerRight
                      : Alignment.centerLeft,
                  child: Container(
                    margin: const EdgeInsets.symmetric(vertical: 5),
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: message['sender'] == 'user'
                          ? Colors.blue.shade100
                          : Colors.grey.shade200,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Text(message['text']!),
                  ),
                );
              },
            ),
          ),
          // Chat input
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: Colors.grey.shade100,
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(15),
                bottomRight: Radius.circular(15),
              ),
            ),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _chatController,
                    decoration: const InputDecoration(
                      hintText: 'Type a message...',
                      border: InputBorder.none,
                    ),
                  ),
                ),
                const SizedBox(
                    width: 10), // Add space between input and send icon
                IconButton(
                  icon: const Icon(Icons.send),
                  onPressed: _sendMessage,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _sendMessage() async {
    final message = _chatController.text.trim();
    if (message.isEmpty) return;

    setState(() {
      _chatMessages.add({'sender': 'user', 'text': message});
      _chatController.clear();
    });

    // Send message via SignalR
    await _hubConnection.invoke('SendMessage', args: [message]);
  }

  // Animated card builder with scale animation
  Widget _buildAnimatedCard(int index, String title, String subtitle,
      IconData icon, VoidCallback onTap) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: ScaleTransition(
        scale: _scaleAnimations[index],
        child: Card(
          elevation: 8,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15),
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Colors.white,
                  Colors.blue.shade50,
                ],
              ),
            ),
            child: ListTile(
              contentPadding:
                  const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              leading: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.blue.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(icon, color: Colors.blue.shade700, size: 30),
              ),
              title: Text(
                title,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              subtitle: subtitle.isNotEmpty
                  ? Text(
                      subtitle,
                      style: TextStyle(color: Colors.grey.shade600),
                    )
                  : null,
              trailing: Icon(Icons.arrow_forward_ios,
                  color: Colors.blue.shade300, size: 20),
              onTap: () {
                // Add tap animation
                _cardControllers[index].reverse().then((_) {
                  _cardControllers[index].forward();
                  onTap();
                });
              },
            ),
          ),
        ),
      ),
    );
  }

  // Animated navigation helper
  void _navigateWithAnimation(BuildContext context, Widget destination) {
    Navigator.push(
      context,
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) => destination,
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          return FadeTransition(
            opacity: animation,
            child: SlideTransition(
              position: Tween<Offset>(
                begin: const Offset(1.0, 0.0),
                end: Offset.zero,
              ).animate(animation),
              child: child,
            ),
          );
        },
        transitionDuration: const Duration(milliseconds: 500),
      ),
    );
  }

  // Enhanced logout dialog
  void logOut1(BuildContext context) {
    showGeneralDialog(
      context: context,
      barrierDismissible: true,
      barrierLabel: '',
      transitionDuration: const Duration(milliseconds: 300),
      pageBuilder: (context, animation, secondaryAnimation) {
        return ScaleTransition(
          scale: Tween<double>(begin: 0.5, end: 1.0).animate(
            CurvedAnimation(parent: animation, curve: Curves.easeOutBack),
          ),
          child: AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            title: const Text(
              'Confirm Logout',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            content: const Text('Are you sure you want to log out?'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  logOut2(context);
                },
                child: const Text('Yes'),
              ),
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text('Cancel'),
              ),
            ],
          ),
        );
      },
    );
  }

  // Enhanced logout implementation
  void logOut2(BuildContext context) {
    // Show loading indicator
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return const Center(
          child: CircularProgressIndicator(),
        );
      },
    );

    // Perform logout
    Future.delayed(const Duration(milliseconds: 800), () {
      AutoLogin.logout3();
      Navigator.of(context).pop(); // Remove loading indicator

      // Show success message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('You have been logged out successfully'),
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          backgroundColor: Colors.green,
        ),
      );

      // Navigate to login
      Navigator.pushReplacement(
        context,
        PageRouteBuilder(
          pageBuilder: (context, animation, secondaryAnimation) =>
              const LoginView(),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            return FadeTransition(
              opacity: animation,
              child: SlideTransition(
                position: Tween<Offset>(
                  begin: const Offset(0.0, 1.0),
                  end: Offset.zero,
                ).animate(animation),
                child: child,
              ),
            );
          },
          transitionDuration: const Duration(milliseconds: 500),
        ),
      );
    });
  }
}
