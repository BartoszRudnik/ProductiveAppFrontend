import 'package:flutter/material.dart';
import 'package:productive_app/provider/theme_provider.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class ThemeSwitchListTile extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);

    return Padding(
      padding: const EdgeInsets.all(12),
      child: Container(
        decoration: BoxDecoration(
          color: themeProvider.isDarkMode
              ? Theme.of(context).floatingActionButtonTheme.backgroundColor
              : Theme.of(context).primaryColor,
          border: Border.all(
            color: Theme.of(context).primaryColor,
          ),
        ),
        child: SwitchListTile(
          activeColor: Theme.of(context).primaryColor,
          inactiveTrackColor: Theme.of(context).accentColor,
          activeTrackColor: Theme.of(context).primaryColor,
          title: Text(
            AppLocalizations.of(context).darkMode,
            style: TextStyle(
              fontSize: 16,
              color: Colors.white,
            ),
          ),
          value: themeProvider.isDarkMode,
          onChanged: (bool value) {
            themeProvider.toggleTheme(value);
          },
        ),
      ),
    );
  }
}
