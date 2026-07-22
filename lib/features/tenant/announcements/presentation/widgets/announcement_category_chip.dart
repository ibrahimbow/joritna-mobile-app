import 'package:flutter/material.dart';

class AnnouncementCategoryChip extends StatelessWidget {
  const AnnouncementCategoryChip({super.key, required this.category});

  final String category;

  @override
  Widget build(final BuildContext context) {
    final String normalizedCategory = category.trim().toUpperCase();

    return Align(
      alignment: Alignment.centerLeft,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
        decoration: BoxDecoration(
          color: _backgroundColor(normalizedCategory),
          borderRadius: BorderRadius.circular(999),
        ),
        child: Text(
          _label(normalizedCategory),
          style: TextStyle(
            color: _textColor(normalizedCategory),
            fontSize: 11,
            fontWeight: FontWeight.w900,
          ),
        ),
      ),
    );
  }

  String _label(final String category) {
    return switch (category) {
      'EMERGENCY' => 'Emergency',
      'MAINTENANCE' => 'Maintenance',
      'EVENT' => 'Event',
      'REMINDER' => 'Reminder',
      'SAFETY' => 'Safety',
      _ => 'General',
    };
  }

  Color _backgroundColor(final String category) {
    return switch (category) {
      'EMERGENCY' => Colors.red.shade50,
      'MAINTENANCE' => Colors.orange.shade50,
      'EVENT' => Colors.purple.shade50,
      'REMINDER' => Colors.blue.shade50,
      'SAFETY' => Colors.green.shade50,
      _ => Colors.grey.shade100,
    };
  }

  Color _textColor(final String category) {
    return switch (category) {
      'EMERGENCY' => Colors.red.shade700,
      'MAINTENANCE' => Colors.orange.shade800,
      'EVENT' => Colors.purple.shade700,
      'REMINDER' => Colors.blue.shade700,
      'SAFETY' => Colors.green.shade700,
      _ => Colors.grey.shade700,
    };
  }
}
