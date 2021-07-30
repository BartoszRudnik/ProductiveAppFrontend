import 'package:flutter/material.dart';

class LoginButton extends StatelessWidget {
  final String labelText;
  final String routeName;
  final Color backgroundColor;
  final Color textColor;
  final bool loginMode;

  LoginButton({
    @required this.backgroundColor,
    @required this.textColor,
    @required this.labelText,
    @required this.routeName,
    @required this.loginMode,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 304,
      height: 47,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          primary: this.backgroundColor,
          side: BorderSide(color: Theme.of(context).primaryColor),
        ),
        onPressed: () {
          Navigator.of(context).pushNamed(
            this.routeName,
            arguments: {'loginMode': this.loginMode},
          );
        },
        child: Text(
          this.labelText,
          style: TextStyle(
            fontSize: 25,
            color: this.textColor,
          ),
        ),
      ),
    );
  }
}
