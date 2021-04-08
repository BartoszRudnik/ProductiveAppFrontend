import 'package:flutter/foundation.dart';

class Tag with ChangeNotifier {
  int id;
  String name;

  Tag({
    @required this.id,
    @required this.name,
  });
}
