import 'package:flutter/material.dart';

class ChatReactionPicker extends StatelessWidget {
  const ChatReactionPicker({super.key, required this.onReactionSelected});

  final ValueChanged<String> onReactionSelected;

  static const List<String> _defaultReactions = [
    '👍',
    '❤️',
    '😂',
    '😮',
    '👏',
    '🎉',
  ];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Material(
      elevation: 8,
      borderRadius: BorderRadius.circular(28),
      color: theme.colorScheme.surface,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: _defaultReactions
              .map((emoji) {
                return InkWell(
                  borderRadius: BorderRadius.circular(24),
                  onTap: () => onReactionSelected(emoji),
                  child: Padding(
                    padding: const EdgeInsets.all(8),
                    child: Text(emoji, style: const TextStyle(fontSize: 24)),
                  ),
                );
              })
              .toList(growable: false),
        ),
      ),
    );
  }
}
