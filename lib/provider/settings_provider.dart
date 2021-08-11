import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:global_configuration/global_configuration.dart';
import 'package:productive_app/model/settings.dart';
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
    this.userSettings.tags = [];
    this.userSettings.sortingMode = 0;
  }

  String _serverUrl = GlobalConfiguration().getValue("serverUrl");

  Future<void> getFilterSettings() async {
    final finalUrl = this._serverUrl + 'filterSettings/getFilterSettings/${this.userMail}';

    try {
      final response = await http.get(finalUrl);

      final responseBody = json.decode(utf8.decode(response.bodyBytes));

      List<String> collaborators = [];
      List<String> priorities = [];
      List<String> tags = [];
      List<int> locations = [];

      for (var element in responseBody['locations']) {
        locations.add(element);
      }

      for (var element in responseBody['tags']) {
        tags.add(element);
      }

      for (var element in responseBody['priorities']) {
        priorities.add(element);
      }

      for (var element in responseBody['collaboratorEmail']) {
        collaborators.add(element);
      }

      Settings newSettings = Settings(
        showOnlyUnfinished: responseBody['showOnlyUnfinished'],
        showOnlyDelegated: responseBody['showOnlyDelegated'],
        showOnlyWithLocalization: responseBody['showOnlyWithLocalization'],
        collaborators: collaborators,
        priorities: priorities,
        tags: tags,
        locations: locations,
        sortingMode: responseBody['sortingMode'],
      );
      this.userSettings = newSettings;

      notifyListeners();
    } catch (error) {
      print(error);
      throw (error);
    }
  }

  void clearTaskName() {
    this.userSettings.taskName = ' ';

    notifyListeners();
  }

  void setTaskName(String name) {
    this.userSettings.taskName = name;

    notifyListeners();
  }

  Future<void> addFilterLocations(List<int> locations) async {
    final finalUrl = this._serverUrl + 'filterSettings/addFilterLocations/${this.userMail}';

    try {
      await http.post(
        finalUrl,
        body: json.encode(
          {'locations': locations},
        ),
        headers: {
          'content-type': 'application/json',
          'accept': 'application/json',
        },
      );

      if (locations != null) {
        locations.forEach(
          (element) {
            if (!this.userSettings.locations.contains(element)) {
              this.userSettings.locations.add(element);
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

  Future<void> addFilterTags(List<String> tags) async {
    final finalUrl = this._serverUrl + 'filterSettings/addFilterTag/${this.userMail}';

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

      if (tags != null) {
        tags.forEach(
          (element) {
            if (!this.userSettings.tags.contains(element)) {
              this.userSettings.tags.add(element);
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

  Future<void> addFilterPriorities(List<String> priorities) async {
    final finalUrl = this._serverUrl + 'filterSettings/addFilterPriority/${this.userMail}';

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

  Future<void> deleteFilterLocation(int location) async {
    final finalUrl = this._serverUrl + 'filterSettings/deleteFilterLocation/${this.userMail}';

    try {
      await http.post(
        finalUrl,
        body: json.encode(
          {
            'location': location,
          },
        ),
        headers: {
          'content-type': 'application/json',
          'accept': 'application/json',
        },
      );

      if (location != null) {
        this.userSettings.locations.remove(location);
      }
      notifyListeners();
    } catch (error) {
      print(error);
      throw (error);
    }
  }

  Future<void> deleteFilterTag(String tag) async {
    final finalUrl = this._serverUrl + 'filterSettings/deleteFilterTag/${this.userMail}';

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
      if (tag != null) {
        this.userSettings.tags.remove(tag);
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

      if (collaboratorEmail != null) {
        this.userSettings.collaborators.remove(collaboratorEmail);
      }

      notifyListeners();
    } catch (error) {
      print(error);
      throw (error);
    }
  }

  Future<void> clearFilterLocations() async {
    final finalUrl = this._serverUrl + 'filterSettings/clearFilterLocations/${this.userMail}';

    try {
      await http.post(
        finalUrl,
        headers: {
          'content-type': 'application/json',
          'accept': 'application/json',
        },
      );

      this.userSettings.locations = [];

      notifyListeners();
    } catch (error) {
      print(error);
      throw (error);
    }
  }

  Future<void> clearFilterTags() async {
    final finalUrl = this._serverUrl + 'filterSettings/clearFilterTags/${this.userMail}';

    try {
      await http.post(
        finalUrl,
        headers: {
          'content-type': 'application/json',
          'accept': 'application/json',
        },
      );

      this.userSettings.tags = [];

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

  Future<void> changeShowOnlyWithLocalization() async {
    final finalUrl = this._serverUrl + 'filterSettings/changeShowOnlyWithLocalization/${this.userMail}';

    try {
      await http.post(
        finalUrl,
        headers: {
          'content-type': 'application/json',
          'accept': 'application/json',
        },
      );

      this.userSettings.showOnlyWithLocalization = !this.userSettings.showOnlyWithLocalization;
      notifyListeners();
    } catch (error) {
      print(error);
      throw (error);
    }
  }

  Future<void> changeShowOnlyDelegated() async {
    final finalUrl = this._serverUrl + 'filterSettings/changeShowOnlyDelegatedStatus/${this.userMail}';

    try {
      await http.post(
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
      await http.post(
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

  Future<void> changeSortingMode(int newMode) async {
    final finalUrl = this._serverUrl + 'filterSettings/changeSortingMode/${this.userMail}';

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

      this.userSettings.sortingMode = newMode;
      notifyListeners();
    } catch (error) {
      print(error);
      throw (error);
    }
  }
}
