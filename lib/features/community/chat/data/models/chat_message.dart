import 'chat_reaction_summary.dart';

class ChatMessage {
  const ChatMessage({
    required this.id,
    required this.senderUserId,
    required this.senderDisplayName,
    required this.deleted,
    required this.createdAt,
    required this.reactions,
    this.senderAvatarUrl,
    this.content,
    this.imageUrl,
    this.updatedAt,
    this.deletedAt,
  });

  final String id;

  final int senderUserId;

  final String senderDisplayName;

  final String? senderAvatarUrl;

  final String? content;

  final String? imageUrl;

  final bool deleted;

  final DateTime createdAt;

  final DateTime? updatedAt;

  final DateTime? deletedAt;

  final List<ChatReactionSummary> reactions;

  bool get hasText => content != null && content!.trim().isNotEmpty;

  bool get hasImage => imageUrl != null && imageUrl!.trim().isNotEmpty;

  bool get isEdited => updatedAt != null && deletedAt == null;

  bool get isDeleted => deleted;

  factory ChatMessage.fromJson(Map<String, dynamic> json) {
    return ChatMessage(
      id: json['id'] as String,
      senderUserId: json['senderUserId'] as int,
      senderDisplayName: json['senderDisplayName'] as String,
      senderAvatarUrl: json['senderAvatarUrl'] as String?,
      content: json['content'] as String?,
      imageUrl: json['imageUrl'] as String?,
      deleted: json['deleted'] as bool? ?? false,
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: json['updatedAt'] == null
          ? null
          : DateTime.parse(json['updatedAt'] as String),
      deletedAt: json['deletedAt'] == null
          ? null
          : DateTime.parse(json['deletedAt'] as String),
      reactions: ((json['reactions'] as List<dynamic>?) ?? [])
          .map(
            (reaction) =>
                ChatReactionSummary.fromJson(reaction as Map<String, dynamic>),
          )
          .toList(growable: false),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'senderUserId': senderUserId,
      'senderDisplayName': senderDisplayName,
      'senderAvatarUrl': senderAvatarUrl,
      'content': content,
      'imageUrl': imageUrl,
      'deleted': deleted,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
      'deletedAt': deletedAt?.toIso8601String(),
      'reactions': reactions.map((e) => e.toJson()).toList(),
    };
  }

  ChatMessage copyWith({
    String? id,
    int? senderUserId,
    String? senderDisplayName,
    String? senderAvatarUrl,
    String? content,
    String? imageUrl,
    bool? deleted,
    DateTime? createdAt,
    DateTime? updatedAt,
    DateTime? deletedAt,
    List<ChatReactionSummary>? reactions,
  }) {
    return ChatMessage(
      id: id ?? this.id,
      senderUserId: senderUserId ?? this.senderUserId,
      senderDisplayName: senderDisplayName ?? this.senderDisplayName,
      senderAvatarUrl: senderAvatarUrl ?? this.senderAvatarUrl,
      content: content ?? this.content,
      imageUrl: imageUrl ?? this.imageUrl,
      deleted: deleted ?? this.deleted,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      deletedAt: deletedAt ?? this.deletedAt,
      reactions: reactions ?? this.reactions,
    );
  }

  bool isOwnedBy(int currentUserId) {
    return senderUserId == currentUserId;
  }
}
