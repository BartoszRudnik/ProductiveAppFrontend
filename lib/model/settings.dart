final String tableSettings = "settings";

class SettingsFields {
  static final List<String> values = [
    id,
    showOnlyDelegated,
    showOnlyWithLocalization,
    collaborators,
    priorities,
    tags,
    locations,
    sortingMode,
    lastUpdated,
  ];

  static final String id = "id";
  static final String showOnlyDelegated = "showOnlyDelegated";
  static final String showOnlyWithLocalization = "showOnlyWithLocalization";
  static final String collaborators = "collaborators";
  static final String priorities = "priorities";
  static final String tags = "tags";
  static final String locations = "locations";
  static final String sortingMode = "sortingMode";
  static final String lastUpdated = "lastUpdated";
}

class Settings {
  int id;
  bool showOnlyDelegated;
  bool showOnlyWithLocalization;
  List<String> collaborators;
  List<String> priorities;
  List<String> tags;
  List<String> locations;
  int sortingMode;
  String taskName;
  DateTime lastUpdated;

  Settings({
    this.id,
    this.showOnlyDelegated = false,
    this.showOnlyWithLocalization = false,
    this.locations,
    this.collaborators,
    this.priorities,
    this.tags,
    this.sortingMode,
    this.taskName,
    this.lastUpdated,
  });

  String joinStringList(List<String> listToFlatten) {
    if (listToFlatten == null) {
      return '';
    }
    return listToFlatten.join('|');
  }

  String joinIntList(List<int> listToFlatten) {
    if (listToFlatten == null) {
      return '';
    }
    return listToFlatten.join('|');
  }

  static List<String> splitStringList(String toSplit) {
    if (toSplit.length > 0) {
      return toSplit.split('|');
    }
    return null;
  }

  static List<int> splitIntList(String toSplit) {
    if (toSplit.length > 0) {
      final stringList = toSplit.split('|');

      List<int> result = [];

      stringList.forEach((element) {
        result.add(int.tryParse(element));
      });

      return result;
    } else {
      return null;
    }
  }

  Settings copy({
    int id,
    bool showOnlyDelegated,
    bool showOnlyWithLocalization,
    List<String> collaborators,
    List<String> priorities,
    List<String> tags,
    List<int> locations,
    int sortingMode = 0,
    String taskName,
    DateTime lastUpdated,
  }) =>
      Settings(
        id: id ?? this.id,
        showOnlyDelegated: showOnlyDelegated ?? this.showOnlyDelegated,
        showOnlyWithLocalization: showOnlyWithLocalization ?? this.showOnlyWithLocalization,
        collaborators: collaborators ?? this.collaborators,
        priorities: priorities ?? this.priorities,
        tags: tags ?? this.tags,
        locations: locations ?? this.locations,
        sortingMode: sortingMode ?? this.sortingMode,
        lastUpdated: DateTime.now(),
      );

  static Settings fromJson(Map<String, Object> json) => Settings(
        id: json[SettingsFields.id] as int,
        showOnlyDelegated: json[SettingsFields.showOnlyDelegated] == null ? 0 : json[SettingsFields.showOnlyDelegated] == 1,
        showOnlyWithLocalization: json[SettingsFields.showOnlyWithLocalization] == null ? 0 : json[SettingsFields.showOnlyWithLocalization] == 1,
        collaborators: json[SettingsFields.collaborators] == null ? [] : splitStringList(json[SettingsFields.collaborators] as String),
        priorities: json[SettingsFields.priorities] == null ? [] : splitStringList(json[SettingsFields.priorities] as String),
        tags: json[SettingsFields.tags] == null ? [] : splitStringList(json[SettingsFields.tags] as String),
        locations: json[SettingsFields.locations] == null ? [] : splitStringList(json[SettingsFields.locations] as String),
        sortingMode: json[SettingsFields.sortingMode] == null ? 0 : json[SettingsFields.sortingMode] as int,
        lastUpdated: json[SettingsFields.lastUpdated] == null ? DateTime.now() : DateTime.parse(json[SettingsFields.lastUpdated] as String),
      );

  Map<String, dynamic> toJson() {
    return {
      SettingsFields.id: this.id,
      SettingsFields.showOnlyDelegated: this.showOnlyDelegated == null
          ? 0
          : this.showOnlyDelegated
              ? 1
              : 0,
      SettingsFields.showOnlyWithLocalization: this.showOnlyWithLocalization == null
          ? 0
          : this.showOnlyWithLocalization
              ? 1
              : 0,
      SettingsFields.collaborators: this.joinStringList(this.collaborators),
      SettingsFields.priorities: this.joinStringList(this.priorities),
      SettingsFields.tags: this.joinStringList(this.tags),
      SettingsFields.locations: this.joinStringList(this.locations),
      SettingsFields.sortingMode: this.sortingMode == null ? 0 : this.sortingMode,
      SettingsFields.lastUpdated: this.lastUpdated != null ? this.lastUpdated.toIso8601String() : DateTime.now().toIso8601String(),
    };
  }
}
