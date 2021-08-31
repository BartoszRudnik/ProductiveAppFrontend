import 'package:flutter/foundation.dart';

final String tableTags = "tags";

class TagFields {
  static final List<String> values = [id, name, isSelected, lastUpdated];

  static final String id = "_id";
  static final String name = "name";
  static final String isSelected = "isSelected";
  static final String lastUpdated = "lastUpdated";
}

class Tag {
  int id;
  String name;
  bool isSelected;

  DateTime lastUpdated;

  Tag({
    this.isSelected = false,
    this.lastUpdated,
    @required this.id,
    @required this.name,
  });

  Tag copy({
    int id,
    String name,
    bool isSelected,
    bool synchronized,
    DateTime lastUpdated,
  }) =>
      Tag(
        id: id ?? this.id,
        name: name ?? this.name,
        isSelected: isSelected ?? this.isSelected,
        lastUpdated: lastUpdated ?? this.lastUpdated == null
            ? DateTime.now()
            : this.lastUpdated,
      );

  static Tag fromJson(Map<String, Object> json) => Tag(
        id: json[TagFields.id] as int,
        name: json[TagFields.name] as String,
        isSelected: json[TagFields.isSelected] == 1,
      );

  Map<String, dynamic> toJson() {
    return {
      TagFields.id: this.id,
      TagFields.name: this.name,
      TagFields.isSelected: this.isSelected ? 1 : 0,
      TagFields.lastUpdated: this.lastUpdated != null
          ? this.lastUpdated.toIso8601String()
          : DateTime.now().toIso8601String()
    };
  }
}
