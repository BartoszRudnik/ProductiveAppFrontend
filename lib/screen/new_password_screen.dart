import 'dart:io';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../config/color_themes.dart';
import '../exception/HttpException.dart';
import '../provider/auth_provider.dart';
import '../widget/appBar/login_appbar.dart';
import '../widget/button/new_password_button.dart';
import '../widget/login_greet.dart';
import '../widget/validation_fail_widget.dart';
import 'login_screen.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

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
  var _validationMessage = '';
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
          title: Center(
            child: Text(
              AppLocalizations.of(context).newPasswordSuccess,
              style: TextStyle(
                fontSize: 26,
                fontFamily: 'RobotoCondensed',
              ),
            ),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).pop(true);
                      Navigator.of(context).pop();
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
      this._validationMessage = AppLocalizations.of(context).authenticationFailed;
      this._isValid = false;
    } on SocketException catch (_) {
      this._validationMessage = AppLocalizations.of(context).connectionFailed;
      this._isValid = false;
    } catch (error) {
      this._validationMessage = AppLocalizations.of(context).wrongToken;
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
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 45),
          child: Form(
            key: this._newPasswordKey,
            child: Column(
              children: [
                LoginGreet(greetText: AppLocalizations.of(context).enterNewPassword),
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
                        this._validationMessage = AppLocalizations.of(context).enterResetToken;
                      });
                      return 'Please enter reset token';
                    }
                    return null;
                  },
                  decoration: ColorThemes.loginFormFieldDecoration(
                    context,
                    'Token',
                    Icons.vpn_key_outlined,
                  ),
                ),
                SizedBox(height: 10),
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
                        this._validationMessage = AppLocalizations.of(context).passwordLength;
                      });
                      return 'Password must be at least 7 characters long';
                    }
                    if (value != this._passwordConfirmKey.currentState.value) {
                      setState(() {
                        this._validationMessage = AppLocalizations.of(context).samePasswords;
                      });
                      return 'Passwords must be the same';
                    }
                    return null;
                  },
                  decoration: ColorThemes.loginFormFieldDecoration(
                    context,
                    AppLocalizations.of(context).password,
                    Icons.lock_outline,
                  ),
                ),
                SizedBox(height: 10),
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
                        this._validationMessage = AppLocalizations.of(context).passwordLength;
                      });
                      return 'Password must be at least 7 characters long';
                    }
                    return null;
                  },
                  decoration: ColorThemes.loginFormFieldDecoration(
                    context,
                    AppLocalizations.of(context).repeatPassword,
                    Icons.lock_outline,
                  ),
                ),
                SizedBox(height: 20),
                if (this._isLoading)
                  CircularProgressIndicator(backgroundColor: Theme.of(context).primaryColor)
                else
                  NewPasswordButton(
                    setNewPassword: this._setNewPassword,
                  ),
                SizedBox(height: 10),
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
