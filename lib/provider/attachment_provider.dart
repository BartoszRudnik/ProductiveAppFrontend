import 'dart:convert';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:global_configuration/global_configuration.dart';
import 'package:http/http.dart' as http;
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:productive_app/model/attachment.dart';
import 'package:productive_app/utils/internet_connection.dart';

class AttachmentProvider with ChangeNotifier {
  List<Attachment> attachments;
  List<Attachment> delegatedAttachments;
  List<Attachment> notSavedAttachments = [];
  String userMail;
  String authToken;

  String _serverUrl = GlobalConfiguration().getValue("serverUrl");

  AttachmentProvider({
    @required this.attachments,
    @required this.delegatedAttachments,
    @required this.userMail,
    @required this.authToken,
  });

  Future<void> deleteFlaggedAttachments() async {
    this.attachments.where((element) => element.toDelete).toList().forEach((element) {
      this._deleteAttachment(element.id);
      this.attachments.remove(element);
    });

    this.notSavedAttachments = [];

    notifyListeners();
  }

  Future<void> deleteNotSavedAttachments() async {
    this.notSavedAttachments.forEach((attachment) {
      this._deleteAttachment(attachment.id);
      this.attachments.remove(attachment);
    });

    this.notSavedAttachments = [];

    notifyListeners();
  }

  void prepare() {
    this.attachments.where((element) => element.toDelete).toList().forEach(
      (element) {
        element.toDelete = false;
      },
    );
  }

  void setToDelete(int attachmentId) {
    this.attachments.firstWhere((attachment) => attachment.id == attachmentId).toDelete = true;

    notifyListeners();
  }

  List<Attachment> taskAttachments(int taskId) {
    return this.attachments.where((attachment) => attachment.taskId == taskId && !attachment.toDelete).toList();
  }

  Future<void> getDelegatedAttachments(List<int> delegatedTasksId) async {
    if (await InternetConnection.internetConnection()) {
      final finalUrl = this._serverUrl + 'attachment/getDelegatedAttachments';

      List<Attachment> loadedAttachments = [];
      try {
        final response = await http.post(
          finalUrl,
          body: json.encode({
            "tasksId": delegatedTasksId,
          }),
          headers: {
            'content-type': 'application/json',
            'accept': 'application/json',
          },
        );

        final responseBody = json.decode(response.body);

        for (var element in responseBody) {
          final newAttachment = Attachment(
            fileName: element['fileName'],
            id: element['id'],
            taskId: element['taskId'],
          );

          loadedAttachments.add(newAttachment);
        }

        if (loadedAttachments.length > 0) {
          this.delegatedAttachments = loadedAttachments;
        }

        notifyListeners();
      } catch (error) {
        print(error);
        throw (error);
      }
    }
  }

  Future<void> getAttachments() async {
    if (await InternetConnection.internetConnection()) {
      final finalUrl = this._serverUrl + 'attachment/getUserAttachments/${this.userMail}';

      List<Attachment> loadedAttachments = [];

      try {
        final response = await http.get(finalUrl);

        final responseBody = json.decode(response.body);

        for (var element in responseBody) {
          final newAttachment = Attachment(
            fileName: element['fileName'],
            id: element['id'],
            taskId: element['taskId'],
          );

          loadedAttachments.add(newAttachment);
        }

        if (loadedAttachments.length > 0) {
          this.attachments = loadedAttachments;
        }

        notifyListeners();
      } catch (error) {
        print(error);
        throw (error);
      }
    }
  }

  Future<void> _deleteAttachment(int attachmentId) async {
    if (await InternetConnection.internetConnection()) {
      final finalUrl = this._serverUrl + 'attachment/deleteAttachment/$attachmentId';

      try {
        http.delete(
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

  Future<void> setAttachments(List<File> attachments, int taskId, bool editMode) async {
    if (await InternetConnection.internetConnection()) {
      try {
        attachments.forEach((attachment) async {
          final fileName = basename(attachment.path);
          final finalUrl = this._serverUrl + 'attachment/addAttachment/${this.userMail}/$taskId/$fileName';
          final uri = Uri.parse(finalUrl);

          final request = http.MultipartRequest('POST', uri);
          final multipartFile = await http.MultipartFile.fromPath('multipartFile', attachment.path, filename: attachment.path);

          request.files.add(multipartFile);

          final response = await request.send();
          final respStr = await response.stream.bytesToString();

          final newAttachment = Attachment(
            id: int.parse(respStr),
            taskId: taskId,
            fileName: basename(attachment.path),
          );

          this.attachments.add(newAttachment);

          if (editMode) {
            this.notSavedAttachments.add(newAttachment);
          }

          notifyListeners();
        });
      } catch (error) {
        print(error);
        throw (error);
      }
    }
  }

  Future<File> loadAttachments(int attachmentId) async {
    if (await InternetConnection.internetConnection()) {
      final finalUrl = this._serverUrl + 'attachment/getAttachment/$attachmentId';

      try {
        final response = await http.get(finalUrl);

        final bytes = response.bodyBytes;

        return this._storeFile(finalUrl, bytes, attachmentId);
      } catch (error) {
        print(error);
        throw (error);
      }
    }
  }

  Future<File> _storeFile(String url, List<int> bytes, int attachmentId) async {
    final allAttachments = this.attachments + this.delegatedAttachments;

    String fileName = allAttachments.firstWhere((element) => element.id == attachmentId).fileName;

    final dir = await getApplicationDocumentsDirectory();

    final file = File('${dir.path}/$fileName');

    await file.writeAsBytes(bytes, flush: true);

    return file;
  }
}
