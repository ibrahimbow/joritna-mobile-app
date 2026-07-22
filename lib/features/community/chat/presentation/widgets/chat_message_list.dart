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
  Widget build(final BuildContext context) {
    if (loading) {
      return const ChatLoadingState();
    }

    if (messages.isEmpty) {
      return const ChatEmptyState();
    }

    return ListView.builder(
      controller: scrollController,
      padding: const EdgeInsets.fromLTRB(12, 16, 12, 20),
      physics: const BouncingScrollPhysics(),
      itemCount: messages.length,
      itemBuilder: (final BuildContext context, final int index) {
        final ChatMessage message = messages[index];

        final bool isMine =
            currentUserId != null && message.isOwnedBy(currentUserId!);

        final bool startsNewDay = _startsNewDay(index);
        final bool isFirstInGroup = _isFirstInGroup(index);
        final bool isLastInGroup = _isLastInGroup(index);

        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            if (startsNewDay)
              Padding(
                padding: EdgeInsets.only(top: index == 0 ? 0 : 18, bottom: 14),
                child: _ChatDateSeparator(date: message.createdAt),
              ),
            Padding(
              padding: EdgeInsets.only(
                top: isFirstInGroup && !startsNewDay && index > 0 ? 12 : 0,
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
                  onReactionTap?.call(message.id, emoji);
                },
              ),
            ),
          ],
        );
      },
    );
  }

  bool _startsNewDay(final int index) {
    if (index == 0) {
      return true;
    }

    final DateTime currentDate = messages[index].createdAt.toLocal();

    final DateTime previousDate = messages[index - 1].createdAt.toLocal();

    return !_isSameCalendarDay(currentDate, previousDate);
  }

  bool _isFirstInGroup(final int index) {
    if (index == 0 || _startsNewDay(index)) {
      return true;
    }

    final ChatMessage currentMessage = messages[index];
    final ChatMessage previousMessage = messages[index - 1];

    return !_hasSameSender(currentMessage, previousMessage);
  }

  bool _isLastInGroup(final int index) {
    if (index == messages.length - 1) {
      return true;
    }

    if (_startsNewDay(index + 1)) {
      return true;
    }

    final ChatMessage currentMessage = messages[index];
    final ChatMessage nextMessage = messages[index + 1];

    return !_hasSameSender(currentMessage, nextMessage);
  }

  bool _hasSameSender(final ChatMessage first, final ChatMessage second) {
    return first.senderUserId == second.senderUserId;
  }

  bool _isSameCalendarDay(final DateTime first, final DateTime second) {
    return first.year == second.year &&
        first.month == second.month &&
        first.day == second.day;
  }
}

final class _ChatDateSeparator extends StatelessWidget {
  const _ChatDateSeparator({required this.date});

  final DateTime date;

  @override
  Widget build(final BuildContext context) {
    return Align(
      alignment: Alignment.center,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
        decoration: BoxDecoration(
          color: const Color(0xFFF1F5F9),
          borderRadius: BorderRadius.circular(999),
        ),
        child: Text(
          _formatDate(date),
          style: const TextStyle(
            color: Color(0xFF64748B),
            fontSize: 11,
            fontWeight: FontWeight.w800,
          ),
        ),
      ),
    );
  }

  String _formatDate(final DateTime value) {
    final DateTime localDate = value.toLocal();
    final DateTime now = DateTime.now();

    final DateTime today = DateTime(now.year, now.month, now.day);

    final DateTime messageDay = DateTime(
      localDate.year,
      localDate.month,
      localDate.day,
    );

    final int difference = today.difference(messageDay).inDays;

    if (difference == 0) {
      return 'Today';
    }

    if (difference == 1) {
      return 'Yesterday';
    }

    return '${localDate.day.toString().padLeft(2, '0')} '
        '${_monthName(localDate.month)} '
        '${localDate.year}';
  }

  String _monthName(final int month) {
    return switch (month) {
      1 => 'Jan',
      2 => 'Feb',
      3 => 'Mar',
      4 => 'Apr',
      5 => 'May',
      6 => 'Jun',
      7 => 'Jul',
      8 => 'Aug',
      9 => 'Sep',
      10 => 'Oct',
      11 => 'Nov',
      12 => 'Dec',
      _ => '',
    };
  }
}
