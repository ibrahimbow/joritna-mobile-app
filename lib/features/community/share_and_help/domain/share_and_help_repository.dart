import '../data/models/share_and_help_post.dart';
import '../data/models/requests/add_share_and_help_comment_request.dart';
import '../data/models/requests/create_share_and_help_post_request.dart';

abstract class ShareAndHelpRepository {
  Future<List<ShareAndHelpPost>> getPosts();

  Future<ShareAndHelpPost> createPost(
    CreateShareAndHelpPostRequest request,
  );

  Future<ShareAndHelpPost> updatePost({
    required String postId,
    required CreateShareAndHelpPostRequest request,
  });

  Future<void> deletePost(
    String postId,
  );

  Future<ShareAndHelpPost> addComment({
    required String postId,
    required AddShareAndHelpCommentRequest request,
  });

  Future<void> deleteComment({
    required String postId,
    required String commentId,
  });
}