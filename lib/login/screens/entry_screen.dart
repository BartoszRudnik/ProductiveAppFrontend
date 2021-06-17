import 'package:flutter/material.dart';

import '../appBars/login_appbar.dart';
import '../buttons/login_button.dart';
import 'login_screen.dart';

class EntryScreen extends StatelessWidget {
  static const routeName = 'entry-screen';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: LoginAppBar(),
      backgroundColor: Theme.of(context).accentColor,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Container(
            width: double.infinity,
            height: 100,
            child: Image(
              image: AssetImage('assets/images/clipboard.png'),
              fit: BoxFit.fitHeight,
            ),
          ),
          SizedBox(
            height: 80,
          ),
          Container(
            width: double.infinity,
            height: 89,
            child: Text(
              'Task manager',
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.headline6,
            ),
          ),
          SizedBox(
            height: 40,
          ),
          LoginButton(
            routeName: LoginScreen.routeName,
            backgroundColor: Theme.of(context).accentColor,
            textColor: Theme.of(context).primaryColor,
            labelText: 'Sign in',
            loginMode: true,
          ),
          SizedBox(height: 40),
          LoginButton(
            routeName: LoginScreen.routeName,
            backgroundColor: Theme.of(context).primaryColor,
            textColor: Theme.of(context).accentColor,
            labelText: 'Sign up',
            loginMode: false,
          ),
        ],
      ),
    );
  }
}
