import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

import '../../firebase_options.dart';

@pragma('vm:entry-point')
Future<void> firebaseBackgroundMessageHandler(
  final RemoteMessage message,
) async {
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  // Keep background processing lightweight.
  // Firebase displays notification payloads automatically when applicable.
  // Data synchronization can be added here later.
}
