import 'package:flutter_background_geolocation/flutter_background_geolocation.dart' as bg;
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

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
    final eventTitle = event.extras['title'];
    final eventDescription = event.extras['description'];

    FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

    final AndroidInitializationSettings initializationSettingsAndroid = AndroidInitializationSettings('@mipmap/ic_launcher');

    final InitializationSettings initializationSettings = InitializationSettings(
      android: initializationSettingsAndroid,
      iOS: null,
      macOS: null,
    );

    await flutterLocalNotificationsPlugin.initialize(initializationSettings, onSelectNotification: _selectNotification);

    const AndroidNotificationDetails androidPlatformChannelSpecifics = AndroidNotificationDetails(
      'your channel id',
      'Localization',
      'Geofence notification',
      importance: Importance.max,
      priority: Priority.high,
      showWhen: false,
    );
    const NotificationDetails platformChannelSpecifics = NotificationDetails(android: androidPlatformChannelSpecifics);
    await flutterLocalNotificationsPlugin.show(0, eventTitle, eventDescription, platformChannelSpecifics, payload: 'item x');
  }

  static Future _selectNotification(String payload) async {}

  static bool checkIfGeofenceExists(int identifier) {
    bg.BackgroundGeolocation.geofenceExists(identifier.toString()).then((bool result) {
      return result;
    }).catchError((error) {
      print(error);
      return false;
    });
  }

  static void removeGeofence(int identifier) {
    bg.BackgroundGeolocation.removeGeofence(identifier.toString()).then((bool success) {
      print('[removeGeofence] success');
    });
  }

  static void removeAllGeofences() {
    bg.BackgroundGeolocation.removeGeofences().then((bool success) {
      print('[removeGeofences] all geofences have been destroyed');
    });
  }

  static void addGeofence(
    int identifier,
    double latitude,
    double longitude,
    double radius,
    bool onEnter,
    bool onExit,
    String title,
    String description,
  ) {
    bg.BackgroundGeolocation.addGeofence(bg.Geofence(
      identifier: identifier.toString(),
      radius: radius * 1000,
      latitude: latitude,
      longitude: longitude,
      notifyOnEntry: onEnter,
      notifyOnExit: onExit,
      notifyOnDwell: true,
      loiteringDelay: 30000,
      extras: {
        'description': description,
        'title': title,
      },
    )).then((bool success) {
      print('[addGeofence] success with $latitude and $longitude');
    }).catchError((error) {
      print('[addGeofence] FAILURE: $error');
    });
  }
}
