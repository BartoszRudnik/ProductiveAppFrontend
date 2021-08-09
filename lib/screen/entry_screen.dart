import 'package:flutter/material.dart';
import '../config/images.dart';
import '../widget/appBar/login_appbar.dart';
import '../widget/button/login_button.dart';
import '../widget/button/sign_with_google.dart';
import 'login_screen.dart';

class EntryScreen extends StatelessWidget {
  static const routeName = 'entry-screen';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: LoginAppBar(),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Container(
              width: double.infinity,
              height: 100,
              child: Image(
                color: Theme.of(context).primaryColor,
                image: AssetImage(Images.entryScreenImage),
                fit: BoxFit.fitHeight,
              ),
            ),
            SizedBox(
              height: 60,
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
              labelText: 'Sign in with e-mail',
              loginMode: true,
            ),
            SizedBox(height: 40),
            LoginButton(
              routeName: LoginScreen.routeName,
              backgroundColor: Theme.of(context).accentColor,
              textColor: Theme.of(context).primaryColor,
              labelText: 'Sign up with e-mail',
              loginMode: false,
            ),
            SizedBox(height: 20),
            Text(
              'Or',
              style: TextStyle(
                fontSize: 25,
                fontWeight: FontWeight.w500,
              ),
            ),
            SizedBox(height: 20),
            SignWithGoogle(),
          ],
        ),
      ),
    );
  }
}
