import 'package:flutter/material.dart';

import '../../data/models/manager_building_tenant.dart';

const List<Map<String, Color>> _avatarColors = [
  {'bg': Color(0xFFE0F2FE), 'text': Color(0xFF0369A1)},
  {'bg': Color(0xFFDCFCE7), 'text': Color(0xFF15803D)},
  {'bg': Color(0xFFF3E8FF), 'text': Color(0xFF7E22CE)},
  {'bg': Color(0xFFFEF3C7), 'text': Color(0xFFB45309)},
  {'bg': Color(0xFFFCE7F3), 'text': Color(0xFFBE185D)},
];

TableRow tenantTableRowBuilder({
  required int index,
  required ManagerBuildingTenant tenant,
  required bool isRemoving,
  required VoidCallback onRemove,
  required VoidCallback onOpenDetails,
}) {
  final colorPair = _avatarColors[index % _avatarColors.length];

  return TableRow(
    decoration: const BoxDecoration(
      color: Colors.white,
      border: Border(bottom: BorderSide(color: Color(0xFFE2E8F0))),
    ),
    children: [
      _TableCellWrapper(
        onTap: onOpenDetails,
        child: Row(
          children: [
            Container(
              width: 29,
              height: 29,
              decoration: BoxDecoration(
                color: colorPair['bg'],
                shape: BoxShape.circle,
              ),
              alignment: Alignment.center,
              child: Text(
                tenant.username.isNotEmpty
                    ? tenant.username[0].toUpperCase()
                    : '?',
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w900,
                  color: colorPair['text'],
                ),
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                tenant.username,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  fontSize: 11.5,
                  fontWeight: FontWeight.w800,
                  color: Color(0xFF0F172A),
                ),
              ),
            ),
          ],
        ),
      ),
      _TableCellWrapper(
        onTap: onOpenDetails,
        child: Text(
          tenant.phoneNumber?.isNotEmpty == true ? tenant.phoneNumber! : '-',
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
      ),
      _TableCellWrapper(
        onTap: onOpenDetails,
        child: Text(tenant.email, maxLines: 1, overflow: TextOverflow.ellipsis),
      ),
      _TableCellWrapper(
        child: Center(
          child: isRemoving
              ? const SizedBox(
                  width: 14,
                  height: 14,
                  child: CircularProgressIndicator(strokeWidth: 2),
                )
              : IconButton(
                  onPressed: onRemove,
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(
                    minWidth: 24,
                    minHeight: 24,
                  ),
                  splashRadius: 16,
                  icon: const Icon(
                    Icons.delete_outline_rounded,
                    size: 18,
                    color: Color(0xFFE11D25),
                  ),
                ),
        ),
      ),
    ],
  );
}

class _TableCellWrapper extends StatelessWidget {
  const _TableCellWrapper({required this.child, this.onTap});

  final Widget child;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final content = Padding(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 10),
      child: Align(
        alignment: Alignment.centerLeft,
        child: DefaultTextStyle(
          style: const TextStyle(
            fontSize: 11,
            fontWeight: FontWeight.w600,
            color: Color(0xFF334155),
          ),
          child: child,
        ),
      ),
    );

    if (onTap == null) {
      return content;
    }

    return InkWell(onTap: onTap, child: content);
  }
}
