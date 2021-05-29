import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_background_geolocation/flutter_background_geolocation.dart' as bg;

class Notifications {
  static void initializeLocalization() {
    bg.BackgroundGeolocation.onGeofence(_onGeofence);

    bg.BackgroundGeolocation.ready(
      bg.Config(
        desiredAccuracy: bg.Config.DESIRED_ACCURACY_HIGH,
        distanceFilter: 10.0,
        stopOnTerminate: false,
        startOnBoot: true,
        debug: false,
        logLevel: bg.Config.LOG_LEVEL_OFF,
      ),
    ).then((bg.State state) {
      if (!state.enabled) {
        bg.BackgroundGeolocation.startGeofences();
      }
    });
  }

  static Future<void> _onGeofence(bg.GeofenceEvent event) async {
    print('in onGeofence method $event');

    FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

    final AndroidInitializationSettings initializationSettingsAndroid = AndroidInitializationSettings('@mipmap/ic_launcher');

    final InitializationSettings initializationSettings = InitializationSettings(
      android: initializationSettingsAndroid,
      iOS: null,
      macOS: null,
    );

    await flutterLocalNotificationsPlugin.initialize(initializationSettings, onSelectNotification: _selectNotification);

    const AndroidNotificationDetails androidPlatformChannelSpecifics = AndroidNotificationDetails('your channel id', 'your channel name', 'your channel description', importance: Importance.max, priority: Priority.high, showWhen: false);
    const NotificationDetails platformChannelSpecifics = NotificationDetails(android: androidPlatformChannelSpecifics);
    await flutterLocalNotificationsPlugin.show(0, '${event.identifier}', 'Test tresci powiadomienia', platformChannelSpecifics, payload: 'item x');
  }

  static Future _selectNotification(String payload) async {}

  static void addGeofence(String identifier, double latitude, double longitude, double radius, bool onEnter, bool onExit) {
    bg.BackgroundGeolocation.addGeofence(bg.Geofence(
      identifier: identifier,
      radius: radius,
      latitude: latitude,
      longitude: longitude,
      notifyOnEntry: onEnter,
      notifyOnExit: onExit,
      notifyOnDwell: false,
      loiteringDelay: 30000,
    )).then((bool success) {
      print('[addGeofence] success with $latitude and $longitude');
    }).catchError((error) {
      print('[addGeofence] FAILURE: $error');
    });
  }
}
