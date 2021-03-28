import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'login/providers/auth_provider.dart';
import 'login/screens/entry_screen.dart';
import 'login/screens/login_screen.dart';
import 'login/screens/splash_screen.dart';
import 'task_page/task_screens/inbox_screen.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => AuthProvider(),
        ),
      ],
      child: Consumer<AuthProvider>(
        builder: (ctx, authData, _) => MaterialApp(
          title: 'Productive app',
          theme: ThemeData(
            primaryColor: Colors.black,
            accentColor: Colors.white,
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
            ),
          ),
          home: authData.isAuth
              ? InboxScreen()
              : FutureBuilder(
                  future: authData.tryAutoLogin(),
                  builder: (ctx, authResult) => authResult.connectionState == ConnectionState.waiting ? SplashScreen() : EntryScreen(),
                ),
          routes: {
            LoginScreen.routeName: (ctx) => LoginScreen(),
            InboxScreen.routeName: (ctx) => InboxScreen(),
            EntryScreen.routeName: (ctx) => EntryScreen(),
          },
        ),
      ),
    );
  }
}
