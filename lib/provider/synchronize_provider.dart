import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:global_configuration/global_configuration.dart';
import 'package:http/http.dart' as http;
import 'package:productive_app/model/collaborator.dart';
import 'package:productive_app/model/location.dart';
import 'package:productive_app/model/tag.dart';

class SynchronizeProvider with ChangeNotifier {
  final String userMail;
  final String authToken;

  SynchronizeProvider({
    this.userMail,
    this.authToken,
  });

  String _serverUrl = GlobalConfiguration().getValue("serverUrl");

  Future<List<Collaborator>> synchronizeCollaborators(List<Collaborator> collaboratorList) async {
    final finalUrl = this._serverUrl + "synchronize/synchronizeCollaborators/${this.userMail}";

    try {
      final response = await http.post(
        finalUrl,
        body: json.encode(
          {
            'collaboratorList': collaboratorList,
          },
        ),
        headers: {
          'content-type': 'application/json',
          'accept': 'application/json',
        },
      );

      final responseBody = json.decode(utf8.decode(response.bodyBytes));

      List<Collaborator> loadedCollaborators = [];

      for (final element in responseBody) {
        bool isAskingForPermission = false;
        bool alreadyAsked = false;
        bool receivedPermission = false;
        bool sentPermission = false;
        bool isReceived = false;
        String collaboratorEmail = '';
        String collaboratorName = '';

        if (element['invitationSender'] == this.userMail) {
          collaboratorEmail = element['invitationReceiver'];
          collaboratorName = element['invitationReceiverName'];
          sentPermission = element['user2Permission'];
          receivedPermission = element['user1Permission'];
          isAskingForPermission = element['user2AskForPermission'];
          alreadyAsked = element['user1AskForPermission'];
        } else {
          isReceived = true;
          collaboratorEmail = element['invitationSender'];
          collaboratorName = element['invitationSenderName'];
          sentPermission = element['user1Permission'];
          receivedPermission = element['user2Permission'];
          isAskingForPermission = element['user1AskForPermission'];
          alreadyAsked = element['user2AskForPermission'];
        }

        Collaborator newCollaborator = Collaborator(
          id: element['id'],
          email: collaboratorEmail,
          collaboratorName: collaboratorName,
          relationState: element['relationState'],
          isSelected: false,
          received: isReceived,
          sentPermission: sentPermission,
          receivedPermission: receivedPermission,
          alreadyAsked: alreadyAsked,
          isAskingForPermission: isAskingForPermission,
          lastUpdated: element['lastUpdated'],
        );

        loadedCollaborators.add(newCollaborator);
      }

      return loadedCollaborators;
    } catch (error) {
      print(error);
      throw (error);
    }
  }

  Future<List<Location>> synchronizeLocations(List<Location> locationList) async {
    final finalUrl = this._serverUrl + "synchronize/synchronizeLocations/${this.userMail}";

    try {
      final response = await http.post(
        finalUrl,
        body: json.encode(
          {
            'locationList': locationList,
          },
        ),
        headers: {
          'content-type': 'application/json',
          'accept': 'application/json',
        },
      );
      final responseBody = json.decode(utf8.decode(response.bodyBytes));

      List<Location> loadedLocations = [];

      for (final element in responseBody) {
        Location newLocation = Location(
          id: element['id'],
          localizationName: element["localizationName"],
          longitude: element["longitude"],
          latitude: element["latitude"],
          country: element["country"],
          locality: element["locality"],
          street: element["street"],
          lastUpdated: element["lastUpdated"],
        );

        loadedLocations.add(newLocation);
      }

      return loadedLocations;
    } catch (error) {
      print(error);
      throw (error);
    }
  }

  Future<List<Tag>> synchronizeTags(List<Tag> tagList) async {
    final finalUrl = this._serverUrl + "synchronize/synchronizeTags/${this.userMail}";

    try {
      final response = await http.post(
        finalUrl,
        body: json.encode(
          {
            'tagList': tagList,
          },
        ),
        headers: {
          'content-type': 'application/json',
          'accept': 'application/json',
        },
      );

      final responseBody = json.decode(utf8.decode(response.bodyBytes));

      List<Tag> loadedTags = [];

      for (final element in responseBody) {
        Tag newTag = Tag(
          id: element['id'],
          name: element['name'],
        );

        loadedTags.add(newTag);
      }

      return loadedTags;
    } catch (error) {
      print(error);
      throw (error);
    }
  }
}
