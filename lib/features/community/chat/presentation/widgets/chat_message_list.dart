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

  final void Function(
    String messageId,
    String emoji,
  )? onReactionTap;

  final ValueChanged<ChatMessage>? onLongPressMessage;

  final String Function(String? url)? resolveFileUrl;

  @override
  Widget build(final BuildContext context) {
    if (loading) {
      return const ChatLoadingState();
    }

    if (messages.isEmpty) {
      return const ChatEmptyState();
    }

    return ListView.builder(
      controller: scrollController,
      padding: const EdgeInsets.fromLTRB(
        12,
        16,
        12,
        20,
      ),
      physics: const BouncingScrollPhysics(),
      itemCount: messages.length,
      itemBuilder: (
        final BuildContext context,
        final int index,
      ) {
        final ChatMessage message = messages[index];

        final bool isMine =
            currentUserId != null &&
            message.isOwnedBy(currentUserId!);

        final bool isFirstInGroup = _isFirstInGroup(index);
        final bool isLastInGroup = _isLastInGroup(index);

        return Padding(
          padding: EdgeInsets.only(
            top: isFirstInGroup && index > 0 ? 12 : 0,
            bottom: isLastInGroup ? 3 : 2,
          ),
          child: ChatMessageBubble(
            key: ValueKey<String>(message.id),
            message: message,
            isMine: isMine,
            isFirstInGroup: isFirstInGroup,
            isLastInGroup: isLastInGroup,
            resolveFileUrl: resolveFileUrl,
            onDelete: isMine
                ? () {
                    onDeleteMessage?.call(message.id);
                  }
                : null,
            onLongPress: () {
              onLongPressMessage?.call(message);
            },
            onReactionTap: (final String emoji) {
              onReactionTap?.call(
                message.id,
                emoji,
              );
            },
          ),
        );
      },
    );
  }

  bool _isFirstInGroup(final int index) {
    if (index == 0) {
      return true;
    }

    final ChatMessage currentMessage = messages[index];
    final ChatMessage previousMessage = messages[index - 1];

    return !_hasSameSender(
      currentMessage,
      previousMessage,
    );
  }

  bool _isLastInGroup(final int index) {
    if (index == messages.length - 1) {
      return true;
    }

    final ChatMessage currentMessage = messages[index];
    final ChatMessage nextMessage = messages[index + 1];

    return !_hasSameSender(
      currentMessage,
      nextMessage,
    );
  }

  bool _hasSameSender(
    final ChatMessage first,
    final ChatMessage second,
  ) {
    return first.senderUserId == second.senderUserId;
  }
}