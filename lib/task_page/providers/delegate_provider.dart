import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:global_configuration/global_configuration.dart';
import 'package:http/http.dart' as http;
import 'package:productive_app/task_page/models/collaborator.dart';

class DelegateProvider with ChangeNotifier {
  List<Collaborator> collaborators = [];
  final userToken;
  final userEmail;

  String _serverUrl = GlobalConfiguration().getValue("serverUrl");

  DelegateProvider({
    @required this.collaborators,
    @required this.userEmail,
    @required this.userToken,
  });

  List<Collaborator> get collaboratorsList {
    return [...this.collaborators];
  }

  Future<void> getCollaborators() async {
    final requestUrl = this._serverUrl + 'delegate/getAllCollaborators/${this.userEmail}';

    List<Collaborator> loadedCollaborators = [];

    try {
      final response = await http.get(requestUrl);

      final responseBody = json.decode(utf8.decode(response.bodyBytes));

      for (var element in responseBody) {
        Collaborator newCollaborator = Collaborator(
          email: element['collaboratorEmail'],
          relationState: element['relationState'],
          isSelected: false,
        );

        loadedCollaborators.add(newCollaborator);
      }

      this.collaborators = loadedCollaborators;
      notifyListeners();
    } catch (error) {
      print(error);
      throw (error);
    }
  }

  Future<void> deleteCollaborator(String collaborator) async {
    final requestUrl = this._serverUrl + 'delegate/deleteCollaborator';

    try {
      final response = await http.post(
        requestUrl,
        body: json.encode(
          {
            'userEmail': this.userEmail,
            'collaboratorEmail': collaborator,
          },
        ),
        headers: {
          'content-type': 'application/json',
          'accept': 'application/json',
        },
      );

      this.collaborators.removeWhere((element) => element.email == collaborator);

      notifyListeners();
    } catch (error) {
      print(error);
      throw (error);
    }
  }

  Future<void> addCollaborator(String newCollaborator) async {
    final requestUrl = this._serverUrl + 'delegate/addCollaborator';

    try {
      final response = await http.post(
        requestUrl,
        body: json.encode(
          {
            'userEmail': this.userEmail,
            'collaboratorEmail': newCollaborator,
          },
        ),
        headers: {
          'content-type': 'application/json',
          'accept': 'application/json',
        },
      );

      print(response.body);

      if (response.body == null || response.body == '') {
        this.collaborators.insert(
              0,
              Collaborator(email: newCollaborator, relationState: 'WAITING', isSelected: false),
            );
      }

      notifyListeners();
    } catch (error) {
      print(error);
      throw (error);
    }
  }
}
