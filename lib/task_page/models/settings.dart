import 'package:flutter/material.dart';

class Settings {
  bool showOnlyUnfinished = false;
  bool showOnlyDelegated = false;

  Settings({
    @required this.showOnlyUnfinished,
    @required this.showOnlyDelegated,
  });
}
