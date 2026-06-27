import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../shared/presentation/layout/app_shell.dart';
import '../data/announcement_providers.dart';
import 'widgets/announcement_card.dart';
import 'widgets/announcement_empty_state.dart';

class AnnouncementsScreen extends ConsumerWidget {
  const AnnouncementsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final announcementsState = ref.watch(tenantAnnouncementsProvider);

    return AppShell(
      selectedIndex: 2,
      child: SafeArea(
        child: RefreshIndicator(
          onRefresh: () async {
            ref.invalidate(tenantAnnouncementsProvider);
          },
          child: announcementsState.when(
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (_, __) => ListView(
              padding: const EdgeInsets.all(24),
              children: const [
                AnnouncementEmptyState(
                  title: 'Could not load announcements',
                  message: 'Please pull down to refresh and try again.',
                  icon: Icons.error_outline_rounded,
                ),
              ],
            ),
            data: (announcements) {
              if (announcements.isEmpty) {
                return ListView(
                  padding: const EdgeInsets.all(24),
                  children: const [
                    AnnouncementEmptyState(
                      title: 'No announcements yet',
                      message:
                          'Your building manager has not posted any announcements yet.',
                      icon: Icons.campaign_outlined,
                    ),
                  ],
                );
              }

              return ListView.separated(
                padding: const EdgeInsets.fromLTRB(20, 20, 20, 32),
                itemCount: announcements.length + 1,
                separatorBuilder: (_, index) {
                  if (index == 0) {
                    return const SizedBox(height: 20);
                  }

                  return const SizedBox(height: 16);
                },
                itemBuilder: (context, index) {
                  if (index == 0) {
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Announcements',
                          style: TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          'Official updates from your building manager.',
                          style: TextStyle(
                            fontSize: 15,
                            color: Colors.grey.shade600,
                          ),
                        ),
                      ],
                    );
                  }

                  final announcement = announcements[index - 1];

                  return AnnouncementCard(announcement: announcement);
                },
              );
            },
          ),
        ),
      ),
    );
  }
}
