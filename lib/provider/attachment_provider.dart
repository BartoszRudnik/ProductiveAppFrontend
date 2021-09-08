import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/cupertino.dart';
import 'package:global_configuration/global_configuration.dart';
import 'package:http/http.dart' as http;
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:productive_app/db/attachment_database.dart';
import 'package:productive_app/model/attachment.dart';
import 'package:productive_app/utils/internet_connection.dart';
import 'package:uuid/uuid.dart';

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
            uuid: element['uuid'],
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

      try {
        final response = await http.get(finalUrl);

        final responseBody = json.decode(response.body);

        for (var element in responseBody) {
          Attachment newAttachment = Attachment(
            uuid: element['uuid'],
            fileName: element['fileName'],
            id: element['id'],
            taskId: element['taskId'],
          );

          if (!await AttachmentDatabase.checkIfExists(newAttachment.id, newAttachment.fileName, newAttachment.taskId)) {
            final file = await this.getFileBytes(newAttachment.uuid);

            if (file != null) {
              newAttachment.localFile = file;
            }

            newAttachment = await AttachmentDatabase.create(newAttachment, this.userMail);
          }
        }

        this.attachments = await AttachmentDatabase.readAll(this.userMail);

        notifyListeners();
      } catch (error) {
        print(error);
        throw (error);
      }
    }
  }

  Future<void> _deleteAttachment(int attachmentId) async {
    await AttachmentDatabase.delete(attachmentId);

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
    attachments.forEach(
      (attachment) async {
        final attachmentBytes = await attachment.readAsBytes();
        final uuid = Uuid();

        Attachment newAttachment = Attachment(
          uuid: uuid.v1(),
          taskId: taskId,
          fileName: basename(attachment.path),
          localFile: attachmentBytes,
        );

        newAttachment = await AttachmentDatabase.create(newAttachment, this.userMail);

        this.attachments.add(newAttachment);

        if (editMode) {
          this.notSavedAttachments.add(newAttachment);
        }

        notifyListeners();

        if (await InternetConnection.internetConnection()) {
          try {
            final fileName = basename(attachment.path);
            final uri = Uri.parse(this._serverUrl + 'attachment/addAttachment/${this.userMail}/$taskId/$fileName/${newAttachment.uuid}');

            final request = http.MultipartRequest('POST', uri);
            final multipartFile = await http.MultipartFile.fromPath('multipartFile', attachment.path, filename: attachment.path);

            request.files.add(multipartFile);

            final response = await request.send();
            final respStr = await response.stream.bytesToString();

            if (newAttachment.id != int.parse(respStr)) {
              await AttachmentDatabase.updateId(newAttachment.id, int.parse(respStr));

              newAttachment.id = int.parse(respStr);
              notifyListeners();
            }
          } catch (error) {
            print(error);
            throw (error);
          }
        }
      },
    );
  }

  Future<Uint8List> getFileBytes(String uuid) async {
    if (await InternetConnection.internetConnection()) {
      final finalUrl = this._serverUrl + 'attachment/getAttachment/$uuid';

      try {
        final response = await http.get(finalUrl);

        return response.bodyBytes;
      } catch (error) {
        print(error);
        throw (error);
      }
    } else {
      return null;
    }
  }

  Future<File> loadAttachments(int attachmentId) async {
    try {
      return this._storeFile(
        List.from(this.attachments.firstWhere((element) => element.id == attachmentId).localFile),
        attachmentId,
      );
    } catch (error) {
      print(error);
      throw (error);
    }
  }

  Future<File> _storeFile(List<int> bytes, int attachmentId) async {
    final allAttachments = this.attachments + this.delegatedAttachments;

    String fileName = allAttachments.firstWhere((element) => element.id == attachmentId).fileName;

    final dir = await getApplicationDocumentsDirectory();

    final file = File('${dir.path}/$fileName');

    await file.writeAsBytes(bytes, flush: true);

    return file;
  }
}
