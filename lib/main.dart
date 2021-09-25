import 'dart:convert';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_background_geolocation/flutter_background_geolocation.dart' as bg;
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:global_configuration/global_configuration.dart';
import 'package:productive_app/l10n/L10n.dart';
import 'package:productive_app/provider/attachment_provider.dart';
import 'package:productive_app/provider/locale_provider.dart';
import 'package:productive_app/provider/synchronize_provider.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:workmanager/workmanager.dart';

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
import 'screen/loading_auth_screen.dart';
import 'screen/main_screen.dart';
import 'utils/notifications.dart';
import 'package:http/http.dart' as http;

void callbackDispatcher() {
  Workmanager().executeTask(
    (taskName, inputData) async {
      final getPreferences = await SharedPreferences.getInstance();

      if (!getPreferences.containsKey('userData')) {
        return false;
      }

      final extractedUserData = json.decode(getPreferences.getString('userData')) as Map<String, Object>;
      final expiryDate = DateTime.parse(extractedUserData['expiryDate']);

      if (expiryDate.isBefore(DateTime.now())) {
        return false;
      }

      final email = extractedUserData['email'];

      if (taskName == "tasks") {
        final requestUrl = "http://192.168.1.120:8080/api/v1/delegatedTaskSSE/isNewTask/$email";
        final response = await http.get(requestUrl);
        final responseBody = json.decode(response.body);

        print(responseBody);

        if (responseBody['result'] == 'true') {
          int id = Random().nextInt(999999);
          Notifications.receivedTask(id);
        }

        return Future.value(true);
      } else {
        final requestUrl = "http://192.168.1.120:8080/api/v1/delegatedTaskSSE/isNewCollaborator/$email";
        final response = await http.get(requestUrl);
        final responseBody = json.decode(response.body);

        print(responseBody);

        if (responseBody['result'] == 'true') {
          int id = Random().nextInt(999999);
          Notifications.receivedInvitation(id);
        }

        return Future.value(true);
      }
    },
  );
}

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

  Workmanager().initialize(callbackDispatcher);
  Workmanager().registerPeriodicTask('1', 'tasks');
  Workmanager().registerPeriodicTask('2', 'collaborators');
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
        ChangeNotifierProxyProvider<AuthProvider, LocaleProvider>(
          create: null,
          update: (ctx, auth, previousLocale) => LocaleProvider(
            locale: previousLocale == null ? Locale('en') : previousLocale.locale,
            email: auth.email,
          ),
        ),
        ChangeNotifierProxyProvider<AuthProvider, SynchronizeProvider>(
          create: null,
          update: (ctx, auth, previousSynchronize) => SynchronizeProvider(
            authToken: auth.token,
            userMail: auth.email,
            attachmentsToDelete: previousSynchronize == null ? [] : previousSynchronize.attachmentsToDelete,
            tasksToDelete: previousSynchronize == null ? [] : previousSynchronize.tasksToDelete,
            collaboratorsToDelete: previousSynchronize == null ? [] : previousSynchronize.collaboratorsToDelete,
            tagsToDelete: previousSynchronize == null ? [] : previousSynchronize.tagsToDelete,
            locationsToDelete: previousSynchronize == null ? [] : previousSynchronize.locationsToDelete,
          ),
        ),
        ChangeNotifierProxyProvider<AuthProvider, AttachmentProvider>(
          create: null,
          update: (ctx, auth, previousAttachments) => AttachmentProvider(
            attachments: previousAttachments == null ? [] : previousAttachments.attachments,
            delegatedAttachments: previousAttachments == null ? [] : previousAttachments.delegatedAttachments,
            authToken: auth.token,
            userMail: auth.email,
          ),
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
            singleTask: previousTasks == null ? Task(id: -1, title: '', uuid: '', taskState: 'COLLECT') : previousTasks.singleTask,
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
                    showOnlyDelegated: false,
                    collaborators: [],
                    locations: [],
                    tags: [],
                    priorities: [],
                  )
                : previousSettings.userSettings,
            userMail: auth.email,
            authToken: auth.token,
          ),
        ),
        ChangeNotifierProxyProvider<AuthProvider, LocationProvider>(
          create: null,
          update: (ctx, auth, previousTasks) => LocationProvider(
              userMail: auth.email,
              authToken: auth.token,
              locationList: previousTasks == null ? [] : previousTasks.locationList,
              placemarks: previousTasks == null ? [] : previousTasks.placemarks),
        ),
      ],
      builder: (context, _) {
        return MaterialApp(
          title: 'Productive app',
          themeMode: Provider.of<ThemeProvider>(context).themeMode,
          theme: ColorThemes.lightTheme,
          darkTheme: ColorThemes.darkTheme,
          supportedLocales: L10n.all,
          localizationsDelegates: [
            AppLocalizations.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
          ],
          locale: Provider.of<LocaleProvider>(context).locale,
          home: Provider.of<AuthProvider>(context).isAuth
              ? MainScreen()
              : FutureBuilder(
                  future: Provider.of<AuthProvider>(context, listen: false).tryAutoLogin(),
                  builder: (ctx, authResult) => authResult.connectionState == ConnectionState.waiting ? LoadingAuthScreen() : EntryScreen(),
                ),
          routes: MyRoutes.routes,
        );
      },
    );
  }
}
