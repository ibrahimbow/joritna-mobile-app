import 'dart:async';
import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:stomp_dart_client/stomp_dart_client.dart';

typedef NotificationWebSocketMessageHandler =
    FutureOr<void> Function(Map<String, dynamic> payload);

final class NotificationWebSocketService {
  NotificationWebSocketService();

  StompClient? _client;
  StompUnsubscribe? _notificationSubscription;

  bool _isConnecting = false;
  bool _isConnected = false;
  bool _isDisposed = false;

  bool get isConnected => _isConnected;

  void connect({
    required String socketUrl,
    required int userId,
    required NotificationWebSocketMessageHandler onNotificationReceived,
    String? accessToken,
  }) {
    if (_isDisposed) {
      throw StateError(
        'NotificationWebSocketService has already been disposed.',
      );
    }

    if (_isConnecting || _isConnected) {
      debugPrint('Notification WebSocket connection is already active.');

      return;
    }

    final String normalizedSocketUrl = socketUrl.trim();

    if (normalizedSocketUrl.isEmpty) {
      throw ArgumentError.value(
        socketUrl,
        'socketUrl',
        'Notification WebSocket URL must not be empty.',
      );
    }

    if (userId <= 0) {
      throw ArgumentError.value(
        userId,
        'userId',
        'Notification WebSocket user ID must be positive.',
      );
    }

    _isConnecting = true;

    final Map<String, String> connectHeaders = <String, String>{};
    final String normalizedAccessToken = accessToken?.trim() ?? '';

    if (normalizedAccessToken.isNotEmpty) {
      connectHeaders['Authorization'] = 'Bearer $normalizedAccessToken';
    }

    _client = StompClient(
      config: StompConfig.sockJS(
        url: normalizedSocketUrl,
        stompConnectHeaders: connectHeaders,
        reconnectDelay: const Duration(seconds: 3),
        heartbeatIncoming: const Duration(seconds: 10),
        heartbeatOutgoing: const Duration(seconds: 10),
        connectionTimeout: const Duration(seconds: 10),
        onConnect: (final StompFrame frame) {
          _handleConnected(
            userId: userId,
            onNotificationReceived: onNotificationReceived,
          );
        },
        onDisconnect: _handleDisconnected,
        onWebSocketDone: _handleWebSocketDone,
        onWebSocketError: _handleWebSocketError,
        onStompError: _handleStompError,
        onDebugMessage: (final String message) {
          if (kDebugMode) {
            debugPrint(_sanitizeDebugMessage(message));
          }
        },
      ),
    );

    debugPrint('Connecting notification WebSocket: $normalizedSocketUrl');

    _client!.activate();
  }

  void _handleConnected({
    required int userId,
    required NotificationWebSocketMessageHandler onNotificationReceived,
  }) {
    if (_isDisposed) {
      return;
    }

    _isConnecting = false;
    _isConnected = true;

    final String destination = '/topic/users/$userId/notifications';

    debugPrint('Notification WebSocket connected.');
    debugPrint('Subscribing to: $destination');

    _notificationSubscription?.call();

    _notificationSubscription = _client?.subscribe(
      destination: destination,
      callback: (final StompFrame frame) {
        unawaited(
          _handleNotificationFrame(
            frame: frame,
            onNotificationReceived: onNotificationReceived,
          ),
        );
      },
    );
  }

  Future<void> _handleNotificationFrame({
    required StompFrame frame,
    required NotificationWebSocketMessageHandler onNotificationReceived,
  }) async {
    final String? body = frame.body;

    if (body == null || body.trim().isEmpty) {
      debugPrint('Notification WebSocket received an empty message.');

      return;
    }

    try {
      final Object? decodedPayload = jsonDecode(body);

      if (decodedPayload is! Map<String, dynamic>) {
        debugPrint(
          'Notification WebSocket received an unsupported payload: '
          '${decodedPayload.runtimeType}.',
        );

        return;
      }

      debugPrint('Notification WebSocket message received: $decodedPayload');

      await Future<void>.sync(() => onNotificationReceived(decodedPayload));

      debugPrint('Notification WebSocket message processed successfully.');
    } on FormatException catch (error, stackTrace) {
      debugPrint('Notification WebSocket JSON parsing failed: $error');

      debugPrintStack(stackTrace: stackTrace);
    } catch (error, stackTrace) {
      debugPrint('Notification WebSocket message processing failed: $error');

      debugPrintStack(stackTrace: stackTrace);
    }
  }

  void _handleDisconnected(final StompFrame frame) {
    _resetConnectionState();

    debugPrint('Notification WebSocket disconnected.');
  }

  void _handleWebSocketDone() {
    _resetConnectionState();

    debugPrint('Notification WebSocket connection closed.');
  }

  void _handleWebSocketError(final dynamic error) {
    _resetConnectionState();

    debugPrint('Notification WebSocket error: $error');
  }

  void _handleStompError(final StompFrame frame) {
    debugPrint(
      'Notification STOMP error: '
      'headers=${frame.headers}, '
      'body=${frame.body}',
    );
  }

  void _resetConnectionState() {
    _isConnecting = false;
    _isConnected = false;
    _notificationSubscription = null;
  }

  String _sanitizeDebugMessage(final String message) {
    final RegExp authorizationPattern = RegExp(
      r'Authorization:Bearer\s+[^\n\\"]+',
      caseSensitive: false,
    );

    final String sanitizedMessage = message.replaceAll(
      authorizationPattern,
      'Authorization:Bearer [REDACTED]',
    );

    return 'Notification STOMP: $sanitizedMessage';
  }

  Future<void> disconnect() async {
    _notificationSubscription?.call();
    _notificationSubscription = null;

    final StompClient? client = _client;

    _client = null;
    _isConnecting = false;
    _isConnected = false;

    client?.deactivate();

    debugPrint('Notification WebSocket disconnected manually.');
  }

  Future<void> dispose() async {
    if (_isDisposed) {
      return;
    }

    _isDisposed = true;

    await disconnect();
  }
}
