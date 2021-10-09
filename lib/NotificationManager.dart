
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class NotificationManager{
  FlutterLocalNotificationsPlugin _flutterLocalNotificationsPlugin;
  AndroidInitializationSettings _androidInitializationSettings;
  IOSInitializationSettings _iosInitializationSettings;
  InitializationSettings _initializationSettings;

  void initNotificationManager(){
    _androidInitializationSettings = new AndroidInitializationSettings('@mipmap/ic_logo_round');
    _iosInitializationSettings = new IOSInitializationSettings();
    _initializationSettings = new InitializationSettings(android: _androidInitializationSettings, iOS: _iosInitializationSettings);
    _flutterLocalNotificationsPlugin = new FlutterLocalNotificationsPlugin();
    _flutterLocalNotificationsPlugin.initialize(_initializationSettings);
  }

  Future showNotification(String title, String body) async {
    var androidPlatformChannelSpecifics = new AndroidNotificationDetails(
        'ID',
        'Channel',
        'Channel Description',
        importance: Importance.max,
        priority: Priority.high,
        styleInformation: BigTextStyleInformation(''),
    );

    var iosPlatformChannelSpecifics = new IOSNotificationDetails();

    var platformChannelSpecifics = new NotificationDetails(android: androidPlatformChannelSpecifics, iOS: iosPlatformChannelSpecifics);
    await _flutterLocalNotificationsPlugin.show(0, title, body, platformChannelSpecifics);
  }

}