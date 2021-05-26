import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import '../appBars/login_appbar.dart';
import '../widgets/login_widget.dart';
import 'package:flutter_background_geolocation/flutter_background_geolocation.dart' as bg;

class LoginScreen extends StatefulWidget {
  static const routeName = '/sign-in-screen';

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  @override
  void initState() {
    super.initState();

    _addGeofence();

    bg.BackgroundGeolocation.onGeofence(_onGeofence);

    // Configure the plugin and call ready
    bg.BackgroundGeolocation.ready(bg.Config(
            desiredAccuracy: bg.Config.DESIRED_ACCURACY_HIGH,
            distanceFilter: 10.0,
            stopOnTerminate: false,
            startOnBoot: true,
            debug: false, // true
            logLevel: bg.Config.LOG_LEVEL_OFF // bg.Config.LOG_LEVEL_VERBOSE
            ))
        .then((bg.State state) {
      if (!state.enabled) {
        // start the plugin
        // bg.BackgroundGeolocation.start();

        // start geofences only
        bg.BackgroundGeolocation.startGeofences();
        print('start geofences');
      }
    });
  }

  Future<void> _onGeofence(bg.GeofenceEvent event) async {
    print('onGeofence $event');

    FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

    final AndroidInitializationSettings initializationSettingsAndroid = AndroidInitializationSettings('@mipmap/ic_launcher');

    final InitializationSettings initializationSettings = InitializationSettings(
      android: initializationSettingsAndroid,
      iOS: null,
      macOS: null,
    );

    await flutterLocalNotificationsPlugin.initialize(initializationSettings, onSelectNotification: selectNotification);

    const AndroidNotificationDetails androidPlatformChannelSpecifics = AndroidNotificationDetails('your channel id', 'your channel name', 'your channel description', importance: Importance.max, priority: Priority.high, showWhen: false);
    const NotificationDetails platformChannelSpecifics = NotificationDetails(android: androidPlatformChannelSpecifics);
    await flutterLocalNotificationsPlugin.show(0, 'Test tytulu', 'Test tresci powiadomienia', platformChannelSpecifics, payload: 'item x');
  }

  Future selectNotification(String payload) async {}

  void _addGeofence() {
    print("in add geofence");
    bg.BackgroundGeolocation.addGeofence(bg.Geofence(
      identifier: 'HOME',
      radius: 150,
      latitude: 51.120281,
      longitude: 15.814276,
      notifyOnEntry: true, // only notify on entry
      notifyOnExit: false,
      notifyOnDwell: false,
      loiteringDelay: 30000, // 30 seconds
    )).then((bool success) {
      print('[addGeofence] success with ${51.120281} and ${15.814276}');
    }).catchError((error) {
      print('[addGeofence] FAILURE: $error');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: LoginAppBar(),
      backgroundColor: Theme.of(context).accentColor,
      body: LoginWidget(),
    );
  }
}
