class SendChatMessageRequest {
  const SendChatMessageRequest({this.content, this.imageUrl});

  final String? content;
  final String? imageUrl;

  Map<String, dynamic> toJson() {
    return {'content': content, 'imageUrl': imageUrl};
  }
}
