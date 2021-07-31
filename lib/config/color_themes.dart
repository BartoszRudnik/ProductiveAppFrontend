import 'package:flutter/material.dart';
import 'package:productive_app/config/text_themes.dart';

class ColorThemes {
  static final ThemeData lightTheme = ThemeData(
    scaffoldBackgroundColor: Colors.white,
    primaryColor: Colors.black,
    accentColor: Colors.white,
    primaryColorLight: Color.fromRGBO(237, 237, 240, 1),
    primaryColorDark: Color.fromRGBO(221, 221, 226, 1),
    floatingActionButtonTheme: FloatingActionButtonThemeData(
      backgroundColor: Colors.black,
    ),
    bottomNavigationBarTheme: BottomNavigationBarThemeData(
      selectedItemColor: Colors.white,
      unselectedItemColor: Colors.black,
    ),
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
    bottomNavigationBarTheme: BottomNavigationBarThemeData(
      selectedItemColor: Colors.black,
      unselectedItemColor: Colors.white,
    ),
    floatingActionButtonTheme: FloatingActionButtonThemeData(
      backgroundColor: Colors.grey[700],
    ),
    colorScheme: ColorScheme.dark(),
    fontFamily: 'Lato',
    textTheme: TextThemes.textTheme,
  );

  static InputDecoration loginFormFieldDecoration(BuildContext context, String labelText, IconData icon) {
    return InputDecoration(
      focusedBorder: UnderlineInputBorder(
        borderSide: BorderSide(color: Theme.of(context).primaryColorDark),
      ),
      enabledBorder: UnderlineInputBorder(
        borderSide: BorderSide(color: Theme.of(context).primaryColorDark),
      ),
      border: UnderlineInputBorder(
        borderSide: BorderSide(color: Theme.of(context).primaryColorDark),
      ),
      errorStyle: TextStyle(
        height: 0,
        color: Colors.transparent,
      ),
      focusedErrorBorder: UnderlineInputBorder(
        borderSide: BorderSide(color: Theme.of(context).primaryColor),
      ),
      errorBorder: UnderlineInputBorder(
        borderSide: BorderSide(color: Theme.of(context).primaryColor),
      ),
      labelText: labelText,
      prefixIcon: Icon(
        icon,
        color: Theme.of(context).primaryColorDark,
      ),
    );
  }
}
