import 'package:flutter/material.dart';
import 'package:productive_app/config/color_themes.dart';

class NewPasswordButton extends StatelessWidget {
  final Function setNewPassword;

  NewPasswordButton({
    @required this.setNewPassword,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 304,
      height: 47,
      child: ElevatedButton(
        style: ColorThemes.loginButtonStyle(context),
        onPressed: this.setNewPassword,
        child: Text(
          'Submit',
          style: TextStyle(
            fontSize: 25,
          ),
        ),
      ),
    );
  }
}
