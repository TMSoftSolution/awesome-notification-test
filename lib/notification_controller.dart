import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:flutter/material.dart';

class NotificationsController {
  // ***************************************************************
  //    INITIALIZATIONS
  // ***************************************************************
  static Future<void> initializeLocalNotifications() async {
    AwesomeNotifications()
        .initialize('resource://drawable/res_notification_app_icon', [
      NotificationChannel(
        channelGroupKey: "daily_data_channel_group",
        channelKey: "daily_data_channel",
        channelName: 'Daily Data Notifications',
        channelDescription: 'Daily Data Notifications',
        importance: NotificationImportance.High,
        defaultColor: const Color(0xFF2A9D8F),
        ledColor: Colors.white,
      ),
    ], channelGroups: [
      NotificationChannelGroup(
          channelGroupKey: "daily_data_channel_group",
          channelGroupName: "Daily Notification")
    ]);
  }

  static Future<void> initializeNotificationsEventListeners() async {
    // Only after at least the action method is set, the notification events are delivered
    AwesomeNotifications().setListeners(
        onActionReceivedMethod: NotificationsController.onActionReceivedMethod,
        onNotificationCreatedMethod:
            NotificationsController.onNotificationCreatedMethod,
        onNotificationDisplayedMethod:
            NotificationsController.onNotificationDisplayedMethod,
        onDismissActionReceivedMethod:
            NotificationsController.onDismissActionReceivedMethod);
  }

  // ***************************************************************
  //    NOTIFICATIONS EVENT LISTENERS
  // ***************************************************************

  /// Use this method to detect when a new notification or a schedule is created
  static Future<void> onNotificationCreatedMethod(
      ReceivedNotification receivedNotification) async {}

  /// Use this method to detect every time that a new notification is displayed
  static Future<void> onNotificationDisplayedMethod(
      ReceivedNotification receivedNotification) async {}

  /// Use this method to detect if the user dismissed a notification
  static Future<void> onDismissActionReceivedMethod(
      ReceivedAction receivedAction) async {
    if (receivedAction.channelKey == 'daily_data_channel') {
      AwesomeNotifications().getGlobalBadgeCounter().then(
            (value) => AwesomeNotifications().resetGlobalBadge(),
          );
    }
  }

  /// Use this method to detect when the user taps on a notification or action button
  static Future<void> onActionReceivedMethod(
      ReceivedAction receivedAction) async {
    // Always ensure that all plugins was initialized
    WidgetsFlutterBinding.ensureInitialized();

    // Navigate into pages, avoiding to open the notification details page over another details page already opened
    if (receivedAction.channelKey == 'daily_data_channel') {
      AwesomeNotifications().decrementGlobalBadgeCounter();
    }
  }

  static Future<void> createDailyDataNotification() async {
    await AwesomeNotifications().createNotification(
        content: NotificationContent(
            id: 10000,
            channelKey: 'daily_data_channel',
            body: 'Your daily glucose analysis is ready!'),
        schedule: NotificationCalendar(second: 0, repeats: true));
  }

  static Future<void> cancelScheduledNotifications() async {
    await AwesomeNotifications().cancelAllSchedules();
  }

  static Future<void> cancelScheduledNotificationsByChannleKey(
      String channelKey) async {
    await AwesomeNotifications().cancelSchedulesByChannelKey(channelKey);
  }
}
