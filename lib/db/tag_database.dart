import 'package:productive_app/db/init_database.dart';
import 'package:productive_app/model/tag.dart';

class TagDatabase {
  static Future<void> deleteAll(String userMail) async {
    final db = await InitDatabase.instance.database;

    db.delete(
      tableTags,
      where: 'userMail = ?',
      whereArgs: [userMail],
    );
  }

  static Future<Tag> create(Tag tag, String userMail) async {
    final db = await InitDatabase.instance.database;

    Map tagMap = tag.toJson();

    tagMap['userMail'] = userMail;

    final id = await db.insert(tableTags, tagMap);

    return tag.copy(id: id, lastUpdated: DateTime.now());
  }

  static Future<Tag> read(int id) async {
    final db = await InitDatabase.instance.database;

    final maps = await db.query(
      tableTags,
      columns: TagFields.values,
      where: '${TagFields.id} = ?',
      whereArgs: [id],
    );

    if (maps.isNotEmpty) {
      return Tag.fromJson(maps.first);
    } else {
      throw Exception('ID $id not found');
    }
  }

  static Future<List<Tag>> readAll(String userMail) async {
    final db = await InitDatabase.instance.database;

    final result = await db.query(
      tableTags,
      where: 'userMail = ?',
      whereArgs: [userMail],
    );

    return result.map((tag) => Tag.fromJson(tag)).toList();
  }

  static Future<int> update(Tag tag, String userMail) async {
    final db = await InitDatabase.instance.database;

    tag.lastUpdated = DateTime.now();

    Map tagMap = tag.toJson();

    tagMap['userMail'] = userMail;

    return await db.update(
      tableTags,
      tagMap,
      where: '${TagFields.id} = ?',
      whereArgs: [tag.id],
    );
  }

  static Future<int> delete(int id) async {
    final db = await InitDatabase.instance.database;

    return db.delete(
      tableTags,
      where: '${TagFields.id} = ?',
      whereArgs: [id],
    );
  }
}
