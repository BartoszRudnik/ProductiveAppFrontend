import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:global_configuration/global_configuration.dart';
import 'package:http/http.dart' as http;
import 'package:productive_app/db/collaborator_database.dart';
import 'package:productive_app/model/collaborator.dart';
import 'package:productive_app/model/collaboratorTask.dart';
import 'package:productive_app/provider/task_provider.dart';
import 'package:productive_app/utils/internet_connection.dart';
import 'package:productive_app/utils/notifications.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class DelegateProvider with ChangeNotifier {
  List<Collaborator> collaborators = [];

  List<Collaborator> _accepted = [];
  List<Collaborator> _received = [];
  List<Collaborator> _send = [];

  String searchingText;

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

  http.Client _client;
  http.Client _collaboratorClient;

  Future<void> sendSSE(String relationUUID, String collaboratorEmail) async {
    if (relationUUID != null && relationUUID.length > 1) {
      final notifyUrl = this._serverUrl + "delegatedTaskSSE/publishCollaborator/$collaboratorEmail";

      try {
        await http.post(
          notifyUrl,
          body: json.encode(
            {
              'relationUuid': relationUUID,
            },
          ),
          headers: {
            'content-type': 'application/json',
            'accept': 'application/json',
          },
        );
      } catch (error) {
        print(error);
      }
    }
  }

  Future<void> _deleteFromLocalList(String uuid) async {
    try {
      await CollaboratorDatabase.deleteByUuid(uuid);
      this.collaborators.removeWhere((element) => element.uuid == uuid);

      this.divideCollaborators(this.collaborators);

      notifyListeners();
    } catch (error) {
      print(error);
    }
  }

  void subscribeCollaborators(BuildContext context) async {
    try {
      this._collaboratorClient = http.Client();

      final request = http.Request("GET", Uri.parse(this._serverUrl + "delegatedTaskSSE/subscribeCollaborators/${this.userEmail}"));

      Future<http.StreamedResponse> response = this._collaboratorClient.send(request);

      response.asStream().listen(
        (streamedResponse) {
          streamedResponse.stream.listen(
            (data) async {
              final stringValue = utf8.decode(data);

              if (stringValue.contains('event')) {
                final message = stringValue.split(":");
                String uuid = message[2].trim();

                uuid = uuid.split("\n")[0];

                final result = await this.getSingleCollaborator(uuid);

                if (result != null) {
                  if (result[0] == 'delete') {
                    await this._deleteFromLocalList(uuid);
                  } else {
                    final Collaborator collaborator = result[0];
                    final bool existing = result[1];

                    if (collaborator != null) {
                      if (existing) {
                        await Notifications.acceptedInvitation(collaborator.id, context, collaborator.email);
                      } else {
                        await Notifications.receivedInvitation(collaborator.id, context, collaborator.email);
                      }
                    }
                  }
                }
              }
            },
          );
        },
      );
    } catch (error) {
      print(error);
    }
  }

  void subscribe(BuildContext context) async {
    try {
      this._client = http.Client();

      final request = http.Request("GET", Uri.parse(this._serverUrl + "delegatedTaskSSE/subscribe/${this.userEmail}"));

      Future<http.StreamedResponse> response = this._client.send(request);

      response.asStream().listen((streamedResponse) {
        streamedResponse.stream.listen((data) async {
          final stringValue = utf8.decode(data);

          if (stringValue.contains('event')) {
            final message = stringValue.split(":");
            String uuid = message[2].trim();

            uuid = uuid.split("\n")[0];

            final task = await Provider.of<TaskProvider>(context, listen: false).fetchSingleTaskFull(uuid, context);

            if (task != null) {
              await Notifications.newDelegatedTaskNotification(task, AppLocalizations.of(context).newTask);
            }
          }
        });
      });
    } catch (error) {
      print(error);
    }
  }

  void setCollaborators(List<Collaborator> newList) {
    this.collaborators = newList;

    this.divideCollaborators(this.collaborators);

    notifyListeners();
  }

  List<Collaborator> get collaboratorsList {
    return [...this.collaborators];
  }

  List<Collaborator> get accepted {
    if (this.searchingText != null && this.searchingText.length >= 1) {
      return this
          ._accepted
          .where((collaborator) => collaborator.email.contains(searchingText) || collaborator.collaboratorName.contains(searchingText))
          .toList();
    } else {
      return [...this._accepted];
    }
  }

  List<Collaborator> get received {
    if (this.searchingText != null && this.searchingText.length >= 1) {
      return this
          ._received
          .where((collaborator) => collaborator.email.contains(searchingText) || collaborator.collaboratorName.contains(searchingText))
          .toList();
    } else {
      return [...this._received];
    }
  }

  List<Collaborator> get send {
    if (this.searchingText != null && this.searchingText.length >= 1) {
      return this._send.where((collaborator) => collaborator.email.contains(searchingText) || collaborator.collaboratorName.contains(searchingText)).toList();
    } else {
      return [...this._send];
    }
  }

  void setSearchingText(String text) {
    this.searchingText = text;

    notifyListeners();
  }

  void clearSearchingText() {
    this.searchingText = '';

    notifyListeners();
  }

  int get numberOfPermissionRequest {
    return this.accepted.where((collaborator) => collaborator.isAskingForPermission && !collaborator.sentPermission).length;
  }

  Future<void> askForPermission(String collaboratorEmail) async {
    if (await InternetConnection.internetConnection()) {
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
  }

  Future<void> acceptAskForPermission(String collaboratorEmail) async {
    if (await InternetConnection.internetConnection()) {
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
  }

  Future<void> declineAskForPermission(String collaboratorEmail) async {
    if (await InternetConnection.internetConnection()) {
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
    } else {
      Collaborator collaborator = this.collaborators.firstWhere((element) => element.email == collaboratorEmail);
      collaborator.isAskingForPermission = false;

      await CollaboratorDatabase.update(collaborator);

      notifyListeners();
    }
  }

  Future<void> changePermission(String collaboratorEmail) async {
    if (await InternetConnection.internetConnection()) {
      final requestUrl = this._serverUrl + 'delegate/changePermission/${this.userEmail}/$collaboratorEmail';

      try {
        await http.post(
          requestUrl,
          headers: {
            'content-type': 'application/json',
            'accept': 'application/json',
          },
        );

        this.collaborators.firstWhere((collaborator) => collaborator.email == collaboratorEmail).sentPermission =
            !this.collaborators.firstWhere((collaborator) => collaborator.email == collaboratorEmail).sentPermission;

        notifyListeners();
      } catch (error) {
        print(error);
        throw error;
      }
    } else {
      Collaborator collaborator = this.collaborators.firstWhere((collaborator) => collaborator.email == collaboratorEmail);
      collaborator.sentPermission = !collaborator.sentPermission;

      await CollaboratorDatabase.update(collaborator);

      notifyListeners();
    }
  }

  Future<int> getNumberOfCollaboratorActiveTasks(String collaboratorEmail) async {
    if (await InternetConnection.internetConnection()) {
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
  }

  Future<int> getNumberOfCollaboratorFinishedTasks(String collaboratorEmail) async {
    if (await InternetConnection.internetConnection()) {
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
  }

  Future<List<CollaboratorTask>> getCollaboratorActiveTasks(String collaboratorEmail, int page, int size) async {
    if (await InternetConnection.internetConnection()) {
      final requestUrl = this._serverUrl + 'delegate/getCollaboratorActiveTasks/${this.userEmail}/$collaboratorEmail/$page/$size';

      List<CollaboratorTask> loadedTasks = [];

      try {
        final response = await http.get(requestUrl);
        final responseBody = json.decode(utf8.decode(response.bodyBytes));

        for (var element in responseBody) {
          CollaboratorTask collaboratorTask = CollaboratorTask(
            uuid: element['uuid'],
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
  }

  Future<List<CollaboratorTask>> getCollaboratorRecentlyFinishedTasks(String collaboratorEmail, int page, int size) async {
    if (await InternetConnection.internetConnection()) {
      final requestUrl = this._serverUrl + 'delegate/getCollaboratorRecentlyFinished/${this.userEmail}/$collaboratorEmail/$page/$size';

      List<CollaboratorTask> loadedTasks = [];

      try {
        final response = await http.get(requestUrl);

        final responseBody = json.decode(utf8.decode(response.bodyBytes));

        for (var element in responseBody) {
          CollaboratorTask collaboratorTask = CollaboratorTask(
            uuid: element['uuid'],
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
  }

  void notify() {
    notifyListeners();
  }

  Future<void> getCollaboratorsOffline() async {
    try {
      this.collaborators = await CollaboratorDatabase.readAll(this.userEmail);

      this.divideCollaborators(this.collaborators);
    } catch (error) {
      print(error);
      throw (error);
    }
  }

  Future<List<Object>> getSingleCollaborator(String relationUuid) async {
    if (await InternetConnection.internetConnection()) {
      final requestUrl = this._serverUrl + "delegate/getSingleCollaborator/$relationUuid";

      try {
        final response = await http.get(requestUrl);

        if (response.body == null || response.body.length <= 1) {
          return ['delete', ''];
        }

        final responseBody = json.decode(utf8.decode(response.bodyBytes));

        bool isAskingForPermission = false;
        bool alreadyAsked = false;
        bool receivedPermission = false;
        bool sentPermission = false;
        bool isReceived = false;
        String collaboratorEmail = '';
        String collaboratorName = '';

        if (responseBody['invitationSender'] == this.userEmail) {
          collaboratorEmail = responseBody['invitationReceiver'];
          collaboratorName = responseBody['invitationReceiverName'];
          sentPermission = responseBody['user2Permission'];
          receivedPermission = responseBody['user1Permission'];
          isAskingForPermission = responseBody['user2AskForPermission'];
          alreadyAsked = responseBody['user1AskForPermission'];
        } else {
          isReceived = true;
          collaboratorEmail = responseBody['invitationSender'];
          collaboratorName = responseBody['invitationSenderName'];
          sentPermission = responseBody['user1Permission'];
          receivedPermission = responseBody['user2Permission'];
          isAskingForPermission = responseBody['user1AskForPermission'];
          alreadyAsked = responseBody['user2AskForPermission'];
        }

        Collaborator newCollaborator = Collaborator(
          uuid: responseBody['uuid'],
          id: responseBody['id'],
          email: collaboratorEmail,
          collaboratorName: collaboratorName,
          relationState: responseBody['relationState'],
          isSelected: false,
          received: isReceived,
          sentPermission: sentPermission,
          receivedPermission: receivedPermission,
          alreadyAsked: alreadyAsked,
          isAskingForPermission: isAskingForPermission,
        );

        final existing = null != this.collaborators.firstWhere((element) => element.uuid == newCollaborator.uuid, orElse: () => null);

        if (existing) {
          Collaborator existingCollaborator = this.collaborators.firstWhere((element) => element.uuid == newCollaborator.uuid);

          await CollaboratorDatabase.deleteByUuid(existingCollaborator.uuid);
          newCollaborator = await CollaboratorDatabase.create(newCollaborator, this.userEmail);

          this.collaborators.remove(existingCollaborator);
          this.collaborators.add(newCollaborator);
        } else {
          newCollaborator = await CollaboratorDatabase.create(newCollaborator, this.userEmail);
          this.collaborators.add(newCollaborator);
        }

        this.divideCollaborators(this.collaborators);

        notifyListeners();

        return [newCollaborator, existing];
      } catch (error) {
        print(error);
      }
    } else {
      return null;
    }
  }

  Future<void> getCollaborators() async {
    final requestUrl = this._serverUrl + 'delegate/getAllCollaborators/${this.userEmail}';

    List<Collaborator> loadedCollaborators = [];

    await CollaboratorDatabase.deleteAll(this.userEmail);

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
          uuid: element['uuid'],
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

        newCollaborator = await CollaboratorDatabase.create(newCollaborator, this.userEmail);
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

  Future<void> deleteCollaborator(String uuid) async {
    final requestUrl = this._serverUrl + 'delegate/deleteCollaborator/$uuid';

    Collaborator collaborator = this.collaborators.firstWhere((element) => element.uuid == uuid);

    if (collaborator.relationState == 'WAITING') {
      this._send.remove(collaborator);
    } else {
      this._accepted.remove(collaborator);
    }

    this.collaborators.remove(collaborator);
    await CollaboratorDatabase.deleteByUuid(uuid);

    if (await InternetConnection.internetConnection()) {
      try {
        await http.delete(
          requestUrl,
          headers: {
            'content-type': 'application/json',
            'accept': 'application/json',
          },
        );

        await this.sendSSE(uuid, collaborator.email);
      } catch (error) {
        print(error);
        throw (error);
      }
    }

    notifyListeners();
  }

  Future<void> acceptInvitation(String uuid) async {
    final requestUrl = this._serverUrl + 'delegate/acceptInvitation/$uuid';

    Collaborator collaborator = this._received.firstWhere((collaborator) => collaborator.uuid == uuid);
    collaborator.relationState = "ACCEPTED";

    this._received.remove(collaborator);
    this._accepted.add(collaborator);

    await CollaboratorDatabase.update(collaborator);

    if (await InternetConnection.internetConnection()) {
      try {
        await http.put(
          requestUrl,
          headers: {
            'content-type': 'application/json',
            'accept': 'application/json',
          },
        );

        await this.sendSSE(uuid, collaborator.email);
      } catch (error) {
        print(error);
        throw (error);
      }
    }

    notifyListeners();
  }

  Future<void> declineInvitation(String uuid) async {
    final requestUrl = this._serverUrl + 'delegate/declineInvitation/$uuid';

    final collaboratorEmail = this._received.firstWhere((element) => element.uuid == uuid).email;

    this.collaborators.removeWhere((collaborator) => collaborator.uuid == uuid);
    this._received.removeWhere((collaborator) => collaborator.uuid == uuid);
    await CollaboratorDatabase.deleteByUuid(uuid);

    if (await InternetConnection.internetConnection()) {
      try {
        await http.put(
          requestUrl,
          headers: {
            'content-type': 'application/json',
            'accept': 'application/json',
          },
        );

        await this.sendSSE(uuid, collaboratorEmail);
      } catch (error) {
        print(error);
        throw (error);
      }
    }

    notifyListeners();
  }

  bool checkIfCollaboratorAlreadyExist(String collaboratorMail) {
    for (Collaborator element in this.collaborators) {
      if (element.email == collaboratorMail) {
        return true;
      }
    }

    return false;
  }

  Future<Collaborator> addCollaborator(String newCollaborator) async {
    if (await InternetConnection.internetConnection()) {
      final requestUrl = this._serverUrl + 'delegate/addCollaborator';

      try {
        if (this.userEmail == newCollaborator) {
          throw Exception("You cannot invite yourself");
        }

        final uuid = Uuid();

        final uuidCode = uuid.v1();

        final response = await http.post(
          requestUrl,
          body: json.encode(
            {
              'userEmail': this.userEmail,
              'collaboratorEmail': newCollaborator,
              'uuid': uuidCode,
            },
          ),
          headers: {
            'content-type': 'application/json',
            'accept': 'application/json',
          },
        );

        Collaborator collaborator = Collaborator(
          uuid: uuidCode,
          id: int.parse(response.body),
          email: newCollaborator,
          relationState: 'WAITING',
          isSelected: false,
          received: false,
          collaboratorName: '',
        );

        collaborator = await CollaboratorDatabase.create(collaborator, this.userEmail);

        this.collaborators.insert(0, collaborator);
        this._send.insert(0, collaborator);

        await this.sendSSE(uuidCode, newCollaborator);

        notifyListeners();

        return collaborator;
      } catch (error) {
        print(error);
        throw (error);
      }
    } else {
      return null;
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
