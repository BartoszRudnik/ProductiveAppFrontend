import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:productive_app/config/color_themes.dart';
import 'package:productive_app/config/const_values.dart';
import 'package:productive_app/provider/auth_provider.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:auto_size_text/auto_size_text.dart';

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
            Expanded(
              child: AutoSizeText(
                AppLocalizations.of(context).signInGoogle,
                maxLines: 1,
                presetFontSizes: ConstValues.fontSizes,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
