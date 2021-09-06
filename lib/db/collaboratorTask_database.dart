import 'package:productive_app/db/init_database.dart';
import 'package:productive_app/model/collaboratorTask.dart';

class CollaboratorTaskDatabase {
  static Future<void> deleteAll(String userMail) async {
    final db = await InitDatabase.instance.database;

    db.delete(
      tableCollaboratorTask,
      where: 'userMail = ?',
      whereArgs: [userMail],
    );
  }

  static Future<void> create(CollaboratorTask collaboratorTask, String userMail) async {
    final db = await InitDatabase.instance.database;

    Map collaboratorTaskMap = collaboratorTask.toJson();

    collaboratorTaskMap['userMail'] = userMail;

    await db.insert(tableCollaboratorTask, collaboratorTaskMap);
  }

  static Future<CollaboratorTask> read(int id) async {
    final db = await InitDatabase.instance.database;

    final maps = await db.query(
      tableCollaboratorTask,
      columns: CollaboratorTaskFields.values,
      where: '${CollaboratorTaskFields.id} = ?',
      whereArgs: [id],
    );

    if (maps.isNotEmpty) {
      return CollaboratorTask.fromJson(maps.first);
    } else {
      return null;
    }
  }

  static Future<List<CollaboratorTask>> readAll(String userMail) async {
    final db = await InitDatabase.instance.database;

    final result = await db.query(
      tableCollaboratorTask,
      where: 'userMail = ?',
      whereArgs: [userMail],
    );

    return result.map((collaboratorTask) => CollaboratorTask.fromJson(collaboratorTask)).toList();
  }

  static Future<int> update(CollaboratorTask collaboratorTask) async {
    final db = await InitDatabase.instance.database;

    collaboratorTask.lastUpdated = DateTime.now();

    return await db.update(
      tableCollaboratorTask,
      collaboratorTask.toJson(),
      where: '${CollaboratorTaskFields.id} = ?',
      whereArgs: [collaboratorTask.id],
    );
  }

  static Future<int> delete(int id) async {
    final db = await InitDatabase.instance.database;

    return db.delete(
      tableCollaboratorTask,
      where: '${CollaboratorTaskFields.id} = ?',
      whereArgs: [id],
    );
  }
}
