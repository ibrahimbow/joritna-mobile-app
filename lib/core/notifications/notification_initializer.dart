import 'dart:async';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';

import '../../features/notifications/data/datasource/remote/notification_websocket_service.dart';
import 'firebase_messaging_service.dart';
import 'notification_handler.dart';
import 'push_device_registration_service.dart';

final class NotificationInitializer {
  NotificationInitializer({
    required FirebaseMessagingService firebaseMessagingService,
    required PushDeviceRegistrationService pushDeviceRegistrationService,
    required NotificationWebSocketService notificationWebSocketService,
    required NotificationHandler notificationHandler,
  }) : _firebaseMessagingService = firebaseMessagingService,
       _pushDeviceRegistrationService = pushDeviceRegistrationService,
       _notificationWebSocketService = notificationWebSocketService,
       _notificationHandler = notificationHandler;

  final FirebaseMessagingService _firebaseMessagingService;
  final PushDeviceRegistrationService _pushDeviceRegistrationService;
  final NotificationWebSocketService _notificationWebSocketService;
  final NotificationHandler _notificationHandler;

  StreamSubscription<RemoteMessage>? _foregroundMessageSubscription;
  StreamSubscription<RemoteMessage>? _messageOpenedSubscription;

  int? _activeUserId;
  String? _activeSocketUrl;
  String? _activeAccessToken;

  bool _isInitializing = false;
  bool _isInitialized = false;
  bool _isDisposed = false;

  Future<void> initialize({
    required int userId,
    required String socketUrl,
    required String accessToken,
  }) async {
    if (_isDisposed) {
      throw StateError('NotificationInitializer has already been disposed.');
    }

    final normalizedSocketUrl = socketUrl.trim();
    final normalizedAccessToken = accessToken.trim();

    if (normalizedSocketUrl.isEmpty) {
      throw ArgumentError.value(
        socketUrl,
        'socketUrl',
        'WebSocket URL must not be empty.',
      );
    }

    if (normalizedAccessToken.isEmpty) {
      throw ArgumentError.value(
        accessToken,
        'accessToken',
        'Access token must not be empty.',
      );
    }

    if (_isInitializing) {
      debugPrint('Notification initialization is already in progress.');
      return;
    }

    final sameSession =
        _isInitialized &&
        _activeUserId == userId &&
        _activeSocketUrl == normalizedSocketUrl &&
        _activeAccessToken == normalizedAccessToken;

    if (sameSession) {
      debugPrint('Notifications are already initialized for user $userId.');
      return;
    }

    _isInitializing = true;

    try {
      if (_isInitialized) {
        await _resetActiveSession();
      }

      await _pushDeviceRegistrationService.initialize();

      _foregroundMessageSubscription = _firebaseMessagingService.onMessage
          .listen(
            _notificationHandler.onForegroundMessage,
            onError: (Object error, StackTrace stackTrace) {
              debugPrint('Foreground notification stream failed: $error');
              debugPrintStack(stackTrace: stackTrace);
            },
          );

      _messageOpenedSubscription = _firebaseMessagingService.onMessageOpenedApp
          .listen(
            _notificationHandler.onNotificationOpened,
            onError: (Object error, StackTrace stackTrace) {
              debugPrint('Notification-open stream failed: $error');
              debugPrintStack(stackTrace: stackTrace);
            },
          );

      final initialMessage = await _firebaseMessagingService
          .getInitialMessage();

      if (initialMessage != null) {
        await _notificationHandler.onInitialMessage(initialMessage);
      }

      _notificationWebSocketService.connect(
        socketUrl: normalizedSocketUrl,
        userId: userId,
        accessToken: normalizedAccessToken,
        onNotificationReceived: (payload) {
          unawaited(_notificationHandler.onWebSocketMessage(payload));
        },
      );

      _activeUserId = userId;
      _activeSocketUrl = normalizedSocketUrl;
      _activeAccessToken = normalizedAccessToken;
      _isInitialized = true;

      debugPrint('Notification infrastructure initialized for user $userId.');
    } catch (error, stackTrace) {
      await _resetActiveSession();

      debugPrint('Notification initialization failed: $error');
      debugPrintStack(stackTrace: stackTrace);

      rethrow;
    } finally {
      _isInitializing = false;
    }
  }

  Future<void> reset() async {
    if (_isDisposed) {
      return;
    }

    await _resetActiveSession();

    debugPrint('Notification session reset.');
  }

  Future<void> _resetActiveSession() async {
    await _foregroundMessageSubscription?.cancel();
    await _messageOpenedSubscription?.cancel();
    await _notificationWebSocketService.disconnect();

    _foregroundMessageSubscription = null;
    _messageOpenedSubscription = null;

    _activeUserId = null;
    _activeSocketUrl = null;
    _activeAccessToken = null;

    _isInitialized = false;
  }

  Future<void> dispose() async {
    if (_isDisposed) {
      return;
    }

    _isDisposed = true;

    await _resetActiveSession();
  }
}
