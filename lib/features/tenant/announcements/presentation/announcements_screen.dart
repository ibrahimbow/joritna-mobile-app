import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/notifications/providers/notification_badge_provider.dart';
import '../../../shared/presentation/layout/app_shell.dart';
import '../data/announcement_providers.dart';
import '../data/models/announcement.dart';
import 'widgets/announcement_card.dart';
import 'widgets/announcement_empty_state.dart';

class AnnouncementsScreen extends ConsumerStatefulWidget {
  const AnnouncementsScreen({super.key});

  @override
  ConsumerState<AnnouncementsScreen> createState() =>
      _AnnouncementsScreenState();
}

final class _AnnouncementsScreenState
    extends ConsumerState<AnnouncementsScreen> {
  static const double _headerHeight = 112;

  static const int _maximumRefreshAttempts = 5;

  static const Duration _initialRefreshDelay = Duration(milliseconds: 500);

  static const Duration _refreshRetryDelay = Duration(milliseconds: 700);

  Set<String> _newAnnouncementIds = const <String>{};

  final Set<String> _pendingAnnouncementIds = <String>{};

  bool _isRefreshingFromNotification = false;

  @override
  void initState() {
    super.initState();

    final badgeState = ref.read(notificationBadgeProvider);

    _newAnnouncementIds = _normalizeIds(badgeState.newAnnouncementIds);

    ref.listenManual(notificationBadgeProvider, _onNotificationBadgeChanged);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) {
        return;
      }

      ref.read(notificationBadgeProvider.notifier).markAnnouncementsAsViewed();
    });
  }

  @override
  Widget build(final BuildContext context) {
    final announcementsState = ref.watch(tenantAnnouncementsProvider);

    return AppShell(
      selectedIndex: 2,
      child: SafeArea(
        child: Stack(
          children: [
            RefreshIndicator(
              onRefresh: _refreshAnnouncements,
              child: CustomScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                slivers: [
                  const SliverToBoxAdapter(
                    child: SizedBox(height: _headerHeight),
                  ),
                  announcementsState.when(
                    loading: () => const SliverFillRemaining(
                      hasScrollBody: false,
                      child: Center(child: CircularProgressIndicator()),
                    ),
                    error: (error, stackTrace) {
                      debugPrint('Could not load announcements: $error');

                      debugPrintStack(stackTrace: stackTrace);

                      return SliverFillRemaining(
                        hasScrollBody: false,
                        child: _AnnouncementsErrorState(
                          onRetry: _refreshAnnouncements,
                        ),
                      );
                    },
                    data: _buildAnnouncementsContent,
                  ),
                  const SliverToBoxAdapter(child: SizedBox(height: 32)),
                ],
              ),
            ),
            const Positioned(
              top: 0,
              left: 0,
              right: 0,
              child: _AnnouncementsHeader(),
            ),
          ],
        ),
      ),
    );
  }

  void _onNotificationBadgeChanged(final dynamic previous, final dynamic next) {
    final Set<String> previousIds = _normalizeIds(
      previous?.newAnnouncementIds ?? const <String>{},
    );

    final Set<String> currentIds = _normalizeIds(next.newAnnouncementIds);

    final Set<String> receivedIds = currentIds.difference(previousIds);

    if (receivedIds.isEmpty) {
      return;
    }

    _pendingAnnouncementIds.addAll(receivedIds);

    if (mounted) {
      setState(() {
        _newAnnouncementIds = Set<String>.unmodifiable({
          ..._newAnnouncementIds,
          ...receivedIds,
        });
      });
    }

    debugPrint(
      'New announcement notification received. '
      'announcementIds=$receivedIds',
    );

    if (!_isRefreshingFromNotification) {
      unawaited(_processPendingAnnouncements());
    }
  }

  Future<void> _processPendingAnnouncements() async {
    if (_isRefreshingFromNotification) {
      return;
    }

    _isRefreshingFromNotification = true;

    try {
      while (_pendingAnnouncementIds.isNotEmpty) {
        final Set<String> expectedIds = Set<String>.from(
          _pendingAnnouncementIds,
        );

        final bool announcementsLoaded =
            await _refreshUntilAnnouncementsAreAvailable(
              expectedAnnouncementIds: expectedIds,
            );

        if (!announcementsLoaded) {
          debugPrint(
            'Announcements were not available after all refresh attempts. '
            'expectedIds=$expectedIds',
          );

          break;
        }

        _pendingAnnouncementIds.removeAll(expectedIds);

        if (!mounted) {
          return;
        }

        ref
            .read(notificationBadgeProvider.notifier)
            .markAnnouncementsAsViewed();
      }
    } catch (error, stackTrace) {
      debugPrint('Could not process new announcements: $error');

      debugPrintStack(stackTrace: stackTrace);
    } finally {
      _isRefreshingFromNotification = false;
    }
  }

  Future<bool> _refreshUntilAnnouncementsAreAvailable({
    required Set<String> expectedAnnouncementIds,
  }) async {
    await Future<void>.delayed(_initialRefreshDelay);

    for (int attempt = 1; attempt <= _maximumRefreshAttempts; attempt++) {
      if (!mounted) {
        return false;
      }

      final List<Announcement> announcements = await ref.refresh(
        tenantAnnouncementsProvider.future,
      );

      final Map<String, Announcement> announcementsById =
          <String, Announcement>{
            for (final Announcement announcement in announcements)
              if (announcement.id.trim().isNotEmpty)
                announcement.id.trim(): announcement,
          };

      final bool allAnnouncementsLoaded = expectedAnnouncementIds.every((
        final String expectedId,
      ) {
        final Announcement? announcement = announcementsById[expectedId.trim()];

        return _isAnnouncementComplete(announcement);
      });

      debugPrint(
        'Announcement refresh attempt '
        '$attempt/$_maximumRefreshAttempts. '
        'expectedIds=$expectedAnnouncementIds, '
        'loadedIds=${announcementsById.keys.toList()}',
      );

      if (allAnnouncementsLoaded) {
        return true;
      }

      if (attempt < _maximumRefreshAttempts) {
        await Future<void>.delayed(_refreshRetryDelay);
      }
    }

    return false;
  }

  bool _isAnnouncementComplete(final Announcement? announcement) {
    if (announcement == null) {
      return false;
    }

    return announcement.id.trim().isNotEmpty &&
        announcement.title.trim().isNotEmpty &&
        announcement.message.trim().isNotEmpty;
  }

  Future<void> _refreshAnnouncements() async {
    final List<Announcement> _ = await ref.refresh(
      tenantAnnouncementsProvider.future,
    );
  }

  Set<String> _normalizeIds(final Iterable<String> ids) {
    return Set<String>.unmodifiable(
      ids
          .map((final String id) => id.trim())
          .where((final String id) => id.isNotEmpty),
    );
  }

  Widget _buildAnnouncementsContent(final List<Announcement> announcements) {
    final List<Announcement> completeAnnouncements = announcements
        .where(_isRenderableAnnouncement)
        .toList(growable: false);

    if (completeAnnouncements.isEmpty) {
      return const SliverFillRemaining(
        hasScrollBody: false,
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 24),
          child: AnnouncementEmptyState(
            title: 'No announcements yet',
            message:
                'Your building manager has not posted any announcements yet.',
            icon: Icons.campaign_outlined,
          ),
        ),
      );
    }

    return SliverPadding(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
      sliver: SliverList.separated(
        itemCount: completeAnnouncements.length,
        separatorBuilder: (final BuildContext context, final int index) {
          return const SizedBox(height: 16);
        },
        itemBuilder: (final BuildContext context, final int index) {
          final Announcement announcement = completeAnnouncements[index];

          final String announcementId = announcement.id.trim();

          return AnnouncementCard(
            key: ValueKey<String>(announcementId),
            announcement: announcement,
            isNew: _newAnnouncementIds.contains(announcementId),
          );
        },
      ),
    );
  }

  bool _isRenderableAnnouncement(final Announcement announcement) {
    return announcement.id.trim().isNotEmpty &&
        announcement.title.trim().isNotEmpty &&
        announcement.message.trim().isNotEmpty;
  }
}

final class _AnnouncementsHeader extends StatelessWidget {
  const _AnnouncementsHeader();

  @override
  Widget build(final BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: Theme.of(context).scaffoldBackgroundColor,
        boxShadow: [
          BoxShadow(
            blurRadius: 12,
            offset: const Offset(0, 5),
            color: Colors.black.withValues(alpha: 0.04),
          ),
        ],
      ),
      child: const Padding(
        padding: EdgeInsets.fromLTRB(16, 18, 16, 18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Announcements',
              style: TextStyle(
                color: Color(0xFF111827),
                fontSize: 28,
                fontWeight: FontWeight.w800,
              ),
            ),
            SizedBox(height: 6),
            Text(
              'Official updates from your building manager.',
              style: TextStyle(color: Color(0xFF6B7280), fontSize: 15),
            ),
          ],
        ),
      ),
    );
  }
}

final class _AnnouncementsErrorState extends StatelessWidget {
  const _AnnouncementsErrorState({required this.onRetry});

  final Future<void> Function() onRetry;

  @override
  Widget build(final BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const AnnouncementEmptyState(
            title: 'Unable to load announcements',
            message: 'Something went wrong while loading the announcements.',
            icon: Icons.error_outline_rounded,
          ),
          const SizedBox(height: 16),
          FilledButton.icon(
            onPressed: () {
              unawaited(onRetry());
            },
            icon: const Icon(Icons.refresh_rounded),
            label: const Text('Try again'),
          ),
        ],
      ),
    );
  }
}
