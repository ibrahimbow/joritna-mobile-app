import 'package:flutter/material.dart';

import '../../data/models/chat_message.dart';
import '../chat_texts.dart';
import 'chat_avatar.dart';
import 'chat_reaction_bar.dart';

class ChatMessageBubble extends StatelessWidget {
  const ChatMessageBubble({
    super.key,
    required this.message,
    required this.isMine,
    this.onDelete,
    this.onReactionTap,
    this.onLongPress,
    this.resolveFileUrl,
  });

  final ChatMessage message;
  final bool isMine;
  final VoidCallback? onDelete;
  final VoidCallback? onLongPress;
  final void Function(String emoji)? onReactionTap;
  final String Function(String? url)? resolveFileUrl;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final resolvedAvatarUrl =
        resolveFileUrl?.call(message.senderAvatarUrl) ??
        message.senderAvatarUrl;

    final resolvedImageUrl =
        resolveFileUrl?.call(message.imageUrl) ?? message.imageUrl;

    return GestureDetector(
      onLongPress: onLongPress,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        mainAxisAlignment: isMine
            ? MainAxisAlignment.end
            : MainAxisAlignment.start,
        children: [
          if (!isMine)
            Padding(
              padding: const EdgeInsets.only(right: 8),
              child: ChatAvatar(
                displayName: message.senderDisplayName,
                avatarUrl: resolvedAvatarUrl,
              ),
            ),
          Flexible(
            child: Column(
              crossAxisAlignment: isMine
                  ? CrossAxisAlignment.end
                  : CrossAxisAlignment.start,
              children: [
                if (!isMine)
                  Padding(
                    padding: const EdgeInsets.only(left: 4, bottom: 4),
                    child: Text(
                      message.senderDisplayName,
                      style: theme.textTheme.labelMedium?.copyWith(
                        fontWeight: FontWeight.w700,
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ),
                _BubbleContainer(
                  isMine: isMine,
                  isDeleted: message.isDeleted,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (message.isDeleted)
                        Text(
                          ChatTexts.deletedMessage,
                          style: theme.textTheme.bodyMedium?.copyWith(
                            fontStyle: FontStyle.italic,
                            color: theme.colorScheme.onSurfaceVariant,
                          ),
                        )
                      else ...[
                        if (message.hasImage && resolvedImageUrl != null)
                          _ChatImage(imageUrl: resolvedImageUrl),
                        if (message.hasImage && message.hasText)
                          const SizedBox(height: 8),
                        if (message.hasText)
                          Text(
                            message.content!,
                            style: theme.textTheme.bodyMedium?.copyWith(
                              color: isMine
                                  ? theme.colorScheme.onPrimary
                                  : theme.colorScheme.onSurface,
                            ),
                          ),
                      ],
                      const SizedBox(height: 6),
                      Align(
                        alignment: Alignment.bottomRight,
                        child: Text(
                          _formatTime(context, message.createdAt),
                          style: theme.textTheme.labelSmall?.copyWith(
                            color: message.isDeleted
                                ? theme.colorScheme.onSurfaceVariant
                                : isMine
                                ? theme.colorScheme.onPrimary.withValues(
                                    alpha: 0.75,
                                  )
                                : theme.colorScheme.onSurfaceVariant,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                if (message.reactions.isNotEmpty)
                  Padding(
                    padding: const EdgeInsets.only(top: 6),
                    child: ChatReactionBar(
                      reactions: message.reactions,
                      onReactionTap: (reaction) =>
                          onReactionTap?.call(reaction.emoji),
                    ),
                  ),
                if (isMine && !message.isDeleted && onDelete != null)
                  Padding(
                    padding: const EdgeInsets.only(top: 2, right: 4),
                    child: InkWell(
                      onTap: onDelete,
                      borderRadius: BorderRadius.circular(12),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 6,
                          vertical: 3,
                        ),
                        child: Text(
                          'Delete',
                          style: theme.textTheme.labelSmall?.copyWith(
                            color: theme.colorScheme.error,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ),
          if (isMine) const SizedBox(width: 44),
        ],
      ),
    );
  }

  String _formatTime(BuildContext context, DateTime dateTime) {
    final localTime = dateTime.toLocal();

    return TimeOfDay.fromDateTime(localTime).format(context);
  }
}

class _BubbleContainer extends StatelessWidget {
  const _BubbleContainer({
    required this.child,
    required this.isMine,
    required this.isDeleted,
  });

  final Widget child;
  final bool isMine;
  final bool isDeleted;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      constraints: BoxConstraints(
        maxWidth: MediaQuery.sizeOf(context).width * 0.74,
      ),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(
        color: isDeleted
            ? theme.colorScheme.surfaceContainerHighest
            : isMine
            ? theme.colorScheme.primary
            : theme.colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.only(
          topLeft: const Radius.circular(18),
          topRight: const Radius.circular(18),
          bottomLeft: Radius.circular(isMine ? 18 : 6),
          bottomRight: Radius.circular(isMine ? 6 : 18),
        ),
      ),
      child: child,
    );
  }
}

class _ChatImage extends StatelessWidget {
  const _ChatImage({required this.imageUrl});

  final String imageUrl;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return ClipRRect(
      borderRadius: BorderRadius.circular(12),
      child: Image.network(
        imageUrl,
        fit: BoxFit.cover,
        errorBuilder: (_, __, ___) {
          return Container(
            height: 140,
            alignment: Alignment.center,
            color: theme.colorScheme.surface,
            child: Icon(
              Icons.broken_image_outlined,
              color: theme.colorScheme.outline,
            ),
          );
        },
      ),
    );
  }
}
