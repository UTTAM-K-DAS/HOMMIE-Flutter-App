import 'dart:developer' as developer;
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:timezone/timezone.dart' as tz;

class NotificationService {
  static final NotificationService _instance = NotificationService._internal();
  factory NotificationService() => _instance;
  NotificationService._internal();

  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;
  final FlutterLocalNotificationsPlugin _localNotifications =
      FlutterLocalNotificationsPlugin();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  String? _fcmToken;
  bool _isInitialized = false;

  // Initialize notification service
  Future<void> initialize() async {
    if (_isInitialized) return;

    try {
      // Request permission for notifications
      await _requestPermission();

      // Initialize local notifications
      await _initializeLocalNotifications();

      // Get FCM token
      await _getFCMToken();

      // Set up message handlers
      _setupMessageHandlers();

      _isInitialized = true;
      developer.log(
        'NotificationService initialized successfully',
        name: 'NotificationService',
      );
    } catch (e) {
      developer.log(
        'Error initializing NotificationService: $e',
        name: 'NotificationService',
      );
    }
  }

  // Request notification permissions
  Future<void> _requestPermission() async {
    final settings = await _firebaseMessaging.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );

    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      developer.log('User granted permission', name: 'NotificationService');
    } else if (settings.authorizationStatus ==
        AuthorizationStatus.provisional) {
      developer.log(
        'User granted provisional permission',
        name: 'NotificationService',
      );
    } else {
      developer.log(
        'User declined or has not accepted permission',
        name: 'NotificationService',
      );
    }
  }

  // Initialize local notifications
  Future<void> _initializeLocalNotifications() async {
    const androidSettings = AndroidInitializationSettings(
      '@mipmap/ic_launcher',
    );
    const iosSettings = DarwinInitializationSettings(
      requestAlertPermission: false,
      requestBadgePermission: false,
      requestSoundPermission: false,
    );

    const initSettings = InitializationSettings(
      android: androidSettings,
      iOS: iosSettings,
    );

    await _localNotifications.initialize(
      initSettings,
      onDidReceiveNotificationResponse: _onNotificationTapped,
    );
  }

  // Handle notification tap
  void _onNotificationTapped(NotificationResponse response) {
    developer.log(
      'Notification tapped: ${response.payload}',
      name: 'NotificationService',
    );
    // Handle navigation based on payload
    _handleNotificationNavigation(response.payload);
  }

  // Get FCM token
  Future<void> _getFCMToken() async {
    try {
      _fcmToken = await _firebaseMessaging.getToken();
      developer.log('FCM Token: $_fcmToken', name: 'NotificationService');

      // Save token to Firestore for admin use
      if (_fcmToken != null) {
        await _saveTokenToFirestore(_fcmToken!);
      }
    } catch (e) {
      developer.log('Error getting FCM token: $e', name: 'NotificationService');
    }
  }

  // Save FCM token to Firestore
  Future<void> _saveTokenToFirestore(String token) async {
    try {
      await _firestore.collection('admin_tokens').doc('current').set({
        'token': token,
        'platform': defaultTargetPlatform.toString(),
        'timestamp': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      developer.log(
        'Error saving token to Firestore: $e',
        name: 'NotificationService',
      );
    }
  }

  // Set up message handlers
  void _setupMessageHandlers() {
    // Handle foreground messages
    FirebaseMessaging.onMessage.listen(_handleForegroundMessage);

    // Handle background messages
    FirebaseMessaging.onBackgroundMessage(_handleBackgroundMessage);

    // Handle notification opened app
    FirebaseMessaging.onMessageOpenedApp.listen(_handleMessageOpenedApp);

    // Handle token refresh
    _firebaseMessaging.onTokenRefresh.listen((token) {
      _fcmToken = token;
      _saveTokenToFirestore(token);
    });
  }

  // Handle foreground messages
  void _handleForegroundMessage(RemoteMessage message) {
    developer.log(
      'Received foreground message: ${message.messageId}',
      name: 'NotificationService',
    );

    // Show local notification for foreground messages
    _showLocalNotification(
      title: message.notification?.title ?? 'New Notification',
      body: message.notification?.body ?? '',
      payload: message.data.toString(),
    );
  }

  // Handle message when app is opened from notification
  void _handleMessageOpenedApp(RemoteMessage message) {
    developer.log(
      'App opened from notification: ${message.messageId}',
      name: 'NotificationService',
    );
    _handleNotificationNavigation(message.data.toString());
  }

  // Handle navigation based on notification data
  void _handleNotificationNavigation(String? payload) {
    if (payload == null) return;

    try {
      // Parse payload and navigate accordingly
      // This would be implemented based on your app's navigation structure
      developer.log(
        'Handling navigation for payload: $payload',
        name: 'NotificationService',
      );
    } catch (e) {
      developer.log(
        'Error handling notification navigation: $e',
        name: 'NotificationService',
      );
    }
  }

  // Show local notification
  Future<void> _showLocalNotification({
    required String title,
    required String body,
    String? payload,
  }) async {
    const androidDetails = AndroidNotificationDetails(
      'admin_channel',
      'Admin Notifications',
      channelDescription: 'Notifications for admin panel',
      importance: Importance.high,
      priority: Priority.high,
      icon: '@mipmap/ic_launcher',
    );

    const iosDetails = DarwinNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
    );

    const details = NotificationDetails(
      android: androidDetails,
      iOS: iosDetails,
    );

    await _localNotifications.show(
      DateTime.now().millisecondsSinceEpoch.remainder(100000),
      title,
      body,
      details,
      payload: payload,
    );
  }

  // Send notification to specific user
  Future<void> sendNotificationToUser({
    required String userId,
    required String title,
    required String body,
    Map<String, dynamic>? data,
  }) async {
    try {
      // Get user's FCM token
      final userDoc = await _firestore.collection('users').doc(userId).get();
      final fcmToken = userDoc.data()?['fcmToken'] as String?;

      if (fcmToken != null) {
        await _sendPushNotification(
          token: fcmToken,
          title: title,
          body: body,
          data: data,
        );
      }

      // Save notification to Firestore
      await _saveNotificationToFirestore(
        userId: userId,
        title: title,
        body: body,
        data: data,
      );
    } catch (e) {
      developer.log(
        'Error sending notification to user: $e',
        name: 'NotificationService',
      );
    }
  }

  // Send notification to all users
  Future<void> sendNotificationToAllUsers({
    required String title,
    required String body,
    Map<String, dynamic>? data,
  }) async {
    try {
      // Get all user tokens
      final usersSnapshot = await _firestore.collection('users').get();

      for (final doc in usersSnapshot.docs) {
        final fcmToken = doc.data()['fcmToken'] as String?;
        if (fcmToken != null) {
          await _sendPushNotification(
            token: fcmToken,
            title: title,
            body: body,
            data: data,
          );
        }
      }

      // Save broadcast notification
      await _saveBroadcastNotification(title: title, body: body, data: data);
    } catch (e) {
      developer.log(
        'Error sending notification to all users: $e',
        name: 'NotificationService',
      );
    }
  }

  // Send notification to service providers
  Future<void> sendNotificationToProviders({
    required String title,
    required String body,
    Map<String, dynamic>? data,
  }) async {
    try {
      final providersSnapshot = await _firestore
          .collection('users')
          .where('isProvider', isEqualTo: true)
          .get();

      for (final doc in providersSnapshot.docs) {
        final fcmToken = doc.data()['fcmToken'] as String?;
        if (fcmToken != null) {
          await _sendPushNotification(
            token: fcmToken,
            title: title,
            body: body,
            data: data,
          );
        }
      }
    } catch (e) {
      developer.log(
        'Error sending notification to providers: $e',
        name: 'NotificationService',
      );
    }
  }

  // Send push notification via FCM
  Future<void> _sendPushNotification({
    required String token,
    required String title,
    required String body,
    Map<String, dynamic>? data,
  }) async {
    try {
      // This would typically use Firebase Functions or a server
      // For now, we'll use Firestore to queue notifications
      await _firestore.collection('notification_queue').add({
        'token': token,
        'title': title,
        'body': body,
        'data': data ?? {},
        'timestamp': FieldValue.serverTimestamp(),
        'status': 'pending',
      });
    } catch (e) {
      developer.log(
        'Error sending push notification: $e',
        name: 'NotificationService',
      );
    }
  }

  // Save notification to Firestore
  Future<void> _saveNotificationToFirestore({
    required String userId,
    required String title,
    required String body,
    Map<String, dynamic>? data,
  }) async {
    try {
      await _firestore.collection('notifications').add({
        'userId': userId,
        'title': title,
        'body': body,
        'data': data ?? {},
        'timestamp': FieldValue.serverTimestamp(),
        'read': false,
        'type': 'individual',
      });
    } catch (e) {
      developer.log(
        'Error saving notification to Firestore: $e',
        name: 'NotificationService',
      );
    }
  }

  // Save broadcast notification
  Future<void> _saveBroadcastNotification({
    required String title,
    required String body,
    Map<String, dynamic>? data,
  }) async {
    try {
      await _firestore.collection('notifications').add({
        'title': title,
        'body': body,
        'data': data ?? {},
        'timestamp': FieldValue.serverTimestamp(),
        'type': 'broadcast',
        'sentBy': 'admin',
      });
    } catch (e) {
      developer.log(
        'Error saving broadcast notification: $e',
        name: 'NotificationService',
      );
    }
  }

  // Get notifications for admin
  Stream<QuerySnapshot> getNotifications() {
    return _firestore
        .collection('notifications')
        .orderBy('timestamp', descending: true)
        .limit(100)
        .snapshots();
  }

  // Mark notification as read
  Future<void> markAsRead(String notificationId) async {
    try {
      await _firestore.collection('notifications').doc(notificationId).update({
        'read': true,
        'readAt': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      developer.log(
        'Error marking notification as read: $e',
        name: 'NotificationService',
      );
    }
  }

  // Delete notification
  Future<void> deleteNotification(String notificationId) async {
    try {
      await _firestore.collection('notifications').doc(notificationId).delete();
    } catch (e) {
      developer.log(
        'Error deleting notification: $e',
        name: 'NotificationService',
      );
    }
  }

  // Schedule local notification
  Future<void> scheduleNotification({
    required String title,
    required String body,
    required DateTime scheduledDate,
    String? payload,
  }) async {
    const androidDetails = AndroidNotificationDetails(
      'scheduled_channel',
      'Scheduled Notifications',
      channelDescription: 'Scheduled notifications for admin',
      importance: Importance.high,
      priority: Priority.high,
    );

    const iosDetails = DarwinNotificationDetails();

    const details = NotificationDetails(
      android: androidDetails,
      iOS: iosDetails,
    );

    await _localNotifications.zonedSchedule(
      scheduledDate.millisecondsSinceEpoch.remainder(100000),
      title,
      body,
      tz.TZDateTime.from(scheduledDate, tz.local),
      details,
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      payload: payload,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
    );
  }

  // Cancel all notifications
  Future<void> cancelAllNotifications() async {
    await _localNotifications.cancelAll();
  }

  // Get FCM token
  String? get fcmToken => _fcmToken;

  // Check if initialized
  bool get isInitialized => _isInitialized;
}

// Background message handler (must be top-level function)
@pragma('vm:entry-point')
Future<void> _handleBackgroundMessage(RemoteMessage message) async {
  developer.log(
    'Handling background message: ${message.messageId}',
    name: 'NotificationService',
  );

  // Save notification to local storage or handle as needed
  // This runs in the background so UI operations are not allowed
}
