import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class NotificationService {
  final FlutterLocalNotificationsPlugin _notifications =
      FlutterLocalNotificationsPlugin();

  Future<void> initialize() async {
    const AndroidInitializationSettings androidSettings =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    await _notifications.initialize(
      settings: InitializationSettings(android: androidSettings),
    );
  }

  Future<void> showGoalReachedNotification(int steps) async {
    const AndroidNotificationDetails androidDetails =
        AndroidNotificationDetails(
          'step_goal_channel',
          'Hedef Bildirimleri',
          importance: Importance.high,
          priority: Priority.high,
        );

    await _notifications.show(
      id: 1,
      title: 'Tebrikler! 🎉',
      body: 'Günlük $steps adım hedefinize ulaştınız!',
      notificationDetails: NotificationDetails(android: androidDetails),
    );
  }
}
