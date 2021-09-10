import 'package:flutter/cupertino.dart';
import 'package:productive_app/db/init_database.dart';
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

  static Future<Task> create(Task task, String userMail) async {
    final db = await InitDatabase.instance.database;

    Map taskMap = task.toJson();

    taskMap['userMail'] = userMail;

    final id = await db.insert(tableTask, taskMap);

    return task.copy(id: id);
  }

  static Future<Task> read(int id, BuildContext context) async {
    final db = await InitDatabase.instance.database;

    final maps = await db.query(
      tableTask,
      columns: TaskFields.values,
      where: '${TaskFields.id} = ?',
      whereArgs: [id],
    );

    if (maps.isNotEmpty) {
      return Task.fromJson(maps.first, context);
    } else {
      return null;
    }
  }

  static Future<List<Task>> readAll(BuildContext context, String userMail) async {
    final db = await InitDatabase.instance.database;

    final result = await db.query(
      tableTask,
      where: 'userMail = ?',
      whereArgs: [userMail],
    );

    return result.map((e) => Task.fromJson(e, context)).toList();
  }

  static Future<int> update(Task task, String userMail) async {
    final db = await InitDatabase.instance.database;

    task.lastUpdated = DateTime.now();

    Map taskMap = task.toJson();

    taskMap['userMail'] = userMail;

    return await db.update(
      tableTask,
      taskMap,
      where: '${TaskFields.id} = ?',
      whereArgs: [task.id],
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

  static Future<int> delete(int id) async {
    final db = await InitDatabase.instance.database;

    return await db.delete(
      tableTask,
      where: '${TaskFields.id} = ?',
      whereArgs: [id],
    );
  }
}
