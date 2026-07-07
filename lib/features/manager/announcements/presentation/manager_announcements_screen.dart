import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/router/app_routes.dart';
import '../../../shared/presentation/layout/app_shell.dart';
import '../../building/data/manager_building_providers.dart';
import '../data/manager_announcement_providers.dart';
import '../data/models/manager_announcement.dart';
import 'widgets/manager_announcement_card.dart';
import 'widgets/manager_announcement_empty_state.dart';

class ManagerAnnouncementsScreen extends ConsumerStatefulWidget {
  const ManagerAnnouncementsScreen({super.key});

  @override
  ConsumerState<ManagerAnnouncementsScreen> createState() =>
      _ManagerAnnouncementsScreenState();
}

class _ManagerAnnouncementsScreenState
    extends ConsumerState<ManagerAnnouncementsScreen> {
  bool _isValidatingBuilding = true;

  @override
  void initState() {
    super.initState();
    _validateManagerBuilding();
  }

  Future<void> _validateManagerBuilding() async {
    final hasBuilding = await ref
        .read(managerBuildingRepositoryProvider)
        .hasMyManagedBuilding();

    if (!mounted) return;

    if (!hasBuilding) {
      context.go(AppRoutes.managerBuilding);
      return;
    }

    setState(() => _isValidatingBuilding = false);
  }

  Future<void> _deleteAnnouncement(ManagerAnnouncement announcement) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Delete announcement'),
          content: Text(
            'Are you sure you want to delete "${announcement.title}"?',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: const Text('Cancel'),
            ),
            FilledButton(
              onPressed: () => Navigator.pop(context, true),
              child: const Text('Delete'),
            ),
          ],
        );
      },
    );

    if (confirmed != true) return;

    await ref
        .read(managerAnnouncementRepositoryProvider)
        .deleteAnnouncement(announcement.id);

    ref.invalidate(managerAnnouncementsProvider);

    if (!mounted) return;

    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text('Announcement deleted.')));
  }

  @override
  Widget build(BuildContext context) {
    final announcementsState = ref.watch(managerAnnouncementsProvider);

    return AppShell(
      selectedIndex: 2,
      backgroundColor: const Color(0xFFEFF6FF),
      child: SafeArea(
        child: _isValidatingBuilding
            ? const Center(child: CircularProgressIndicator())
            : announcementsState.when(
                loading: () => const Center(child: CircularProgressIndicator()),
                error: (_, __) => const ManagerAnnouncementEmptyState(
                  title: 'Could not load announcements',
                  message: 'Please try again in a moment.',
                  icon: Icons.error_outline_rounded,
                ),
                data: (announcements) {
                  return RefreshIndicator(
                    onRefresh: () async {
                      ref.invalidate(managerAnnouncementsProvider);
                    },
                    child: ListView.separated(
                      padding: const EdgeInsets.fromLTRB(20, 20, 20, 32),
                      itemCount: announcements.isEmpty
                          ? 2
                          : announcements.length + 1,
                      separatorBuilder: (_, __) => const SizedBox(height: 16),
                      itemBuilder: (context, index) {
                        if (index == 0) {
                          return _Header(
                            onCreatePressed: () {
                              context.push(AppRoutes.managerCreateAnnouncement);
                            },
                          );
                        }

                        if (announcements.isEmpty) {
                          return const ManagerAnnouncementEmptyState(
                            title: 'No announcements yet',
                            message:
                                'Create your first announcement for your building tenants.',
                            icon: Icons.campaign_outlined,
                          );
                        }

                        final announcement = announcements[index - 1];

                        return ManagerAnnouncementCard(
                          announcement: announcement,
                          onEdit: () {
                            context.push(
                              AppRoutes.managerEditAnnouncement,
                              extra: announcement,
                            );
                          },
                          onDelete: () => _deleteAnnouncement(announcement),
                        );
                      },
                    ),
                  );
                },
              ),
      ),
    );
  }
}

class _Header extends StatelessWidget {
  final VoidCallback onCreatePressed;

  const _Header({required this.onCreatePressed});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Announcements',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.w800,
                  color: Color(0xFF0F172A),
                ),
              ),
              SizedBox(height: 6),
              Text(
                'Manage official building updates.',
                style: TextStyle(fontSize: 15, color: Color(0xFF64748B)),
              ),
            ],
          ),
        ),
        IconButton.filled(
          onPressed: onCreatePressed,
          icon: const Icon(Icons.add_rounded),
        ),
      ],
    );
  }
}
