import 'package:flutter/material.dart';

import 'screens/entry_screen.dart';
import 'screens/login_screen.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
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
      home: EntryScreen(),
      routes: {
        LoginScreen.routeName: (ctx) => LoginScreen(),
      },
    );
  }
}
