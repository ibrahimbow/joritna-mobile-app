import 'dart:async';
import 'dart:convert';

import 'package:stomp_dart_client/stomp_dart_client.dart';

import '../../../../../../core/realtime/realtime_client_factory.dart';
import '../../../../../../core/realtime/realtime_connection_status.dart';
import '../../../../../../core/realtime/realtime_subscription.dart';
import '../../models/chat_websocket_event.dart';

class ChatWebSocketService {
  ChatWebSocketService(this._realtimeClientFactory);

  final RealtimeClientFactory _realtimeClientFactory;

  final StreamController<ChatWebSocketEvent> _eventController =
      StreamController<ChatWebSocketEvent>.broadcast();

  final StreamController<RealtimeConnectionStatus> _statusController =
      StreamController<RealtimeConnectionStatus>.broadcast();

  StompClient? _client;
  StompUnsubscribe? _unsubscribe;
  String? _connectedBuildingId;

  Stream<ChatWebSocketEvent> get events => _eventController.stream;

  Stream<RealtimeConnectionStatus> get status => _statusController.stream;

  Future<void> connect(String buildingId) async {
    final alreadyConnectedToBuilding =
        _client?.connected == true && _connectedBuildingId == buildingId;

    if (alreadyConnectedToBuilding) {
      return;
    }

    await disconnect();

    _connectedBuildingId = buildingId;
    _emitStatus(RealtimeConnectionStatus.connecting);

    _client = await _realtimeClientFactory.createClient(
      onConnect: (_) {
        _emitStatus(RealtimeConnectionStatus.connected);
        _subscribeToBuildingChat(buildingId);
      },
      onDisconnect: (_) {
        _emitStatus(RealtimeConnectionStatus.disconnected);
      },
      onStompError: (_) {
        _emitStatus(RealtimeConnectionStatus.failed);
      },
      onWebSocketError: (_) {
        _emitStatus(RealtimeConnectionStatus.failed);
      },
      onDebugMessage: (_) {},
    );

    _client?.activate();
  }

  Future<void> disconnect() async {
    _unsubscribe?.call();
    _unsubscribe = null;

    _client?.deactivate();
    _client = null;
    _connectedBuildingId = null;

    _emitStatus(RealtimeConnectionStatus.disconnected);
  }

  void _subscribeToBuildingChat(String buildingId) {
    final topic = RealtimeSubscription.buildingChatMessages(buildingId);

    _unsubscribe = _client?.subscribe(
      destination: topic,
      callback: (frame) {
        final body = frame.body;

        if (body == null || body.isEmpty) {
          return;
        }

        try {
          final decoded = jsonDecode(body) as Map<String, dynamic>;
          final event = ChatWebSocketEvent.fromJson(decoded);

          if (!_eventController.isClosed) {
            _eventController.add(event);
          }
        } catch (_) {
          _emitStatus(RealtimeConnectionStatus.failed);
        }
      },
    );
  }

  void _emitStatus(RealtimeConnectionStatus status) {
    if (!_statusController.isClosed) {
      _statusController.add(status);
    }
  }

  Future<void> dispose() async {
    await disconnect();

    await _eventController.close();
    await _statusController.close();
  }
}
