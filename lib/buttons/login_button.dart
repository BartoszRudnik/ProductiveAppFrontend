import 'package:flutter/material.dart';

class LoginButton extends StatefulWidget {
  final String labelText;
  final String routeName;
  final Color backgroundColor;
  final Color textColor;

  LoginButton({
    @required this.backgroundColor,
    @required this.textColor,
    @required this.labelText,
    @required this.routeName,
  });

  @override
  _LoginButtonState createState() => _LoginButtonState();
}

class _LoginButtonState extends State<LoginButton> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 304,
      height: 47,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          primary: this.widget.backgroundColor,
          side: BorderSide(color: Theme.of(context).accentColor),
        ),
        onPressed: () {
          Navigator.of(context).pushNamed(this.widget.routeName);
        },
        child: Text(
          this.widget.labelText,
          style: TextStyle(
            fontSize: 25,
            color: this.widget.textColor,
          ),
        ),
      ),
    );
  }
}
