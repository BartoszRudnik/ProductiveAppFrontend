import 'package:productive_app/db/init_database.dart';

class GraphicDatabase {
  static Future<List<String>> read() async {
    final db = await InitDatabase.instance.database;

    final maps = await db.query(
      'GRAPHIC',
      columns: ['mode', 'lastUpdated'],
      where: 'id = ?',
      whereArgs: [1],
    );

    if (maps.isNotEmpty) {
      return [maps.first['mode'] as String, maps.first['lastUpdated'] as String];
    } else {
      return null;
    }
  }

  static Future<int> update(String mode) async {
    final db = await InitDatabase.instance.database;

    return await db.update(
      'GRAPHIC',
      {
        'mode': mode,
        'lastUpdated': DateTime.now().toIso8601String(),
      },
      where: 'id = ?',
      whereArgs: [1],
    );
  }

  static Future<void> create(String mode) async {
    final db = await InitDatabase.instance.database;

    final existing = await read();

    if (existing != null) {
      update(mode);
    } else {
      db.insert(
        'GRAPHIC',
        {
          'mode': mode,
          'lastUpdated': DateTime.now().toIso8601String(),
        },
      );
    }
  }
}
