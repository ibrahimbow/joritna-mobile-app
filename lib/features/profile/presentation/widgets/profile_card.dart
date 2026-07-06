import 'package:flutter/material.dart';

import '../../../../core/file/file_url_resolver.dart';
import '../../data/models/current_user_profile.dart';
import '../sheets/edit_profile_sheet.dart';
import 'profile_info_tile.dart';

class ProfileCard extends StatelessWidget {
  const ProfileCard({super.key, required this.profile});

  final CurrentUserProfile profile;

  @override
  Widget build(BuildContext context) {
    final avatarUrl = FileUrlResolver.resolve(profile.avatarUrl);

    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(28),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.08),
              blurRadius: 24,
              offset: const Offset(0, 12),
            ),
          ],
        ),
        child: Column(
          children: [
            CircleAvatar(
              radius: 48,
              backgroundColor: const Color(0xFFE2E7FF),
              backgroundImage: avatarUrl.isNotEmpty
                  ? NetworkImage(avatarUrl)
                  : null,
              child: avatarUrl.isEmpty
                  ? Text(
                      profile.displayName.isNotEmpty
                          ? profile.displayName.substring(0, 1).toUpperCase()
                          : '?',
                      style: const TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.w900,
                      ),
                    )
                  : null,
            ),
            const SizedBox(height: 16),
            Text(
              profile.displayName,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w900),
            ),
            const SizedBox(height: 4),
            Text(profile.email, style: TextStyle(color: Colors.grey.shade600)),
            const SizedBox(height: 24),
            ProfileInfoTile(
              icon: Icons.person_outline,
              label: 'Username',
              value: profile.username,
            ),
            ProfileInfoTile(
              icon: Icons.phone_outlined,
              label: 'Phone number',
              value: profile.phoneNumber,
            ),
            ProfileInfoTile(
              icon: Icons.language_outlined,
              label: 'Language',
              value: profile.preferredLanguage,
            ),
            ProfileInfoTile(
              icon: Icons.verified_user_outlined,
              label: 'Role',
              value: profile.role.displayName,
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              height: 52,
              child: FilledButton.icon(
                onPressed: () {
                  showModalBottomSheet<void>(
                    context: context,
                    isScrollControlled: true,
                    useSafeArea: true,
                    builder: (_) => EditProfileSheet(profile: profile),
                  );
                },
                icon: const Icon(Icons.edit_outlined),
                label: const Text('Edit profile'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
