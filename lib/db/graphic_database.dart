import 'package:productive_app/db/init_database.dart';

class GraphicDatabase {
  static Future<void> deleteAll(String userMail) async {
    final db = await InitDatabase.instance.database;

    if (userMail != null) {
      await db.delete(
        'GRAPHIC',
        where: 'userMail = ?',
        whereArgs: [userMail],
      );
    }
  }

  static Future<List<String>> read(String userMail) async {
    final db = await InitDatabase.instance.database;

    if (userMail != null) {
      final maps = await db.query(
        'GRAPHIC',
        columns: ['mode', 'lastUpdated'],
        where: 'userMail = ?',
        whereArgs: [userMail],
      );

      if (maps.isNotEmpty) {
        return [maps.first['mode'] as String, maps.first['lastUpdated'] as String];
      } else {
        return null;
      }
    } else {
      return null;
    }
  }

  static Future<int> update(String mode, String userMail) async {
    final db = await InitDatabase.instance.database;

    return await db.update(
      'GRAPHIC',
      {
        'mode': mode,
        'lastUpdated': DateTime.now().toIso8601String(),
        'userMail': userMail,
      },
      where: 'userMail = ?',
      whereArgs: [userMail],
    );
  }

  static Future<void> create(String mode, String userMail) async {
    final db = await InitDatabase.instance.database;

    final existing = await read(userMail);

    if (existing != null) {
      update(mode, userMail);
    } else {
      db.insert(
        'GRAPHIC',
        {
          'mode': mode,
          'lastUpdated': DateTime.now().toIso8601String(),
          'userMail': userMail,
        },
      );
    }
  }
}
