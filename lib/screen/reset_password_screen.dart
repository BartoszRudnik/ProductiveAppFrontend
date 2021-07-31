import 'dart:io';

import 'package:flutter/material.dart';
import 'package:productive_app/config/color_themes.dart';
import 'package:provider/provider.dart';

import '../widget/appBar/login_appbar.dart';
import '../provider/auth_provider.dart';
import '../widget/validation_fail_widget.dart';
import '../widget/login_greet.dart';
import 'login_screen.dart';
import 'new_password_screen.dart';

class ResetPassword extends StatefulWidget {
  static const routeName = '/reset-password';

  @override
  _ResetPasswordState createState() => _ResetPasswordState();
}

class _ResetPasswordState extends State<ResetPassword> {
  final _resetKey = GlobalKey<FormState>();

  var _email = '';

  var _isValid = true;
  var _isLoading = false;

  var _operationFailedMessage = 'Operation failed';

  Future<void> _tryReset() async {
    setState(() {
      this._isLoading = true;
    });
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
            style: TextStyle(
              fontSize: 26,
              fontFamily: 'RobotoCondensed',
            ),
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
    } on HttpException catch (_) {
      setState(() {
        this._operationFailedMessage = 'Authentication failed.';
        this._isValid = false;
      });
    } on SocketException catch (_) {
      setState(() {
        this._operationFailedMessage = 'Connection failed';
        this._isValid = false;
      });
    } catch (error) {
      print(error);
      this._operationFailedMessage = 'Email address not found';
      this._isValid = false;
    }
    setState(() {
      this._isLoading = false;
    });
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
                if (!this._isValid) ValidationFailWidget(message: this._operationFailedMessage),
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
                  decoration: ColorThemes.loginFormFieldDecoration(
                    context,
                    'Email',
                    Icons.email_outlined,
                  ),
                ),
                SizedBox(height: 50),
                if (this._isLoading)
                  CircularProgressIndicator(backgroundColor: Theme.of(context).primaryColor)
                else
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
