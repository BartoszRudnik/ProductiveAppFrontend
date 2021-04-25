import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:global_configuration/global_configuration.dart';
import 'package:http/http.dart' as http;
import 'package:productive_app/task_page/models/collaborator.dart';

class DelegateProvider with ChangeNotifier {
  List<Collaborator> collaborators = [
    Collaborator(
      email: 'jan@kowalski.com',
      isSelected: false,
    ),
    Collaborator(
      email: 'stefan@batory.com',
      isSelected: false,
    ),
  ];
  final userToken;
  final userEmail;

  String _serverUrl = GlobalConfiguration().getValue("serverUrl");

  DelegateProvider({
    //@required this.collaborators,
    @required this.userEmail,
    @required this.userToken,
  });

  List<Collaborator> get collaboratorsList {
    return [...this.collaborators];
  }

  Future<void> getCollaborators() async {
    final requestUrl = this._serverUrl + 'delegate/getCollaborators';

    List<Collaborator> loadedCollaborators;

    try {
      final response = await http.get(requestUrl);

      final responseBody = json.decode(utf8.decode(response.bodyBytes));

      for (var element in responseBody) {
        loadedCollaborators.add(element);
      }

      this.collaborators = loadedCollaborators;
      notifyListeners();
    } catch (error) {
      print(error);
      throw (error);
    }
  }

  Future<void> addCollaborator(String collaboratorEmail) async {
    final requestUrl = this._serverUrl + '/delegate/addCollaborator';
  }
}
