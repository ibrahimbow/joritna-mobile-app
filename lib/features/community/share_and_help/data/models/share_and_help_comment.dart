class ShareAndHelpComment {
  final String id;
  final int createdByUserId;
  final String createdByDisplayName;
  final String? createdByAvatarUrl;
  final String comment;
  final DateTime createdAt;

  const ShareAndHelpComment({
    required this.id,
    required this.createdByUserId,
    required this.createdByDisplayName,
    required this.createdByAvatarUrl,
    required this.comment,
    required this.createdAt,
  });

  factory ShareAndHelpComment.fromJson(Map<String, dynamic> json) {
    return ShareAndHelpComment(
      id: json['id'] as String,
      createdByUserId: json['createdByUserId'] as int,
      createdByDisplayName: json['createdByDisplayName'] as String,
      createdByAvatarUrl: json['createdByAvatarUrl'] as String?,
      comment: json['comment'] as String,
      createdAt: DateTime.parse(json['createdAt'] as String),
    );
  }
}