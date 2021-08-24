import 'package:flutter/material.dart';
import 'package:productive_app/l10n/L10n.dart';
import 'package:productive_app/provider/locale_provider.dart';
import 'package:provider/provider.dart';

class SettingsLanguage extends StatelessWidget {
  String getLanguageName(String languageCode) {
    if (languageCode == 'en') {
      return 'English';
    } else {
      return 'Polish';
    }
  }

  @override
  Widget build(BuildContext context) {
    final actualLanguageCode = Provider.of<LocaleProvider>(context).locale;

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
        children: [
          ListTile(
            minLeadingWidth: 16,
            contentPadding: EdgeInsets.symmetric(horizontal: 0),
            title: Align(
              alignment: Alignment(-1.1, 0),
              child: Center(
                child: Text(
                  "Language",
                  style: TextStyle(fontSize: 20),
                ),
              ),
            ),
          ),
          DropdownButtonHideUnderline(
            child: Center(
              child: DropdownButton(
                hint: Text(actualLanguageCode.languageCode == 'en' ? 'English' : 'Polish'),
                icon: Icon(Icons.language_outlined),
                items: L10n.all.map(
                  (Locale locale) {
                    return DropdownMenuItem(
                      child: Text(
                        this.getLanguageName(locale.languageCode),
                      ),
                      value: locale,
                    );
                  },
                ).toList(),
                onChanged: (locale) {
                  Provider.of<LocaleProvider>(context, listen: false).setLocale(locale);
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
