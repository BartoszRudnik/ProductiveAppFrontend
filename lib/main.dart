import 'package:flutter/material.dart';

import 'screens/entry_screen.dart';
import 'screens/sign_in_screen.dart';
import 'screens/sign_up_screen.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Productive app',
      theme: ThemeData(
        primaryColor: Colors.white,
        accentColor: Colors.black,
        fontFamily: 'Lato',
      ),
      home: EntryScreen(),
      routes: {
        SignUpScreen.routeName: (ctx) => SignUpScreen(),
        SignInScreen.routeName: (ctx) => SignInScreen(),
      },
    );
  }
}
