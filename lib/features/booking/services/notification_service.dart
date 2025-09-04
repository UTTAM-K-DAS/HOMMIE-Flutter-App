import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import '../models/booking_model.dart';

class NotificationService {
  final FlutterLocalNotificationsPlugin _notifications =
      FlutterLocalNotificationsPlugin();

  NotificationService() {
    _initializeNotifications();
  }

  Future<void> _initializeNotifications() async {
    const androidSettings =
        AndroidInitializationSettings('@mipmap/ic_launcher');
    const iosSettings = DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
    );

    const settings = InitializationSettings(
      android: androidSettings,
      iOS: iosSettings,
    );

    await _notifications.initialize(settings);
  }

  Future<void> showBookingConfirmation(BookingModel booking) async {
    const androidDetails = AndroidNotificationDetails(
      'booking_channel',
      'Booking Notifications',
      channelDescription: 'Notifications for booking status updates',
      importance: Importance.high,
      priority: Priority.high,
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

    await _notifications.show(
      booking.hashCode,
      'Booking Confirmed',
      'Your booking for ${booking.service.name} on ${_formatDateTime(booking.dateTime)} has been confirmed.',
      details,
    );
  }

  Future<void> showBookingReminder(BookingModel booking) async {
    const androidDetails = AndroidNotificationDetails(
      'reminder_channel',
      'Booking Reminders',
      channelDescription: 'Reminders for upcoming bookings',
      importance: Importance.high,
      priority: Priority.high,
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

    await _notifications.show(
      booking.hashCode + 1, // Different ID from confirmation
      'Upcoming Booking',
      'Reminder: You have ${booking.service.name} scheduled for ${_formatDateTime(booking.dateTime)}',
      details,
    );
  }

  String _formatDateTime(DateTime dateTime) {
    return '${dateTime.day}/${dateTime.month}/${dateTime.year} at ${dateTime.hour}:${dateTime.minute.toString().padLeft(2, '0')}';
  }
}
