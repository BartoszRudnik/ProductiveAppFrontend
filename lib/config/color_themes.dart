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
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        onPrimary: Colors.white,
        side: BorderSide(color: Colors.black),
        primary: Colors.black,
      ),
    ),
    colorScheme: ColorScheme.light(),
    fontFamily: 'Lato',
    textTheme: TextThemes.textTheme,
  );

  static final ThemeData darkTheme = ThemeData(
    scaffoldBackgroundColor: Colors.black,
    primaryColor: Colors.white,
    accentColor: Colors.black,
    primaryColorDark: Colors.grey[900],
    primaryColorLight: Colors.grey[800],
    bottomNavigationBarTheme: BottomNavigationBarThemeData(
      selectedItemColor: Colors.black,
      unselectedItemColor: Colors.white,
    ),
    floatingActionButtonTheme: FloatingActionButtonThemeData(
      backgroundColor: Colors.grey[700],
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        onPrimary: Colors.white,
        side: BorderSide(color: Colors.white),
        primary: Colors.grey[700],
      ),
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

  static ButtonStyle taskDetailsButtonStyle(BuildContext context) {
    return ElevatedButton.styleFrom(
      elevation: 3,
      primary: Theme.of(context).primaryColorLight,
      side: BorderSide(color: Theme.of(context).primaryColorLight),
      onPrimary: Theme.of(context).primaryColor,
    );
  }

  static ButtonStyle loginButtonStyle(BuildContext context) {
    return ElevatedButton.styleFrom(
      primary: Colors.black,
      side: BorderSide(
        color: Colors.white,
      ),
    );
  }

  static ThemeData lightDateTimePicker(BuildContext context) {
    return Theme.of(context).copyWith(
      colorScheme: ColorScheme.light(
        primary: Colors.grey,
        onPrimary: Colors.white,
        onSurface: Colors.black,
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          primary: Colors.black,
        ),
      ),
    );
  }

  static ThemeData darkDateTimePicker(BuildContext context) {
    return Theme.of(context).copyWith(
      colorScheme: ColorScheme.dark(
        primary: Colors.grey,
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          primary: Colors.white,
        ),
      ),
    );
  }
}
