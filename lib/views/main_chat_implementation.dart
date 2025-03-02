import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'chat_service.dart';
import 'chat_cubit.dart';
import 'chat_window.dart';

class ChatImplementation extends StatelessWidget {
  const ChatImplementation({super.key});

  @override
  Widget build(BuildContext context) {
    // Read user information from your auth service or storage
    final String userId = "user123"; // Replace with actual user ID
    final String username = "Omar Ahmed"; // Replace with actual username

    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => ChatCubit(ChatService()),
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        home: Scaffold(
          // Your main app content here
          body: Stack(
            children: [
              // Your main app UI
              const Center(
                child: Text("Your App Content Here"),
              ),

              // Chat overlay - will display as a floating button initially
              ChatApp(
                username: username,
                userId: userId,
                onLogout: () {
                  // Handle logout
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// Usage example:
// To add this chat functionality to an existing Flutter app, add the ChatApp widget
// to your widget tree wrapped in a BlocProvider for ChatCubit.
// 
// Example in your existing app:
// 
// @override
// Widget build(BuildContext context) {
//   return Scaffold(
//     body: Stack(
//       children: [
//         // Your existing app UI
//         ...
//         
//         // Add chat overlay
//         BlocProvider(
//           create: (context) => ChatCubit(ChatService()),
//           child: ChatApp(
//             username: currentUser.username, 
//             userId: currentUser.id,
//             onLogout: handleLogout,
//           ),
//         ),
//       ],
//     ),
//   );
// }