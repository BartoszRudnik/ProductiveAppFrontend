import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:global_configuration/global_configuration.dart';
import 'package:http/http.dart' as http;

class ThemeProvider with ChangeNotifier {
  ThemeMode themeMode;
  final userToken;
  final userEmail;

  String _serverUrl = GlobalConfiguration().getValue("serverUrl");

  ThemeProvider({
    @required this.themeMode,
    @required this.userEmail,
    @required this.userToken,
  });

  bool get isDarkMode {
    if (this.themeMode == ThemeMode.system) {
      final brightness = SchedulerBinding.instance.window.platformBrightness;

      return brightness == Brightness.dark;
    } else {
      return this.themeMode == ThemeMode.dark;
    }
  }

  Future<void> getUserMode() async {
    final requestUrl = this._serverUrl + 'themeMode/get/${this.userEmail}';

    try {
      final response = await http.get(
        requestUrl,
        headers: {
          'content-type': 'application/json',
          'accept': 'application/json',
        },
      );

      print(response);
      print(response.body);

      final responseBody = json.decode(response.body);

      this.themeMode = this._selectColorMode(responseBody['backgroundType']);

      notifyListeners();
    } catch (error) {
      print(error);
      throw (error);
    }
  }

  Future<void> toggleTheme(bool isOn) async {
    final requestUrl = this._serverUrl + 'themeMode/add';

    this.themeMode = isOn ? ThemeMode.dark : ThemeMode.light;

    final modeToSend = this._getColorMode();

    try {
      await http.post(
        requestUrl,
        body: json.encode(
          {
            'backgroundType': modeToSend,
            'userMail': this.userEmail,
          },
        ),
        headers: {
          'content-type': 'application/json',
          'accept': 'application/json',
        },
      );

      notifyListeners();
    } catch (error) {
      print(error);
      throw (error);
    }
  }

  String _getColorMode() {
    if (this.isDarkMode) {
      return "BLACK";
    } else {
      return "GREY";
    }
  }

  ThemeMode _selectColorMode(String mode) {
    if (mode == "BLACK") {
      return ThemeMode.dark;
    } else {
      return ThemeMode.light;
    }
  }
}
