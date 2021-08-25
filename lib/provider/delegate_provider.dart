import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:global_configuration/global_configuration.dart';
import 'package:http/http.dart' as http;
import 'package:productive_app/model/collaborator.dart';
import 'package:productive_app/model/collaboratorTask.dart';

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

  int get numberOfPermissionRequest {
    return this.accepted.where((collaborator) => collaborator.isAskingForPermission && !collaborator.sentPermission).length;
  }

  Future<void> askForPermission(String collaboratorEmail) async {
    final requestUrl = this._serverUrl + 'delegate/askForPermission/${this.userEmail}/$collaboratorEmail';

    try {
      await http.post(
        requestUrl,
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

  Future<void> acceptAskForPermission(String collaboratorEmail) async {
    final requestUrl = this._serverUrl + 'delegate/acceptAskForPermission/${this.userEmail}/$collaboratorEmail';

    try {
      await http.post(
        requestUrl,
        headers: {
          'content-type': 'application/json',
          'accept': 'application/json',
        },
      );

      notifyListeners();
    } catch (error) {
      print(error);
      throw (error);
    }
  }

  Future<void> declineAskForPermission(String collaboratorEmail) async {
    final requestUrl = this._serverUrl + 'delegate/declineAskForPermission/${this.userEmail}/$collaboratorEmail';

    try {
      await http.post(
        requestUrl,
        headers: {
          'content-type': 'application/json',
          'accept': 'application/json',
        },
      );

      this.collaborators.firstWhere((element) => element.email == collaboratorEmail).isAskingForPermission = false;

      notifyListeners();
    } catch (error) {
      print(error);
      throw (error);
    }
  }

  Future<void> changePermission(String collaboratorEmail) async {
    final requestUrl = this._serverUrl + 'delegate/changePermission/${this.userEmail}/$collaboratorEmail';

    try {
      await http.post(
        requestUrl,
        headers: {
          'content-type': 'application/json',
          'accept': 'application/json',
        },
      );

      this.collaborators.firstWhere((collaborator) => collaborator.email == collaboratorEmail).sentPermission = !this.collaborators.firstWhere((collaborator) => collaborator.email == collaboratorEmail).sentPermission;

      notifyListeners();
    } catch (error) {
      print(error);
      throw error;
    }
  }

  Future<int> getNumberOfCollaboratorActiveTasks(String collaboratorEmail) async {
    final requestUrl = this._serverUrl + 'delegate/getNumberOfCollaboratorActiveTasks/${this.userEmail}/$collaboratorEmail';

    try {
      final response = await http.get(requestUrl);
      final responseBody = response.body;

      if (responseBody != null) {
        return int.parse(responseBody);
      } else {
        return 0;
      }
    } catch (error) {
      print(error);
      throw (error);
    }
  }

  Future<int> getNumberOfCollaboratorFinishedTasks(String collaboratorEmail) async {
    final requestUrl = this._serverUrl + 'delegate/getNumberOfCollaboratorFinishedTasks/${this.userEmail}/$collaboratorEmail';

    try {
      final response = await http.get(requestUrl);

      final responseBody = response.body;

      if (responseBody != null) {
        return int.parse(responseBody);
      } else {
        return 0;
      }
    } catch (error) {
      print(error);
      throw (error);
    }
  }

  Future<List<CollaboratorTask>> getCollaboratorActiveTasks(String collaboratorEmail, int page, int size) async {
    final requestUrl = this._serverUrl + 'delegate/getCollaboratorActiveTasks/${this.userEmail}/$collaboratorEmail/$page/$size';

    List<CollaboratorTask> loadedTasks = [];

    try {
      final response = await http.get(requestUrl);
      final responseBody = json.decode(utf8.decode(response.bodyBytes));

      for (var element in responseBody) {
        CollaboratorTask collaboratorTask = CollaboratorTask(
          id: element['id'],
          title: element['taskName'],
          description: element['description'],
          startDate: DateTime.parse(element['startDate']),
          endDate: DateTime.parse(element['endDate']),
          lastUpdated: DateTime.parse(element['lastUpdated']),
        );

        loadedTasks.add(collaboratorTask);
      }

      return loadedTasks;
    } catch (error) {
      print(error);
      throw (error);
    }
  }

  Future<List<CollaboratorTask>> getCollaboratorRecentlyFinishedTasks(String collaboratorEmail, int page, int size) async {
    final requestUrl = this._serverUrl + 'delegate/getCollaboratorRecentlyFinished/${this.userEmail}/$collaboratorEmail/$page/$size';

    List<CollaboratorTask> loadedTasks = [];

    try {
      final response = await http.get(requestUrl);

      final responseBody = json.decode(utf8.decode(response.bodyBytes));

      for (var element in responseBody) {
        CollaboratorTask collaboratorTask = CollaboratorTask(
          id: element['id'],
          title: element['taskName'],
          description: element['description'],
          startDate: DateTime.parse(element['startDate']),
          endDate: DateTime.parse(element['endDate']),
          lastUpdated: DateTime.parse(element['lastUpdated']),
        );

        loadedTasks.add(collaboratorTask);
      }

      return loadedTasks;
    } catch (error) {
      print(error);
      throw (error);
    }
  }

  Future<void> getCollaborators() async {
    final requestUrl = this._serverUrl + 'delegate/getAllCollaborators/${this.userEmail}';

    List<Collaborator> loadedCollaborators = [];

    try {
      final response = await http.get(requestUrl);

      final responseBody = json.decode(utf8.decode(response.bodyBytes));

      for (var element in responseBody) {
        bool isAskingForPermission = false;
        bool alreadyAsked = false;
        bool receivedPermission = false;
        bool sentPermission = false;
        bool isReceived = false;
        String collaboratorEmail = '';
        String collaboratorName = '';

        if (element['invitationSender'] == this.userEmail) {
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
      await http.delete(
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
      await http.put(
        requestUrl,
        headers: {
          'content-type': 'application/json',
          'accept': 'application/json',
        },
      );

      Collaborator collaborator = this._received.firstWhere((collaborator) => collaborator.id == id);
      collaborator.relationState = "ACCEPTED";

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
      await http.put(
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

  bool checkIfCollaboratorAlreadyExist(String collaboratorMail) {
    for (Collaborator element in this.collaborators) {
      if (element.email == collaboratorMail) {
        return true;
      }
    }

    return false;
  }

  Future<void> addCollaborator(String newCollaborator) async {
    final requestUrl = this._serverUrl + 'delegate/addCollaborator';

    try {
      if (this.userEmail == newCollaborator) {
        throw Exception("You cannot invite yourself");
      }

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
