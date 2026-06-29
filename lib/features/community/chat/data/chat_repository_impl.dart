import '../../../../core/realtime/realtime_connection_status.dart';
import '../domain/chat_repository.dart';
import 'datasource/local/chat_cache.dart';
import 'datasource/remote/chat_api_client.dart';
import 'datasource/remote/chat_websocket_service.dart';
import 'models/chat_message.dart';
import 'models/chat_reaction.dart';
import 'models/chat_websocket_event.dart';
import 'models/requests/react_to_chat_message_request.dart';
import 'models/requests/send_chat_message_request.dart';

class ChatRepositoryImpl implements ChatRepository {
  const ChatRepositoryImpl({
    required ChatApiClient apiClient,
    required ChatWebSocketService webSocketService,
    required ChatCache cache,
  }) : _apiClient = apiClient,
       _webSocketService = webSocketService,
       _cache = cache;

  final ChatApiClient _apiClient;
  final ChatWebSocketService _webSocketService;
  final ChatCache _cache;

  @override
  List<ChatMessage> getCachedMessages(String buildingId) {
    return _cache.getMessages(buildingId);
  }

  @override
  Future<List<ChatMessage>> getMessages(String buildingId) async {
    final messages = await _apiClient.getMessages();

    _cache.saveMessages(buildingId: buildingId, messages: messages);

    return messages;
  }

  @override
  Future<ChatMessage> sendMessage(SendChatMessageRequest request) {
    return _apiClient.sendMessage(request);
  }

  @override
  Future<void> deleteMessage(String messageId) {
    return _apiClient.deleteMessage(messageId);
  }

  @override
  Future<ChatReaction?> reactToMessage(
    String messageId,
    ReactToChatMessageRequest request,
  ) {
    return _apiClient.reactToMessage(messageId, request);
  }

  @override
  Future<void> removeReaction(
    String messageId,
    ReactToChatMessageRequest request,
  ) {
    return _apiClient.removeReaction(messageId, request);
  }

  @override
  Future<void> connectToRealtime(String buildingId) {
    return _webSocketService.connect(buildingId);
  }

  @override
  Future<void> disconnectFromRealtime() {
    return _webSocketService.disconnect();
  }

  @override
  Stream<ChatWebSocketEvent> get realtimeEvents {
    return _webSocketService.events.map((event) {
      _cache.upsertMessage(
        buildingId: event.buildingId,
        message: event.message,
      );

      return event;
    });
  }

  @override
  Stream<RealtimeConnectionStatus> get realtimeStatus =>
      _webSocketService.status;
}
