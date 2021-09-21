import 'package:flutter/material.dart';
import 'package:productive_app/config/text_themes.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

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
    buttonBarTheme: ButtonBarThemeData(
      alignment: MainAxisAlignment.spaceEvenly,
    ),
    snackBarTheme: SnackBarThemeData(
      backgroundColor: Color.fromRGBO(237, 237, 240, 1),
      contentTextStyle: TextStyle(
        color: Colors.black,
        fontSize: 18,
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
    buttonBarTheme: ButtonBarThemeData(
      alignment: MainAxisAlignment.spaceEvenly,
    ),
    snackBarTheme: SnackBarThemeData(
      backgroundColor: Colors.grey[900],
      contentTextStyle: TextStyle(
        color: Colors.white,
        fontSize: 18,
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

  static InputDecoration taskDetailsFieldDecoration(isFocused, description, BuildContext context) {
    return InputDecoration(
      hintText: isFocused ? "" : AppLocalizations.of(context).tapToAddDescription,
      filled: true,
      fillColor: Theme.of(context).primaryColorLight,
      enabledBorder: description != null && description.isEmpty
          ? OutlineInputBorder(
              borderSide: BorderSide(
                color: Theme.of(context).primaryColorDark,
              ),
            )
          : InputBorder.none,
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

  static ButtonStyle newTaskDateButtonStyle(BuildContext context) {
    return ElevatedButton.styleFrom(
      elevation: 3,
      primary: Theme.of(context).primaryColorDark,
      side: BorderSide(color: Theme.of(context).primaryColorDark),
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

  static ButtonStyle addTaskButtonStyle(BuildContext context) {
    return ElevatedButton.styleFrom(
      onPrimary: Theme.of(context).primaryColor,
      side: BorderSide(color: Theme.of(context).brightness == Brightness.dark ? Colors.grey[700] : Theme.of(context).accentColor),
      primary: Theme.of(context).brightness == Brightness.dark ? Colors.grey[700] : Theme.of(context).accentColor,
      elevation: 0,
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

  static InputDecoration searchFormFieldDecoration(BuildContext context, String labelText, Function onPressed) {
    return InputDecoration(
      focusedBorder: InputBorder.none,
      enabledBorder: InputBorder.none,
      border: InputBorder.none,
      focusedErrorBorder: InputBorder.none,
      errorBorder: InputBorder.none,
      errorStyle: TextStyle(
        height: 0,
        color: Colors.transparent,
      ),
      labelStyle: TextStyle(color: Colors.grey[700]),
      labelText: labelText,
      suffixIcon: IconButton(
        color: Theme.of(context).primaryColor,
        icon: Icon(Icons.close_outlined),
        onPressed: () {
          onPressed();
        },
      ),
    );
  }
}
