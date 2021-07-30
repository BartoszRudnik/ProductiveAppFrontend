import 'package:flutter/foundation.dart';

class Tag with ChangeNotifier {
  int id;
  String name;
  bool isSelected = false;

  Tag({
    @required this.id,
    @required this.name,
  });

  Map<String, dynamic> toJson() {
    return {
      "id": this.id,
      "name": this.name,
    };
  }
}
