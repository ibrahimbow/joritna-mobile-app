import 'chat_message.dart';

enum ChatWebSocketEventType {
  messageCreated,
  messageDeleted,
  reactionUpdated,
  unknown,
}

class ChatWebSocketEvent {
  const ChatWebSocketEvent({
    required this.type,
    required this.buildingId,
    required this.message,
  });

  final ChatWebSocketEventType type;

  final String buildingId;

  final ChatMessage message;

  factory ChatWebSocketEvent.fromJson(Map<String, dynamic> json) {
    return ChatWebSocketEvent(
      type: ChatWebSocketEventTypeExtension.fromBackend(
        json['type'] as String?,
      ),
      buildingId: json['buildingId'] as String,
      message: ChatMessage.fromJson(json['message'] as Map<String, dynamic>),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'type': type.backendValue,
      'buildingId': buildingId,
      'message': message.toJson(),
    };
  }
}

extension ChatWebSocketEventTypeExtension on ChatWebSocketEventType {
  static ChatWebSocketEventType fromBackend(String? value) {
    switch (value) {
      case 'MESSAGE_CREATED':
        return ChatWebSocketEventType.messageCreated;

      case 'MESSAGE_DELETED':
        return ChatWebSocketEventType.messageDeleted;

      case 'REACTION_UPDATED':
        return ChatWebSocketEventType.reactionUpdated;

      default:
        return ChatWebSocketEventType.unknown;
    }
  }

  String get backendValue {
    switch (this) {
      case ChatWebSocketEventType.messageCreated:
        return 'MESSAGE_CREATED';

      case ChatWebSocketEventType.messageDeleted:
        return 'MESSAGE_DELETED';

      case ChatWebSocketEventType.reactionUpdated:
        return 'REACTION_UPDATED';

      case ChatWebSocketEventType.unknown:
        return 'UNKNOWN';
    }
  }
}
