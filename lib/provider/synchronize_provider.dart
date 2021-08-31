import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:global_configuration/global_configuration.dart';
import 'package:http/http.dart' as http;
import 'package:productive_app/model/tag.dart';

class SynchronizeProvider with ChangeNotifier {
  final String userMail;
  final String authToken;

  SynchronizeProvider({
    this.userMail,
    this.authToken,
  });

  String _serverUrl = GlobalConfiguration().getValue("serverUrl");

  Future<List<Tag>> synchronizeTags(List<Tag> tagList) async {
    final finalUrl =
        this._serverUrl + "synchronize/synchronizeTags/${this.userMail}";

    try {
      final response = await http.post(
        finalUrl,
        body: json.encode(
          {
            'tagList': tagList,
          },
        ),
        headers: {
          'content-type': 'application/json',
          'accept': 'application/json',
        },
      );

      final responseBody = json.decode(utf8.decode(response.bodyBytes));

      List<Tag> loadedTags = [];

      for (final element in responseBody) {
        Tag newTag = Tag(
          id: element['id'],
          name: element['name'],
        );

        loadedTags.add(newTag);
      }

      return loadedTags;
    } catch (error) {
      print(error);
      throw (error);
    }
  }
}
