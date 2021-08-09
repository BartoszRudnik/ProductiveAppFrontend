import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:productive_app/config/color_themes.dart';
import 'package:productive_app/provider/auth_provider.dart';
import 'package:provider/provider.dart';

class SignWithGoogle extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 300,
      height: 47,
      child: ElevatedButton(
        style: ColorThemes.loginButtonStyle(context),
        onPressed: () {
          Provider.of<AuthProvider>(context, listen: false).googleAuthenticate();
        },
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(FontAwesomeIcons.google),
            SizedBox(width: 10),
            Text(
              'Sign in with Google',
              style: TextStyle(
                fontSize: 25,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
