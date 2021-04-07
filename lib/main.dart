import 'package:flutter/material.dart';
import 'package:productive_app/task_page/providers/task_provider.dart';
import 'package:provider/provider.dart';

import 'login/providers/auth_provider.dart';
import 'login/screens/entry_screen.dart';
import 'login/screens/login_screen.dart';
import 'login/screens/new_password.dart';
import 'login/screens/reset_password.dart';
import 'login/screens/splash_screen.dart';
import 'task_page/task_screens/inbox_screen.dart';
import 'task_page/task_screens/main_screen.dart';
import 'task_page/task_screens/tabs_screen.dart';
import 'task_page/task_screens/task_details_screen.dart';

void main() => runApp(MyApp());

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
          ),
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
            InboxScreen.routeName: (ctx) => InboxScreen(),
            EntryScreen.routeName: (ctx) => EntryScreen(),
            ResetPassword.routeName: (ctx) => ResetPassword(),
            TaskDetailScreen.routeName: (ctx) => TaskDetailScreen(),
            NewPassword.routeName: (ctx) => NewPassword(),
          },
        ),
      ),
    );
  }
}
