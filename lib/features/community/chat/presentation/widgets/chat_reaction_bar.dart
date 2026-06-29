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
  Widget build(BuildContext context) {
    if (reactions.isEmpty) {
      return const SizedBox.shrink();
    }

    return Wrap(
      spacing: 6,
      runSpacing: 6,
      children: reactions
          .map((reaction) {
            final selected = reaction.reactedByCurrentUser;

            return InkWell(
              borderRadius: BorderRadius.circular(16),
              onTap: onReactionTap == null
                  ? null
                  : () => onReactionTap!(reaction),
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: selected
                      ? Theme.of(context).colorScheme.primaryContainer
                      : Theme.of(context).colorScheme.surfaceContainerHighest,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: selected
                        ? Theme.of(context).colorScheme.primary
                        : Colors.transparent,
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(reaction.emoji, style: const TextStyle(fontSize: 16)),
                    const SizedBox(width: 4),
                    Text(
                      '${reaction.count}',
                      style: Theme.of(context).textTheme.labelMedium,
                    ),
                  ],
                ),
              ),
            );
          })
          .toList(growable: false),
    );
  }
}
