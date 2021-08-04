import 'package:flutter/material.dart';
import 'package:productive_app/provider/theme_provider.dart';
import 'package:provider/provider.dart';

class ThemeSwitchListTile extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);

    return Padding(
      padding: const EdgeInsets.all(12),
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(
            color: Theme.of(context).primaryColor,
          ),
        ),
        child: SwitchListTile(
          tileColor: themeProvider.isDarkMode ? Theme.of(context).primaryColorDark : Colors.black,
          activeColor: Theme.of(context).primaryColor,
          inactiveTrackColor: Theme.of(context).primaryColorLight,
          activeTrackColor: Theme.of(context).primaryColor,
          title: Text(
            'Dark Mode',
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
