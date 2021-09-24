import 'package:flutter_background_geolocation/flutter_background_geolocation.dart' as bg;
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:productive_app/model/task.dart';
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

  static Future<void> newDelegatedTaskNotification(Task task, String title) async {
    const AndroidNotificationDetails androidPlatformChannelSpecifics = AndroidNotificationDetails(
      '2',
      'Delegated task',
      'Notification about new delegated task',
      importance: Importance.max,
      priority: Priority.high,
    );

    const NotificationDetails platformChannelSpecifics = NotificationDetails(android: androidPlatformChannelSpecifics);
    await _notifications.show(task.id, title + task.title, task.description, platformChannelSpecifics, payload: task.uuid);
  }

  static Future<void> onGeofence(bg.GeofenceEvent event) async {
    final taskUuid = event.extras['uuid'];
    final taskTitle = event.extras['title'];
    final taskDescription = event.extras['description'];

    const AndroidNotificationDetails androidPlatformChannelSpecifics = AndroidNotificationDetails(
      '1',
      'Localization',
      'Geofence notification',
      importance: Importance.max,
      priority: Priority.high,
    );

    const NotificationDetails platformChannelSpecifics = NotificationDetails(android: androidPlatformChannelSpecifics);
    await _notifications.show(int.parse(event.extras['id']), taskTitle, taskDescription, platformChannelSpecifics, payload: taskUuid);
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

  static Future<void> removeUserGeofences(List<String> tasks) async {
    tasks.forEach((taskUuid) async {
      await bg.BackgroundGeolocation.removeGeofence(taskUuid);
    });
  }

  static Future<void> removeGeofence(String uuid) async {
    await bg.BackgroundGeolocation.removeGeofence(uuid);
  }

  static Future<void> removeAllGeofences() async {
    await bg.BackgroundGeolocation.removeGeofences();
  }

  static Future<void> addGeofence(
      String uuid, double latitude, double longitude, double radius, bool onEnter, bool onExit, String title, String description, int taskId) async {
    await bg.BackgroundGeolocation.addGeofence(bg.Geofence(
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
        'id': taskId,
      },
    ));
  }
}
