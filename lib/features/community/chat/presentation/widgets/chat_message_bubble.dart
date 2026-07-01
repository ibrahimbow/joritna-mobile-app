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
  State<ChatMessageBubble> createState() => _ChatMessageBubbleState();
}

class _ChatMessageBubbleState extends State<ChatMessageBubble> {
  static const List<String> _availableReactions = [
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

  void _handleReactionTap(String emoji) {
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
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final resolvedAvatarUrl =
        widget.resolveFileUrl?.call(widget.message.senderAvatarUrl) ??
        widget.message.senderAvatarUrl;

    final resolvedImageUrl =
        widget.resolveFileUrl?.call(widget.message.imageUrl) ??
        widget.message.imageUrl;

    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onLongPress: _handleLongPress,
      onTap: () {
        if (_showActions) {
          setState(() => _showActions = false);
        }
      },
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        mainAxisAlignment: widget.isMine
            ? MainAxisAlignment.end
            : MainAxisAlignment.start,
        children: [
          if (!widget.isMine)
            Padding(
              padding: const EdgeInsets.only(right: 8),
              child: ChatAvatar(
                displayName: widget.message.senderDisplayName,
                avatarUrl: resolvedAvatarUrl,
              ),
            ),
          Flexible(
            child: Column(
              crossAxisAlignment: widget.isMine
                  ? CrossAxisAlignment.end
                  : CrossAxisAlignment.start,
              children: [
                if (!widget.isMine)
                  Padding(
                    padding: const EdgeInsets.only(left: 4, bottom: 4),
                    child: Text(
                      widget.message.senderDisplayName,
                      style: theme.textTheme.labelMedium?.copyWith(
                        fontWeight: FontWeight.w700,
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ),
                _BubbleContainer(
                  isMine: widget.isMine,
                  isDeleted: widget.message.isDeleted,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (widget.message.isDeleted)
                        Text(
                          ChatTexts.deletedMessage,
                          style: theme.textTheme.bodyMedium?.copyWith(
                            fontStyle: FontStyle.italic,
                            color: theme.colorScheme.onSurfaceVariant,
                          ),
                        )
                      else ...[
                        if (widget.message.hasImage && resolvedImageUrl != null)
                          _ChatImage(imageUrl: resolvedImageUrl),
                        if (widget.message.hasImage && widget.message.hasText)
                          const SizedBox(height: 8),
                        if (widget.message.hasText)
                          Text(
                            widget.message.content!,
                            style: theme.textTheme.bodyMedium?.copyWith(
                              color: widget.isMine
                                  ? theme.colorScheme.onPrimary
                                  : theme.colorScheme.onSurface,
                            ),
                          ),
                      ],
                      const SizedBox(height: 5),
                      Align(
                        widthFactor: 1,
                        alignment: Alignment.bottomRight,
                        child: Text(
                          _formatTime(context, widget.message.createdAt),
                          style: theme.textTheme.labelSmall?.copyWith(
                            fontSize: 10,
                            height: 1,
                            fontWeight: FontWeight.w500,
                            color: widget.message.isDeleted
                                ? theme.colorScheme.onSurfaceVariant.withValues(
                                    alpha: 0.65,
                                  )
                                : widget.isMine
                                ? Colors.white.withValues(alpha: 0.65)
                                : theme.colorScheme.onSurfaceVariant.withValues(
                                    alpha: 0.70,
                                  ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                if (widget.message.reactions.isNotEmpty)
                  Padding(
                    padding: const EdgeInsets.only(top: 6),
                    child: ChatReactionBar(
                      reactions: widget.message.reactions,
                      onReactionTap: (reaction) =>
                          widget.onReactionTap?.call(reaction.emoji),
                    ),
                  ),
                if (_showActions && !widget.message.isDeleted)
                  _InlineMessageActions(
                    isMine: widget.isMine,
                    reactions: _availableReactions,
                    canDelete: widget.isMine && widget.onDelete != null,
                    onReactionTap: _handleReactionTap,
                    onDelete: _handleDeleteTap,
                  ),
              ],
            ),
          ),
          if (widget.isMine) const SizedBox(width: 44),
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

    return IntrinsicWidth(
      child: ConstrainedBox(
        constraints: BoxConstraints(
          minWidth: 72,
          maxWidth: MediaQuery.sizeOf(context).width * 0.74,
        ),
        child: Container(
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
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.04),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: child,
        ),
      ),
    );
  }
}

class _InlineMessageActions extends StatelessWidget {
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
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        top: 8,
        left: isMine ? 0 : 4,
        right: isMine ? 4 : 0,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          for (final emoji in reactions)
            _ReactionAction(emoji: emoji, onTap: () => onReactionTap(emoji)),
          if (canDelete) ...[
            const SizedBox(width: 6),
            _DeleteAction(onTap: onDelete),
          ],
        ],
      ),
    );
  }
}

class _ReactionAction extends StatelessWidget {
  const _ReactionAction({required this.emoji, required this.onTap});

  final String emoji;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
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
            border: Border.all(color: const Color(0xFFE2E8F0)),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.04),
                blurRadius: 8,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          child: Text(emoji, style: const TextStyle(fontSize: 17)),
        ),
      ),
    );
  }
}

class _DeleteAction extends StatelessWidget {
  const _DeleteAction({required this.onTap});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
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
          border: Border.all(color: const Color(0xFFE2E8F0)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.04),
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
