import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest.dart' as tz;
import '../models/favorite_item.dart';

class NotificationService {
  static final NotificationService _instance = NotificationService._internal();
  factory NotificationService() => _instance;
  NotificationService._internal();

  final FlutterLocalNotificationsPlugin _notifications =
      FlutterLocalNotificationsPlugin();

  Future<void> initialize() async {
    tz.initializeTimeZones();

    const androidSettings = AndroidInitializationSettings('@mipmap/ic_launcher');
    const iosSettings = DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
    );

    const initSettings = InitializationSettings(
      android: androidSettings,
      iOS: iosSettings,
    );

    await _notifications.initialize(initSettings);
  }

  Future<bool> requestPermissions() async {
    final androidImplementation =
        _notifications.resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>();
    
    if (androidImplementation != null) {
      await androidImplementation.requestNotificationsPermission();
    }

    final iosImplementation =
        _notifications.resolvePlatformSpecificImplementation<
            IOSFlutterLocalNotificationsPlugin>();
    
    if (iosImplementation != null) {
      await iosImplementation.requestPermissions(
        alert: true,
        badge: true,
        sound: true,
      );
    }

    return true;
  }

  Future<void> scheduleReleaseNotification(FavoriteItem item) async {
    if (item.isReleased) return;

    final notificationId = item.id.hashCode;
    
    // Schedule notification for release day at 9 AM
    final scheduledDate = tz.TZDateTime(
      tz.local,
      item.releaseDate.year,
      item.releaseDate.month,
      item.releaseDate.day,
      9, // 9 AM
    );

    // Only schedule if the date is in the future
    if (scheduledDate.isAfter(tz.TZDateTime.now(tz.local))) {
      await _notifications.zonedSchedule(
        notificationId,
        '${item.title} releases today! 🎬',
        _getNotificationBody(item),
        scheduledDate,
        const NotificationDetails(
          android: AndroidNotificationDetails(
            'release_channel',
            'Release Notifications',
            channelDescription: 'Notifications for upcoming releases',
            importance: Importance.high,
            priority: Priority.high,
          ),
          iOS: DarwinNotificationDetails(),
        ),
        androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
        uiLocalNotificationDateInterpretation:
            UILocalNotificationDateInterpretation.absoluteTime,
      );
    }

    // Optional: Schedule a reminder 1 day before
    final reminderDate = scheduledDate.subtract(const Duration(days: 1));
    if (reminderDate.isAfter(tz.TZDateTime.now(tz.local))) {
      await _notifications.zonedSchedule(
        notificationId + 1,
        '${item.title} releases tomorrow! 📅',
        _getNotificationBody(item),
        reminderDate,
        const NotificationDetails(
          android: AndroidNotificationDetails(
            'reminder_channel',
            'Reminder Notifications',
            channelDescription: 'Reminders for upcoming releases',
            importance: Importance.defaultImportance,
            priority: Priority.defaultPriority,
          ),
          iOS: DarwinNotificationDetails(),
        ),
        androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
        uiLocalNotificationDateInterpretation:
            UILocalNotificationDateInterpretation.absoluteTime,
      );
    }
  }

  Future<void> cancelNotification(FavoriteItem item) async {
    final notificationId = item.id.hashCode;
    await _notifications.cancel(notificationId);
    await _notifications.cancel(notificationId + 1); // Cancel reminder too
  }

  String _getNotificationBody(FavoriteItem item) {
    final type = item.contentType == 'movie' 
        ? 'Movie' 
        : item.contentType == 'tv' 
            ? 'TV Show' 
            : 'Anime';
    
    String body = '$type';
    if (item.genres != null && item.genres!.isNotEmpty) {
      body += ' • ${item.genres!.first}';
    }
    if (item.runtime != null) {
      body += ' • ${item.runtime}min';
    }
    return body;
  }
}
