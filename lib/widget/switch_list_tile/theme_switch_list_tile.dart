import 'package:flutter/material.dart';
import 'package:productive_app/provider/theme_provider.dart';
import 'package:provider/provider.dart';

class ThemeSwitchListTile extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);

    return Padding(
      padding: const EdgeInsets.all(12),
      child: Card(
        color: Theme.of(context).primaryColorDark,
        elevation: 8,
        child: SwitchListTile(
          activeColor: Theme.of(context).primaryColor,
          title: Text('Dark Mode'),
          value: themeProvider.isDarkMode,
          onChanged: (bool value) {
            themeProvider.toggleTheme(value);
          },
        ),
      ),
    );
  }
}
