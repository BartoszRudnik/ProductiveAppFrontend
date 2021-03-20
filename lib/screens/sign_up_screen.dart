import 'package:flutter/material.dart';
import 'package:productive_app/appBars/login_appbar.dart';
import 'package:productive_app/buttons/login_button.dart';
import 'package:productive_app/screens/sign_in_screen.dart';
import 'package:productive_app/widgets/login_greet.dart';

class SignUpScreen extends StatelessWidget {
  static const routeName = '/sign-up-screen';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: LoginAppBar(),
      backgroundColor: Theme.of(context).primaryColor,
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            LoginGreet(greetText: 'Create account'),
            SizedBox(
              height: 50,
            ),
            LoginButton(
              backgroundColor: Theme.of(context).accentColor,
              textColor: Theme.of(context).primaryColor,
              labelText: 'Sign up',
              routeName: null,
            ),
            SizedBox(
              height: 20,
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text(
                  'Already have a account',
                  style: Theme.of(context).textTheme.headline4,
                ),
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pushReplacementNamed(SignInScreen.routeName);
                  },
                  child: Text(
                    'Login',
                    style: Theme.of(context).textTheme.headline5,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
