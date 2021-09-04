import 'package:flutter/cupertino.dart';
import 'package:productive_app/db/init_database.dart';
import 'package:productive_app/model/task.dart';

class TaskDatabase {
  static Future<void> deleteAll() async {
    final db = await InitDatabase.instance.database;

    db.delete(tableTask);
  }

  static Future<void> create(Task task) async {
    final db = await InitDatabase.instance.database;

    await db.insert(tableTask, task.toJson());
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

  static Future<List<Task>> readAll(BuildContext context) async {
    final db = await InitDatabase.instance.database;

    final result = await db.query(tableTask);

    return result.map((e) => Task.fromJson(e, context)).toList();
  }

  static Future<int> update(Task task) async {
    final db = await InitDatabase.instance.database;

    task.lastUpdated = DateTime.now();

    return await db.update(
      tableTask,
      task.toJson(),
      where: '${TaskFields.id} = ?',
      whereArgs: [task.id],
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
