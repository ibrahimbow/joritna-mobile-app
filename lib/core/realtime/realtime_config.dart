class RealtimeConfig {
  const RealtimeConfig._();

  static const String stompEndpoint = '/ws/chat';

  static const Duration reconnectDelay = Duration(seconds: 5);

  static const Duration heartbeatOutgoing = Duration(seconds: 10);

  static const Duration heartbeatIncoming = Duration(seconds: 10);
}
