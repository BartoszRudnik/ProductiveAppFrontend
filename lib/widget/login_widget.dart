import 'dart:io';
import 'package:flutter/material.dart';
import 'package:productive_app/config/color_themes.dart';
import 'package:provider/provider.dart';
import '../exception/HttpException.dart';
import '../provider/auth_provider.dart';
import '../screen/reset_password_screen.dart';
import 'validation_fail_widget.dart';
import 'login_greet.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class LoginWidget extends StatefulWidget {
  @override
  _LoginWidgetState createState() => _LoginWidgetState();
}

class _LoginWidgetState extends State<LoginWidget> {
  final _formKey = GlobalKey<FormState>();

  var _isValid = true;
  var _isLogin = true;
  var _isLoading = false;
  var _isSuccessfull = false;
  var _email = '';
  var _password = '';
  var _authenticationFailedMessage = 'Authentication failed';

  @override
  void initState() {
    super.initState();

    Future.delayed(
      Duration.zero,
      () {
        setState(() {
          var args = ModalRoute.of(context).settings.arguments as Map<String, bool>;
          this._isLogin = args['loginMode'];
        });
      },
    );
  }

  Future<void> _trySubmit() async {
    final isValid = this._formKey.currentState.validate();
    setState(() {
      this._isValid = isValid;
    });

    FocusScope.of(context).unfocus();

    if (!isValid) {
      return;
    }

    _formKey.currentState.save();

    setState(() {
      this._isLoading = true;
    });

    try {
      if (!_isLogin) {
        await Provider.of<AuthProvider>(context, listen: false).signUp(
          this._email,
          this._password,
        );
        setState(() {
          this._isLoading = false;
          this._isSuccessfull = true;
        });
        return showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: Text(
              AppLocalizations.of(context).registrationSuccessful,
              style: Theme.of(context).textTheme.headline2,
            ),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(AppLocalizations.of(context).checkEmail),
                SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ElevatedButton(
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
      } else {
        await Provider.of<AuthProvider>(context, listen: false).signIn(
          this._email,
          this._password,
        );
        Navigator.of(context).pop();
      }
    } on HttpException catch (error) {
      var message = 'Authentication failed';

      if (error.toString().contains('email already taken')) {
        message = 'Email already taken';
      }
      if (error.toString().contains('Wrong email or password')) {
        message = 'E-mail or Password is incorrect';
      }

      setState(() {
        this._authenticationFailedMessage = message;
        this._isValid = false;
      });
    } on SocketException catch (error) {
      var message = "Connection failed. PLease check your network connection.";
      if (error.osError.errorCode == 110) {
        message = "Server connection timed out";
      } else if (error.osError.errorCode == 101) {
        message = "No network connection";
      }
      setState(() {
        this._authenticationFailedMessage = message;
        this._isValid = false;
      });
    } catch (error) {
      setState(() {
        this._isValid = false;
      });
    }

    setState(() {
      this._isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 30),
        child: Form(
          key: this._formKey,
          child: Column(
            children: [
              LoginGreet(greetText: this._isLogin ? AppLocalizations.of(context).welcomeBack : AppLocalizations.of(context).createAccount),
              if (!this._isValid) ValidationFailWidget(message: this._authenticationFailedMessage),
              SizedBox(height: this._isValid ? 0 : 10),
              TextFormField(
                key: ValueKey('email'),
                onSaved: (value) {
                  this._email = value;
                },
                keyboardType: TextInputType.emailAddress,
                validator: (value) {
                  if (value.isEmpty || !value.contains('@')) {
                    setState(() {
                      this._authenticationFailedMessage = 'Please enter a valid email address.';
                    });
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
              SizedBox(height: 20),
              TextFormField(
                key: ValueKey('password'),
                validator: (value) {
                  if (value.isEmpty || value.length < 7) {
                    setState(() {
                      this._authenticationFailedMessage = 'Password must be at least 7 characters long.';
                    });
                    return 'Password must be at least 7 characters long.';
                  }
                  return null;
                },
                onSaved: (value) {
                  this._password = value;
                },
                obscureText: true,
                decoration: ColorThemes.loginFormFieldDecoration(
                  context,
                  AppLocalizations.of(context).password,
                  Icons.lock_outline,
                ),
              ),
              this._isLogin
                  ? Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: <Widget>[
                        TextButton(
                          onPressed: () {
                            Navigator.of(context).pushReplacementNamed(ResetPassword.routeName);
                          },
                          child: Text(
                            AppLocalizations.of(context).forgotPassword,
                            style: Theme.of(context).textTheme.headline5,
                          ),
                        ),
                      ],
                    )
                  : SizedBox(height: 48),
              if (this._isLoading)
                CircularProgressIndicator(backgroundColor: Theme.of(context).primaryColor)
              else
                Container(
                  width: 304,
                  height: 47,
                  child: this._isSuccessfull
                      ? null
                      : ElevatedButton(
                          style: ColorThemes.loginButtonStyle(context),
                          onPressed: this._trySubmit,
                          child: Text(
                            this._isLogin ? AppLocalizations.of(context).signInShort : AppLocalizations.of(context).signUpShort,
                            style: TextStyle(
                              fontSize: 25,
                            ),
                          ),
                        ),
                ),
              SizedBox(height: 20),
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text(
                    this._isLogin ? AppLocalizations.of(context).noAccount : AppLocalizations.of(context).alreadyAccount,
                    style: TextStyle(
                      fontSize: 12,
                      fontFamily: 'RobotoCondensed',
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      setState(() {
                        this._isValid = true;
                        this._isLogin = !this._isLogin;
                      });
                    },
                    child: Text(
                      this._isLogin ? AppLocalizations.of(context).createAccount : AppLocalizations.of(context).signInShort,
                      style: Theme.of(context).textTheme.headline5,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
