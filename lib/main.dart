import 'package:flutter/material.dart';
import 'package:global_configuration/global_configuration.dart';
import 'utils/notifications.dart';
import 'package:provider/provider.dart';
import 'config/color_themes.dart';
import 'config/my_routes.dart';
import 'model/settings.dart';
import 'model/task.dart';
import 'provider/auth_provider.dart';
import 'provider/delegate_provider.dart';
import 'provider/location_provider.dart';
import 'provider/settings_provider.dart';
import 'provider/tag_provider.dart';
import 'provider/task_provider.dart';
import 'provider/theme_provider.dart';
import 'screen/entry_screen.dart';
import 'screen/main_screen.dart';
import 'screen/loading_screen.dart';
import 'package:flutter_background_geolocation/flutter_background_geolocation.dart' as bg;

void headlessTask(bg.HeadlessEvent headlessEvent) async {
  switch (headlessEvent.name) {
    case bg.Event.GEOFENCE:
      bg.GeofenceEvent event = headlessEvent.event;
      Notifications.onGeofence(event);
      break;
  }
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await GlobalConfiguration().loadFromAsset("properties");

  runApp(MyApp());

  bg.BackgroundGeolocation.registerHeadlessTask(headlessTask);
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => AuthProvider(),
        ),
        ChangeNotifierProxyProvider<AuthProvider, ThemeProvider>(
          create: null,
          update: (ctx, auth, previousTheme) => ThemeProvider(
            themeMode: previousTheme == null ? ThemeMode.system : previousTheme.themeMode,
            userEmail: auth.email,
            userToken: auth.token,
          ),
        ),
        ChangeNotifierProxyProvider<AuthProvider, TaskProvider>(
          create: null,
          update: (ctx, auth, previousTasks) => TaskProvider(
            userMail: auth.email,
            authToken: auth.token,
            taskList: previousTasks == null ? [] : previousTasks.taskList,
            taskPriorities: previousTasks == null ? [] : previousTasks.priorities,
            singleTask: previousTasks == null ? Task(id: -1, title: '') : previousTasks.singleTask,
          ),
        ),
        ChangeNotifierProxyProvider<AuthProvider, TagProvider>(
          create: null,
          update: (ctx, auth, previousTags) => TagProvider(
            authToken: auth.token,
            userMail: auth.email,
            tagList: previousTags == null ? [] : previousTags.tagList,
          ),
        ),
        ChangeNotifierProxyProvider<AuthProvider, DelegateProvider>(
          create: null,
          update: (ctx, auth, previousDelegate) => DelegateProvider(
            collaborators: previousDelegate == null ? [] : previousDelegate.collaborators,
            userEmail: auth.email,
            userToken: auth.token,
          ),
        ),
        ChangeNotifierProxyProvider<AuthProvider, SettingsProvider>(
          create: null,
          update: (ctx, auth, previousSettings) => SettingsProvider(
            userSettings: previousSettings == null
                ? Settings(
                    showOnlyWithLocalization: false,
                    showOnlyUnfinished: false,
                    showOnlyDelegated: false,
                  )
                : previousSettings.userSettings,
            userMail: auth.email,
            authToken: auth.token,
          ),
        ),
        ChangeNotifierProxyProvider<AuthProvider, LocationProvider>(
          create: null,
          update: (ctx, auth, previousTasks) =>
              LocationProvider(userMail: auth.email, authToken: auth.token, locationList: previousTasks == null ? [] : previousTasks.locationList, placemarks: previousTasks == null ? [] : previousTasks.placemarks),
        ),
      ],
      builder: (context, _) {
        return MaterialApp(
          title: 'Productive app',
          themeMode: Provider.of<ThemeProvider>(context).themeMode,
          theme: ColorThemes.lightTheme,
          darkTheme: ColorThemes.darkTheme,
          home: Provider.of<AuthProvider>(context).isAuth
              ? MainScreen()
              : FutureBuilder(
                  future: Provider.of<AuthProvider>(context, listen: false).tryAutoLogin(),
                  builder: (ctx, authResult) => authResult.connectionState == ConnectionState.waiting ? LoadingScreen() : EntryScreen(),
                ),
          routes: MyRoutes.routes,
        );
      },
    );
  }
}
