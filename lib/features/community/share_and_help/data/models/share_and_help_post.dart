import 'share_and_help_comment.dart';
import 'share_and_help_post_status.dart';

class ShareAndHelpPost {
  const ShareAndHelpPost({
    required this.id,
    required this.createdByUserId,
    required this.createdByDisplayName,
    required this.createdByAvatarUrl,
    required this.title,
    required this.description,
    required this.imageUrl,
    required this.status,
    required this.createdAt,
    required this.updatedAt,
    required this.comments,
  });

  final String id;
  final int createdByUserId;
  final String createdByDisplayName;
  final String? createdByAvatarUrl;
  final String title;
  final String description;
  final String? imageUrl;
  final ShareAndHelpPostStatus status;
  final DateTime createdAt;
  final DateTime updatedAt;
  final List<ShareAndHelpComment> comments;

  bool get isResolved => status.isResolved;

  factory ShareAndHelpPost.fromJson(Map<String, dynamic> json) {
    return ShareAndHelpPost(
      id: json['id'] as String,
      createdByUserId: (json['createdByUserId'] as num).toInt(),
      createdByDisplayName: json['createdByDisplayName'] as String,
      createdByAvatarUrl: json['createdByAvatarUrl'] as String?,
      title: json['title'] as String,
      description: json['description'] as String,
      imageUrl: json['imageUrl'] as String?,
      status: ShareAndHelpPostStatus.fromJson(
        json['status'] as String? ?? 'OPEN',
      ),
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
      comments: (json['comments'] as List<dynamic>? ?? [])
          .map(
            (comment) =>
                ShareAndHelpComment.fromJson(comment as Map<String, dynamic>),
          )
          .toList(),
    );
  }

  ShareAndHelpPost copyWith({
    String? id,
    int? createdByUserId,
    String? createdByDisplayName,
    String? createdByAvatarUrl,
    String? title,
    String? description,
    String? imageUrl,
    ShareAndHelpPostStatus? status,
    DateTime? createdAt,
    DateTime? updatedAt,
    List<ShareAndHelpComment>? comments,
  }) {
    return ShareAndHelpPost(
      id: id ?? this.id,
      createdByUserId: createdByUserId ?? this.createdByUserId,
      createdByDisplayName: createdByDisplayName ?? this.createdByDisplayName,
      createdByAvatarUrl: createdByAvatarUrl ?? this.createdByAvatarUrl,
      title: title ?? this.title,
      description: description ?? this.description,
      imageUrl: imageUrl ?? this.imageUrl,
      status: status ?? this.status,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      comments: comments ?? this.comments,
    );
  }
}