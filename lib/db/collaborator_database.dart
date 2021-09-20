import 'package:productive_app/db/init_database.dart';
import 'package:productive_app/model/collaborator.dart';

class CollaboratorDatabase {
  static Future<void> deleteAll(String userMail) async {
    final db = await InitDatabase.instance.database;

    await db.delete(
      tableCollaborators,
      where: '${CollaboratorsFields.email} = ? OR userMail = ?',
      whereArgs: [userMail, userMail],
    );
  }

  static Future<bool> alreadyExist(String uuid) async {
    final db = await InitDatabase.instance.database;

    if (uuid == null) {
      return false;
    }

    final maps = await db.query(
      tableCollaborators,
      columns: CollaboratorsFields.values,
      where: '${CollaboratorsFields.uuid} = ?',
      whereArgs: [uuid],
    );

    return maps.isNotEmpty;
  }

  static Future<Collaborator> create(Collaborator collaborator, String userMail) async {
    if (!await alreadyExist(collaborator.uuid)) {
      final db = await InitDatabase.instance.database;

      collaborator.id = null;
      final map = collaborator.toJson();
      map['userMail'] = userMail;

      final id = await db.insert(tableCollaborators, map);

      return collaborator.copy(id: id);
    } else {
      await update(collaborator);

      return collaborator;
    }
  }

  static Future<Collaborator> read(int id) async {
    final db = await InitDatabase.instance.database;

    final maps = await db.query(
      tableCollaborators,
      columns: CollaboratorsFields.values,
      where: '${CollaboratorsFields.id} = ?',
      whereArgs: [id],
    );

    if (maps.isNotEmpty) {
      return Collaborator.fromJson(maps.first);
    } else {
      return null;
    }
  }

  static Future<List<Collaborator>> readAll(String userMail) async {
    final db = await InitDatabase.instance.database;

    final result = await db.query(
      tableCollaborators,
      where: '${CollaboratorsFields.email} = ? OR userMail = ?',
      whereArgs: [userMail, userMail],
    );

    return result.map((collaborator) => Collaborator.fromJson(collaborator)).toList();
  }

  static Future<int> update(Collaborator collaborator) async {
    final db = await InitDatabase.instance.database;

    collaborator.lastUpdated = DateTime.now();

    return await db.update(
      tableCollaborators,
      collaborator.toJson(),
      where: '${CollaboratorsFields.id} = ?',
      whereArgs: [collaborator.id],
    );
  }

  static Future<int> delete(int id) async {
    final db = await InitDatabase.instance.database;

    return db.delete(
      tableCollaborators,
      where: '${CollaboratorsFields.id} = ?',
      whereArgs: [id],
    );
  }

  static Future<int> deleteByUuid(String uuid) async {
    final db = await InitDatabase.instance.database;

    return db.delete(
      tableCollaborators,
      where: '${CollaboratorsFields.uuid} = ?',
      whereArgs: [uuid],
    );
  }
}
