import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class NotificationService {
  final FirebaseMessaging _fcm = FirebaseMessaging.instance;
  final FlutterLocalNotificationsPlugin _flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  Future<void> initialize() async {
    // Request permission for notifications
    await _fcm.requestPermission(
      alert: true,
      badge: true,
      sound: true,
    );

    // Initialize local notifications
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    final DarwinInitializationSettings initializationSettingsIOS =
        DarwinInitializationSettings(
      requestSoundPermission: true,
      requestBadgePermission: true,
      requestAlertPermission: true,
    );

    final InitializationSettings initializationSettings =
        InitializationSettings(
      android: initializationSettingsAndroid,
      iOS: initializationSettingsIOS,
    );

    await _flutterLocalNotificationsPlugin.initialize(
      initializationSettings,
      onDidReceiveNotificationResponse: onDidReceiveNotificationResponse,
    );

    // Handle notifications when app is in background
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      print('Message clicked!');
      handleNotification(message);
    });

    // Handle notifications when app is in foreground
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      print('Got a message whilst in the foreground!');
      showLocalNotification(message);
    });
  }

  Future<void> onDidReceiveLocalNotification(
      int id, String? title, String? body, String? payload) async {
    // Handle iOS local notification
  }

  void onDidReceiveNotificationResponse(NotificationResponse response) {
    // Handle notification tap
    final String? payload = response.payload;
    if (payload != null) {
      print('notification payload: $payload');
      // Navigate to specific screen based on payload
    }
  }

  Future<void> showLocalNotification(RemoteMessage message) async {
    RemoteNotification? notification = message.notification;

    if (notification != null) {
      await _flutterLocalNotificationsPlugin.show(
        notification.hashCode,
        notification.title,
        notification.body,
        NotificationDetails(
          android: AndroidNotificationDetails(
            'high_importance_channel',
            'High Importance Notifications',
            channelDescription:
                'This channel is used for important notifications.',
            importance: Importance.max,
            priority: Priority.high,
            showWhen: true,
          ),
          iOS: const DarwinNotificationDetails(
            presentAlert: true,
            presentBadge: true,
            presentSound: true,
          ),
        ),
        payload: message.data.toString(),
      );
    }
  }

  void handleNotification(RemoteMessage message) {
    if (message.data['type'] == 'booking_status') {
      // Navigate to booking details page
      // Get.toNamed('/booking-details', arguments: message.data['booking_id']);
    } else if (message.data['type'] == 'promotion') {
      // Navigate to promotions page
      // Get.toNamed('/promotions');
    }
  }

  Future<String?> getToken() async {
    return await _fcm.getToken();
  }

  Future<void> subscribeToTopic(String topic) async {
    await _fcm.subscribeToTopic(topic);
  }

  Future<void> unsubscribeFromTopic(String topic) async {
    await _fcm.unsubscribeFromTopic(topic);
  }

  Future<void> sendNotification({
    required String topic,
    required String title,
    required String body,
    Map<String, dynamic>? data,
  }) async {
    final message = RemoteMessage(
      notification: RemoteNotification(
        title: title,
        body: body,
      ),
      data: {...?data, 'topic': topic},
    );
    await showLocalNotification(message);
  }

  void saveTokenToDatabase(String userId, String token) {
    // Save the token to Firestore
    // _db.collection('users').doc(userId).update({
    //   'tokens': FieldValue.arrayUnion([token]),
    //   'lastTokenUpdate': FieldValue.serverTimestamp(),
    // });
  }
}
