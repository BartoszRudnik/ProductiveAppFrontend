import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:global_configuration/global_configuration.dart';
import 'package:http/http.dart' as http;
import 'package:productive_app/db/settings_database.dart';
import 'package:productive_app/model/settings.dart';
import 'package:productive_app/utils/internet_connection.dart';

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

  void deleteTag(String tagName) async {
    if (this.userSettings.tags.contains(tagName)) {
      this.userSettings.tags.removeWhere((element) => element == tagName);

      await SettingsDatabase.update(this.userSettings, this.userMail);

      notifyListeners();
    }
  }

  void editTag(String oldName, String newName) async {
    if (this.userSettings.tags.contains(oldName)) {
      this.userSettings.tags.removeWhere((element) => element == oldName);
      this.userSettings.tags.add(newName);

      await SettingsDatabase.update(this.userSettings, this.userMail);

      notifyListeners();
    }
  }

  void notify() {
    notifyListeners();
  }

  Future<void> getFilterSettingsOffline() async {
    try {
      this.userSettings = await SettingsDatabase.read(this.userMail);
    } catch (error) {
      print(error);
      throw (error);
    }
  }

  Future<void> getFilterSettings() async {
    final finalUrl = this._serverUrl + 'filterSettings/getFilterSettings/${this.userMail}';

    await SettingsDatabase.delete(this.userMail);

    try {
      final response = await http.get(finalUrl);

      final responseBody = json.decode(utf8.decode(response.bodyBytes));

      List<String> collaborators = [];
      List<String> priorities = [];
      List<String> tags = [];
      List<String> locations = [];

      for (final element in responseBody['locations']) {
        locations.add(element);
      }

      for (final element in responseBody['tags']) {
        tags.add(element);
      }

      for (final element in responseBody['priorities']) {
        priorities.add(element);
      }

      for (final element in responseBody['collaboratorEmail']) {
        collaborators.add(element);
      }

      Settings newSettings = Settings(
        id: responseBody['id'],
        showOnlyDelegated: responseBody['showOnlyDelegated'],
        showOnlyWithLocalization: responseBody['showOnlyWithLocalization'],
        collaborators: collaborators,
        priorities: priorities,
        tags: tags,
        locations: locations,
        sortingMode: responseBody['sortingMode'],
      );
      this.userSettings = newSettings;

      await SettingsDatabase.create(newSettings, this.userMail);

      notifyListeners();
    } catch (error) {
      print(error);
      throw (error);
    }
  }

  void clearTaskName() {
    this.userSettings.taskName = '';

    notifyListeners();
  }

  void setTaskName(String name) {
    this.userSettings.taskName = name;

    notifyListeners();
  }

  Future<void> addFilterLocations(List<String> locations) async {
    final finalUrl = this._serverUrl + 'filterSettings/addFilterLocations/${this.userMail}';

    if (locations != null) {
      this.userSettings.locations = locations;
    }

    await SettingsDatabase.create(this.userSettings, this.userMail);

    notifyListeners();

    if (await InternetConnection.internetConnection()) {
      try {
        await http.post(
          finalUrl,
          body: json.encode(
            {
              'locations': locations,
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

  Future<void> addFilterTags(List<String> tags) async {
    final finalUrl = this._serverUrl + 'filterSettings/addFilterTag/${this.userMail}';

    if (tags != null) {
      this.userSettings.tags = tags;
    }

    await SettingsDatabase.create(this.userSettings, this.userMail);

    notifyListeners();

    if (await InternetConnection.internetConnection()) {
      try {
        await http.post(
          finalUrl,
          body: json.encode(
            {
              'tags': tags,
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

  Future<void> addFilterPriorities(List<String> priorities) async {
    final finalUrl = this._serverUrl + 'filterSettings/addFilterPriority/${this.userMail}';

    if (priorities != null) {
      this.userSettings.priorities = priorities;
    }

    await SettingsDatabase.create(this.userSettings, this.userMail);

    notifyListeners();

    if (await InternetConnection.internetConnection()) {
      try {
        await http.post(
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
      } catch (error) {
        print(error);
        throw (error);
      }
    }
  }

  Future<void> addFilterCollaboratorEmail(List<String> collaboratorEmail) async {
    final finalUrl = this._serverUrl + 'filterSettings/addFilterCollaboratorEmail/${this.userMail}';

    if (collaboratorEmail != null) {
      this.userSettings.collaborators = collaboratorEmail;
    }

    await SettingsDatabase.create(this.userSettings, this.userMail);

    notifyListeners();

    if (await InternetConnection.internetConnection()) {
      try {
        await http.post(
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
      } catch (error) {
        print(error);
        throw (error);
      }
    }
  }

  Future<void> deleteFilterLocation(String locationUuid) async {
    final finalUrl = this._serverUrl + 'filterSettings/deleteFilterLocation/${this.userMail}';

    if (locationUuid != null) {
      this.userSettings.locations.remove(locationUuid);
    }

    await SettingsDatabase.create(this.userSettings, this.userMail);

    notifyListeners();

    if (await InternetConnection.internetConnection()) {
      try {
        await http.post(
          finalUrl,
          body: json.encode(
            {
              'locationUuid': locationUuid,
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

  Future<void> deleteFilterTag(String tag) async {
    final finalUrl = this._serverUrl + 'filterSettings/deleteFilterTag/${this.userMail}';

    if (tag != null) {
      this.userSettings.tags.remove(tag);
    }

    await SettingsDatabase.create(this.userSettings, this.userMail);

    notifyListeners();

    if (await InternetConnection.internetConnection()) {
      try {
        await http.post(
          finalUrl,
          body: json.encode(
            {
              'tag': tag,
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

  Future<void> deleteFilterPriority(String priority) async {
    final finalUrl = this._serverUrl + 'filterSettings/deleteFilterPriority/${this.userMail}';

    if (priority != null) {
      this.userSettings.priorities.remove(priority);
    }

    await SettingsDatabase.create(this.userSettings, this.userMail);

    notifyListeners();

    if (await InternetConnection.internetConnection()) {
      try {
        await http.post(
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
      } catch (error) {
        print(error);
        throw (error);
      }
    }
  }

  Future<void> deleteFilterCollaboratorEmail(String collaboratorEmail) async {
    final finalUrl = this._serverUrl + 'filterSettings/deleteFilterCollaboratorEmail/${this.userMail}';

    if (collaboratorEmail != null) {
      this.userSettings.collaborators.remove(collaboratorEmail);
    }

    await SettingsDatabase.create(this.userSettings, this.userMail);

    notifyListeners();

    if (await InternetConnection.internetConnection()) {
      try {
        await http.post(
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
      } catch (error) {
        print(error);
        throw (error);
      }
    }
  }

  Future<void> clearFilterLocations() async {
    final finalUrl = this._serverUrl + 'filterSettings/clearFilterLocations/${this.userMail}';

    this.userSettings.locations = [];

    await SettingsDatabase.create(this.userSettings, this.userMail);

    notifyListeners();

    if (await InternetConnection.internetConnection()) {
      try {
        await http.post(
          finalUrl,
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

  Future<void> clearFilterTags() async {
    final finalUrl = this._serverUrl + 'filterSettings/clearFilterTags/${this.userMail}';

    this.userSettings.tags = [];

    await SettingsDatabase.create(this.userSettings, this.userMail);

    notifyListeners();

    if (await InternetConnection.internetConnection()) {
      try {
        await http.post(
          finalUrl,
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

  Future<void> clearFilterPriorities() async {
    final finalUrl = this._serverUrl + 'filterSettings/clearFilterPriorities/${this.userMail}';

    this.userSettings.priorities = [];

    await SettingsDatabase.create(this.userSettings, this.userMail);

    notifyListeners();

    if (await InternetConnection.internetConnection()) {
      try {
        await http.post(
          finalUrl,
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

  Future<void> clearFilterCollaborators() async {
    final finalUrl = this._serverUrl + 'filterSettings/clearFilterCollaborators/${this.userMail}';

    this.userSettings.collaborators = [];

    await SettingsDatabase.create(this.userSettings, this.userMail);

    notifyListeners();

    if (await InternetConnection.internetConnection()) {
      try {
        await http.post(
          finalUrl,
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

  Future<void> changeShowOnlyWithLocalization() async {
    final finalUrl = this._serverUrl + 'filterSettings/changeShowOnlyWithLocalization/${this.userMail}';

    if (this.userSettings != null) {
      this.userSettings.showOnlyWithLocalization = !this.userSettings.showOnlyWithLocalization;

      await SettingsDatabase.create(this.userSettings, this.userMail);

      notifyListeners();
    }
    if (await InternetConnection.internetConnection()) {
      try {
        await http.post(
          finalUrl,
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

  Future<void> changeShowOnlyDelegated() async {
    final finalUrl = this._serverUrl + 'filterSettings/changeShowOnlyDelegatedStatus/${this.userMail}';

    this.userSettings.showOnlyDelegated = !this.userSettings.showOnlyDelegated;

    await SettingsDatabase.create(this.userSettings, this.userMail);

    notifyListeners();

    if (await InternetConnection.internetConnection()) {
      try {
        await http.post(
          finalUrl,
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

  Future<void> changeSortingMode(int newMode) async {
    final finalUrl = this._serverUrl + 'filterSettings/changeSortingMode/${this.userMail}';

    this.userSettings.sortingMode = newMode;

    await SettingsDatabase.create(this.userSettings, this.userMail);

    notifyListeners();

    if (await InternetConnection.internetConnection()) {
      try {
        await http.post(
          finalUrl,
          body: json.encode({
            'sortingMode': newMode,
          }),
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
}
