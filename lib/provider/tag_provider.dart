import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:global_configuration/global_configuration.dart';
import 'package:http/http.dart' as http;

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

  List<Tag> get tags {
    if (this.searchingText == null || this.searchingText.length < 1) {
      return [...this.tagList];
    } else {
      return this.tagList.where((element) => element.name.contains(this.searchingText)).toList();
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

  Future<void> getTags() async {
    final url = this._serverUrl + "tag/getAll/${this.userMail}";

    final List<Tag> loadedTags = [];

    try {
      final response = await http.get(url);

      final responseBody = json.decode(utf8.decode(response.bodyBytes));

      for (var element in responseBody) {
        Tag newTag = Tag(
          id: element['id'],
          name: element['name'],
        );

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

    try {
      await http.delete(url);

      this.tagList.removeWhere((element) => element.name == tagName);
      notifyListeners();
    } catch (error) {
      print(error);
      throw error;
    }
  }

  Future<void> updateTag(String newName, String oldName) async {
    final url = this._serverUrl + "tag/update/${this.userMail}";

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

      this.tagList.forEach((tag) {
        if (tag.name == oldName) {
          tag.name = newName;
        }
      });

      notifyListeners();
    } catch (error) {
      print(error);
      throw (error);
    }
  }

  Future<void> addTag(Tag newTag) async {
    final url = this._serverUrl + "tag/add";

    newTag.id = this.tagList.length + 1;

    try {
      await http.post(
        url,
        body: json.encode(
          {
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

      this.tagList.insert(0, newTag);
      notifyListeners();
    } catch (error) {
      print(error);
      throw error;
    }
  }
}
