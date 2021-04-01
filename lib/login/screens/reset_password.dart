import 'dart:io';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../appBars/login_appbar.dart';
import '../providers/auth_provider.dart';
import '../widgets/validation_fail_widget.dart';
import '../widgets/login_greet.dart';
import 'login_screen.dart';
import 'new_password.dart';

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
      return showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text(
            'Reset Password Success',
            style: Theme.of(context).textTheme.headline2,
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('Please check your registered email for reset token'),
              SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      primary: Theme.of(context).primaryColor,
                      side: BorderSide(color: Theme.of(context).primaryColor),
                    ),
                    onPressed: () {
                      Navigator.of(context).pop(true);
                      Navigator.of(context).pushReplacementNamed(
                        NewPassword.routeName,
                        arguments: {
                          'email': this._email,
                        },
                      );
                    },
                    child: Text(
                      'OK',
                      style: TextStyle(
                        fontSize: 14,
                        color: Theme.of(context).accentColor,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      );
    } on HttpException catch (error) {
      var errorMessage = 'Authentication failed.';

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
                if (!this._isValid) ValidationFailWidget(message: 'Please enter a valid email address.'),
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
