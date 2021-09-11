import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:global_configuration/global_configuration.dart';
import 'package:http/http.dart' as http;
import 'package:productive_app/db/tag_database.dart';
import 'package:productive_app/utils/internet_connection.dart';

import '../model/tag.dart';

class TagProvider with ChangeNotifier {
  List<Tag> tagList;

  final String userMail;
  final String authToken;

  String searchingText;

  String _serverUrl = GlobalConfiguration().getValue("serverUrl");

  TagProvider({
    @required this.userMail,
    @required this.authToken,
    @required this.tagList,
  });

  void setTags(List<Tag> listToSet) {
    this.tagList = listToSet;

    notifyListeners();
  }

  List<Tag> get tags {
    if (this.searchingText == null || this.searchingText.length < 1) {
      return [...this.tagList];
    } else {
      return this.tagList.where((element) => element.name.toLowerCase().contains(this.searchingText.toLowerCase())).toList();
    }
  }

  List<String> get tagNames {
    List<String> result = [];

    this.tagList.forEach((element) {
      result.add(element.name);
    });

    return result;
  }

  void setSearchingText(String text) {
    this.searchingText = text;

    notifyListeners();
  }

  void clearSearchingText() {
    this.searchingText = '';

    notifyListeners();
  }

  void notify() {
    notifyListeners();
  }

  Future<List<Tag>> getTagsOffline() async {
    try {
      final tags = await TagDatabase.readAll(this.userMail);

      this.tagList = tags;

      return tags;
    } catch (error) {
      print(error);
      throw (error);
    }
  }

  Future<void> getTags() async {
    final url = this._serverUrl + "tag/getAll/${this.userMail}";

    final List<Tag> loadedTags = [];
    await TagDatabase.deleteAll(this.userMail);

    try {
      final response = await http.get(url);

      final responseBody = json.decode(utf8.decode(response.bodyBytes));

      for (var element in responseBody) {
        Tag newTag = Tag(
          uuid: element['uuid'],
          id: element['id'],
          name: element['name'],
        );

        newTag = await TagDatabase.create(newTag, this.userMail);

        loadedTags.add(newTag);
      }

      this.tagList = loadedTags;
      notifyListeners();
    } catch (error) {
      print(error);
      throw error;
    }
  }

  Future<void> deleteTagPermanently(String tagName) async {
    final url = this._serverUrl + "tag/delete/$tagName&${this.userMail}";

    final id = this.tagList.firstWhere((element) => element.name == tagName).id;
    this.tagList.removeWhere((element) => element.name == tagName);
    await TagDatabase.delete(id);

    notifyListeners();

    if (await InternetConnection.internetConnection()) {
      try {
        await http.delete(url);
      } catch (error) {
        print(error);
        throw error;
      }
    }
  }

  Future<void> updateTag(String newName, String oldName) async {
    final url = this._serverUrl + "tag/update/${this.userMail}";

    this.tagList.forEach((tag) async {
      if (tag.name == oldName) {
        tag.name = newName;
        await TagDatabase.update(tag, this.userMail);
      }
    });

    notifyListeners();

    if (await InternetConnection.internetConnection()) {
      try {
        await http.put(
          url,
          body: json.encode({
            'oldName': oldName,
            'newName': newName,
          }),
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

  Future<void> addTag(Tag newTag) async {
    final url = this._serverUrl + "tag/add";

    newTag.id = null;
    newTag = await TagDatabase.create(newTag, this.userMail);

    this.tagList.insert(0, newTag);

    notifyListeners();

    if (await InternetConnection.internetConnection()) {
      try {
        await http.post(
          url,
          body: json.encode(
            {
              'uuid': newTag.uuid,
              'id': newTag.id,
              'name': newTag.name,
              'taskId': null,
              'ownerEmail': this.userMail,
            },
          ),
          headers: {
            'content-type': 'application/json',
            'accept': 'application/json',
          },
        );
      } catch (error) {
        print(error);
        throw error;
      }
    }
  }
}
