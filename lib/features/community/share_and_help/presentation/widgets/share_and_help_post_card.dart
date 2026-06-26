import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../../../app/router/app_routes.dart';
import '../../../../../../core/user/current_user_provider.dart';
import '../../data/models/requests/add_share_and_help_comment_request.dart';
import '../../data/models/share_and_help_post.dart';
import '../../data/share_and_help_providers.dart';
import 'comment_input.dart';
import 'comment_item.dart';
import 'comment_toggle_button.dart';
import 'post_author_row.dart';
import 'post_image.dart';

class ShareAndHelpPostCard extends ConsumerStatefulWidget {
  const ShareAndHelpPostCard({super.key, required this.post});

  final ShareAndHelpPost post;

  @override
  ConsumerState<ShareAndHelpPostCard> createState() =>
      _ShareAndHelpPostCardState();
}

class _ShareAndHelpPostCardState extends ConsumerState<ShareAndHelpPostCard> {
  final TextEditingController _commentController = TextEditingController();

  late ShareAndHelpPost _post;

  int? _currentUserId;

  bool _showComments = false;
  bool _isSubmittingComment = false;
  bool _isDeletingComment = false;

  @override
  void initState() {
    super.initState();

    _post = widget.post;

    _loadCurrentUser();
  }

  Future<void> _loadCurrentUser() async {
    try {
      final currentUser = await ref.read(currentUserProvider.future);

      if (!mounted) {
        return;
      }

      setState(() {
        _currentUserId = currentUser.userId;
      });
    } catch (_) {
      if (!mounted) {
        return;
      }

      setState(() {
        _currentUserId = null;
      });
    }
  }

  @override
  void didUpdateWidget(covariant ShareAndHelpPostCard oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (oldWidget.post != widget.post) {
      _post = widget.post;
    }
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
      final updatedPost = await ref
          .read(shareAndHelpRepositoryProvider)
          .addComment(
            postId: _post.id,
            request: AddShareAndHelpCommentRequest(comment: comment),
          );

      if (!mounted) {
        return;
      }

      setState(() {
        _post = updatedPost;
        _showComments = true;
      });

      _commentController.clear();

      ref.invalidate(shareAndHelpPostsProvider);
    } catch (_) {
      if (!mounted) {
        return;
      }

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Could not add comment.')));
    } finally {
      if (mounted) {
        setState(() {
          _isSubmittingComment = false;
        });
      }
    }
  }

  Future<void> _deleteComment(String commentId) async {
    if (_isDeletingComment) {
      return;
    }

    final confirmed = await _confirmDeleteComment();

    if (!confirmed) {
      return;
    }

    setState(() {
      _isDeletingComment = true;
    });

    try {
      await ref
          .read(shareAndHelpRepositoryProvider)
          .deleteComment(postId: _post.id, commentId: commentId);

      if (!mounted) {
        return;
      }

      setState(() {
        _post = _post.copyWith(
          comments: _post.comments
              .where((comment) => comment.id != commentId)
              .toList(),
        );
      });

      ref.invalidate(shareAndHelpPostsProvider);

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Comment deleted.')));
    } catch (_) {
      if (!mounted) {
        return;
      }

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Could not delete comment.')),
      );
    } finally {
      if (mounted) {
        setState(() {
          _isDeletingComment = false;
        });
      }
    }
  }

  Future<bool> _confirmDeleteComment() async {
    final result = await showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Delete comment?'),
          content: const Text('This comment will be removed.'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: const Text('Cancel'),
            ),
            FilledButton(
              onPressed: () => Navigator.of(context).pop(true),
              child: const Text('Delete'),
            ),
          ],
        );
      },
    );

    return result ?? false;
  }

  void _editPost() {
    context.push(AppRoutes.tenantCreatePost, extra: _post);
  }

  bool _isOwner({required int ownerId, required int? currentUserId}) {
    if (currentUserId == null) {
      return false;
    }

    return ownerId.toString() == currentUserId.toString();
  }

  @override
  Widget build(BuildContext context) {
    final commentsCount = _post.comments.length;

    final canEditPost = _isOwner(
      ownerId: _post.createdByUserId,
      currentUserId: _currentUserId,
    );

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
          PostAuthorRow(
            displayName: _post.createdByDisplayName,
            avatarUrl: _post.createdByAvatarUrl,
            createdAt: _post.createdAt,
            canEdit: canEditPost,
            onEdit: _editPost,
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
            PostImage(imageUrl: _post.imageUrl!),
          ],
          const SizedBox(height: 14),
          CommentToggleButton(
            commentsCount: commentsCount,
            isExpanded: _showComments,
            onTap: () {
              setState(() {
                _showComments = !_showComments;
              });
            },
          ),
          if (_showComments) ...[
            const SizedBox(height: 16),
            const Divider(color: Color(0xFFE2E8F0)),
            const SizedBox(height: 12),
            _CommentsHeader(commentsCount: commentsCount),
            const SizedBox(height: 12),
            if (_post.comments.isEmpty)
              const Text(
                'No comments yet. Be the first to comment.',
                style: TextStyle(color: Color(0xFF64748B), fontSize: 13),
              )
            else
              ..._post.comments.map((comment) {
                final canDeleteComment = _isOwner(
                  ownerId: comment.createdByUserId,
                  currentUserId: _currentUserId,
                );

                return CommentItem(
                  displayName: comment.createdByDisplayName,
                  avatarUrl: comment.createdByAvatarUrl,
                  createdAt: comment.createdAt,
                  text: comment.comment,
                  canDelete: canDeleteComment,
                  onDelete: () => _deleteComment(comment.id),
                );
              }),
            const SizedBox(height: 12),
            CommentInput(
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

class _CommentsHeader extends StatelessWidget {
  const _CommentsHeader({required this.commentsCount});

  final int commentsCount;

  @override
  Widget build(BuildContext context) {
    return Row(
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
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
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
    );
  }
}
