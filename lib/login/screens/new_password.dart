import 'dart:io';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../appBars/login_appbar.dart';
import '../exceptions/HttpException.dart';
import '../providers/auth_provider.dart';
import '../widgets/login_greet.dart';
import '../widgets/validation_fail_widget.dart';
import 'login_screen.dart';

class NewPassword extends StatefulWidget {
  static const routeName = '/new-password';

  @override
  _NewPasswordState createState() => _NewPasswordState();
}

class _NewPasswordState extends State<NewPassword> {
  final _newPasswordKey = GlobalKey<FormState>();
  final _passwordConfirmKey = GlobalKey<FormFieldState>();

  var _isValid = true;

  var _email = '';
  var _resetToken = '';
  var _password = '';
  var _repeatPassword = '';

  var _validationMessage = 'Authentication failed';
  var _isLoading = false;

  @override
  void initState() {
    super.initState();

    Future.delayed(
      Duration.zero,
      () {
        setState(() {
          var args = ModalRoute.of(context).settings.arguments as Map<String, String>;
          this._email = args['email'];
        });
      },
    );
  }

  Future<void> _setNewPassword() async {
    setState(() {
      this._isLoading = true;
    });
    final isValid = this._newPasswordKey.currentState.validate();

    setState(() {
      this._isValid = isValid;
    });

    FocusScope.of(context).unfocus();

    if (!isValid) {
      setState(() {
        this._isLoading = false;
      });
      return;
    }

    this._newPasswordKey.currentState.save();

    try {
      await Provider.of<AuthProvider>(context, listen: false).newPassword(
        this._email,
        this._resetToken,
        this._password,
      );
      return showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text(
            'New password successfuly set',
            style: Theme.of(context).textTheme.headline2,
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
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
                      Navigator.of(context).pop();
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
      this._validationMessage = 'Authentication failed.';
      this._isValid = false;
    } on SocketException catch (error) {
      this._validationMessage = 'Connection failed';
      this._isValid = false;
    } catch (error) {
      this._validationMessage = 'Wrong token';
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
            key: this._newPasswordKey,
            child: Column(
              children: <Widget>[
                LoginGreet(greetText: 'Enter new password'),
                if (!this._isValid) ValidationFailWidget(message: this._validationMessage),
                SizedBox(
                  height: this._isValid ? 0 : 10,
                ),
                TextFormField(
                  key: ValueKey('Reset token'),
                  onSaved: (value) {
                    this._resetToken = value;
                  },
                  keyboardType: TextInputType.emailAddress,
                  validator: (value) {
                    if (value.isEmpty) {
                      setState(() {
                        this._validationMessage = 'Please enter reset token';
                      });
                      return 'Please enter reset token';
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
                    labelText: 'Reset token',
                    prefixIcon: Icon(Icons.person_outline),
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                TextFormField(
                  obscureText: true,
                  key: ValueKey('newPassword'),
                  onSaved: (value) {
                    this._password = value;
                  },
                  keyboardType: TextInputType.emailAddress,
                  validator: (value) {
                    if (value.isEmpty || value.length < 7) {
                      setState(() {
                        this._validationMessage = 'Password must be at least 7 characters long';
                      });
                      return 'Password must be at least 7 characters long';
                    }
                    if (value != this._passwordConfirmKey.currentState.value) {
                      print(value);
                      print(this._repeatPassword);
                      setState(() {
                        this._validationMessage = 'Passwords must be the same';
                      });
                      return 'Passwords must be the same';
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
                    labelText: 'New Password',
                    prefixIcon: Icon(Icons.lock_outline),
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                TextFormField(
                  obscureText: true,
                  key: this._passwordConfirmKey,
                  onSaved: (value) {
                    this._repeatPassword = value;
                  },
                  keyboardType: TextInputType.emailAddress,
                  validator: (value) {
                    if (value.isEmpty || value.length < 7) {
                      setState(() {
                        this._validationMessage = 'Password must be at least 7 characters long';
                      });
                      return 'Password must be at least 7 characters long';
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
                    labelText: 'Password Confirm',
                    prefixIcon: Icon(Icons.lock_outline),
                  ),
                ),
                SizedBox(height: 20),
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
                      onPressed: this._setNewPassword,
                      child: Text(
                        'Submit',
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
