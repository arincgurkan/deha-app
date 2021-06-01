import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:flutter/material.dart';

class FeedScreen extends StatefulWidget {
  @override
  _FeedScreenState createState() => _FeedScreenState();
}

class _FeedScreenState extends State<FeedScreen> {
  final FirebaseMessaging messaging = FirebaseMessaging.instance;

  @override
  void initState() {
    super.initState();
    messaging.subscribeToTopic('actionTest');

    //FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

    // FirebaseMessaging.onBackgroundMessage((RemoteMessage message) async {
    //   print('Got a message whilst in the foreground!');
    //   print('Message data: ${message.data}');
    //   AwesomeNotifications().createNotification(
    //       content: NotificationContent(
    //           id: 10,
    //           channelKey: 'basic_channel',
    //           title: 'Simple Notification',
    //           body: 'Simple body'),
    //       actionButtons: [
    //         NotificationActionButton(
    //             label: 'TEST',
    //             enabled: true,
    //             buttonType: ActionButtonType.Default,
    //             key: 'test')
    //       ]);
    // });

    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      print('Got a message whilst in the foreground!');
      print('Message data: ${message.data}');

      // var androidPlatformChannelSpecifics = AndroidNotificationDetails('channelId', 'channelName', 'channelDescription');

      // flutterLocalNotificationsPlugin.show(0, message.notification.body, message.notification.body, NotificationDetails(android: ));

      //AwesomeNotifications().createNotificationFromJsonData(message.data);

      AwesomeNotifications().createNotification(
          content: NotificationContent(
              id: 10,
              channelKey: 'basic_channel',
              title: 'Simple Notification',
              body: 'Simple body'),
          actionButtons: [
            NotificationActionButton(
                label: 'TEST',
                enabled: true,
                buttonType: ActionButtonType.Default,
                key: 'test')
          ]);

      if (message.notification != null) {
        print('Message also contained a notification: ${message.notification}');
      }
    });

    
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromRGBO(15, 31, 40, 1),
        title: Text('HOME'),
      ),
      body: Container(
        child: Center(
          child: Text(
            'This is feed page',
          ),
        ),
      ),
    );
  }
}
