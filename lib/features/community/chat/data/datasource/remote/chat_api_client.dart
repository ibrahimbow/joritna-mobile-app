import 'package:dio/dio.dart';

import '../../models/chat_message.dart';
import '../../models/chat_reaction.dart';
import '../../models/requests/react_to_chat_message_request.dart';
import '../../models/requests/send_chat_message_request.dart';

class ChatApiClient {
  const ChatApiClient({required Dio dio, required String basePath})
    : _dio = dio,
      _basePath = basePath;

  final Dio _dio;
  final String _basePath;

  Future<List<ChatMessage>> getMessages() async {
    final response = await _dio.get<List<dynamic>>(_basePath);

    final data = response.data ?? <dynamic>[];

    return data
        .map((json) => ChatMessage.fromJson(json as Map<String, dynamic>))
        .toList(growable: false);
  }

  Future<ChatMessage> sendMessage(SendChatMessageRequest request) async {
    final response = await _dio.post<Map<String, dynamic>>(
      _basePath,
      data: request.toJson(),
    );

    return ChatMessage.fromJson(response.data!);
  }

  Future<void> deleteMessage(String messageId) async {
    await _dio.delete<void>('$_basePath/$messageId');
  }

  Future<ChatReaction?> reactToMessage(
    String messageId,
    ReactToChatMessageRequest request,
  ) async {
    final response = await _dio.post<Map<String, dynamic>?>(
      '$_basePath/$messageId/reactions',
      data: request.toJson(),
    );

    if (response.statusCode == 204 || response.data == null) {
      return null;
    }

    return ChatReaction.fromJson(response.data!);
  }

  Future<void> removeReaction(
    String messageId,
    ReactToChatMessageRequest request,
  ) async {
    await _dio.delete<void>(
      '$_basePath/$messageId/reactions',
      data: request.toJson(),
    );
  }
}
