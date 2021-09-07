import 'package:productive_app/db/init_database.dart';
import 'package:productive_app/model/attachment.dart';

class AttachmentDatabase {
  static Future<void> deleteAll(String userMail) async {
    final db = await InitDatabase.instance.database;

    await db.delete(
      tableAttachment,
      where: 'userMail = ?',
      whereArgs: [userMail],
    );
  }

  static Future<List<Attachment>> readAll(String userMail) async {
    final db = await InitDatabase.instance.database;

    final result = await db.query(
      tableAttachment,
      where: 'userMail = ?',
      whereArgs: [userMail],
    );

    return result.map((e) => Attachment.fromJson(e)).toList();
  }

  static Future<Attachment> read(int attachmentId) async {
    final db = await InitDatabase.instance.database;

    final maps = await db.query(
      tableAttachment,
      columns: AttachmentFields.values,
      where: '${AttachmentFields.id} = ?',
      whereArgs: [attachmentId],
    );

    if (maps.isNotEmpty) {
      return Attachment.fromJson(maps.first);
    } else {
      return null;
    }
  }

  static Future<int> update(Attachment attachment, String userMail) async {
    final db = await InitDatabase.instance.database;

    Map map = attachment.toJson();
    map['userMail'] = userMail;

    return await db.update(
      tableAttachment,
      map,
      where: '$AttachmentFields.id = ?',
      whereArgs: [attachment.id],
    );
  }

  static Future<int> delete(int id) async {
    final db = await InitDatabase.instance.database;

    return db.delete(
      tableAttachment,
      where: '$AttachmentFields.id = ?',
      whereArgs: [id],
    );
  }

  static Future<void> create(Attachment attachment, String userMail) async {
    final db = await InitDatabase.instance.database;

    final existing = await read(attachment.id);

    Map map = attachment.toJson();
    map['userMail'] = userMail;

    if (existing == null) {
      await db.insert(
        tableAttachment,
        map,
      );
    }
  }
}
