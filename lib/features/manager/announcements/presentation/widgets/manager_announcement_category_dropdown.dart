import 'package:flutter/material.dart';

import '../../data/models/manager_announcement.dart';

class ManagerAnnouncementCategoryDropdown extends StatelessWidget {
  final AnnouncementCategory value;
  final ValueChanged<AnnouncementCategory?> onChanged;

  const ManagerAnnouncementCategoryDropdown({
    super.key,
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<AnnouncementCategory>(
      initialValue: value,
      decoration: const InputDecoration(
        labelText: 'Category',
        border: OutlineInputBorder(),
      ),
      items: AnnouncementCategory.values.map((category) {
        return DropdownMenuItem(value: category, child: Text(category.label));
      }).toList(),
      onChanged: onChanged,
    );
  }
}
