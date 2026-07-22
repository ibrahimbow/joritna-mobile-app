import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../../app/router/app_routes.dart';
import '../../../../../core/notifications/providers/notification_badge_provider.dart';
import '../../../../../core/user/current_user_provider.dart';
import '../../../../../core/user/user_role.dart';
import '../../../shared/presentation/layout/app_shell.dart';
import '../data/share_and_help_providers.dart';
import 'widgets/share_and_help_header.dart';
import 'widgets/share_and_help_post_card.dart';

class ShareAndHelpScreen extends ConsumerStatefulWidget {
  const ShareAndHelpScreen({super.key});

  @override
  ConsumerState<ShareAndHelpScreen> createState() => _ShareAndHelpScreenState();
}

class _ShareAndHelpScreenState extends ConsumerState<ShareAndHelpScreen> {
  static const double _headerHeight = 168;

  late final Set<String> _newPostIdsForCurrentVisit;

  @override
  void initState() {
    super.initState();

    final notificationBadgeState = ref.read(notificationBadgeProvider);

    _newPostIdsForCurrentVisit = Set<String>.from(
      notificationBadgeState.newShareAndHelpPostIds,
    );

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) {
        return;
      }

      ref.read(notificationBadgeProvider.notifier).markShareAndHelpAsViewed();
    });
  }

  @override
  Widget build(BuildContext context) {
    final postsState = ref.watch(shareAndHelpPostsProvider);

    final currentUserState = ref.watch(currentUserProvider);

    return AppShell(
      selectedIndex: 4,
      child: SafeArea(
        child: Stack(
          children: [
            RefreshIndicator(
              onRefresh: _refreshPosts,
              child: CustomScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                slivers: [
                  const SliverToBoxAdapter(
                    child: SizedBox(height: _headerHeight),
                  ),
                  postsState.when(
                    loading: () => const SliverFillRemaining(
                      hasScrollBody: false,
                      child: Center(child: CircularProgressIndicator()),
                    ),
                    error: (error, stackTrace) => const SliverFillRemaining(
                      hasScrollBody: false,
                      child: _ShareAndHelpErrorState(),
                    ),
                    data: (posts) {
                      if (posts.isEmpty) {
                        return const SliverFillRemaining(
                          hasScrollBody: false,
                          child: _ShareAndHelpEmptyState(),
                        );
                      }

                      return SliverList.separated(
                        itemCount: posts.length,
                        separatorBuilder: (_, __) => const SizedBox(height: 12),
                        itemBuilder: (context, index) {
                          final post = posts[index];

                          final bool isNew = _newPostIdsForCurrentVisit
                              .contains(post.id);

                          return ShareAndHelpPostCard(post: post, isNew: isNew);
                        },
                      );
                    },
                  ),
                  const SliverToBoxAdapter(child: SizedBox(height: 24)),
                ],
              ),
            ),
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              child: currentUserState.when(
                loading: () => const SizedBox.shrink(),
                error: (error, stackTrace) => ShareAndHelpHeader(
                  onCreatePost: () {
                    context.push(AppRoutes.tenantCreatePost);
                  },
                ),
                data: (user) => ShareAndHelpHeader(
                  onCreatePost: () {
                    context.push(_createPostRouteForRole(user.role));
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _refreshPosts() async {
    ref.invalidate(shareAndHelpPostsProvider);

    await ref.read(shareAndHelpPostsProvider.future);
  }

  String _createPostRouteForRole(UserRole role) {
    switch (role) {
      case UserRole.manager:
      case UserRole.admin:
        return AppRoutes.managerCreatePost;

      case UserRole.tenant:
        return AppRoutes.tenantCreatePost;
    }
  }
}

class _ShareAndHelpEmptyState extends StatelessWidget {
  const _ShareAndHelpEmptyState();

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.symmetric(horizontal: 32),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.volunteer_activism_outlined,
            size: 42,
            color: Color(0xFF2563EB),
          ),
          SizedBox(height: 14),
          Text(
            'No posts yet',
            style: TextStyle(
              color: Color(0xFF0F172A),
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 8),
          Text(
            'Be the first to help your neighbours or ask your community for support.',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Color(0xFF64748B),
              fontSize: 14,
              height: 1.4,
            ),
          ),
        ],
      ),
    );
  }
}

class _ShareAndHelpErrorState extends ConsumerWidget {
  const _ShareAndHelpErrorState();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 32),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(
            Icons.cloud_off_outlined,
            size: 42,
            color: Color(0xFFDC2626),
          ),
          const SizedBox(height: 14),
          const Text(
            'Could not load posts',
            style: TextStyle(
              color: Color(0xFF0F172A),
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'Please check your connection and try again.',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Color(0xFF64748B),
              fontSize: 14,
              height: 1.4,
            ),
          ),
          const SizedBox(height: 16),
          FilledButton.icon(
            onPressed: () {
              ref.invalidate(shareAndHelpPostsProvider);
            },
            icon: const Icon(Icons.refresh_rounded),
            label: const Text('Retry'),
          ),
        ],
      ),
    );
  }
}
