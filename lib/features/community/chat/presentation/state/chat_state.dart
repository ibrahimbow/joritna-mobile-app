import '../../../../../core/realtime/realtime_connection_status.dart';
import '../../data/models/chat_message.dart';

class ChatState {
  const ChatState({
    this.messages = const [],
    this.loading = false,
    this.sending = false,
    this.currentUserId,
    this.connectionStatus = RealtimeConnectionStatus.disconnected,
    this.errorMessage,
  });

  final List<ChatMessage> messages;
  final bool loading;
  final bool sending;
  final int? currentUserId;
  final RealtimeConnectionStatus connectionStatus;
  final String? errorMessage;

  ChatState copyWith({
    List<ChatMessage>? messages,
    bool? loading,
    bool? sending,
    int? currentUserId,
    RealtimeConnectionStatus? connectionStatus,
    String? errorMessage,
    bool clearError = false,
  }) {
    return ChatState(
      messages: messages ?? this.messages,
      loading: loading ?? this.loading,
      sending: sending ?? this.sending,
      currentUserId: currentUserId ?? this.currentUserId,
      connectionStatus: connectionStatus ?? this.connectionStatus,
      errorMessage: clearError ? null : errorMessage ?? this.errorMessage,
    );
  }
}
