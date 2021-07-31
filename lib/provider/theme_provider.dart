import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

class ThemeProvider with ChangeNotifier {
  ThemeMode themeMode = ThemeMode.system;

  bool get isDarkMode {
    if (this.themeMode == ThemeMode.system) {
      final brightness = SchedulerBinding.instance.window.platformBrightness;

      return brightness == Brightness.dark;
    } else {
      return this.themeMode == ThemeMode.dark;
    }
  }

  void toggleTheme(bool isOn) {
    this.themeMode = isOn ? ThemeMode.dark : ThemeMode.light;

    notifyListeners();
  }
}
