import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../../app/config/app_config.dart';
import '../../../../../app/router/app_routes.dart';
import '../../../../../core/utils/date_utils.dart';
import '../../../../../core/utils/string_utils.dart';
import '../../../shared/presentation/layout/app_shell.dart';
import '../data/models/requests/add_share_and_help_comment_request.dart';
import '../data/models/share_and_help_post.dart';
import '../data/share_and_help_providers.dart';

class ShareAndHelpScreen extends ConsumerWidget {
  const ShareAndHelpScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final postsState = ref.watch(shareAndHelpPostsProvider);

    return AppShell(
      selectedIndex: 4,
      child: SafeArea(
        child: RefreshIndicator(
          onRefresh: () async {
            ref.invalidate(shareAndHelpPostsProvider);
          },
          child: CustomScrollView(
            slivers: [
              SliverToBoxAdapter(
                child: _ShareAndHelpHeader(
                  onCreatePost: () => context.go(AppRoutes.tenantCreatePost),
                ),
              ),
              postsState.when(
                loading: () => const SliverFillRemaining(
                  hasScrollBody: false,
                  child: Center(child: CircularProgressIndicator()),
                ),
                error: (error, _) => SliverFillRemaining(
                  hasScrollBody: false,
                  child: Center(child: Text('Could not load posts: $error')),
                ),
                data: (posts) {
                  if (posts.isEmpty) {
                    return const SliverFillRemaining(
                      hasScrollBody: false,
                      child: Center(
                        child: Text(
                          'No posts yet. Be the first to help your neighbours.',
                        ),
                      ),
                    );
                  }

                  return SliverList.separated(
                    itemCount: posts.length,
                    separatorBuilder: (_, __) => const SizedBox(height: 12),
                    itemBuilder: (context, index) {
                      return _ShareAndHelpPostCard(
                        post: posts[index],
                      );
                    },
                  );
                },
              ),
              const SliverToBoxAdapter(child: SizedBox(height: 24)),
            ],
          ),
        ),
      ),
    );
  }
}

class _ShareAndHelpHeader extends StatelessWidget {
  final VoidCallback onCreatePost;

  const _ShareAndHelpHeader({
    required this.onCreatePost,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Share & Help',
            style: TextStyle(
              color: Color(0xFF0F172A),
              fontSize: 26,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 6),
          const Text(
            'Ask neighbours for help, share useful things, and support your building community.',
            style: TextStyle(
              color: Color(0xFF64748B),
              fontSize: 14,
              height: 1.4,
            ),
          ),
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            height: 48,
            child: ElevatedButton.icon(
              onPressed: onCreatePost,
              icon: const Icon(Icons.add_rounded),
              label: const Text('Create Post'),
            ),
          ),
        ],
      ),
    );
  }
}

class _ShareAndHelpPostCard extends ConsumerStatefulWidget {
  final ShareAndHelpPost post;

  const _ShareAndHelpPostCard({
    required this.post,
  });

  @override
  ConsumerState<_ShareAndHelpPostCard> createState() =>
      _ShareAndHelpPostCardState();
}

class _ShareAndHelpPostCardState extends ConsumerState<_ShareAndHelpPostCard> {
  final TextEditingController _commentController = TextEditingController();

  late ShareAndHelpPost _post;
  bool _showComments = false;
  bool _isSubmittingComment = false;

  @override
  void initState() {
    super.initState();
    _post = widget.post;
  }

  @override
  void dispose() {
    _commentController.dispose();
    super.dispose();
  }

  Future<void> _addComment() async {
    final comment = _commentController.text.trim();

    if (comment.isEmpty || _isSubmittingComment) {
      return;
    }

    setState(() {
      _isSubmittingComment = true;
    });

    try {
      final updatedPost =
          await ref.read(shareAndHelpRepositoryProvider).addComment(
                postId: _post.id,
                request: AddShareAndHelpCommentRequest(
                  comment: comment,
                ),
              );

      setState(() {
        _post = updatedPost;
        _showComments = true;
      });

      _commentController.clear();

      ref.invalidate(shareAndHelpPostsProvider);
    } catch (error) {
      if (!mounted) {
        return;
      }

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Could not add comment: $error'),
        ),
      );
    } finally {
      if (mounted) {
        setState(() {
          _isSubmittingComment = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final commentsCount = _post.comments.length;

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: const Color(0xFFE2E8F0)),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 14,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _PostAuthorRow(
            displayName: _post.createdByDisplayName,
            avatarUrl: _post.createdByAvatarUrl,
            createdAt: _post.createdAt,
          ),
          const SizedBox(height: 14),
          Text(
            _post.title,
            style: const TextStyle(
              color: Color(0xFF0F172A),
              fontSize: 17,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            _post.description,
            style: const TextStyle(
              color: Color(0xFF334155),
              fontSize: 14,
              height: 1.45,
            ),
          ),
          if (_post.imageUrl != null && _post.imageUrl!.trim().isNotEmpty) ...[
            const SizedBox(height: 14),
            _PostImage(imageUrl: _post.imageUrl!),
          ],
          const SizedBox(height: 14),
          Row(
            children: [
              _PostActionChip(
                icon: Icons.thumb_up_alt_outlined,
                label: 'Support',
                onTap: () {},
              ),
              const SizedBox(width: 10),
              _PostActionChip(
                icon: Icons.mode_comment_rounded,
                label: '$commentsCount comments',
                onTap: () {
                  setState(() {
                    _showComments = !_showComments;
                  });
                },
              ),
            ],
          ),
          if (_showComments) ...[
            const SizedBox(height: 16),
            const Divider(color: Color(0xFFE2E8F0)),
            const SizedBox(height: 12),
            Row(
              children: [
                const Text(
                  'Comments',
                  style: TextStyle(
                    color: Color(0xFF0F172A),
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(width: 8),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 2,
                  ),
                  decoration: BoxDecoration(
                    color: const Color(0xFFEFF6FF),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    '$commentsCount',
                    style: const TextStyle(
                      color: Color(0xFF2563EB),
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            if (_post.comments.isEmpty)
              const Text(
                'No comments yet. Be the first to comment.',
                style: TextStyle(
                  color: Color(0xFF64748B),
                  fontSize: 13,
                ),
              )
            else
              ..._post.comments.map(
                (comment) => _CommentItem(
                  displayName: comment.createdByDisplayName,
                  avatarUrl: comment.createdByAvatarUrl,
                  createdAt: comment.createdAt,
                  text: comment.comment,
                ),
              ),
            const SizedBox(height: 12),
            _CommentInput(
              controller: _commentController,
              isSubmitting: _isSubmittingComment,
              onSubmit: _addComment,
            ),
          ],
        ],
      ),
    );
  }
}

class _PostActionChip extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  const _PostActionChip({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: const Color(0xFFF1F5F9),
      borderRadius: BorderRadius.circular(999),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(999),
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 12,
            vertical: 8,
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                icon,
                size: 16,
                color: Color(0xFF2563EB),
              ),
              const SizedBox(width: 6),
              Text(
                label,
                style: const TextStyle(
                  color: Color(0xFF475569),
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _CommentItem extends StatelessWidget {
  final String displayName;
  final String? avatarUrl;
  final DateTime createdAt;
  final String text;

  const _CommentItem({
    required this.displayName,
    required this.avatarUrl,
    required this.createdAt,
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CircleAvatar(
            radius: 18,
            backgroundColor: const Color(0xFFE6EFFD),
            backgroundImage: avatarUrl != null && avatarUrl!.isNotEmpty
                ? NetworkImage(avatarUrl!)
                : null,
            child: avatarUrl == null || avatarUrl!.isEmpty
                ? Text(
                    AppStringUtils.initials(displayName),
                    style: const TextStyle(
                      color: Color(0xFF0057C8),
                      fontSize: 11,
                      fontWeight: FontWeight.bold,
                    ),
                  )
                : null,
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Container(
              padding: const EdgeInsets.fromLTRB(12, 10, 12, 10),
              decoration: BoxDecoration(
                color: const Color(0xFFF8FAFC),
                border: Border.all(
                  color: const Color(0xFFE2E8F0),
                ),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Wrap(
                    crossAxisAlignment: WrapCrossAlignment.center,
                    spacing: 6,
                    children: [
                      Text(
                        displayName,
                        style: const TextStyle(
                          color: Color(0xFF0F172A),
                          fontSize: 13,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        AppDateUtils.timeAgo(createdAt),
                        style: const TextStyle(
                          color: Color(0xFF64748B),
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  Text(
                    text,
                    style: const TextStyle(
                      color: Color(0xFF334155),
                      fontSize: 13,
                      height: 1.35,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _CommentInput extends StatelessWidget {
  final TextEditingController controller;
  final bool isSubmitting;
  final VoidCallback onSubmit;

  const _CommentInput({
    required this.controller,
    required this.isSubmitting,
    required this.onSubmit,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: TextField(
            controller: controller,
            minLines: 1,
            maxLines: 3,
            decoration: InputDecoration(
              hintText: 'Write a comment...',
              filled: true,
              fillColor: Colors.white,
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 14,
                vertical: 12,
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(999),
                borderSide: const BorderSide(
                  color: Color(0xFFCBD5E1),
                ),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(999),
                borderSide: const BorderSide(
                  color: Color(0xFF2563EB),
                ),
              ),
            ),
          ),
        ),
        const SizedBox(width: 8),
        SizedBox(
          height: 46,
          child: FilledButton(
            onPressed: isSubmitting ? null : onSubmit,
            child: isSubmitting
                ? const SizedBox(
                    width: 16,
                    height: 16,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : const Text('Comment'),
          ),
        ),
      ],
    );
  }
}

class _PostAuthorRow extends StatelessWidget {
  final String displayName;
  final String? avatarUrl;
  final DateTime createdAt;

  const _PostAuthorRow({
    required this.displayName,
    required this.avatarUrl,
    required this.createdAt,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        CircleAvatar(
          radius: 22,
          backgroundColor: const Color(0xFFE6EFFD),
          backgroundImage: avatarUrl != null && avatarUrl!.isNotEmpty
              ? NetworkImage(avatarUrl!)
              : null,
          child: avatarUrl == null || avatarUrl!.isEmpty
              ? Text(
                  AppStringUtils.initials(displayName),
                  style: const TextStyle(
                    color: Color(0xFF0057C8),
                    fontWeight: FontWeight.bold,
                  ),
                )
              : null,
        ),
        const SizedBox(width: 10),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                displayName,
                style: const TextStyle(
                  color: Color(0xFF0F172A),
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                AppDateUtils.timeAgo(createdAt),
                style: const TextStyle(
                  color: Color(0xFF64748B),
                  fontSize: 12,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _PostImage extends StatelessWidget {
  final String imageUrl;

  const _PostImage({
    required this.imageUrl,
  });

  @override
  Widget build(BuildContext context) {
    final resolvedUrl = _resolveImageUrl(imageUrl);

    return ClipRRect(
      borderRadius: BorderRadius.circular(16),
      child: AspectRatio(
        aspectRatio: 16 / 9,
        child: Image.network(
          resolvedUrl,
          width: double.infinity,
          fit: BoxFit.cover,
          loadingBuilder: (context, child, loadingProgress) {
            if (loadingProgress == null) {
              return child;
            }

            return const Center(child: CircularProgressIndicator());
          },
          errorBuilder: (context, error, stackTrace) {
            return Container(
              color: const Color(0xFFF1F5F9),
              alignment: Alignment.center,
              child: const Icon(
                Icons.broken_image_outlined,
                color: Color(0xFF64748B),
                size: 36,
              ),
            );
          },
        ),
      ),
    );
  }

  String _resolveImageUrl(String value) {
    final trimmedValue = value.trim();

    if (trimmedValue.startsWith('http://') ||
        trimmedValue.startsWith('https://')) {
      return trimmedValue;
    }

    final apiBaseUri = Uri.parse(AppConfig.apiBaseUrl);
    final origin = '${apiBaseUri.scheme}://${apiBaseUri.authority}';

    if (trimmedValue.startsWith('/api/')) {
      return '$origin$trimmedValue';
    }

    if (trimmedValue.startsWith('/')) {
      return '${AppConfig.apiBaseUrl}$trimmedValue';
    }

    return '${AppConfig.apiBaseUrl}/$trimmedValue';
  }
}