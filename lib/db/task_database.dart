import 'package:productive_app/db/init_database.dart';
import 'package:productive_app/model/tag.dart';
import 'package:productive_app/model/task.dart';

class TaskDatabase {
  static Future<void> deleteAll(String userMail) async {
    final db = await InitDatabase.instance.database;

    await db.delete(
      tableTask,
      where: 'userMail = ?',
      whereArgs: [userMail],
    );
  }

  static Future<bool> idExist(int taskId) async {
    if (taskId == null) {
      return false;
    }

    final db = await InitDatabase.instance.database;

    final maps = await db.query(
      tableTask,
      columns: TaskFields.values,
      where: '${TaskFields.id} = ?',
      whereArgs: [taskId],
    );

    return maps.isNotEmpty;
  }

  static Future<Task> create(Task task, String userMail) async {
    final db = await InitDatabase.instance.database;

    if (await idExist(task.id)) {
      task.id = null;
    }

    Map taskMap = task.toJson();
    taskMap['userMail'] = userMail;

    final id = await db.insert(tableTask, taskMap);

    return task.copy(id: id);
  }

  static Future<int> getIdByUuid(String uuid) async {
    final db = await InitDatabase.instance.database;

    final maps = await db.query(
      tableTask,
      columns: TaskFields.values,
      where: '${TaskFields.uuid} = ?',
      whereArgs: [uuid],
    );

    final taskId = int.parse(maps.first['id'].toString());

    if (maps.length > 1) {
      await deleteNotUnique(uuid, taskId);
    }

    return taskId;
  }

  static Future<Task> read(String uuid, List<Tag> tags) async {
    final db = await InitDatabase.instance.database;

    final maps = await db.query(
      tableTask,
      columns: TaskFields.values,
      where: '${TaskFields.uuid} = ?',
      whereArgs: [uuid],
    );

    if (maps.isNotEmpty) {
      return Task.fromJson(maps.first, tags);
    } else {
      return null;
    }
  }

  static Future<List<Task>> readAll(List<Tag> tags, String userMail) async {
    if (userMail != null) {
      final db = await InitDatabase.instance.database;

      final result = await db.query(
        tableTask,
        where: 'userMail = ?',
        whereArgs: [userMail],
      );

      return result.map((e) => Task.fromJson(e, tags)).toList();
    }
    return [];
  }

  static Future<int> update(Task task, String userMail) async {
    final db = await InitDatabase.instance.database;

    task.id = await getIdByUuid(task.uuid);

    task.lastUpdated = DateTime.now();

    Map taskMap = task.toJson();
    taskMap['userMail'] = userMail;

    return await db.update(
      tableTask,
      taskMap,
      where: '${TaskFields.uuid} = ?',
      whereArgs: [task.uuid],
    );
  }

  static Future<void> deleteAllFromList(String listName) async {
    final db = await InitDatabase.instance.database;

    return await db.delete(
      tableTask,
      where: '${TaskFields.localization} = ?',
      whereArgs: [listName],
    );
  }

  static Future<int> deleteNotUnique(String uuid, int taskId) async {
    final db = await InitDatabase.instance.database;

    return await db.delete(
      tableTask,
      where: '${TaskFields.uuid} = ? AND ${TaskFields.id} != ?',
      whereArgs: [uuid, taskId],
    );
  }

  static Future<int> delete(String uuid) async {
    final db = await InitDatabase.instance.database;

    return await db.delete(
      tableTask,
      where: '${TaskFields.uuid} = ?',
      whereArgs: [uuid],
    );
  }
}
