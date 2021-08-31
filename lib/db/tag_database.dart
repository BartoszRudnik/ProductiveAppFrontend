import 'package:productive_app/db/init_database.dart';
import 'package:productive_app/model/tag.dart';

class TagDatabase {
  static Future<Tag> create(Tag tag) async {
    final db = await InitDatabase.instance.database;

    if (tag.id != null) {
      tag.id = null;
    }

    final id = await db.insert(tableTags, tag.toJson());

    print(id);

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

  static Future<List<Tag>> readAll() async {
    final db = await InitDatabase.instance.database;

    final result = await db.query(tableTags);

    return result.map((tag) => Tag.fromJson(tag)).toList();
  }

  static Future<int> update(Tag tag) async {
    final db = await InitDatabase.instance.database;

    tag.lastUpdated = DateTime.now();

    return db.update(
      tableTags,
      tag.toJson(),
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
