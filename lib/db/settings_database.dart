import 'package:productive_app/db/init_database.dart';
import 'package:productive_app/model/settings.dart';

class SettingsDatabase {
  static Future<Settings> read(String userMail) async {
    final db = await InitDatabase.instance.database;

    final maps = await db.query(
      tableSettings,
      columns: SettingsFields.values,
      where: 'userMail = ?',
      whereArgs: [userMail],
    );

    if (maps.isNotEmpty) {
      return Settings.fromJson(maps.first);
    } else {
      return Settings();
    }
  }

  static Future<int> update(Settings settings, String userMail) async {
    final db = await InitDatabase.instance.database;

    Map settingsMap = settings.toJson();

    settingsMap['userMail'] = userMail;

    return await db.update(
      tableSettings,
      settingsMap,
      where: 'userMail = ?',
      whereArgs: [userMail],
    );
  }

  static Future<int> delete(String userMail) async {
    final db = await InitDatabase.instance.database;

    return db.delete(
      tableSettings,
      where: 'userMail = ?',
      whereArgs: [userMail],
    );
  }

  static Future<void> create(Settings settings, String userMail) async {
    final db = await InitDatabase.instance.database;

    final existing = await read(userMail);

    settings.lastUpdated = DateTime.now();

    Map settingsMap = settings.toJson();

    settingsMap['userMail'] = userMail;

    if (existing != null) {
      update(settings, userMail);
    } else {
      db.insert(tableSettings, settingsMap);
    }
  }
}
