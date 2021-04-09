import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

import '../models/tag.dart';

class TagProvider with ChangeNotifier {
  List<Tag> tagList = [];

  final String userMail;
  final String authToken;

  String _serverUrl = 'http://192.168.1.120:8080/api/v1/';

  TagProvider({
    @required this.userMail,
    @required this.authToken,
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

  void addTag(Tag newTag) {
    this.tagList.add(newTag);

    notifyListeners();
  }
}
