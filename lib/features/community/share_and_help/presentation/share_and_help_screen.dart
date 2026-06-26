import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../../app/router/app_routes.dart';
import '../../../shared/presentation/layout/app_shell.dart';
import '../data/share_and_help_providers.dart';
import 'widgets/share_and_help_header.dart';
import 'widgets/share_and_help_post_card.dart';

class ShareAndHelpScreen extends ConsumerWidget {
  const ShareAndHelpScreen({super.key});

  static const double _headerHeight = 168;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final postsState = ref.watch(shareAndHelpPostsProvider);

    return AppShell(
      selectedIndex: 4,
      child: SafeArea(
        child: Stack(
          children: [
            RefreshIndicator(
              onRefresh: () async {
                ref.invalidate(shareAndHelpPostsProvider);
              },
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
                    error: (error, _) => const SliverFillRemaining(
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
                          return ShareAndHelpPostCard(post: posts[index]);
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
              child: ShareAndHelpHeader(
                onCreatePost: () => context.go(AppRoutes.tenantCreatePost),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ShareAndHelpEmptyState extends StatelessWidget {
  const _ShareAndHelpEmptyState();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 32),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: const [
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
