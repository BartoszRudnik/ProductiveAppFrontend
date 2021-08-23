import 'package:flutter/material.dart';
import 'package:productive_app/widget/switch_list_tile/theme_switch_list_tile.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class SettingsGraphicSettings extends StatefulWidget {
  @override
  _SettingsGraphicSettingsState createState() => _SettingsGraphicSettingsState();
}

class _SettingsGraphicSettingsState extends State<SettingsGraphicSettings> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(bottom: 4),
      decoration: BoxDecoration(
        color: Theme.of(context).primaryColorLight,
        border: Border.all(
          color: Theme.of(context).primaryColorDark,
          width: 2.5,
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          ListTile(
            minLeadingWidth: 16,
            contentPadding: EdgeInsets.symmetric(horizontal: 0),
            title: Align(
              alignment: Alignment(-1.1, 0),
              child: Center(
                child: Text(
                  AppLocalizations.of(context).graphicSettings,
                  style: TextStyle(fontSize: 20),
                ),
              ),
            ),
          ),
          ThemeSwitchListTile(),
        ],
      ),
    );
  }
}
