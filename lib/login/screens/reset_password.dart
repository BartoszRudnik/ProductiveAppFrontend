import 'dart:io';

import 'package:flutter/material.dart';
import 'package:productive_app/login/providers/auth_provider.dart';
import 'package:productive_app/login/screens/login_screen.dart';
import 'package:provider/provider.dart';

import '../appBars/login_appbar.dart';
import '../widgets/login_greet.dart';

class ResetPassword extends StatefulWidget {
  static const routeName = '/reset-password';

  @override
  _ResetPasswordState createState() => _ResetPasswordState();
}

class _ResetPasswordState extends State<ResetPassword> {
  final _resetKey = GlobalKey<FormState>();

  var _email = '';

  var _isValid = true;

  Future<void> _tryReset() async {
    final isValid = this._resetKey.currentState.validate();

    setState(() {
      this._isValid = isValid;
    });

    FocusScope.of(context).unfocus();

    if (!isValid) {
      return;
    }

    this._resetKey.currentState.save();

    try {
      await Provider.of<AuthProvider>(context, listen: false).resetPassword(
        this._email,
      );
    } on HttpException catch (error) {
      var errorMessage = 'Authentication failed.';

      if (error.toString().contains('EMAIL_EXISTS')) {
        errorMessage = 'This email address is already in use';
      } else if (error.toString().contains('INVALID_EMAIL')) {
        errorMessage = 'This is not a valid email address';
      } else if (error.toString().contains('WEAK_PASSWORD')) {
        errorMessage = 'This password is too weak';
      } else if (error.toString().contains('EMAIL_NOT_FOUND')) {
        errorMessage = 'Could not find your email address';
      } else if (error.toString().contains('INVALID_PASSWORD')) {
        errorMessage = 'Invalid password';
      }

      print(errorMessage);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: LoginAppBar(),
      backgroundColor: Theme.of(context).accentColor,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 45),
          child: Form(
            key: this._resetKey,
            child: Column(
              children: <Widget>[
                LoginGreet(greetText: 'Reset password'),
                if (!this._isValid)
                  Container(
                    width: 310,
                    height: 30,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        Icon(
                          Icons.warning_amber_outlined,
                          size: 30,
                        ),
                        SizedBox(
                          width: 8,
                        ),
                        Text(
                          'Please enter a valid email address.',
                          style: TextStyle(
                            fontSize: 16,
                          ),
                        ),
                      ],
                    ),
                  ),
                SizedBox(
                  height: this._isValid ? 0 : 10,
                ),
                TextFormField(
                  key: ValueKey('email'),
                  onSaved: (value) {
                    this._email = value;
                  },
                  keyboardType: TextInputType.emailAddress,
                  validator: (value) {
                    if (value.isEmpty || !value.contains('@')) {
                      return 'Please enter a valid email address.';
                    }
                    return null;
                  },
                  decoration: InputDecoration(
                    errorStyle: TextStyle(
                      height: 0,
                      color: Colors.transparent,
                    ),
                    focusedErrorBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Theme.of(context).primaryColor),
                    ),
                    errorBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Theme.of(context).primaryColor),
                    ),
                    labelText: 'E-mail',
                    prefixIcon: Icon(Icons.person_outline),
                  ),
                ),
                SizedBox(height: 50),
                Container(
                  width: 304,
                  height: 47,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      primary: Theme.of(context).primaryColor,
                      side: BorderSide(color: Theme.of(context).primaryColor),
                    ),
                    onPressed: this._tryReset,
                    child: Text(
                      'Reset',
                      style: TextStyle(
                        fontSize: 25,
                        color: Theme.of(context).accentColor,
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    TextButton(
                      onPressed: () {
                        Navigator.of(context).popAndPushNamed(LoginScreen.routeName);
                      },
                      child: Text(
                        'Go back to login form',
                        style: Theme.of(context).textTheme.headline5,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
