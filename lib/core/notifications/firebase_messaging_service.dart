import 'dart:async';

import 'package:firebase_messaging/firebase_messaging.dart';

final class FirebaseMessagingService {
  FirebaseMessagingService({required FirebaseMessaging firebaseMessaging})
    : _firebaseMessaging = firebaseMessaging;

  final FirebaseMessaging _firebaseMessaging;

  Future<NotificationSettings> requestPermission() {
    return _firebaseMessaging.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );
  }

  Future<String?> getRegistrationToken() {
    return _firebaseMessaging.getToken();
  }

  Future<void> deleteRegistrationToken() {
    return _firebaseMessaging.deleteToken();
  }

  Stream<String> get onTokenRefresh {
    return _firebaseMessaging.onTokenRefresh;
  }

  /// Notification received while the application is in the foreground.
  Stream<RemoteMessage> get onMessage {
    return FirebaseMessaging.onMessage;
  }

  /// User tapped a notification while the application was in the background.
  Stream<RemoteMessage> get onMessageOpenedApp {
    return FirebaseMessaging.onMessageOpenedApp;
  }

  /// Notification that launched the application from the terminated state.
  Future<RemoteMessage?> getInitialMessage() {
    return _firebaseMessaging.getInitialMessage();
  }

  Future<bool> isPermissionGranted() async {
    final NotificationSettings settings = await _firebaseMessaging
        .getNotificationSettings();

    return settings.authorizationStatus == AuthorizationStatus.authorized ||
        settings.authorizationStatus == AuthorizationStatus.provisional;
  }

  Future<String?> requestPermissionAndGetToken() async {
    final NotificationSettings settings = await requestPermission();

    final bool permissionGranted =
        settings.authorizationStatus == AuthorizationStatus.authorized ||
        settings.authorizationStatus == AuthorizationStatus.provisional;

    if (!permissionGranted) {
      return null;
    }

    return getRegistrationToken();
  }
}
