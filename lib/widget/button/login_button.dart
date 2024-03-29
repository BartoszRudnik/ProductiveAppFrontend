import 'package:auto_size_text/auto_size_text.dart';
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
      width: 300,
      height: 47,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          primary: this.backgroundColor,
        ),
        onPressed: () {
          Navigator.of(context).pushNamed(
            this.routeName,
            arguments: {'loginMode': this.loginMode},
          );
        },
        child: AutoSizeText(
          this.labelText,
          minFontSize: 17,
          maxFontSize: 32,
          style: TextStyle(
            color: this.textColor,
          ),
        ),
      ),
    );
  }
}
