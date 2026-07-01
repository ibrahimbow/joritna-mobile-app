import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../../../app/router/app_routes.dart';
import '../../../../../../core/user/current_user_provider.dart';
import '../../data/models/requests/add_share_and_help_comment_request.dart';
import '../../data/models/share_and_help_comment.dart';
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
  static const int _initialVisibleCommentsCount = 5;

  final TextEditingController _commentController = TextEditingController();

  late ShareAndHelpPost _post;

  bool _isDeletingPost = false;
  bool _isUpdatingStatus = false;

  bool _showComments = false;
  bool _showAllComments = false;

  bool _isSubmittingComment = false;
  bool _isDeletingComment = false;

  int? _currentUserId;

  List<ShareAndHelpComment> get _visibleComments {
    if (_showAllComments ||
        _post.comments.length <= _initialVisibleCommentsCount) {
      return _post.comments;
    }

    return _post.comments.take(_initialVisibleCommentsCount).toList();
  }

  bool get _hasMoreComments =>
      _post.comments.length > _initialVisibleCommentsCount;

  int get _hiddenCommentsCount =>
      _post.comments.length - _initialVisibleCommentsCount;

  @override
  void initState() {
    super.initState();
    _post = widget.post;
    _loadCurrentUser();
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

  Future<void> _addComment() async {
    if (_post.isResolved) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('This discussion is closed.')),
      );
      return;
    }

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
        _showAllComments = true;
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

        if (_post.comments.length <= _initialVisibleCommentsCount) {
          _showAllComments = false;
        }
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

  Future<void> _deletePost() async {
    if (_isDeletingPost) {
      return;
    }

    final confirmed = await _confirmDeletePost();

    if (!confirmed) {
      return;
    }

    setState(() {
      _isDeletingPost = true;
    });

    try {
      await ref.read(shareAndHelpRepositoryProvider).deletePost(_post.id);

      ref.invalidate(shareAndHelpPostsProvider);

      if (!mounted) {
        return;
      }

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Post deleted.')));
    } catch (_) {
      if (!mounted) {
        return;
      }

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Could not delete post.')));
    } finally {
      if (mounted) {
        setState(() {
          _isDeletingPost = false;
        });
      }
    }
  }

  Future<void> _togglePostStatus() async {
    final confirmed = await _confirmTogglePostStatus();

    if (!confirmed || _isUpdatingStatus) {
      return;
    }

    setState(() {
      _isUpdatingStatus = true;
    });

    try {
      if (_post.isResolved) {
        await _reopenPost();
      } else {
        await _resolvePost();
      }
    } catch (_) {
      if (!mounted) {
        return;
      }

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Could not update post status.')),
      );
    } finally {
      if (mounted) {
        setState(() {
          _isUpdatingStatus = false;
        });
      }
    }
  }

  Future<bool> _confirmTogglePostStatus() async {
    final resolving = !_post.isResolved;

    final result = await showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(resolving ? 'Mark as resolved?' : 'Reopen discussion?'),
          content: Text(
            resolving
                ? 'Members will no longer be able to add new comments.'
                : 'Members will be able to comment again.',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: const Text('Cancel'),
            ),
            FilledButton(
              onPressed: () => Navigator.of(context).pop(true),
              child: Text(resolving ? 'Resolve' : 'Reopen'),
            ),
          ],
        );
      },
    );

    return result ?? false;
  }

  Future<void> _resolvePost() async {
    final updatedPost = await ref
        .read(shareAndHelpRepositoryProvider)
        .resolvePost(_post.id);

    if (!mounted) {
      return;
    }

    setState(() {
      _post = updatedPost;
    });

    ref.invalidate(shareAndHelpPostsProvider);

    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text('Post marked as resolved.')));
  }

  Future<void> _reopenPost() async {
    final updatedPost = await ref
        .read(shareAndHelpRepositoryProvider)
        .reopenPost(_post.id);

    if (!mounted) {
      return;
    }

    setState(() {
      _post = updatedPost;
    });

    ref.invalidate(shareAndHelpPostsProvider);

    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text('Discussion reopened.')));
  }

  Future<bool> _confirmDeletePost() async {
    final result = await showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Delete post?'),
          content: const Text(
            'This post and its comments will be removed from Share & Help.',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: const Text('Cancel'),
            ),
            FilledButton(
              style: FilledButton.styleFrom(
                backgroundColor: const Color(0xFFDC2626),
              ),
              onPressed: () => Navigator.of(context).pop(true),
              child: const Text('Delete'),
            ),
          ],
        );
      },
    );

    return result ?? false;
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
            isOwner: canEditPost,
            isResolved: _post.isResolved,
            isUpdatingStatus: _isUpdatingStatus,
            isDeleting: _isDeletingPost,
            onEdit: _editPost,
            onDelete: _deletePost,
            onToggleStatus: _togglePostStatus,
          ),
          const SizedBox(height: 14),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Text(
                  _post.title,
                  style: const TextStyle(
                    color: Color(0xFF0F172A),
                    fontSize: 17,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            
            ],
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
          Align(
            alignment: Alignment.centerRight,
            child: CommentToggleButton(
              commentsCount: commentsCount,
              isExpanded: _showComments,
              onTap: () {
                setState(() {
                  _showComments = !_showComments;
                });
              },
            ),
          ),
          if (_showComments) ...[
            const SizedBox(height: 14),
            const Divider(color: Color(0xFFE2E8F0)),
            const SizedBox(height: 12),
            _CommentsHeader(commentsCount: commentsCount),
            const SizedBox(height: 12),
            if (_post.comments.isEmpty)
              const Text(
                'No comments yet. Be the first to comment.',
                style: TextStyle(color: Color(0xFF64748B), fontSize: 13),
              )
            else ...[
              ..._visibleComments.map((comment) {
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
              if (_hasMoreComments)
                Align(
                  alignment: Alignment.centerRight,
                  child: TextButton.icon(
                    style: TextButton.styleFrom(
                      foregroundColor: const Color(0xFF2563EB),
                      visualDensity: VisualDensity.compact,
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                    ),
                    onPressed: () {
                      setState(() {
                        _showAllComments = !_showAllComments;
                      });
                    },
                    icon: Icon(
                      _showAllComments
                          ? Icons.keyboard_arrow_up_rounded
                          : Icons.keyboard_arrow_down_rounded,
                      size: 18,
                    ),
                    label: Text(
                      _showAllComments
                          ? 'Show less'
                          : 'Read $_hiddenCommentsCount more',
                      style: const TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ),
            ],
            const SizedBox(height: 12),
            if (_post.isResolved)
              const _DiscussionClosedMessage()
            else
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

class _DiscussionClosedMessage extends StatelessWidget {
  const _DiscussionClosedMessage();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: const Color(0xFFF0FDF4),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFBBF7D0)),
      ),
      child: const Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(Icons.check_circle_rounded, color: Color(0xFF16A34A), size: 22),
          SizedBox(width: 10),
          Expanded(
            child: Text(
              'Discussion closed. This post has been marked as resolved, so new comments are disabled.',
              style: TextStyle(
                color: Color(0xFF166534),
                fontSize: 13,
                fontWeight: FontWeight.w700,
                height: 1.4,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _ResolvedBadge extends StatelessWidget {
  const _ResolvedBadge();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 5),
      decoration: BoxDecoration(
        color: const Color(0xFFDCFCE7),
        borderRadius: BorderRadius.circular(999),
      ),
      child: const Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.check_circle_rounded, color: Color(0xFF16A34A), size: 15),
          SizedBox(width: 4),
          Text(
            'Resolved',
            style: TextStyle(
              color: Color(0xFF166534),
              fontSize: 11,
              fontWeight: FontWeight.w800,
            ),
          ),
        ],
      ),
    );
  }
}
