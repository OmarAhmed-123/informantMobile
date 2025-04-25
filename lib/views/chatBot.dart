import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:graduation___part1/views/chatBot_cubit.dart';

import 'package:cached_network_image/cached_network_image.dart';

import 'package:shimmer/shimmer.dart';

class ChatBot extends StatelessWidget {
  const ChatBot({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ChatBotCubit()..loadMessages(),
      child: Scaffold(
        body: const ChatBody(),
      ),
    );
  }
}

class ChatBody extends StatefulWidget {
  const ChatBody({super.key});

  @override
  State<ChatBody> createState() => _ChatBodyState();
}

class _ChatBodyState extends State<ChatBody> with TickerProviderStateMixin {
  final TextEditingController _messageController = TextEditingController();

  final ScrollController _scrollController = ScrollController();

  late AnimationController _adLoadingController;

  @override
  void initState() {
    super.initState();

    _adLoadingController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
  }

  @override
  void dispose() {
    _messageController.dispose();

    _scrollController.dispose();

    _adLoadingController.dispose();

    super.dispose();
  }

  void _scrollToBottom() {
    if (_scrollController.hasClients) {
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    }
  }

  Widget _buildAdsMessage(BuildContext context, Map<String, dynamic> message) {
    final List<dynamic> ads = message['ads'];

    if (_adLoadingController.status != AnimationStatus.forward) {
      _adLoadingController.reset();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CircleAvatar(
              radius: 18,
              backgroundColor: Colors.teal[600],
              child: const Icon(
                Icons.smart_toy_rounded,
                color: Colors.white,
                size: 20,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: GestureDetector(
                onTap: () {
                  saveMessage();

                  Navigator.pushReplacementNamed(context, '/chatBot');
                },
                child: Container(
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: Colors.grey[200],
                    borderRadius: const BorderRadius.only(
                      topRight: Radius.circular(18),
                      bottomLeft: Radius.circular(18),
                      bottomRight: Radius.circular(18),
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.05),
                        blurRadius: 2,
                        offset: const Offset(0, 1),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'tap to show your ads....',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        message['time'],
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey[600],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        SizedBox(
          height: 280,
          child: ads.isEmpty
              ? _buildLoadingIndicator()
              : _buildAdCarousel(context, ads),
        ),
        const SizedBox(height: 8),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: double.infinity,
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(0),
      ),
      child: Column(
        children: [
          _buildChatbotHeader(context),
          Expanded(child: _buildChatMessages(context)),
          BlocBuilder<ChatBotCubit, ChatState>(
            builder: (context, state) {
              if (state.isBotTyping) {
                return _buildTypingIndicator();
              } else {
                return const SizedBox.shrink();
              }
            },
          ),
          _buildChatInput(context),
        ],
      ),
    );
  }

  // Widget _buildViewAdsAction(BuildContext context) {

  //   return BlocBuilder<ChatBotCubit, ChatState>(

  //     buildWhen: (previous, current) {

  //       return previous.showViewAdsAction != current.showViewAdsAction;

  //     },

  //     builder: (context, state) {

  //       if (!state.showViewAdsAction) {

  //         return const SizedBox.shrink();

  //       }

  //       return Container(

  //         width: double.infinity,

  //         padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),

  //         decoration: BoxDecoration(

  //           color: Colors.indigo[50],

  //           boxShadow: [

  //             BoxShadow(

  //               color: Colors.black.withOpacity(0.05),

  //               blurRadius: 2,

  //               offset: const Offset(0, 1),

  //             ),

  //           ],

  //         ),

  //         child: Row(

  //           children: [

  //             Icon(Icons.lightbulb_outline, color: Colors.amber[700], size: 20),

  //             const SizedBox(width: 12),

  //             Expanded(

  //               child: Text(

  //                 'Check out your ads',

  //                 style: TextStyle(

  //                   color: Colors.grey[800],

  //                   fontSize: 14,

  //                 ),

  //               ),

  //             ),

  //             ElevatedButton.icon(

  //               icon: const Icon(Icons.ads_click, size: 18),

  //               label: const Text('View My Ads'),

  //               style: ElevatedButton.styleFrom(

  //                 backgroundColor: Colors.indigo[600],

  //                 foregroundColor: Colors.white,

  //                 elevation: 1,

  //                 shape: RoundedRectangleBorder(

  //                   borderRadius: BorderRadius.circular(12),

  //                 ),

  //                 padding:

  //                     const EdgeInsets.symmetric(horizontal: 16, vertical: 8),

  //               ),

  //               onPressed: () {

  //                 context.read<ChatBotCubit>().fetchAds();

  //                 context.read<ChatBotCubit>().hideViewAdsAction();

  //               },

  //             ),

  //           ],

  //         ),

  //       );

  //     },

  //   );

  // }

  Widget _buildChatbotHeader(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.indigo[800],
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: SafeArea(
        bottom: false,
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.indigo[700],
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 2,
                    offset: const Offset(0, 1),
                  ),
                ],
              ),
              child: const Icon(Icons.smart_toy_rounded,
                  color: Colors.white, size: 22),
            ),
            const SizedBox(width: 14),
            const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Chatbot Assistant',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    letterSpacing: 0.3,
                  ),
                ),
                Text(
                  'Always here to help',
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: 12,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ],
            ),
            const Spacer(),
            IconButton(
              icon: const Icon(Icons.close, color: Colors.white),
              onPressed: () {
                Navigator.pop(context);
              },
              splashRadius: 24,
            ),
          ],
        ),
      ),
    );
  }

  Future<void> saveMessage() async {
    await context.read<ChatBotCubit>().saveMessages();
  }

  Widget _buildChatMessages(BuildContext context) {
    return BlocConsumer<ChatBotCubit, ChatState>(
      listenWhen: (previous, current) =>
          previous.chatMessages.length < current.chatMessages.length ||
          previous.forceRefresh != current.forceRefresh,
      listener: (context, state) {
        // Auto-scroll when new messages are added

        WidgetsBinding.instance.addPostFrameCallback((_) {
          _scrollToBottom();
        });
      },
      builder: (context, state) {
        return ListView.builder(
          controller: _scrollController,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
          itemCount: state.chatMessages.length,
          itemBuilder: (context, index) {
            final message = state.chatMessages[index];

            final isLastMessage = index == state.chatMessages.length - 1;

            // Add extra padding at the bottom of the last message

            final bottomPadding = isLastMessage ? 12.0 : 16.0;

            // Special handling for ad messages

            if (message['messageType'] == 'ads') {
              return Padding(
                padding: EdgeInsets.only(bottom: bottomPadding),
                child: _buildAdsMessage(context, message),
              );
            }

            return Padding(
              padding: EdgeInsets.only(bottom: bottomPadding),
              child: Row(
                mainAxisAlignment: message['sender'] == 'user'
                    ? MainAxisAlignment.end
                    : MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (message['sender'] == 'user') ...[
                    _buildUserMessage(context, message),
                    const SizedBox(width: 12),
                    CircleAvatar(
                      radius: 18,
                      backgroundColor: Colors.indigo[400],
                      child: const Icon(
                        Icons.person_rounded,
                        color: Colors.white,
                        size: 20,
                      ),
                    ),
                  ] else ...[
                    CircleAvatar(
                      radius: 18,
                      backgroundColor: Colors.teal[600],
                      child: const Icon(
                        Icons.smart_toy_rounded,
                        color: Colors.white,
                        size: 20,
                      ),
                    ),
                    const SizedBox(width: 12),
                    _buildBotMessage(context, message),
                  ],
                ],
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildLoadingIndicator() {
    saveMessage();

    return ListView.builder(
      scrollDirection: Axis.horizontal,

      itemCount: 3, // Show 3 shimmer placeholders

      itemBuilder: (context, index) {
        return Shimmer.fromColors(
          baseColor: Colors.grey[300]!,
          highlightColor: Colors.grey[100]!,
          child: Container(
            width: 220,
            margin: const EdgeInsets.only(right: 16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
            ),
          ),
        );
      },
    );
  }

  Widget _buildUserMessage(BuildContext context, Map<String, dynamic> message) {
    return Flexible(
      child: Container(
        padding: const EdgeInsets.all(14),
        constraints: BoxConstraints(
          maxWidth: MediaQuery.of(context).size.width * 0.65,
        ),
        decoration: BoxDecoration(
          color: Colors.indigo[100],
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(18),
            bottomLeft: Radius.circular(18),
            bottomRight: Radius.circular(18),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 2,
              offset: const Offset(0, 1),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
              message['text']!,
              style: const TextStyle(
                fontSize: 15,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              message['time'],
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey[600],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBotMessage(BuildContext context, Map<String, dynamic> message) {
    return Flexible(
      child: Container(
        padding: const EdgeInsets.all(14),
        constraints: BoxConstraints(
          maxWidth: MediaQuery.of(context).size.width * 0.65,
        ),
        decoration: BoxDecoration(
          color: Colors.grey[200],
          borderRadius: const BorderRadius.only(
            topRight: Radius.circular(18),
            bottomLeft: Radius.circular(18),
            bottomRight: Radius.circular(18),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 2,
              offset: const Offset(0, 1),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              message['text']!,
              style: const TextStyle(
                fontSize: 15,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              message['time'],
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey[600],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTypingIndicator() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        children: [
          CircleAvatar(
            radius: 18,
            backgroundColor: Colors.teal[600],
            child: const Icon(
              Icons.smart_toy_rounded,
              color: Colors.white,
              size: 20,
            ),
          ),
          const SizedBox(width: 12),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: Colors.grey[200],
              borderRadius: const BorderRadius.only(
                topRight: Radius.circular(18),
                bottomLeft: Radius.circular(18),
                bottomRight: Radius.circular(18),
              ),
            ),
            child: Row(
              children: [
                Text(
                  'Typing',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey[700],
                  ),
                ),
                const SizedBox(width: 10),
                _buildDotAnimation(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDotAnimation() {
    return TweenAnimationBuilder<double>(
      tween: Tween<double>(begin: 0, end: 1),
      duration: const Duration(milliseconds: 1500),
      builder: (context, value, child) {
        return Row(
          children: List.generate(
            3,
            (index) {
              final delay = (index / 3);

              final position = (value - delay) % 1;

              final opacity =
                  position > 0.5 ? (1 - position) * 2 : position * 2;

              return Container(
                margin: const EdgeInsets.symmetric(horizontal: 2),
                width: 5,
                height: 5,
                decoration: BoxDecoration(
                  color: Colors.grey[600]!.withOpacity(0.3 + (opacity * 0.7)),
                  shape: BoxShape.circle,
                ),
              );
            },
          ),
        );
      },
    );
  }

  Widget _buildAdCarousel(BuildContext context, List<dynamic> ads) {
    // Run animation controller forward if not already running

    if (!_adLoadingController.isAnimating &&
        !_adLoadingController.isCompleted) {
      _adLoadingController.forward();
    }

    return FadeTransition(
      opacity: _adLoadingController.drive(
        CurveTween(curve: Curves.easeIn),
      ),
      child: SizedBox(
        height: 220, // Adjusted height for better proportions

        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          padding: const EdgeInsets.symmetric(horizontal: 8),
          itemCount: ads.length,
          itemBuilder: (context, index) {
            final ad = ads[index];

            // Call saveMessage after building the ad card

            saveMessage();

            return _buildAdCard(context, ad);
          },
        ),
      ),
    );
  }

  Widget _buildAdCard(BuildContext context, Map<String, dynamic> ad) {
    final bool hasImage =
        ad['images'] != null && (ad['images'] as List).isNotEmpty;

    final String? displayImage = hasImage ? ad['images'][0] : null;

    return Container(
      width: 160,
      margin: const EdgeInsets.only(right: 12),
      child: Card(
        elevation: 3,
        shadowColor: Colors.black26,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Image

            Expanded(
              flex: 3,
              child: ClipRRect(
                borderRadius: BorderRadius.vertical(top: Radius.circular(12)),
                child: hasImage && displayImage != null
                    ? CachedNetworkImage(
                        imageUrl: displayImage,
                        width: double.infinity,
                        fit: BoxFit.cover,
                        fadeInDuration: const Duration(milliseconds: 200),
                        fadeOutDuration: const Duration(milliseconds: 200),
                        memCacheHeight: 160,
                        memCacheWidth: 160,
                        placeholder: (context, url) => Container(
                          color: Colors.grey[200],
                          child: Center(
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: Colors.grey[400],
                            ),
                          ),
                        ),
                        errorWidget: (context, url, error) => Container(
                          color: Colors.grey[300],
                          child: Icon(
                            Icons.image_not_supported,
                            color: Colors.grey[500],
                            size: 100,
                          ),
                        ),
                      )
                    : Container(
                        color: Colors.grey[300],
                        child: Icon(
                          Icons.image_not_supported,
                          color: Colors.grey[500],
                          size: 160,
                        ),
                      ),
              ),
            ),

            // Name

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
              child: Text(
                ad['name'],
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.center,
              ),
            ),

            // Stars

            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(5, (index) {
                return Icon(
                  index < (ad['stars'] as int) ? Icons.star : Icons.star_border,
                  color: index < (ad['stars'] as int)
                      ? Colors.amber
                      : Colors.grey[400],
                  size: 16,
                );
              }),
            ),

            // Show Details Button

            Padding(
              padding: const EdgeInsets.all(2.0),
              child: ElevatedButton(
                onPressed: () {
                  saveMessage();

                  context.read<ChatBotCubit>().selectAd(
                        context,
                        ad,
                        showStatistics: false,
                      );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.indigo[600],
                  foregroundColor: Colors.white,
                  minimumSize: const Size(double.infinity, 32),
                  padding: EdgeInsets.zero,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: const Text('Show Details'),
              ),
            ),

            Padding(
              padding: const EdgeInsets.all(2.0),
              child: ElevatedButton(
                onPressed: () {
                  saveMessage();

                  context.read<ChatBotCubit>().selectAd(
                        context,
                        ad,
                        showStatistics: true,
                      );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.indigo[600],
                  foregroundColor: Colors.white,
                  minimumSize: const Size(double.infinity, 32),
                  padding: EdgeInsets.zero,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: const Text('Show Statistics'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildChatInput(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(30.0),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            spreadRadius: 1,
            blurRadius: 3,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: SafeArea(
        top: false,
        child: Row(
          children: [
            IconButton(
              icon: Icon(
                Icons.coffee_rounded,
                color: Colors.indigo[400],
              ),
              onPressed: () {
                context.read<ChatBotCubit>().fetchAds(context);

                context.read<ChatBotCubit>().hideViewAdsAction();
              },
              tooltip: 'Show Ads',
              splashRadius: 24,
            ),
            Expanded(
              child: TextField(
                controller: _messageController,
                decoration: InputDecoration(
                  hintText: 'Message',
                  hintStyle: TextStyle(color: Colors.grey[500]),
                  border: InputBorder.none,
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 0,
                    vertical: 14,
                  ),
                ),
                minLines: 1,
                maxLines: 5,
                textCapitalization: TextCapitalization.sentences,
                onSubmitted: (text) {
                  if (text.trim().isNotEmpty) {
                    context
                        .read<ChatBotCubit>()
                        .sendMessage(text.trim(), false, "-100");

                    _messageController.clear();
                  }
                },
              ),
            ),
            const SizedBox(width: 12),
            Container(
              decoration: BoxDecoration(
                color: Colors.indigo[600],
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: Colors.indigo.withOpacity(0.3),
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: IconButton(
                icon: const Icon(
                  Icons.send_rounded,
                  color: Colors.white,
                ),
                onPressed: () {
                  final message = _messageController.text.trim();

                  if (message.isNotEmpty) {
                    context
                        .read<ChatBotCubit>()
                        .sendMessage(message, false, "-100");

                    _messageController.clear();
                  }
                },
                splashRadius: 24,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

extension ChatBotCubitExtension on ChatBotCubit {
  void hideViewAdsAction() {
    emit(state.copyWith(showViewAdsAction: false));
  }
}
