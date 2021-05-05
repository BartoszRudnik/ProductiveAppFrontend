import 'package:flutter/material.dart';

class Settings {
  bool showOnlyUnfinished = false;
  bool showOnlyDelegated = false;
  String collaboratorEmail;

  Settings({
    @required this.showOnlyUnfinished,
    @required this.showOnlyDelegated,
    this.collaboratorEmail,
  });
}
