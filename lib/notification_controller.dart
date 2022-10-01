import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:flutter/material.dart';

class NotificationsController {
  // ***************************************************************
  //    INITIALIZATIONS
  // ***************************************************************

  static const String _channelWithBadge = 'daily_data_channel_badge',
      _channelWithoutBadge = 'daily_data_channel_no_badge';

  static Future<void> initializeLocalNotifications() async {
    await AwesomeNotifications()
        .initialize('resource://drawable/res_notification_app_icon', [
      NotificationChannel(
        channelGroupKey: 'daily_data_channel_group',
        channelKey: _channelWithBadge,
        channelName: 'Daily Data Notifications',
        channelDescription: 'Daily Data Notifications',
        channelShowBadge: true,
        importance: NotificationImportance.High,
        defaultColor: const Color(0xFF2A9D8F),
        ledColor: Colors.white,
      ),
      NotificationChannel(
        channelGroupKey: 'daily_data_channel_group',
        channelKey: _channelWithoutBadge,
        channelName: 'Daily Data Notifications',
        channelDescription: 'Daily Data Notifications',
        importance: NotificationImportance.High,
        defaultColor: const Color(0xFF2A9D8F),
        ledColor: Colors.white,
      ),
    ], channelGroups: [
      NotificationChannelGroup(
          channelGroupKey: 'daily_data_channel_group',
          channelGroupName: 'Daily Notification')
    ]);
  }

  static Future<void> initializeNotificationsEventListeners() async {
    // Only after at least the action method is set, the notification events are delivered
    await AwesomeNotifications().setListeners(
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
    if (receivedAction.channelKey?.startsWith('daily_data_channel_') ?? false) {
      // int value = await AwesomeNotifications().getGlobalBadgeCounter();
      await AwesomeNotifications().resetGlobalBadge();
    }
  }

  /// Use this method to detect when the user taps on a notification or action button
  static Future<void> onActionReceivedMethod(
      ReceivedAction receivedAction) async {
    // Always ensure that all plugins was initialized
    WidgetsFlutterBinding.ensureInitialized();
    await cancelScheduledNotifications();

    // Navigate into pages, avoiding to open the notification details page over another details page already opened
    if (receivedAction.channelKey?.startsWith('daily_data_channel_') ?? false) {
      await AwesomeNotifications().resetGlobalBadge();
    }
  }

  static Future<bool> checkNotificationsPermission(BuildContext context) async {
    bool isAllowed = await AwesomeNotifications().isNotificationAllowed();
    if (!isAllowed) {
      // You must show rationale for all platforms
      await showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Allow Notifications'),
          content:
          const Text('Our app would like to send you notifications'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text(
                'Don\'t Allow',
                style: TextStyle(
                  color: Colors.red,
                  fontSize: 18,
                ),
              ),
            ),
            TextButton(
              onPressed: () async {
                NavigatorState navigator = Navigator.of(context);
                isAllowed = await AwesomeNotifications()
                    .isNotificationAllowed();
                navigator.pop();
              },
              child: const Text(
                'Allow',
                style: TextStyle(
                  color: Colors.teal,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              )
            )
          ],
        ),
      );
    }
    return isAllowed;
  }

  static Future<void> createDailyDataNotification(BuildContext context) async {
    if (!await NotificationsController.checkNotificationsPermission(context)) {
      return;
    }
    // in case you want to already display the badge counter when the schedule
    // is created, do it instead of create an update notification
    // await AwesomeNotifications().incrementGlobalBadgeCounter();
    // await AwesomeNotifications().createNotification(
    //     content: NotificationContent(
    //         id: 10000,
    //         channelKey: _channelWithoutBadge,
    //         body: 'Your daily glucose analysis is ready!'),
    //     schedule: NotificationCalendar(second: 0, repeats: true));
    await AwesomeNotifications().createNotification(
        content: NotificationContent(
            id: 10000,
            channelKey: _channelWithBadge,
            body: 'Your daily glucose analysis is ready!'),
        schedule: NotificationCalendar(second: 0, repeats: true));
  }

  static Future<void> cancelScheduledNotifications() async {
    await AwesomeNotifications().cancelAllSchedules();
  }

  static Future<void> cancelScheduledNotificationsByChannelKey(
      String channelKey) async {
    await AwesomeNotifications().cancelSchedulesByChannelKey(channelKey);
  }
}
