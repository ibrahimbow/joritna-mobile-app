class ReactToChatMessageRequest {
  const ReactToChatMessageRequest({required this.emoji});

  final String emoji;

  Map<String, dynamic> toJson() {
    return {'emoji': emoji};
  }
}
