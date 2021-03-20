import 'package:flutter/material.dart';

class LoginGreet extends StatelessWidget {
  final String greetText;

  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  LoginGreet({
    @required this.greetText,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        SizedBox(
          height: 80,
        ),
        Container(
          height: 130,
          width: 130,
          child: Icon(
            Icons.person_outline_outlined,
            size: 130,
          ),
        ),
        Text(
          this.greetText,
          style: TextStyle(
            fontSize: 36,
            fontFamily: 'RobotoCondensed',
          ),
        ),
        SizedBox(
          height: 50,
        ),
        Padding(
          padding: EdgeInsets.symmetric(
            horizontal: 30,
          ),
          child: TextField(
            decoration: InputDecoration(
              labelText: 'E-mail',
              labelStyle: TextStyle(
                color: Theme.of(context).accentColor,
              ),
              prefixIcon: Icon(
                Icons.person_outline,
                color: Theme.of(context).accentColor,
              ),
              focusedBorder: UnderlineInputBorder(
                borderSide: BorderSide(
                  color: Theme.of(context).accentColor,
                ),
              ),
            ),
            controller: this._emailController,
          ),
        ),
        SizedBox(
          height: 20,
        ),
        Padding(
          padding: EdgeInsets.symmetric(
            horizontal: 30,
          ),
          child: TextField(
            obscureText: true,
            decoration: InputDecoration(
              labelText: 'Password',
              labelStyle: TextStyle(
                color: Theme.of(context).accentColor,
              ),
              prefixIcon: Icon(
                Icons.lock_outline,
                color: Theme.of(context).accentColor,
              ),
              focusedBorder: UnderlineInputBorder(
                borderSide: BorderSide(
                  color: Theme.of(context).accentColor,
                ),
              ),
            ),
            controller: this._passwordController,
          ),
        ),
      ],
    );
  }
}
