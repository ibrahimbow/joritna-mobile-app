import '../domain/share_and_help_repository.dart';
import 'models/requests/add_share_and_help_comment_request.dart';
import 'models/requests/create_share_and_help_post_request.dart';
import 'models/share_and_help_post.dart';
import 'share_and_help_api_client.dart';

class ShareAndHelpRepositoryImpl implements ShareAndHelpRepository {
  const ShareAndHelpRepositoryImpl(this._apiClient);

  final ShareAndHelpApiClient _apiClient;

  @override
  Future<List<ShareAndHelpPost>> getPosts() {
    return _apiClient.getPosts();
  }

  @override
  Future<ShareAndHelpPost> createPost(CreateShareAndHelpPostRequest request) {
    return _apiClient.createPost(request);
  }

  @override
  Future<ShareAndHelpPost> updatePost({
    required String postId,
    required CreateShareAndHelpPostRequest request,
  }) {
    return _apiClient.updatePost(postId: postId, request: request);
  }

  @override
  Future<void> deletePost(String postId) {
    return _apiClient.deletePost(postId);
  }

  @override
  Future<ShareAndHelpPost> addComment({
    required String postId,
    required AddShareAndHelpCommentRequest request,
  }) {
    return _apiClient.addComment(postId: postId, request: request);
  }

  @override
  Future<void> deleteComment({
    required String postId,
    required String commentId,
  }) {
    return _apiClient.deleteComment(postId: postId, commentId: commentId);
  }
}
