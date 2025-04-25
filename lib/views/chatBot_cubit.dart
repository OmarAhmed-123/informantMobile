import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:graduation___part1/views/auth_cubit.dart';

import 'package:graduation___part1/views/httpCodeG.dart';

import 'package:intl/intl.dart';

import 'package:shared_preferences/shared_preferences.dart';

import 'dart:convert';

import 'package:flutter/material.dart';

class ChatBotCubit extends Cubit<ChatState> {
  ChatBotCubit() : super(ChatState.initial());

  void hideViewAdsAction() {
    emit(state.copyWith(showViewAdsAction: false));
  }

  void loadMessages() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    String? messagesString = prefs.getString('chatMessages');

    if (messagesString != null) {
      List<dynamic> messagesJson = json.decode(messagesString);

      emit(state.copyWith(
          chatMessages: List<Map<String, dynamic>>.from(messagesJson)));
    }
  }

  Future<void> saveMessages() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    String messagesString = json.encode(state.chatMessages);

    await prefs.setString('chatMessages', messagesString);
  }

  List<dynamic> Ads = [];

  void fetchAds(BuildContext context) async {
    emit(state.copyWith(isBotTyping: true));
    await saveMessages();
    try {
      if (Ads.isEmpty) {
        await context.read<AuthCubit>().loadMyAds();
      }
      Ads = myAds;
      Future.delayed(const Duration(milliseconds: 300), () {
        final adsMessage = {
          'sender': 'bot',
          'messageType': 'ads',
          'ads': Ads.map((ad) {
            return {
              ...ad,
              'hasImage':
                  ad['images'] != null && (ad['images'] as List).isNotEmpty,
              'displayImage':
                  ad['images'] != null && (ad['images'] as List).isNotEmpty
                      ? (ad['images'] as List).first
                      : null,
            };
          }).toList(),
          'time': _getCurrentTime(),
        };

        List<Map<String, dynamic>> updatedMessages =
            List.from(state.chatMessages)..add(adsMessage);

        // Update state with the new messages

        emit(state.copyWith(
          chatMessages: updatedMessages,
          isBotTyping: false,
        ));

        // Force a UI update and scroll to bottom after a short delay

        Future.delayed(const Duration(milliseconds: 200), () {
          emit(state.copyWith(forceRefresh: !state.forceRefresh));
        });
      });
    } catch (e) {
      emit(state.copyWith(
        isBotTyping: false,
        chatMessages: [
          ...state.chatMessages,
          {
            'sender': 'bot',
            'text': 'Failed to load ads. Please try again.\n $e',
            'time': _formatTime(DateTime.now())
          }
        ],
      ));

      await saveMessages();
    }
  }

  void selectAd(BuildContext context, Map<String, dynamic> ad,
      {bool showStatistics = false}) {
    final int adIndex = Ads.indexOf(ad) + 1;

    final int adId = ad['id'] ?? 0;

    late String message;

    if (showStatistics) {
      message = 'Statistics of ${ad['name']} ad';
    } else {
      message = 'Details of ${ad['name']} ad';
    }

    final userMessage = {
      'sender': 'user',
      'text': message,
      'time': _getCurrentTime(),
    };

    List<Map<String, dynamic>> updatedMessages = List.from(state.chatMessages)
      ..add(userMessage);

    emit(state.copyWith(chatMessages: updatedMessages, isBotTyping: true));

    Future.delayed(const Duration(seconds: 1), () {
      String responseContent;

      if (showStatistics) {
        try {
          context.read<AuthCubit>().getStatistics(adId);

          Map<String, dynamic> stats = statistics;

          responseContent = '''

📊 *Ad Statistics for ${ad['name']}* 📊

• Public ID: ${stats['publicId']}

• Views: ${stats['views'] ?? 0}

• Visits: ${stats['visits'] ?? 0}

• Link: ${stats['link']}

${stats['profits'] != null ? '• Profits: \$${stats['profits']}' : ''}

Ad ID: ${stats['adId']} (#${adIndex})

''';

          if (stats['workinAds'] == null) {
            responseContent = "Not found Statistics for your ad....";
          }

          final botResponse = {
            'sender': 'bot',
            'text': responseContent,
            'time': _getCurrentTime(),
          };

          updatedMessages = List.from(state.chatMessages)..add(botResponse);

          emit(state.copyWith(
            chatMessages: updatedMessages,
            isBotTyping: false,
          ));
        } catch (error) {
          // Handle error by showing error message in chat

          final botResponse = {
            'sender': 'bot',
            'text':
                'Sorry, I couldn\'t retrieve statistics for this ad. Please try again later.',
            'time': _getCurrentTime(),
          };

          updatedMessages = List.from(state.chatMessages)..add(botResponse);

          emit(state.copyWith(
            chatMessages: updatedMessages,
            isBotTyping: false,
          ));
        }
      } else {
        final images = ad['images'] as List<dynamic>;

        responseContent = '''

Here are details about Ad #$adIndex: ${ad['name']}

${ad['details']}

Rating: ${ad['stars']} stars  

Potential Revenue: \$${ad['potentialRevenue']}  

Available Places: ${ad['availablePlaces']}  

Images:

${images.map((url) => '- $url').join('\n')}

''';

        final botResponse = {
          'sender': 'bot',
          'text': responseContent,
          'time': _getCurrentTime(),
        };

        updatedMessages = List.from(state.chatMessages)..add(botResponse);

        emit(state.copyWith(
          chatMessages: updatedMessages,
          isBotTyping: false,
        ));
      }
    });
  }

  String _formatTime(DateTime time) {
    return DateFormat('hh:mm a').format(time);
  }

  String _getCurrentTime() {
    return DateFormat('hh:mm a').format(DateTime.now());
  }

  List<Map<String, String>> history = [];

  Future<void> sendMessage(String message, bool flag, String id) async {
    if (message.isEmpty) return;

    emit(state.copyWith(chatMessages: [
      ...state.chatMessages,
      {'sender': 'user', 'text': message, 'time': _formatTime(DateTime.now())}
    ]));

    await saveMessages();

    emit(state.copyWith(isBotTyping: true));

    try {
      final allMessages = [...state.chatMessages];

      final userMessages = allMessages
          .where((msg) => msg['sender'] == 'user')
          .map((msg) => msg['text'].toString())
          .toList();

      final last5messageUser = userMessages.length <= 5
          ? userMessages
          : userMessages.sublist(userMessages.length - 5);

      final botMessages = allMessages
          .where((msg) => msg['sender'] == 'bot')
          .map((msg) => msg['text'].toString())
          .toList();

      final last5messageBot = botMessages.length <= 5
          ? botMessages
          : botMessages.sublist(botMessages.length - 5);

      if (history.length > 5) {
        for (int i = 0;
            i < last5messageBot.length && i < last5messageUser.length;
            i++) {
          history.add(
              {'model_res': last5messageBot[i], 'user_q': last5messageUser[i]});
        }
      } else if (history.isNotEmpty) {
        for (int i = 0; i < last5messageBot.length; i++) {
          history.add(
              {'model_res': last5messageBot[i], 'user_q': last5messageUser[i]});
        }
      } else {
        history.add({'model_res': "string", 'user_q': "string"});
      }

      final prefs = await SharedPreferences.getInstance();

      if (flag) {
        await prefs.setString('idAd', id);

        await prefs.setString('action', "Fetch Ads");
      }

      String action = prefs.getString('action') ?? "string";

      String adId = prefs.getString('idAd') ?? "string";

      final response = await HttpRequest.post({
        "endPoint": "/user/TryBot",
        "user_input": message,
        'history': history,
        "action": action,
        "pram": adId,
      });

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.toString());

        emit(state.copyWith(
          isBotTyping: false,
          chatMessages: [
            ...state.chatMessages,
            {
              'sender': 'bot',
              'text': data['massege'],
              'time': _formatTime(DateTime.now())
            }
          ],
        ));
        await saveMessages();
      }
    } catch (e) {
      emit(state.copyWith(
        isBotTyping: false,
        chatMessages: [
          ...state.chatMessages,
          {
            'sender': 'bot',
            'text': 'Failed to send message. Please try again.\n $e',
            'time': _formatTime(DateTime.now())
          }
        ],
      ));

      await saveMessages();
    }
  }
}

class ChatState {
  final List<Map<String, dynamic>> chatMessages;

  final bool isBotTyping;

  final bool showViewAdsAction;

  final bool forceRefresh;

  const ChatState({
    this.chatMessages = const [],
    this.isBotTyping = false,
    this.showViewAdsAction = true,
    this.forceRefresh = false,
  });

  factory ChatState.initial() {
    return const ChatState(
      chatMessages: [],
      isBotTyping: false,
      showViewAdsAction: true,
    );
  }

  ChatState copyWith({
    List<Map<String, dynamic>>? chatMessages,
    bool? isBotTyping,
    bool? showViewAdsAction,
    bool? forceRefresh,
  }) {
    return ChatState(
      chatMessages: chatMessages ?? this.chatMessages,
      isBotTyping: isBotTyping ?? this.isBotTyping,
      showViewAdsAction: showViewAdsAction ?? this.showViewAdsAction,
      forceRefresh: forceRefresh ?? this.forceRefresh,
    );
  }
}
