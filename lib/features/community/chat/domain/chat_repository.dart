import '../data/models/chat_message.dart';
import '../data/models/chat_reaction.dart';
import '../data/models/chat_websocket_event.dart';
import '../data/models/requests/react_to_chat_message_request.dart';
import '../data/models/requests/send_chat_message_request.dart';
import '../../../../core/realtime/realtime_connection_status.dart';

abstract interface class ChatRepository {
  List<ChatMessage> getCachedMessages(String buildingId);

  Future<List<ChatMessage>> getMessages(String buildingId);

  Future<ChatMessage> sendMessage(SendChatMessageRequest request);

  Future<void> deleteMessage(String messageId);

  Future<ChatReaction?> reactToMessage(
    String messageId,
    ReactToChatMessageRequest request,
  );

  Future<void> removeReaction(
    String messageId,
    ReactToChatMessageRequest request,
  );

  Future<void> connectToRealtime(String buildingId);

  Future<void> disconnectFromRealtime();

  Stream<ChatWebSocketEvent> get realtimeEvents;

  Stream<RealtimeConnectionStatus> get realtimeStatus;
}
