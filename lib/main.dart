import 'package:flutter/material.dart';
import 'package:global_configuration/global_configuration.dart';
import 'package:productive_app/task_page/task_screens/collaborator_profile_tabs.dart';
import 'package:provider/provider.dart';

import 'login/providers/auth_provider.dart';
import 'login/screens/entry_screen.dart';
import 'login/screens/login_screen.dart';
import 'login/screens/new_password.dart';
import 'login/screens/reset_password.dart';
import 'login/screens/splash_screen.dart';
import 'shared/notifications.dart';
import 'task_page/models/settings.dart';
import 'task_page/models/task.dart';
import 'task_page/providers/delegate_provider.dart';
import 'task_page/providers/location_provider.dart';
import 'task_page/providers/settings_provider.dart';
import 'task_page/providers/tag_provider.dart';
import 'task_page/providers/task_provider.dart';
import 'task_page/task_screens/collaborators_screen.dart';
import 'task_page/task_screens/completed_screen.dart';
import 'task_page/task_screens/filters_screen.dart';
import 'task_page/task_screens/locations_screen.dart';
import 'task_page/task_screens/main_screen.dart';
import 'task_page/task_screens/related_task_info_screen.dart';
import 'task_page/task_screens/settings_tabs_screen.dart';
import 'task_page/task_screens/tabs_screen.dart';
import 'task_page/task_screens/tags_screen.dart';
import 'task_page/task_screens/task_details_screen.dart';
import 'task_page/task_screens/task_map.dart';
import 'task_page/task_screens/trash_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await GlobalConfiguration().loadFromAsset("properties");
  Notifications.initializeLocalization();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => AuthProvider(),
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
      child: Consumer<AuthProvider>(
        builder: (ctx, authData, _) => MaterialApp(
          title: 'Productive app',
          theme: ThemeData(
            scaffoldBackgroundColor: Colors.white,
            primaryColor: Colors.black,
            accentColor: Colors.white,
            backgroundColor: Colors.black,
            fontFamily: 'Lato',
            textTheme: TextTheme(
              headline6: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 40,
                fontFamily: 'Lato',
              ),
              headline5: TextStyle(
                fontFamily: 'RobotoCondensed',
                fontSize: 12,
                color: Colors.grey,
              ),
              headline4: TextStyle(
                fontSize: 12,
                fontFamily: 'RobotoCondensed',
                color: Colors.black,
              ),
              headline3: TextStyle(
                fontSize: 36,
                fontFamily: 'RobotoCondensed',
                color: Colors.black,
              ),
              headline2: TextStyle(
                fontSize: 26,
                fontFamily: 'RobotoCondensed',
                color: Colors.black,
              ),
            ),
          ),
          home: authData.isAuth
              ? MainScreen()
              : FutureBuilder(
                  future: authData.tryAutoLogin(),
                  builder: (ctx, authResult) => authResult.connectionState == ConnectionState.waiting ? SplashScreen() : EntryScreen(),
                ),
          routes: {
            MainScreen.routeName: (ctx) => MainScreen(),
            TabsScreen.routeName: (ctx) => TabsScreen(),
            LoginScreen.routeName: (ctx) => LoginScreen(),
            EntryScreen.routeName: (ctx) => EntryScreen(),
            ResetPassword.routeName: (ctx) => ResetPassword(),
            TaskDetailScreen.routeName: (ctx) => TaskDetailScreen(),
            NewPassword.routeName: (ctx) => NewPassword(),
            TagsScreen.routeName: (ctx) => TagsScreen(),
            CompletedScreen.routeName: (ctx) => CompletedScreen(),
            TrashScreen.routeName: (ctx) => TrashScreen(),
            CollaboratorsScreen.routeName: (ctx) => CollaboratorsScreen(),
            SettingsTabsScreen.routeName: (ctx) => SettingsTabsScreen(),
            FiltersScreen.routeName: (ctx) => FiltersScreen(),
            RelatedTaskInfoScreen.routeName: (ctx) => RelatedTaskInfoScreen(),
            LocationsScreen.routeName: (ctx) => LocationsScreen(),
            TaskMap.routeName: (ctx) => TaskMap(),
            CollaboratorProfileTabs.routeName: (ctx) => CollaboratorProfileTabs(),
          },
        ),
      ),
    );
  }
}
