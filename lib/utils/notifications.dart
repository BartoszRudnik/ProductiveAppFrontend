import 'package:flutter_background_geolocation/flutter_background_geolocation.dart' as bg;
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:rxdart/rxdart.dart';

class Notifications {
  static final onNotifications = BehaviorSubject<String>();
  static final _notifications = FlutterLocalNotificationsPlugin();

  static void initLocalization() {
    bg.BackgroundGeolocation.onGeofence(onGeofence);

    bg.BackgroundGeolocation.ready(
      bg.Config(
        desiredAccuracy: bg.Config.DESIRED_ACCURACY_HIGH,
        distanceFilter: 10.0,
        stopOnTerminate: false,
        startOnBoot: true,
        logLevel: bg.Config.LOG_LEVEL_VERBOSE,
        allowIdenticalLocations: true,
        enableHeadless: true,
      ),
    ).then((bg.State state) {
      if (!state.enabled) {
        bg.BackgroundGeolocation.startGeofences();
      }
    });
  }

  static Future initNotification() async {
    final android = AndroidInitializationSettings('@mipmap/ic_launcher');
    final ios = IOSInitializationSettings();

    final initializationSettings = InitializationSettings(
      android: android,
      iOS: ios,
    );

    final details = await _notifications.getNotificationAppLaunchDetails();

    if (details != null && details.didNotificationLaunchApp) {
      onNotifications.add(details.payload);
    }

    await _notifications.initialize(initializationSettings, onSelectNotification: _selectNotification);
  }

  static Future<void> onGeofence(bg.GeofenceEvent event) async {
    final taskUuid = event.extras['uuid'];
    final taskTitle = event.extras['title'];
    final taskDescription = event.extras['description'];

    const AndroidNotificationDetails androidPlatformChannelSpecifics = AndroidNotificationDetails(
      'your channel id',
      'Localization',
      'Geofence notification',
      importance: Importance.max,
      priority: Priority.high,
    );

    const NotificationDetails platformChannelSpecifics = NotificationDetails(android: androidPlatformChannelSpecifics);
    await _notifications.show(0, taskTitle, taskDescription, platformChannelSpecifics, payload: taskUuid);
  }

  static Future _selectNotification(String payload) async {
    onNotifications.add(payload);
  }

  static Future<bool> checkIfGeofenceExists(int identifier) async {
    bool result = false;

    await bg.BackgroundGeolocation.geofenceExists(identifier.toString()).then((bool exists) {
      result = exists;
    });

    return result;
  }

  static void removeGeofence(String uuid) {
    bg.BackgroundGeolocation.removeGeofence(uuid).then((bool success) {
      print('[removeGeofence] success');
    });
  }

  static void removeAllGeofences() {
    bg.BackgroundGeolocation.removeGeofences().then((bool success) {
      print('[removeGeofences] all geofences have been destroyed');
    });
  }

  static void addGeofence(String uuid, double latitude, double longitude, double radius, bool onEnter, bool onExit, String title, String description) {
    bg.BackgroundGeolocation.addGeofence(bg.Geofence(
      identifier: uuid,
      radius: radius * 1000,
      latitude: latitude,
      longitude: longitude,
      notifyOnEntry: onEnter,
      notifyOnExit: onExit,
      notifyOnDwell: true,
      loiteringDelay: 30000,
      extras: {
        'uuid': uuid,
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
