class ChatReactionSummary {
  const ChatReactionSummary({
    required this.emoji,
    required this.count,
    required this.reactedByCurrentUser,
  });

  final String emoji;
  final int count;
  final bool reactedByCurrentUser;

  factory ChatReactionSummary.fromJson(Map<String, dynamic> json) {
    return ChatReactionSummary(
      emoji: json['emoji'] as String,
      count: json['count'] as int,
      reactedByCurrentUser: json['reactedByCurrentUser'] as bool? ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'emoji': emoji,
      'count': count,
      'reactedByCurrentUser': reactedByCurrentUser,
    };
  }
}
