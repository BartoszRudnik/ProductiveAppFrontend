import 'package:flutter/foundation.dart';

import '../models/tag.dart';

class TagProvider with ChangeNotifier {
  List<Tag> tagList = [
    Tag(
      id: 1,
      name: 'tag one',
    ),
    Tag(
      id: 2,
      name: 'tag two',
    ),
    Tag(
      id: 3,
      name: 'three',
    ),
    Tag(
      id: 4,
      name: 'tag number four',
    ),
    Tag(
      id: 5,
      name: '5',
    ),
  ];

  final String userMail;
  final String authToken;

  TagProvider({
    @required this.userMail,
    @required this.authToken,
  });

  List<Tag> get tags {
    return [...this.tagList];
  }

  void addTag(Tag newTag) {
    this.tagList.add(newTag);

    notifyListeners();
  }
}
