import 'package:productive_app/db/init_database.dart';
import 'package:productive_app/model/user.dart';

class UserDatabase {
  static Future<User> read() async {
    final db = await InitDatabase.instance.database;

    final maps = await db.query(
      tableUser,
      columns: UserFields.values,
      where: '${UserFields.id} = ?',
      whereArgs: [1],
    );

    if (maps.isNotEmpty) {
      return User.fromJson(maps.first);
    } else {
      return null;
    }
  }

  static Future<int> update(User user) async {
    final db = await InitDatabase.instance.database;

    user.id = 1;

    return await db.update(
      tableUser,
      user.toJson(),
      where: '${UserFields.id} = ?',
      whereArgs: [1],
    );
  }

  static Future<int> delete() async {
    final db = await InitDatabase.instance.database;

    return db.delete(
      tableUser,
      where: '${UserFields.id} = ?',
      whereArgs: [1],
    );
  }

  static Future<void> create(User user) async {
    final db = await InitDatabase.instance.database;

    final existing = await read();

    user.id = 1;

    if (existing != null) {
      update(user);
    } else {
      db.insert(tableUser, user.toJson());
    }
  }
}
