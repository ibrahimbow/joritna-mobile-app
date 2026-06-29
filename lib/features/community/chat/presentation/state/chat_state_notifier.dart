import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../chat_texts.dart';
import '../../data/models/chat_message.dart';
import '../../data/models/chat_websocket_event.dart';
import '../../data/models/requests/react_to_chat_message_request.dart';
import '../../data/models/requests/send_chat_message_request.dart';
import '../../domain/chat_repository.dart';
import 'chat_state.dart';

class ChatStateNotifier extends StateNotifier<ChatState> {
  ChatStateNotifier({required ChatRepository repository})
    : _repository = repository,
      super(const ChatState());

  final ChatRepository _repository;

  StreamSubscription<ChatWebSocketEvent>? _realtimeSubscription;
  StreamSubscription? _realtimeStatusSubscription;

  Future<void> initialize({
    required String buildingId,
    required int currentUserId,
  }) async {
    await _cancelSubscriptions();

    final cachedMessages = _repository.getCachedMessages(buildingId);

    state = state.copyWith(
      loading: cachedMessages.isEmpty,
      currentUserId: currentUserId,
      messages: _sortMessages(cachedMessages),
      clearError: true,
    );

    try {
      final messages = await _repository.getMessages(buildingId);

      state = state.copyWith(
        messages: _sortMessages(messages),
        loading: false,
        clearError: true,
      );

      await _repository.connectToRealtime(buildingId);

      _realtimeSubscription = _repository.realtimeEvents.listen(
        _handleRealtimeEvent,
        onError: (_) {
          state = state.copyWith(errorMessage: ChatTexts.realtimeError);
        },
      );

      _realtimeStatusSubscription = _repository.realtimeStatus.listen((status) {
        state = state.copyWith(connectionStatus: status);
      });
    } catch (_) {
      state = state.copyWith(loading: false, errorMessage: ChatTexts.loadError);
    }
  }

  Future<void> refresh(String buildingId) async {
    state = state.copyWith(loading: state.messages.isEmpty, clearError: true);

    try {
      final messages = await _repository.getMessages(buildingId);

      state = state.copyWith(
        messages: _sortMessages(messages),
        loading: false,
        clearError: true,
      );
    } catch (_) {
      state = state.copyWith(loading: false, errorMessage: ChatTexts.loadError);
    }
  }

  Future<void> sendMessage({required String content, String? imageUrl}) async {
    final trimmedContent = content.trim();
    final normalizedImageUrl = imageUrl?.trim();

    if (trimmedContent.isEmpty &&
        (normalizedImageUrl == null || normalizedImageUrl.isEmpty)) {
      return;
    }

    state = state.copyWith(sending: true, clearError: true);

    try {
      final message = await _repository.sendMessage(
        SendChatMessageRequest(
          content: trimmedContent.isEmpty ? null : trimmedContent,
          imageUrl: normalizedImageUrl == null || normalizedImageUrl.isEmpty
              ? null
              : normalizedImageUrl,
        ),
      );

      _upsertMessage(message);

      state = state.copyWith(sending: false, clearError: true);
    } catch (_) {
      state = state.copyWith(sending: false, errorMessage: ChatTexts.sendError);
    }
  }

  Future<void> deleteMessage(String messageId) async {
    state = state.copyWith(clearError: true);

    try {
      await _repository.deleteMessage(messageId);

      final updatedMessages = state.messages
          .map((message) {
            if (message.id != messageId) {
              return message;
            }

            return message.copyWith(
              deleted: true,
              content: '',
              imageUrl: '',
              deletedAt: DateTime.now(),
            );
          })
          .toList(growable: false);

      state = state.copyWith(messages: updatedMessages, clearError: true);
    } catch (_) {
      state = state.copyWith(errorMessage: ChatTexts.deleteError);
    }
  }

  Future<void> toggleReaction({
    required String messageId,
    required String emoji,
  }) async {
    final message = state.messages
        .where((message) => message.id == messageId)
        .cast<ChatMessage?>()
        .firstWhere((message) => message != null, orElse: () => null);

    final alreadyReacted =
        message?.reactions.any(
          (reaction) =>
              reaction.emoji == emoji && reaction.reactedByCurrentUser,
        ) ??
        false;

    if (alreadyReacted) {
      await removeReaction(messageId: messageId, emoji: emoji);
      return;
    }

    await reactToMessage(messageId: messageId, emoji: emoji);
  }

  Future<void> reactToMessage({
    required String messageId,
    required String emoji,
  }) async {
    state = state.copyWith(clearError: true);

    try {
      await _repository.reactToMessage(
        messageId,
        ReactToChatMessageRequest(emoji: emoji),
      );
    } catch (_) {
      state = state.copyWith(errorMessage: ChatTexts.reactionError);
    }
  }

  Future<void> removeReaction({
    required String messageId,
    required String emoji,
  }) async {
    state = state.copyWith(clearError: true);

    try {
      await _repository.removeReaction(
        messageId,
        ReactToChatMessageRequest(emoji: emoji),
      );
    } catch (_) {
      state = state.copyWith(errorMessage: ChatTexts.reactionError);
    }
  }

  void _handleRealtimeEvent(ChatWebSocketEvent event) {
    switch (event.type) {
      case ChatWebSocketEventType.messageCreated:
      case ChatWebSocketEventType.messageDeleted:
      case ChatWebSocketEventType.reactionUpdated:
        _upsertMessage(event.message);
        break;

      case ChatWebSocketEventType.unknown:
        break;
    }
  }

  void _upsertMessage(ChatMessage message) {
    final messages = [...state.messages];

    final index = messages.indexWhere((existing) => existing.id == message.id);

    if (index == -1) {
      messages.add(message);
    } else {
      messages[index] = message;
    }

    state = state.copyWith(messages: _sortMessages(messages));
  }

  List<ChatMessage> _sortMessages(List<ChatMessage> messages) {
    final sortedMessages = [...messages];

    sortedMessages.sort((a, b) => a.createdAt.compareTo(b.createdAt));

    return sortedMessages;
  }

  Future<void> _cancelSubscriptions() async {
    await _realtimeSubscription?.cancel();
    await _realtimeStatusSubscription?.cancel();

    _realtimeSubscription = null;
    _realtimeStatusSubscription = null;
  }

  @override
  void dispose() {
    _cancelSubscriptions();
    _repository.disconnectFromRealtime();

    super.dispose();
  }
}
