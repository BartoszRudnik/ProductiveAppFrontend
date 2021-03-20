import 'package:flutter/material.dart';

import '../appBars/login_appbar.dart';
import '../buttons/login_button.dart';
import '../widgets/login_greet.dart';
import 'sign_up_screen.dart';

class SignInScreen extends StatefulWidget {
  static const routeName = '/sign-in-screen';

  @override
  _SignInScreenState createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: LoginAppBar(),
        backgroundColor: Theme.of(context).primaryColor,
        body: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              LoginGreet(greetText: 'Welcome back'),
              Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: 50,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: <Widget>[
                    TextButton(
                      onPressed: () {},
                      child: Text(
                        'Forgot Password?',
                        style: Theme.of(context).textTheme.headline5,
                      ),
                    ),
                  ],
                ),
              ),
              LoginButton(
                backgroundColor: Theme.of(context).accentColor,
                textColor: Theme.of(context).primaryColor,
                labelText: 'Sign in',
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
                    'Don\'t have account?',
                    style: Theme.of(context).textTheme.headline4,
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pushReplacementNamed(SignUpScreen.routeName);
                    },
                    child: Text(
                      'create a new account!',
                      style: Theme.of(context).textTheme.headline5,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ));
  }
}
