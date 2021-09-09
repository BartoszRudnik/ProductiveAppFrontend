import 'package:productive_app/db/init_database.dart';

class LocaleDatabase {
  static Future<void> deleteAll(String userMail) async {
    final db = await InitDatabase.instance.database;

    await db.delete(
      'LOCALE',
      where: 'userMail = ?',
      whereArgs: [userMail],
    );
  }

  static Future<List<String>> read(String userMail) async {
    final db = await InitDatabase.instance.database;

    if (userMail != null) {
      final maps = await db.query(
        'LOCALE',
        columns: ['localeName', 'lastUpdated'],
        where: 'userMail = ?',
        whereArgs: [userMail],
      );

      if (maps.isNotEmpty) {
        return [maps.first['localeName'] as String, maps.first['lastUpdated'] as String];
      } else {
        return null;
      }
    } else {
      return null;
    }
  }

  static Future<int> update(String locale, String userMail) async {
    final db = await InitDatabase.instance.database;

    return await db.update(
      'LOCALE',
      {
        'localeName': locale,
        'lastUpdated': DateTime.now().toIso8601String(),
        'userMail': userMail,
      },
      where: 'userMail = ?',
      whereArgs: [userMail],
    );
  }

  static Future<void> create(String locale, String userMail) async {
    final db = await InitDatabase.instance.database;

    final existing = await read(userMail);

    if (existing != null) {
      update(locale, userMail);
    } else {
      db.insert(
        'LOCALE',
        {
          'localeName': locale,
          'lastUpdated': DateTime.now().toIso8601String(),
          'userMail': userMail,
        },
      );
    }
  }
}
