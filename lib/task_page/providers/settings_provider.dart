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
  }) {
    this.userSettings.collaborators = [];
    this.userSettings.priorities = [];
  }

  String _serverUrl = GlobalConfiguration().getValue("serverUrl");

  Future<void> getFilterSettings() async {
    final finalUrl = this._serverUrl + 'filterSettings/getFilterSettings/${this.userMail}';

    try {
      final response = await http.get(finalUrl);

      final responseBody = json.decode(utf8.decode(response.bodyBytes));

      List<String> collaborators = [];
      List<String> priorities = [];

      for (var element in responseBody['priorities']) {
        priorities.add(element);
      }

      for (var element in responseBody['collaboratorEmail']) {
        collaborators.add(element);
      }

      Settings newSettings = Settings(
        showOnlyUnfinished: responseBody['showOnlyUnfinished'],
        showOnlyDelegated: responseBody['showOnlyDelegated'],
        collaborators: collaborators,
        priorities: priorities,
      );
      this.userSettings = newSettings;

      notifyListeners();
    } catch (error) {
      print(error);
      throw (error);
    }
  }

  Future<void> addFilterPriorities(List<String> priorities) async {
    final finalUrl = this._serverUrl + 'filterSettings/addFilterPriority/${this.userMail}';

    try {
      final response = await http.post(
        finalUrl,
        body: json.encode(
          {
            'priorities': priorities,
          },
        ),
        headers: {
          'content-type': 'application/json',
          'accept': 'application/json',
        },
      );

      if (priorities != null) {
        priorities.forEach(
          (element) {
            if (!this.userSettings.priorities.contains(element)) {
              this.userSettings.priorities.add(element);
            }
          },
        );
      }
      notifyListeners();
    } catch (error) {
      print(error);
      throw (error);
    }
  }

  Future<void> addFilterCollaboratorEmail(List<String> collaboratorEmail) async {
    final finalUrl = this._serverUrl + 'filterSettings/addFilterCollaboratorEmail/${this.userMail}';

    try {
      final response = await http.post(
        finalUrl,
        body: json.encode(
          {
            'collaboratorEmail': collaboratorEmail,
          },
        ),
        headers: {
          'content-type': 'application/json',
          'accept': 'application/json',
        },
      );

      if (collaboratorEmail != null) {
        collaboratorEmail.forEach(
          (element) {
            if (!this.userSettings.collaborators.contains(element)) {
              this.userSettings.collaborators.add(element);
            }
          },
        );
      }
      notifyListeners();
    } catch (error) {
      print(error);
      throw (error);
    }
  }

  Future<void> deleteFilterPriority(String priority) async {
    final finalUrl = this._serverUrl + 'filterSettings/deleteFilterPriority/${this.userMail}';

    try {
      final response = await http.post(
        finalUrl,
        body: json.encode(
          {
            'priority': priority,
          },
        ),
        headers: {
          'content-type': 'application/json',
          'accept': 'application/json',
        },
      );

      if (priority != null) {
        this.userSettings.priorities.remove(priority);
      }

      notifyListeners();
    } catch (error) {
      print(error);
      throw (error);
    }
  }

  Future<void> deleteFilterCollaboratorEmail(String collaboratorEmail) async {
    final finalUrl = this._serverUrl + 'filterSettings/deleteFilterCollaboratorEmail/${this.userMail}';

    try {
      final response = await http.post(
        finalUrl,
        body: json.encode(
          {
            'collaboratorEmail': collaboratorEmail,
          },
        ),
        headers: {
          'content-type': 'application/json',
          'accept': 'application/json',
        },
      );

      if (collaboratorEmail != null) {
        this.userSettings.collaborators.remove(collaboratorEmail);
      }

      notifyListeners();
    } catch (error) {
      print(error);
      throw (error);
    }
  }

  Future<void> clearFilterPriorities() async {
    final finalUrl = this._serverUrl + 'filterSettings/clearFilterPriorities/${this.userMail}';

    try {
      await http.post(
        finalUrl,
        headers: {
          'content-type': 'application/json',
          'accept': 'application/json',
        },
      );

      this.userSettings.priorities = [];

      notifyListeners();
    } catch (error) {
      print(error);
      throw (error);
    }
  }

  Future<void> clearFilterCollaborators() async {
    final finalUrl = this._serverUrl + 'filterSettings/clearFilterCollaborators/${this.userMail}';

    try {
      await http.post(
        finalUrl,
        headers: {
          'content-type': 'application/json',
          'accept': 'application/json',
        },
      );

      this.userSettings.collaborators = [];

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
