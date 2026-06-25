import 'share_and_help_comment.dart';

class ShareAndHelpPost {
  final String id;
  final int createdByUserId;
  final String createdByDisplayName;
  final String? createdByAvatarUrl;
  final String title;
  final String description;
  final String? imageUrl;
  final DateTime createdAt;
  final DateTime updatedAt;
  final List<ShareAndHelpComment> comments;

  const ShareAndHelpPost({
    required this.id,
    required this.createdByUserId,
    required this.createdByDisplayName,
    required this.createdByAvatarUrl,
    required this.title,
    required this.description,
    required this.imageUrl,
    required this.createdAt,
    required this.updatedAt,
    required this.comments,
  });

  factory ShareAndHelpPost.fromJson(Map<String, dynamic> json) {
    return ShareAndHelpPost(
      id: json['id'] as String,
      createdByUserId: json['createdByUserId'] as int,
      createdByDisplayName: json['createdByDisplayName'] as String,
      createdByAvatarUrl: json['createdByAvatarUrl'] as String?,
      title: json['title'] as String,
      description: json['description'] as String,
      imageUrl: json['imageUrl'] as String?,
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
      comments: (json['comments'] as List<dynamic>? ?? [])
          .map(
            (comment) => ShareAndHelpComment.fromJson(
              comment as Map<String, dynamic>,
            ),
          )
          .toList(),
    );
  }
}