import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';

import '../../config/color_themes.dart';
import '../../provider/auth_provider.dart';

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
                minFontSize: 16,
                maxFontSize: 32,
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
