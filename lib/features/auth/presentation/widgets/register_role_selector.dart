import 'package:flutter/material.dart';

import '../../../../core/user/user_role.dart';
import 'role_option_card.dart';

class RegisterRoleSelector extends StatelessWidget {
  const RegisterRoleSelector({
    required this.selectedRole,
    required this.onChanged,
    super.key,
  });

  final UserRole selectedRole;
  final ValueChanged<UserRole> onChanged;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: RoleOptionCard(
            title: 'Tenant',
            subtitle: 'Join a building',
            icon: Icons.home_outlined,
            isSelected: selectedRole == UserRole.tenant,
            onTap: () => onChanged(UserRole.tenant),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: RoleOptionCard(
            title: 'Manager',
            subtitle: 'Manage building',
            icon: Icons.apartment_rounded,
            isSelected: selectedRole == UserRole.manager,
            onTap: () => onChanged(UserRole.manager),
          ),
        ),
      ],
    );
  }
}
