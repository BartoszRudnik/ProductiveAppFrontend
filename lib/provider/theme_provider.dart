import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:global_configuration/global_configuration.dart';
import 'package:http/http.dart' as http;
import 'package:productive_app/db/graphic_database.dart';
import 'package:productive_app/utils/internet_connection.dart';

class ThemeProvider with ChangeNotifier {
  ThemeMode themeMode;
  final userToken;
  final userEmail;

  String _serverUrl = GlobalConfiguration().getValue("serverUrl");

  ThemeProvider({
    @required this.themeMode,
    @required this.userEmail,
    @required this.userToken,
  }) {
    GraphicDatabase.create(this._getColorMode(), this.userEmail);
  }

  bool get isDarkMode {
    if (this.themeMode == ThemeMode.system) {
      final brightness = SchedulerBinding.instance.window.platformBrightness;

      return brightness == Brightness.dark;
    } else {
      return this.themeMode == ThemeMode.dark;
    }
  }

  Future<void> getUserMode() async {
    if (await InternetConnection.internetConnection()) {
      final requestUrl = this._serverUrl + 'themeMode/get/${this.userEmail}';

      try {
        final response = await http.get(
          requestUrl,
          headers: {
            'content-type': 'application/json',
            'accept': 'application/json',
          },
        );

        final responseBody = json.decode(response.body);

        this.themeMode = this._selectColorMode(responseBody['backgroundType']);

        await GraphicDatabase.create(
          this._getColorMode(),
          this.userEmail,
        );

        notifyListeners();
      } catch (error) {
        print(error);
        throw (error);
      }
    }
  }

  Future<void> toggleTheme(bool isOn) async {
    final requestUrl = this._serverUrl + 'themeMode/add';

    this.themeMode = isOn ? ThemeMode.dark : ThemeMode.light;

    final modeToSend = this._getColorMode();
    GraphicDatabase.create(modeToSend, this.userEmail);

    notifyListeners();

    if (await InternetConnection.internetConnection()) {
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
      } catch (error) {
        print(error);
        throw (error);
      }
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
