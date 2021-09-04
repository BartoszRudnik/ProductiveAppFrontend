import 'package:productive_app/db/init_database.dart';
import 'package:productive_app/model/settings.dart';

class SettingsDatabase {
  static Future<Settings> read() async {
    final db = await InitDatabase.instance.database;

    final maps = await db.query(
      tableSettings,
      columns: SettingsFields.values,
      where: '${SettingsFields.id} = ?',
      whereArgs: [1],
    );

    if (maps.isNotEmpty) {
      return Settings.fromJson(maps.first);
    } else {
      return Settings();
    }
  }

  static Future<int> update(Settings settings) async {
    final db = await InitDatabase.instance.database;

    settings.id = 1;

    return await db.update(
      tableSettings,
      settings.toJson(),
      where: '${SettingsFields.id} = ?',
      whereArgs: [1],
    );
  }

  static Future<int> delete() async {
    final db = await InitDatabase.instance.database;

    return db.delete(
      tableSettings,
      where: '${SettingsFields.id} = ?',
      whereArgs: [1],
    );
  }

  static Future<void> create(Settings settings) async {
    final db = await InitDatabase.instance.database;

    final existing = await read();

    settings.id = 1;
    settings.lastUpdated = DateTime.now();

    if (existing != null) {
      update(settings);
    } else {
      db.insert(tableSettings, settings.toJson());
    }
  }
}
