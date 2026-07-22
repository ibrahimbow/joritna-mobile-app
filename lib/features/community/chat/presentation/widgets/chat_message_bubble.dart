import 'package:flutter/material.dart';

import '../../data/models/chat_message.dart';
import '../chat_texts.dart';
import 'chat_avatar.dart';
import 'chat_reaction_bar.dart';

class ChatMessageBubble extends StatefulWidget {
  const ChatMessageBubble({
    super.key,
    required this.message,
    required this.isMine,
    required this.isFirstInGroup,
    required this.isLastInGroup,
    this.onDelete,
    this.onReactionTap,
    this.onLongPress,
    this.resolveFileUrl,
  });

  final ChatMessage message;
  final bool isMine;
  final bool isFirstInGroup;
  final bool isLastInGroup;

  final VoidCallback? onDelete;
  final VoidCallback? onLongPress;

  final void Function(String emoji)? onReactionTap;

  final String Function(String? url)? resolveFileUrl;

  @override
  State<ChatMessageBubble> createState() =>
      _ChatMessageBubbleState();
}

final class _ChatMessageBubbleState
    extends State<ChatMessageBubble> {
  static const List<String> _availableReactions = <String>[
    '👍',
    '❤️',
    '😂',
    '😮',
    '🙏',
  ];

  bool _showActions = false;

  void _handleLongPress() {
    if (widget.message.isDeleted) {
      return;
    }

    setState(() {
      _showActions = !_showActions;
    });

    widget.onLongPress?.call();
  }

  void _handleReactionTap(final String emoji) {
    widget.onReactionTap?.call(emoji);

    setState(() {
      _showActions = false;
    });
  }

  void _handleDeleteTap() {
    widget.onDelete?.call();

    setState(() {
      _showActions = false;
    });
  }

  @override
  Widget build(final BuildContext context) {
    final ThemeData theme = Theme.of(context);

    final String? resolvedAvatarUrl =
        widget.resolveFileUrl?.call(
          widget.message.senderAvatarUrl,
        ) ??
        widget.message.senderAvatarUrl;

    final String? resolvedImageUrl =
        widget.resolveFileUrl?.call(
          widget.message.imageUrl,
        ) ??
        widget.message.imageUrl;

    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onLongPress: _handleLongPress,
      onTap: () {
        if (!_showActions) {
          return;
        }

        setState(() {
          _showActions = false;
        });
      },
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        mainAxisAlignment: widget.isMine
            ? MainAxisAlignment.end
            : MainAxisAlignment.start,
        children: [
          if (!widget.isMine)
            SizedBox(
              width: 42,
              child: widget.isLastInGroup
                  ? Padding(
                      padding: const EdgeInsets.only(
                        right: 6,
                      ),
                      child: ChatAvatar(
                        displayName:
                            widget.message.senderDisplayName,
                        avatarUrl: resolvedAvatarUrl,
                        size: 34,
                      ),
                    )
                  : const SizedBox.shrink(),
            ),
          Flexible(
            child: Column(
              crossAxisAlignment: widget.isMine
                  ? CrossAxisAlignment.end
                  : CrossAxisAlignment.start,
              children: [
                _BubbleContainer(
                  isMine: widget.isMine,
                  isDeleted: widget.message.isDeleted,
                  isFirstInGroup: widget.isFirstInGroup,
                  isLastInGroup: widget.isLastInGroup,
                  child: Column(
                    crossAxisAlignment:
                        CrossAxisAlignment.start,
                    children: [
                      if (!widget.isMine &&
                          widget.isFirstInGroup) ...[
                        Text(
                          widget.message.senderDisplayName,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: theme.textTheme.labelMedium
                              ?.copyWith(
                                color: const Color(
                                  0xFF2563EB,
                                ),
                                fontSize: 12,
                                fontWeight: FontWeight.w800,
                                height: 1.1,
                              ),
                        ),
                        const SizedBox(height: 5),
                      ],
                      if (widget.message.isDeleted)
                        Text(
                          ChatTexts.deletedMessage,
                          style: theme.textTheme.bodyMedium
                              ?.copyWith(
                                fontStyle: FontStyle.italic,
                                color: theme
                                    .colorScheme
                                    .onSurfaceVariant,
                              ),
                        )
                      else ...[
                        if (widget.message.hasImage &&
                            resolvedImageUrl != null)
                          _ChatImage(
                            imageUrl: resolvedImageUrl,
                          ),
                        if (widget.message.hasImage &&
                            widget.message.hasText)
                          const SizedBox(height: 8),
                        if (widget.message.hasText)
                          Text(
                            widget.message.content!,
                            style: theme.textTheme.bodyMedium
                                ?.copyWith(
                                  color: widget.isMine
                                      ? Colors.white
                                      : const Color(
                                          0xFF172033,
                                        ),
                                  fontSize: 14.5,
                                  height: 1.35,
                                ),
                          ),
                      ],
                      const SizedBox(height: 5),
                      Align(
                        alignment: Alignment.bottomRight,
                        widthFactor: 1,
                        child: Text(
                          _formatTime(
                            context,
                            widget.message.createdAt,
                          ),
                          style: theme.textTheme.labelSmall
                              ?.copyWith(
                                color: widget.isMine
                                    ? Colors.white.withValues(
                                        alpha: 0.68,
                                      )
                                    : const Color(
                                        0xFF64748B,
                                      ),
                                fontSize: 10,
                                fontWeight: FontWeight.w500,
                                height: 1,
                              ),
                        ),
                      ),
                    ],
                  ),
                ),
                if (widget.message.reactions.isNotEmpty)
                  Padding(
                    padding: EdgeInsets.only(
                      top: 4,
                      left: widget.isMine ? 0 : 5,
                      right: widget.isMine ? 5 : 0,
                    ),
                    child: ChatReactionBar(
                      reactions: widget.message.reactions,
                      onReactionTap: (reaction) {
                        widget.onReactionTap?.call(
                          reaction.emoji,
                        );
                      },
                    ),
                  ),
                if (_showActions &&
                    !widget.message.isDeleted)
                  _InlineMessageActions(
                    isMine: widget.isMine,
                    reactions: _availableReactions,
                    canDelete:
                        widget.isMine &&
                        widget.onDelete != null,
                    onReactionTap: _handleReactionTap,
                    onDelete: _handleDeleteTap,
                  ),
              ],
            ),
          ),
          if (widget.isMine)
            const SizedBox(width: 42),
        ],
      ),
    );
  }

  String _formatTime(
    final BuildContext context,
    final DateTime dateTime,
  ) {
    return TimeOfDay.fromDateTime(
      dateTime.toLocal(),
    ).format(context);
  }
}

final class _BubbleContainer extends StatelessWidget {
  const _BubbleContainer({
    required this.child,
    required this.isMine,
    required this.isDeleted,
    required this.isFirstInGroup,
    required this.isLastInGroup,
  });

  final Widget child;
  final bool isMine;
  final bool isDeleted;
  final bool isFirstInGroup;
  final bool isLastInGroup;

  @override
  Widget build(final BuildContext context) {
    final ThemeData theme = Theme.of(context);

    return IntrinsicWidth(
      child: ConstrainedBox(
        constraints: BoxConstraints(
          minWidth: 76,
          maxWidth:
              MediaQuery.sizeOf(context).width * 0.76,
        ),
        child: Container(
          padding: const EdgeInsets.fromLTRB(
            12,
            8,
            12,
            7,
          ),
          decoration: BoxDecoration(
            color: isDeleted
                ? theme
                      .colorScheme
                      .surfaceContainerHighest
                : isMine
                ? const Color(0xFF2563EB)
                : Colors.white,
            border: !isMine && !isDeleted
                ? Border.all(
                    color: const Color(0xFFE2E8F0),
                  )
                : null,
            borderRadius: _resolveBorderRadius(),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(
                  alpha: 0.035,
                ),
                blurRadius: 8,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          child: child,
        ),
      ),
    );
  }

  BorderRadius _resolveBorderRadius() {
    const Radius largeRadius = Radius.circular(18);
    const Radius groupedRadius = Radius.circular(6);

    if (isMine) {
      return BorderRadius.only(
        topLeft: largeRadius,
        bottomLeft: largeRadius,
        topRight: isFirstInGroup
            ? largeRadius
            : groupedRadius,
        bottomRight: isLastInGroup
            ? groupedRadius
            : largeRadius,
      );
    }

    return BorderRadius.only(
      topRight: largeRadius,
      bottomRight: largeRadius,
      topLeft: isFirstInGroup
          ? largeRadius
          : groupedRadius,
      bottomLeft: isLastInGroup
          ? groupedRadius
          : largeRadius,
    );
  }
}

final class _InlineMessageActions extends StatelessWidget {
  const _InlineMessageActions({
    required this.isMine,
    required this.reactions,
    required this.canDelete,
    required this.onReactionTap,
    required this.onDelete,
  });

  final bool isMine;
  final List<String> reactions;
  final bool canDelete;
  final ValueChanged<String> onReactionTap;
  final VoidCallback onDelete;

  @override
  Widget build(final BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        top: 8,
        left: isMine ? 0 : 4,
        right: isMine ? 4 : 0,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          for (final String emoji in reactions)
            _ReactionAction(
              emoji: emoji,
              onTap: () {
                onReactionTap(emoji);
              },
            ),
          if (canDelete) ...[
            const SizedBox(width: 6),
            _DeleteAction(
              onTap: onDelete,
            ),
          ],
        ],
      ),
    );
  }
}

final class _ReactionAction extends StatelessWidget {
  const _ReactionAction({
    required this.emoji,
    required this.onTap,
  });

  final String emoji;
  final VoidCallback onTap;

  @override
  Widget build(final BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 6),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(18),
        child: Container(
          width: 34,
          height: 34,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: Colors.white,
            shape: BoxShape.circle,
            border: Border.all(
              color: const Color(0xFFE2E8F0),
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(
                  alpha: 0.04,
                ),
                blurRadius: 8,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          child: Text(
            emoji,
            style: const TextStyle(fontSize: 17),
          ),
        ),
      ),
    );
  }
}

final class _DeleteAction extends StatelessWidget {
  const _DeleteAction({
    required this.onTap,
  });

  final VoidCallback onTap;

  @override
  Widget build(final BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(18),
      child: Container(
        width: 34,
        height: 34,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: Colors.white,
          shape: BoxShape.circle,
          border: Border.all(
            color: const Color(0xFFE2E8F0),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(
                alpha: 0.04,
              ),
              blurRadius: 8,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: const Icon(
          Icons.delete_outline_rounded,
          size: 20,
          color: Color(0xFF64748B),
        ),
      ),
    );
  }
}

final class _ChatImage extends StatelessWidget {
  const _ChatImage({
    required this.imageUrl,
  });

  final String imageUrl;

  @override
  Widget build(final BuildContext context) {
    final ThemeData theme = Theme.of(context);

    return ClipRRect(
      borderRadius: BorderRadius.circular(12),
      child: Image.network(
        imageUrl,
        fit: BoxFit.cover,
        errorBuilder: (
          final BuildContext context,
          final Object error,
          final StackTrace? stackTrace,
        ) {
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