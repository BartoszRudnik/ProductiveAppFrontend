import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:global_configuration/global_configuration.dart';
import 'package:http/http.dart' as http;
import 'package:productive_app/task_page/models/collaborator.dart';

class DelegateProvider with ChangeNotifier {
  List<Collaborator> collaborators = [];

  List<Collaborator> _accepted = [];
  List<Collaborator> _received = [];
  List<Collaborator> _send = [];

  final userToken;
  final userEmail;

  String _serverUrl = GlobalConfiguration().getValue("serverUrl");

  DelegateProvider({
    @required this.collaborators,
    @required this.userEmail,
    @required this.userToken,
  }) {
    this.divideCollaborators(this.collaborators);
  }

  List<Collaborator> get collaboratorsList {
    return [...this.collaborators];
  }

  List<Collaborator> get accepted {
    return [...this._accepted];
  }

  List<Collaborator> get received {
    return [...this._received];
  }

  List<Collaborator> get send {
    return [...this._send];
  }

  Future<void> getCollaborators() async {
    final requestUrl = this._serverUrl + 'delegate/getAllCollaborators/${this.userEmail}';

    List<Collaborator> loadedCollaborators = [];

    try {
      final response = await http.get(requestUrl);

      final responseBody = json.decode(utf8.decode(response.bodyBytes));

      for (var element in responseBody) {
        bool isReceived = false;
        String collaboratorEmail = '';

        if (element['invitationSender'] == this.userEmail) {
          collaboratorEmail = element['invitationReceiver'];
        } else {
          isReceived = true;
          collaboratorEmail = element['invitationSender'];
        }

        Collaborator newCollaborator = Collaborator(
          id: element['id'],
          email: collaboratorEmail,
          relationState: element['relationState'],
          isSelected: false,
          received: isReceived,
        );

        loadedCollaborators.add(newCollaborator);
      }

      this.collaborators = loadedCollaborators;

      this.divideCollaborators(this.collaborators);

      notifyListeners();
    } catch (error) {
      print(error);
      throw (error);
    }
  }

  Future<void> deleteCollaborator(int id) async {
    final requestUrl = this._serverUrl + 'delegate/deleteCollaborator/$id';

    try {
      final response = await http.delete(
        requestUrl,
        headers: {
          'content-type': 'application/json',
          'accept': 'application/json',
        },
      );

      Collaborator collaborator = this.collaborators.firstWhere((element) => element.id == id);

      if (collaborator.relationState == 'WAITING') {
        this._send.remove(collaborator);
      } else {
        this._accepted.remove(collaborator);
      }

      this.collaborators.remove(collaborator);

      notifyListeners();
    } catch (error) {
      print(error);
      throw (error);
    }
  }

  Future<void> acceptInvitation(int id) async {
    final requestUrl = this._serverUrl + 'delegate/acceptInvitation/$id';

    try {
      final response = await http.put(
        requestUrl,
        headers: {
          'content-type': 'application/json',
          'accept': 'application/json',
        },
      );

      Collaborator collaborator = this._received.firstWhere((collaborator) => collaborator.id == id);

      this._received.remove(collaborator);
      this._accepted.add(collaborator);

      notifyListeners();
    } catch (error) {
      print(error);
      throw (error);
    }
  }

  Future<void> declineInvitation(int id) async {
    final requestUrl = this._serverUrl + 'delegate/declineInvitation/$id';

    try {
      final response = await http.put(
        requestUrl,
        headers: {
          'content-type': 'application/json',
          'accept': 'application/json',
        },
      );

      this._received.removeWhere((collaborator) => collaborator.id == id);

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

      Collaborator collaborator = Collaborator(
        id: int.parse(response.body),
        email: newCollaborator,
        relationState: 'WAITING',
        isSelected: false,
        received: false,
      );

      this.collaborators.insert(0, collaborator);
      this._send.insert(0, collaborator);

      notifyListeners();
    } catch (error) {
      print(error);
      throw (error);
    }
  }

  void divideCollaborators(List<Collaborator> collaborators) {
    this._accepted = [];
    this._received = [];
    this._send = [];

    collaborators.forEach((collaborator) {
      if (collaborator.relationState == 'ACCEPTED') {
        this._accepted.add(collaborator);
      } else if (collaborator.relationState == 'WAITING' && collaborator.received) {
        this._received.add(collaborator);
      } else if (collaborator.relationState == 'WAITING' && !collaborator.received) {
        this._send.add(collaborator);
      }
    });
  }
}