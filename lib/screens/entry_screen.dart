import 'package:flutter/material.dart';

import '../buttons/login_button.dart';
import 'sign_in_screen.dart';
import 'sign_up_screen.dart';

class EntryScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(0),
        child: AppBar(
          backgroundColor: Theme.of(context).accentColor,
          brightness: Brightness.dark,
        ),
      ),
      backgroundColor: Theme.of(context).primaryColor,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Container(
            width: double.infinity,
            height: 89,
            child: Image(
              image: AssetImage('assets/images/logo.png'),
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
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 40,
                fontFamily: 'Lato',
              ),
            ),
          ),
          SizedBox(
            height: 40,
          ),
          LoginButton(
            routeName: SignInScreen.routeName,
            backgroundColor: Theme.of(context).primaryColor,
            textColor: Theme.of(context).accentColor,
            labelText: 'Sign in',
          ),
          SizedBox(height: 40),
          LoginButton(
            routeName: SignUpScreen.routeName,
            backgroundColor: Theme.of(context).accentColor,
            textColor: Theme.of(context).primaryColor,
            labelText: 'Sign up',
          ),
        ],
      ),
    );
  }
}
