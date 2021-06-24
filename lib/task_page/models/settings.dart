import 'package:flutter/material.dart';

class Settings {
  bool showOnlyUnfinished = false;
  bool showOnlyDelegated = false;
  bool showOnlyWithLocalization = false;
  List<String> collaborators;
  List<String> priorities;
  List<String> tags;
  int sortingMode;

  Settings({
    @required this.showOnlyUnfinished,
    @required this.showOnlyDelegated,
    @required this.showOnlyWithLocalization,
    this.collaborators,
    this.priorities,
    this.tags,
    this.sortingMode,
  });
}
