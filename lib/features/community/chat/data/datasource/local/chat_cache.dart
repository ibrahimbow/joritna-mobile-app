import '../../models/chat_message.dart';

class ChatCache {
  final Map<String, List<ChatMessage>> _messagesByBuildingId = {};

  List<ChatMessage> getMessages(String buildingId) {
    return List.unmodifiable(_messagesByBuildingId[buildingId] ?? const []);
  }

  void saveMessages({
    required String buildingId,
    required List<ChatMessage> messages,
  }) {
    final sortedMessages = [...messages]
      ..sort((a, b) => a.createdAt.compareTo(b.createdAt));

    _messagesByBuildingId[buildingId] = sortedMessages;
  }

  void upsertMessage({
    required String buildingId,
    required ChatMessage message,
  }) {
    final messages = [...getMessages(buildingId)];

    final index = messages.indexWhere((existing) => existing.id == message.id);

    if (index == -1) {
      messages.add(message);
    } else {
      messages[index] = message;
    }

    saveMessages(buildingId: buildingId, messages: messages);
  }

  void clearBuilding(String buildingId) {
    _messagesByBuildingId.remove(buildingId);
  }

  void clearAll() {
    _messagesByBuildingId.clear();
  }
}
