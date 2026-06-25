class AddShareAndHelpCommentRequest {
  final String comment;

  const AddShareAndHelpCommentRequest({required this.comment});

  Map<String, dynamic> toJson() {
    return {'comment': comment};
  }
}
