import 'package:flutter/material.dart';
import 'package:global_configuration/global_configuration.dart';
import 'package:productive_app/screen/collaborator_profile_tabs.dart';
import 'package:provider/provider.dart';
import 'provider/auth_provider.dart';
import 'screen/entry_screen.dart';
import 'screen/login_screen.dart';
import 'screen/new_password_screen.dart';
import 'screen/reset_password_screen.dart';
import 'screen/splash_screen.dart';
import 'utils/notifications.dart';
import 'model/settings.dart';
import 'model/task.dart';
import 'provider/delegate_provider.dart';
import 'provider/location_provider.dart';
import 'provider/settings_provider.dart';
import 'provider/tag_provider.dart';
import 'provider/task_provider.dart';
import 'screen/collaborators_screen.dart';
import 'screen/completed_screen.dart';
import 'screen/filters_screen.dart';
import 'screen/locations_screen.dart';
import 'screen/main_screen.dart';
import 'screen/related_task_info_screen.dart';
import 'screen/settings_tabs_screen.dart';
import 'screen/tabs_screen.dart';
import 'screen/tags_screen.dart';
import 'screen/task_details_screen.dart';
import 'screen/task_map.dart';
import 'screen/trash_screen.dart';

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
