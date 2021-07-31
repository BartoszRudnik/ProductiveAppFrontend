import 'package:flutter/material.dart';
import 'package:productive_app/config/text_themes.dart';

class ColorThemes {
  static final ThemeData lightTheme = ThemeData(
    scaffoldBackgroundColor: Colors.white,
    primaryColor: Colors.black,
    accentColor: Colors.white,
    primaryColorLight: Color.fromRGBO(237, 237, 240, 1),
    primaryColorDark: Color.fromRGBO(221, 221, 226, 1),
    colorScheme: ColorScheme.light(),
    fontFamily: 'Lato',
    textTheme: TextThemes.textTheme,
  );

  static final ThemeData darkTheme = ThemeData(
    scaffoldBackgroundColor: Colors.black,
    primaryColor: Colors.white,
    accentColor: Colors.black,
    primaryColorDark: Colors.grey[700],
    primaryColorLight: Colors.grey[600],
    colorScheme: ColorScheme.dark(),
    fontFamily: 'Lato',
    textTheme: TextThemes.textTheme,
  );
}
