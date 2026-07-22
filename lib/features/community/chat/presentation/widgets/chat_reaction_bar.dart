import 'package:flutter/material.dart';

import '../../data/models/chat_reaction_summary.dart';

class ChatReactionBar extends StatelessWidget {
  const ChatReactionBar({
    super.key,
    required this.reactions,
    this.onReactionTap,
  });

  final List<ChatReactionSummary> reactions;

  final ValueChanged<ChatReactionSummary>? onReactionTap;

  @override
  Widget build(final BuildContext context) {
    if (reactions.isEmpty) {
      return const SizedBox.shrink();
    }

    return Wrap(
      spacing: 4,
      runSpacing: 4,
      children: reactions
          .map((final ChatReactionSummary reaction) {
            return _ReactionPill(
              reaction: reaction,
              onTap: onReactionTap == null
                  ? null
                  : () {
                      onReactionTap!(reaction);
                    },
            );
          })
          .toList(growable: false),
    );
  }
}

final class _ReactionPill extends StatelessWidget {
  const _ReactionPill({required this.reaction, this.onTap});

  final ChatReactionSummary reaction;
  final VoidCallback? onTap;

  @override
  Widget build(final BuildContext context) {
    final bool selected = reaction.reactedByCurrentUser;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(999),
        child: Container(
          height: 24,
          padding: const EdgeInsets.symmetric(horizontal: 7),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(999),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: selected ? 0.10 : 0.07),
                blurRadius: selected ? 6 : 4,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                reaction.emoji,
                style: const TextStyle(fontSize: 13, height: 1),
              ),
              const SizedBox(width: 3),
              Text(
                '${reaction.count}',
                style: TextStyle(
                  color: selected
                      ? const Color(0xFF2563EB)
                      : const Color(0xFF475569),
                  fontSize: 10,
                  fontWeight: FontWeight.w700,
                  height: 1,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
