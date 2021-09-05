import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:global_configuration/global_configuration.dart';
import 'package:http/http.dart' as http;
import 'package:productive_app/model/collaborator.dart';
import 'package:productive_app/model/deleteCollaborator.dart';
import 'package:productive_app/model/deleteLocation.dart';
import 'package:productive_app/model/deleteTag.dart';
import 'package:productive_app/model/deleteTask.dart';
import 'package:productive_app/model/location.dart';
import 'package:productive_app/model/settings.dart';
import 'package:productive_app/model/tag.dart';
import 'package:productive_app/model/task.dart';
import 'package:productive_app/model/user.dart';

class SynchronizeProvider with ChangeNotifier {
  final String userMail;
  final String authToken;

  List<DeleteCollaborator> collaboratorsToDelete;
  List<DeleteTag> tagsToDelete;
  List<DeleteLocation> locationsToDelete;
  List<DeleteTask> tasksToDelete;

  SynchronizeProvider({
    @required this.userMail,
    @required this.authToken,
    @required this.collaboratorsToDelete,
    @required this.tagsToDelete,
    @required this.locationsToDelete,
    @required this.tasksToDelete,
  });

  String _serverUrl = GlobalConfiguration().getValue("serverUrl");

  void addLocationToDelete(String locationName) {
    DeleteLocation newToDelete = DeleteLocation(
      ownerEmail: this.userMail,
      locationName: locationName,
    );

    this.locationsToDelete.add(newToDelete);
  }

  void addTagToDelete(String tagName) {
    DeleteTag newToDelete = DeleteTag(
      ownerEmail: this.userMail,
      tagName: tagName,
    );

    this.tagsToDelete.add(newToDelete);
  }

  void addCollaboratorToDelete(String collaboratorEmail) {
    DeleteCollaborator newToDelete = DeleteCollaborator(
      user1Mail: this.userMail,
      user2Mail: collaboratorEmail,
    );

    this.collaboratorsToDelete.add(newToDelete);
  }

  void addTaskToDelete(int taskId){
    DeleteTask newToDelete = DeleteTask(ownerEmail: this.userMail, taskId: taskId,);

    this.tasksToDelete.add(newToDelete);
  }

  Future<void> synchronizeTasks(List<Task> tasks) async {
    final finalUrl = this._serverUrl + "synchronize/synchronizeTasks/${this.userMail}";

    print(json.encode({
      'taskList': tasks,
      'deleteList': this.tasksToDelete,
    },),);

    try {
      await http.post(
        finalUrl,
        body: json.encode({
          'taskList': tasks,
          'deleteList': this.tasksToDelete,
        },),
        headers: {
          'content-type': 'application/json',
          'accept': 'application/json',
        },
      );

      this.tasksToDelete = [];
    } catch (error) {
      print(error);
      throw (error);
    }
  }

  Future<void> synchronizeSettings(Settings settings) async {
    final finalUrl = this._serverUrl + "synchronize/synchronizeSettings/${this.userMail}";

    try {
      await http.post(
        finalUrl,
        body: json.encode(
          {
            "showOnlyUnfinished": settings.showOnlyUnfinished,
            "showOnlyDelegated": settings.showOnlyDelegated,
            "showOnlyWithLocalization": settings.showOnlyWithLocalization,
            "collaborators": settings.collaborators,
            "priorities": settings.priorities,
            "tags": settings.tags,
            "locations": settings.locations,
            "sortingMode": settings.sortingMode,
            "taskName": settings.taskName,
            "lastUpdated": settings.lastUpdated != null ? settings.lastUpdated.toIso8601String() : DateTime.fromMicrosecondsSinceEpoch(0).toIso8601String(),
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

  Future<void> synchronizeUser(User user) async {
    final finalUrl = this._serverUrl + "synchronize/synchronizeUser";

    try {
      await http.post(
        finalUrl,
        body: json.encode(
          {
            "firstName": user.firstName,
            "lastName": user.lastName,
            "email": user.email,
            "lastUpdatedImage": user.lastUpdatedImage.toIso8601String(),
            "lastUpdatedName": user.lastUpdatedName.toIso8601String(),
            "removed": user.removed ? 1 : 0,
            "userType": user.userType,
            "localImage": user.localImage,
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

  Future<void> synchronizeGraphic(List<String> data) async {
    final finalUrl = this._serverUrl + "synchronize/synchronizeGraphic/${this.userMail}";

    try {
      await http.post(
        finalUrl,
        body: json.encode(
          {
            'mode': data[0],
            'lastUpdated': data[1],
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

  Future<void> synchronizeLocale(List<String> data) async {
    final finalUrl = this._serverUrl + "synchronize/synchronizeLocale/${this.userMail}";

    try {
      await http.post(
        finalUrl,
        body: json.encode(
          {
            'locale': data[0],
            'lastUpdated': data[1],
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

  Future<void> synchronizeCollaborators(List<Collaborator> collaboratorList) async {
    final finalUrl = this._serverUrl + "synchronize/synchronizeCollaborators/${this.userMail}";

    try {
      await http.post(
        finalUrl,
        body: json.encode(
          {
            'collaboratorList': collaboratorList,
            'deleteList': this.collaboratorsToDelete,
          },
        ),
        headers: {
          'content-type': 'application/json',
          'accept': 'application/json',
        },
      );

      this.collaboratorsToDelete = [];
    } catch (error) {
      print(error);
      throw (error);
    }
  }

  Future<void> synchronizeLocations(List<Location> locationList) async {
    final finalUrl = this._serverUrl + "synchronize/synchronizeLocations/${this.userMail}";

    try {
      await http.post(
        finalUrl,
        body: json.encode(
          {
            'locationList': locationList,
            'deleteList': this.locationsToDelete,
          },
        ),
        headers: {
          'content-type': 'application/json',
          'accept': 'application/json',
        },
      );

      this.locationsToDelete = [];
    } catch (error) {
      print(error);
      throw (error);
    }
  }

  Future<void> synchronizeTags(List<Tag> tagList) async {
    final finalUrl = this._serverUrl + "synchronize/synchronizeTags/${this.userMail}";

    try {
      await http.post(
        finalUrl,
        body: json.encode(
          {
            'tagList': tagList,
            'deleteList': this.tagsToDelete,
          },
        ),
        headers: {
          'content-type': 'application/json',
          'accept': 'application/json',
        },
      );

      this.tagsToDelete = [];
    } catch (error) {
      print(error);
      throw (error);
    }
  }
}
