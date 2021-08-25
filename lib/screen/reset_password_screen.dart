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
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

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
  var _operationFailedMessage = '';

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
            AppLocalizations.of(context).resetPasswordSuccess,
            style: TextStyle(
              fontSize: 26,
              fontFamily: 'RobotoCondensed',
            ),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(AppLocalizations.of(context).emailResetToken),
              SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).pop(true);
                      Navigator.of(context).pushReplacementNamed(
                        NewPassword.routeName,
                        arguments: {
                          'email': this._email,
                        },
                      );
                    },
                    child: Text('OK'),
                  ),
                ],
              ),
            ],
          ),
        ),
      );
    } on HttpException catch (_) {
      setState(() {
        this._operationFailedMessage = AppLocalizations.of(context).authenticationFailed;
        this._isValid = false;
      });
    } on SocketException catch (_) {
      setState(() {
        this._operationFailedMessage = AppLocalizations.of(context).connectionFailed;
        this._isValid = false;
      });
    } catch (error) {
      print(error);
      this._operationFailedMessage = AppLocalizations.of(context).emailNotFound;
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
                LoginGreet(greetText: AppLocalizations.of(context).resetPassword),
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
                      return AppLocalizations.of(context).enterValidEmail;
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
                      style: ColorThemes.loginButtonStyle(context),
                      onPressed: this._tryReset,
                      child: Text(
                        AppLocalizations.of(context).reset,
                        style: TextStyle(fontSize: 25),
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
                        AppLocalizations.of(context).goBackLogin,
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
