import 'package:productive_app/db/init_database.dart';

class LocaleDatabase {
  static Future<void> deleteAll() async {
    final db = await InitDatabase.instance.database;

    await db.delete('LOCALE');
  }

  static Future<List<String>> read() async {
    final db = await InitDatabase.instance.database;

    final maps = await db.query(
      'LOCALE',
      columns: ['localeName', 'lastUpdated'],
      where: 'id = ?',
      whereArgs: [1],
    );

    if (maps.isNotEmpty) {
      return [maps.first['localeName'] as String, maps.first['lastUpdated'] as String];
    } else {
      return null;
    }
  }

  static Future<int> update(String locale) async {
    final db = await InitDatabase.instance.database;

    return await db.update(
      'LOCALE',
      {
        'localeName': locale,
        'lastUpdated': DateTime.now().toIso8601String(),
      },
      where: 'id = ?',
      whereArgs: [1],
    );
  }

  static Future<void> create(String locale) async {
    final db = await InitDatabase.instance.database;

    final existing = await read();

    if (existing != null) {
      update(locale);
    } else {
      db.insert(
        'LOCALE',
        {
          'localeName': locale,
          'lastUpdated': DateTime.now().toIso8601String(),
        },
      );
    }
  }
}
