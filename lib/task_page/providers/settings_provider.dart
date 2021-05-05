import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:global_configuration/global_configuration.dart';
import 'package:productive_app/task_page/models/settings.dart';
import 'package:http/http.dart' as http;

class SettingsProvider with ChangeNotifier {
  Settings userSettings;
  final String userMail;
  final String authToken;

  SettingsProvider({
    this.userSettings,
    this.userMail,
    this.authToken,
  });

  String _serverUrl = GlobalConfiguration().getValue("serverUrl");

  Future<void> getFilterSettings() async {
    final finalUrl = this._serverUrl + 'filterSettings/getFilterSettings/${this.userMail}';

    try {
      final response = await http.get(finalUrl);

      final responseBody = json.decode(utf8.decode(response.bodyBytes));

      Settings newSettings = Settings(
        showOnlyUnfinished: responseBody['showOnlyUnfinished'],
        showOnlyDelegated: responseBody['showOnlyDelegated'],
      );
      this.userSettings = newSettings;

      notifyListeners();
    } catch (error) {
      print(error);
      throw (error);
    }
  }

  Future<void> changeShowOnlyDelegated() async {
    final finalUrl = this._serverUrl + 'filterSettings/changeShowOnlyDelegatedStatus/${this.userMail}';

    try {
      final response = await http.post(
        finalUrl,
        headers: {
          'content-type': 'application/json',
          'accept': 'application/json',
        },
      );

      this.userSettings.showOnlyDelegated = !this.userSettings.showOnlyDelegated;
      notifyListeners();
    } catch (error) {
      print(error);
      throw (error);
    }
  }

  Future<void> changeShowOnlyUnfinished() async {
    final finalUrl = this._serverUrl + 'filterSettings/changeShowOnlyUnfinishedStatus/${this.userMail}';

    try {
      final response = await http.post(
        finalUrl,
        headers: {
          'content-type': 'application/json',
          'accept': 'application/json',
        },
      );

      this.userSettings.showOnlyUnfinished = !this.userSettings.showOnlyUnfinished;
      notifyListeners();
    } catch (error) {
      print(error);
      throw (error);
    }
  }
}
