import 'package:flutter/material.dart';

import '../../data/models/chat_message.dart';
import 'chat_empty_state.dart';
import 'chat_loading_state.dart';
import 'chat_message_bubble.dart';

class ChatMessageList extends StatelessWidget {
  const ChatMessageList({
    super.key,
    required this.messages,
    required this.loading,
    required this.currentUserId,
    required this.scrollController,
    this.onDeleteMessage,
    this.onReactionTap,
    this.onLongPressMessage,
    this.resolveFileUrl,
  });

  final List<ChatMessage> messages;
  final bool loading;
  final int? currentUserId;
  final ScrollController scrollController;

  final ValueChanged<String>? onDeleteMessage;

  final void Function(String messageId, String emoji)? onReactionTap;

  final ValueChanged<ChatMessage>? onLongPressMessage;

  final String Function(String? url)? resolveFileUrl;

  @override
  Widget build(BuildContext context) {
    if (loading) {
      return const ChatLoadingState();
    }

    if (messages.isEmpty) {
      return const ChatEmptyState();
    }

    return ListView.separated(
      controller: scrollController,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      physics: const BouncingScrollPhysics(),
      itemCount: messages.length,
      separatorBuilder: (_, __) => const SizedBox(height: 8),
      itemBuilder: (context, index) {
        final message = messages[index];

        final isMine =
            currentUserId != null && message.isOwnedBy(currentUserId!);

        return ChatMessageBubble(
          key: ValueKey(message.id),
          message: message,
          isMine: isMine,
          resolveFileUrl: resolveFileUrl,
          onDelete: isMine ? () => onDeleteMessage?.call(message.id) : null,
          onLongPress: () {
            onLongPressMessage?.call(message);
          },
          onReactionTap: (emoji) {
            onReactionTap?.call(message.id, emoji);
          },
        );
      },
    );
  }
}
