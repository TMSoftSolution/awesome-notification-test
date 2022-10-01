import 'dart:io';

import 'package:awesome_notification_test/notification_controller.dart';
// Avoid to import third party packages across your app. Encapsulate them
// with your classes, even for visual plugins. this way third party packages gonna
// be concentrated in just one place, decreasing coupling and your app dependency.
// import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:flutter/material.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await NotificationsController.initializeLocalNotifications();

  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  // This widget is the root of your application.

  @override
  void initState() {
    super.initState();
    NotificationsController.initializeNotificationsEventListeners().then(
        (_) => NotificationsController.checkNotificationsPermission(context));
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            OutlinedButton(
                onPressed: () =>
                    NotificationsController.createDailyDataNotification(),
                child: const Text('Schedule the Notification')),
            const SizedBox(
              height: 20,
            ),
            const OutlinedButton(
                onPressed: NotificationsController.cancelScheduledNotifications,
                child: Text('Cancel Scheduled Notification')),
          ],
        ),
      ),
    );
  }
}
