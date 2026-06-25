import 'package:dio/dio.dart';

import 'models/requests/add_share_and_help_comment_request.dart';
import 'models/requests/create_share_and_help_post_request.dart';
import 'models/share_and_help_post.dart';

class ShareAndHelpApiClient {
  final Dio _dio;

  const ShareAndHelpApiClient(this._dio);

  static const String _basePath = '/tenant/share-and-help/posts';

  Future<List<ShareAndHelpPost>> getPosts() async {
    final response = await _dio.get<List<dynamic>>(_basePath);

    return (response.data ?? [])
        .map((json) => ShareAndHelpPost.fromJson(json as Map<String, dynamic>))
        .toList();
  }

  Future<ShareAndHelpPost> createPost(
    CreateShareAndHelpPostRequest request,
  ) async {
    final response = await _dio.post<Map<String, dynamic>>(
      _basePath,
      data: request.toJson(),
    );

    return ShareAndHelpPost.fromJson(response.data!);
  }

  Future<ShareAndHelpPost> updatePost({
    required String postId,
    required CreateShareAndHelpPostRequest request,
  }) async {
    final response = await _dio.put<Map<String, dynamic>>(
      '$_basePath/$postId',
      data: request.toJson(),
    );

    return ShareAndHelpPost.fromJson(response.data!);
  }

  Future<void> deletePost(String postId) async {
    await _dio.delete<void>('$_basePath/$postId');
  }

  Future<ShareAndHelpPost> addComment({
    required String postId,
    required AddShareAndHelpCommentRequest request,
  }) async {
    final response = await _dio.post<Map<String, dynamic>>(
      '$_basePath/$postId/comments',
      data: request.toJson(),
    );

    return ShareAndHelpPost.fromJson(response.data!);
  }

  Future<void> deleteComment({
    required String postId,
    required String commentId,
  }) async {
    await _dio.delete<void>('$_basePath/$postId/comments/$commentId');
  }
}
