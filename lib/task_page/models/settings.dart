import 'package:flutter/material.dart';

class Settings {
  bool showOnlyUnfinished = false;
  bool showOnlyDelegated = false;
  List<String> collaborators;

  Settings({
    @required this.showOnlyUnfinished,
    @required this.showOnlyDelegated,
    this.collaborators,
  });
}
