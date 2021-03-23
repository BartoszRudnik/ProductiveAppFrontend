import 'package:flutter/material.dart';
import 'package:productive_app/task_page/task_screens/task_screen.dart';

import 'login_greet.dart';

class LoginWidget extends StatefulWidget {
  @override
  _LoginWidgetState createState() => _LoginWidgetState();
}

class _LoginWidgetState extends State<LoginWidget> {
  final _formKey = GlobalKey<FormState>();

  var _isValid = true;
  var _isLogin = true;
  var _email = '';
  var _password = '';

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

  void _trySubmit() {
    final isValid = _formKey.currentState.validate();
    setState(() {
      this._isValid = isValid;
    });

    FocusScope.of(context).unfocus();

    if (isValid) {
      _formKey.currentState.save();
    }
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
                        'E-mail or Password is incorrect',
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
              SizedBox(
                height: 20,
              ),
              TextFormField(
                key: ValueKey('password'),
                validator: (value) {
                  if (value.isEmpty || value.length < 7) {
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
                          onPressed: () {},
                          child: Text(
                            'Forgot Password?',
                            style: Theme.of(context).textTheme.headline5,
                          ),
                        ),
                      ],
                    )
                  : SizedBox(height: 48),
              Container(
                width: 304,
                height: 47,
                child: ElevatedButton(
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
