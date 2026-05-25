import 'package:firebase_messaging/firebase_messaging.dart';

@pragma('vm:entry-point')
Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  // Keep this top-level. Firebase calls it when app is in background/terminated.
}

class NotificationService {
  NotificationService._();

  static Future<void> init() async {
    final messaging = FirebaseMessaging.instance;

    await messaging.requestPermission(
      alert: true,
      badge: true,
      sound: true,
    );

    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      // Later you can show local notification here.
    });
  }

  static Future<String?> getFcmToken() {
    return FirebaseMessaging.instance.getToken();
  }
}