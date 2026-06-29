import 'package:stomp_dart_client/stomp_dart_client.dart';

import '../../app/config/app_config.dart';
import '../storage/token_storage.dart';
import 'realtime_config.dart';

class RealtimeClientFactory {
  const RealtimeClientFactory(this._tokenStorage);

  final TokenStorage _tokenStorage;

  Future<StompClient> createClient({
    required void Function(StompFrame frame) onConnect,
    required void Function(dynamic error) onWebSocketError,
    void Function(StompFrame frame) onDisconnect = _noopFrame,
    void Function(StompFrame frame) onStompError = _noopFrame,
    void Function(String message) onDebugMessage = _noopDebug,
  }) async {
    final token = await _tokenStorage.getAccessToken();

    return StompClient(
      config: StompConfig.sockJS(
        url: '${AppConfig.webSocketBaseUrl}${RealtimeConfig.stompEndpoint}',
        reconnectDelay: RealtimeConfig.reconnectDelay,
        heartbeatOutgoing: RealtimeConfig.heartbeatOutgoing,
        heartbeatIncoming: RealtimeConfig.heartbeatIncoming,
        stompConnectHeaders: {
          if (token != null && token.isNotEmpty)
            'Authorization': 'Bearer $token',
        },
        webSocketConnectHeaders: {
          if (token != null && token.isNotEmpty)
            'Authorization': 'Bearer $token',
        },
        onConnect: onConnect,
        onDisconnect: onDisconnect,
        onStompError: onStompError,
        onWebSocketError: onWebSocketError,
        onDebugMessage: onDebugMessage,
      ),
    );
  }
}

void _noopFrame(StompFrame frame) {}

void _noopDebug(String message) {}
