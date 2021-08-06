import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:productive_app/provider/auth_provider.dart';
import 'package:provider/provider.dart';
import '../config/images.dart';
import '../widget/appBar/login_appbar.dart';
import '../widget/button/login_button.dart';
import 'login_screen.dart';

class EntryScreen extends StatelessWidget {
  static const routeName = 'entry-screen';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: LoginAppBar(),
      backgroundColor: Theme.of(context).accentColor,
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
            SizedBox(height: 20),
            Text(
              'Or',
              style: TextStyle(
                fontSize: 25,
                fontWeight: FontWeight.w500,
              ),
            ),
            SizedBox(height: 20),
            Container(
              width: 300,
              height: 47,
              child: ElevatedButton(
                onPressed: () {
                  Provider.of<AuthProvider>(context, listen: false).googleAuthenticate();
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(FontAwesomeIcons.google),
                    SizedBox(width: 10),
                    Text(
                      'Sign in with Google',
                      style: TextStyle(
                        fontSize: 25,
                      ),
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
