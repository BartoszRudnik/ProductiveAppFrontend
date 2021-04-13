import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

import '../models/tag.dart';

class TagProvider with ChangeNotifier {
  List<Tag> tagList;

  final String userMail;
  final String authToken;

  String _serverUrl = 'http://192.168.1.120:8080/api/v1/';

  TagProvider({
    @required this.userMail,
    @required this.authToken,
    @required this.tagList,
  });

  List<Tag> get tags {
    return [...this.tagList];
  }

  Future<void> getTags() async {
    final url = this._serverUrl + "tag/getAll/${this.userMail}";

    final List<Tag> loadedTags = [];

    try {
      final response = await http.get(url);

      final responseBody = json.decode(response.body);

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
    final url = this._serverUrl + "tag/delete/$tagName";

    try {
      await http.delete(url);

      this.tagList.removeWhere((element) => element.name == tagName);
      notifyListeners();
    } catch (error) {
      print(error);
      throw error;
    }
  }

  Future<void> addTag(Tag newTag) async {
    final url = this._serverUrl + "tag/add";

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
