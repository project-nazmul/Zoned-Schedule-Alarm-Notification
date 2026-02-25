import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:timezone/data/latest_all.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

class NotificationService {
  final FlutterLocalNotificationsPlugin notificationsPlugin = FlutterLocalNotificationsPlugin();

  Future<void> initNotification() async {
    PermissionStatus status = await Permission.notification.request();

    if (status.isGranted) {
      print("Notification permission granted");
    } else{
      // Take the user to the app settings if they've checked "Don't ask again"
      await openAppSettings();
    }

    // Check the current status
    PermissionStatus statuss = await Permission.scheduleExactAlarm.status;

    if (statuss.isDenied) {
      // This opens the "Alarms & Reminders" special access screen
      await Permission.scheduleExactAlarm.request();
    } else if (statuss.isPermanentlyDenied) {
      // If the user previously said no, you may need to guide them to App Settings
      await openAppSettings();
    }
    // 1. Initialize Timezones
    tz.initializeTimeZones();

    // 2. Setup Android/iOS settings
    const AndroidInitializationSettings androidSettings = AndroidInitializationSettings('@mipmap/ic_launcher');
    const DarwinInitializationSettings iosSettings = DarwinInitializationSettings();

    await notificationsPlugin.initialize(
      settings: const InitializationSettings(android: androidSettings, iOS: iosSettings),
    );
  }

  Future<void> scheduleNotification(int id, String title, String body, DateTime scheduledTime) async {
    await notificationsPlugin.zonedSchedule(
      id: id,
      title: title,
      body: body,
      scheduledDate: tz.TZDateTime.from(scheduledTime, tz.local), // Convert DateTime to TZDateTime
      notificationDetails: const NotificationDetails(
        android: AndroidNotificationDetails(
          'channel_id', 'channel_name',
          importance: Importance.max,
          priority: Priority.high,
        ),
        iOS: DarwinNotificationDetails(),
      ),
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle, // Required for modern Android
      matchDateTimeComponents: DateTimeComponents.time, // Optional: repeat daily at this time
    );
  }

}