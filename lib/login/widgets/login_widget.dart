import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../exceptions/HttpException.dart';
import '../providers/auth_provider.dart';
import '../screens/reset_password.dart';
import 'validation_fail_widget.dart';
import 'login_greet.dart';

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

  var _authenticationFailedMessage = '';

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
              'Registration successful',
              style: Theme.of(context).textTheme.headline2,
            ),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text('Please check your registered email for email verification'),
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
            children: <Widget>[
              LoginGreet(greetText: this._isLogin ? 'Welcome back' : 'Create account'),
              if (!this._isValid) ValidationFailWidget(message: this._authenticationFailedMessage),
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
                    setState(() {
                      this._authenticationFailedMessage = 'Please enter a valid email address.';
                    });
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
              SizedBox(
                height: 20,
              ),
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
                  labelText: 'Password',
                  prefixIcon: Icon(Icons.lock_outline),
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
                            'Forgot Password?',
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
                          style: ElevatedButton.styleFrom(
                            primary: Theme.of(context).primaryColor,
                            side: BorderSide(color: Theme.of(context).primaryColor),
                          ),
                          onPressed: this._trySubmit,
                          child: Text(
                            this._isLogin ? 'Sign in' : 'Sign up',
                            style: TextStyle(
                              fontSize: 25,
                              color: Theme.of(context).accentColor,
                            ),
                          ),
                        ),
                ),
              SizedBox(
                height: 20,
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text(
                    this._isLogin ? 'Don\'t have account?' : 'Already have a account',
                    style: Theme.of(context).textTheme.headline4,
                  ),
                  TextButton(
                    onPressed: () {
                      setState(() {
                        this._isValid = true;
                        this._isLogin = !this._isLogin;
                      });
                    },
                    child: Text(
                      this._isLogin ? 'create a new account!' : 'Login',
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
