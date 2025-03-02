import 'dart:async';
import 'dart:io';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'chat_service.dart';

// Define states
enum ChatViewState { initial, loading, loaded, error }

class ChatState {
  final List<ChatMessage> messages;
  final List<ChatUser> users;
  final ChatUser? selectedUser;
  final ChatViewState viewState;
  final String? error;
  final CallInfo? incomingCall;
  final bool isInCall;
  final Map<String, bool> typingUsers;

  ChatState({
    this.messages = const [],
    this.users = const [],
    this.selectedUser,
    this.viewState = ChatViewState.initial,
    this.error,
    this.incomingCall,
    this.isInCall = false,
    this.typingUsers = const {},
  });

  ChatState copyWith({
    List<ChatMessage>? messages,
    List<ChatUser>? users,
    ChatUser? selectedUser,
    ChatViewState? viewState,
    String? error,
    CallInfo? incomingCall,
    bool? isInCall,
    Map<String, bool>? typingUsers,
  }) {
    return ChatState(
      messages: messages ?? this.messages,
      users: users ?? this.users,
      selectedUser: selectedUser ?? this.selectedUser,
      viewState: viewState ?? this.viewState,
      error: error,
      incomingCall: incomingCall,
      isInCall: isInCall ?? this.isInCall,
      typingUsers: typingUsers ?? this.typingUsers,
    );
  }
}

class ChatCubit extends Cubit<ChatState> {
  final ChatService _chatService;
  String? _currentUserId;
  Timer? _typingTimer;
  Map<String, Timer> _userTypingTimers = {};

  ChatCubit(this._chatService)
      : super(ChatState(viewState: ChatViewState.loading)) {
    _initialize();
  }

  Future<void> _initialize() async {
    await _chatService.connect();
    _currentUserId = _chatService.currentUserId;

    // Setup callbacks
    _chatService.onUsersUpdated = _handleUsersUpdated;
    _chatService.onMessageReceived = _handleMessageReceived;
    _chatService.onTyping = _handleUserTyping;
    _chatService.onIncomingCall = _handleIncomingCall;
    _chatService.onCallAccepted = _handleCallAccepted;
    _chatService.onCallRejected = _handleCallRejected;
    _chatService.onCallEnded = _handleCallEnded;

    emit(state.copyWith(
      users: _chatService.onlineUsers,
      viewState: ChatViewState.loaded,
    ));
  }

  void _handleUsersUpdated(List<ChatUser> users) {
    emit(state.copyWith(users: users));
  }

  void _handleMessageReceived(ChatMessage message) {
    if (state.selectedUser != null &&
        (message.senderId == state.selectedUser!.userId ||
            message.receiverId == state.selectedUser!.userId)) {
      final updatedMessages = [...state.messages, message];
      emit(state.copyWith(messages: updatedMessages));
    }
  }

  void _handleUserTyping(String userId) {
    // Cancel existing timer if any
    _userTypingTimers[userId]?.cancel();

    // Create new typing state
    final updatedTypingUsers = Map<String, bool>.from(state.typingUsers);
    updatedTypingUsers[userId] = true;
    emit(state.copyWith(typingUsers: updatedTypingUsers));

    // Set timer to clear typing state after 3 seconds
    _userTypingTimers[userId] = Timer(const Duration(seconds: 3), () {
      final updatedTypingUsers = Map<String, bool>.from(state.typingUsers);
      updatedTypingUsers.remove(userId);
      emit(state.copyWith(typingUsers: updatedTypingUsers));
    });
  }

  void _handleIncomingCall(CallInfo callInfo) {
    emit(state.copyWith(incomingCall: callInfo));
  }

  void _handleCallAccepted(String userId) {
    emit(state.copyWith(isInCall: true, incomingCall: null));
  }

  void _handleCallRejected(String userId) {
    emit(state.copyWith(incomingCall: null));
  }

  void _handleCallEnded(String userId) {
    emit(state.copyWith(isInCall: false));
  }

  void selectUser(ChatUser user) async {
    emit(state.copyWith(
      selectedUser: user,
      messages: [], // Clear previous messages
      viewState: ChatViewState.loading,
    ));

    // Here you would typically load message history for this user
    // This would come from your backend via SignalR

    emit(state.copyWith(viewState: ChatViewState.loaded));
  }

  void sendTextMessage(String content) {
    if (state.selectedUser == null || content.trim().isEmpty) return;

    _chatService.sendMessage(
      state.selectedUser!.userId,
      content,
      type: MessageType.text,
    );

    // Optimistically add message to state
    final newMessage = ChatMessage(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      senderId: _currentUserId ?? '',
      receiverId: state.selectedUser!.userId,
      content: content,
      timestamp: DateTime.now(),
      type: MessageType.text,
      isRead: false,
    );

    emit(state.copyWith(messages: [...state.messages, newMessage]));
  }

  void sendAudioMessage(String audioPath) {
    if (state.selectedUser == null || audioPath.isEmpty) return;

    _chatService.sendMessage(
      state.selectedUser!.userId,
      audioPath,
      type: MessageType.audio,
    );

    // Optimistically add message to state
    final newMessage = ChatMessage(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      senderId: _currentUserId ?? '',
      receiverId: state.selectedUser!.userId,
      content: audioPath,
      timestamp: DateTime.now(),
      type: MessageType.audio,
      isRead: false,
    );

    emit(state.copyWith(messages: [...state.messages, newMessage]));
  }

  void sendTypingNotification() {
    if (state.selectedUser == null) return;

    // Avoid sending too many typing notifications
    if (_typingTimer?.isActive ?? false) return;

    _chatService.sendTypingNotification(state.selectedUser!.userId);

    _typingTimer = Timer(const Duration(seconds: 2), () {});
  }

  void initiateCall(bool isVideoCall) {
    if (state.selectedUser == null) return;
    _chatService.initiateCall(state.selectedUser!.userId, isVideoCall);
    emit(state.copyWith(isInCall: true));
  }

  void acceptIncomingCall() {
    if (state.incomingCall == null) return;
    _chatService.acceptCall(state.incomingCall!.callerId);
    emit(state.copyWith(isInCall: true, incomingCall: null));
  }

  void rejectIncomingCall() {
    if (state.incomingCall == null) return;
    _chatService.rejectCall(state.incomingCall!.callerId);
    emit(state.copyWith(incomingCall: null));
  }

  void endCurrentCall() {
    if (!state.isInCall || state.selectedUser == null) return;
    _chatService.endCall(state.selectedUser!.userId);
    emit(state.copyWith(isInCall: false));
  }

  @override
  Future<void> close() async {
    _typingTimer?.cancel();
    _userTypingTimers.values.forEach((timer) => timer.cancel());
    _userTypingTimers.clear();
    await _chatService.disconnect();
    return super.close();
  }
}