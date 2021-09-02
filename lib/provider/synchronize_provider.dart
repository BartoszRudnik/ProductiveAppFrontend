import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:global_configuration/global_configuration.dart';
import 'package:http/http.dart' as http;
import 'package:productive_app/model/collaborator.dart';
import 'package:productive_app/model/deleteCollaborator.dart';
import 'package:productive_app/model/deleteLocation.dart';
import 'package:productive_app/model/deleteTag.dart';
import 'package:productive_app/model/location.dart';
import 'package:productive_app/model/tag.dart';

class SynchronizeProvider with ChangeNotifier {
  final String userMail;
  final String authToken;

  List<DeleteCollaborator> collaboratorsToDelete;
  List<DeleteTag> tagsToDelete;
  List<DeleteLocation> locationsToDelete;

  SynchronizeProvider({
    @required this.userMail,
    @required this.authToken,
    @required this.collaboratorsToDelete,
    @required this.tagsToDelete,
    @required this.locationsToDelete,
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
