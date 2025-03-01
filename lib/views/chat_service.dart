/*
import 'package:shared_preferences/shared_preferences.dart';
import 'package:signalr_core/signalr_core.dart';

class ChatService {
  late HubConnection _hubConnection;

  Future<void> connect() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('CookieToken');
    String? ptoken = prefs.getString('pToken');

    _hubConnection = HubConnectionBuilder()
        .withUrl(
          'https://infinitely-native-lamprey.ngrok-free.app/chatHub',
          options: HttpConnectionOptions(
            accessTokenFactory: () async => token ?? '',
            headers: {
              'Authorization': 'Bearer $token',
              'AuthorizationPtoken': ptoken ?? '',
            },
          ),
        )
        .build();

    await _hubConnection.start();
  }

  void onReceiveMessage(Function(String, String) onMessageReceived) {
    _hubConnection.on('ReceiveMessage', (arguments) {
      final sender = arguments?[0] as String? ?? '';
      final message = arguments?[1] as String? ?? '';
      onMessageReceived(sender, message);
    });
  }

  void sendMessage(String message, String sender) {
    if (message.trim().isEmpty) return;
    _hubConnection.invoke('SendMessage', args: [sender, message]);
  }

  Future<void> disconnect() async {
    await _hubConnection.stop();
  }
}
*/
import 'package:shared_preferences/shared_preferences.dart';
import 'package:signalr_core/signalr_core.dart';

class ChatService {
  late HubConnection _hubConnection;

  Future<void> connect() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('CookieToken');

    _hubConnection = HubConnectionBuilder()
        .withUrl(
          'https://infinitely-native-lamprey.ngrok-free.app/chat',
          HttpConnectionOptions(
            accessTokenFactory: () async => token ?? '',
            transport: HttpTransportType
                .webSockets, // Ensure WebSocket transport is used
            logging: (level, message) =>
                print("SignalR Log: $message"), // Optional logging
          ),
        )
        .build();

    // Handling connection events
    _hubConnection.onclose((error) => print("Connection closed: $error"));
    _hubConnection.onreconnecting((error) => print("Reconnecting: $error"));
    _hubConnection
        .onreconnected((connectionId) => print("Reconnected: $connectionId"));

    try {
      await _hubConnection.start();
      print("Connected to SignalR");
    } catch (e) {
      print("SignalR connection error: $e");
    }
  }

  void onReceiveMessage(Function(String, String) onMessageReceived) {
    _hubConnection.on('ReceiveMessage', (arguments) {
      if (arguments != null && arguments.length >= 2) {
        final sender = arguments[0] as String? ?? 'Unknown';
        final message = arguments[1] as String? ?? '';
        onMessageReceived(sender, message);
      }
    });
  }

  void sendMessage(String message, String sender) {
    if (message.trim().isEmpty) return;
    _hubConnection.invoke('SendMessage', args: [sender, message]).catchError(
        (error) => print("Error sending message: $error"));
  }

  Future<void> disconnect() async {
    await _hubConnection.stop();
    print("Disconnected from SignalR");
  }
}
