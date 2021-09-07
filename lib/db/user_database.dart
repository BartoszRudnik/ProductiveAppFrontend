import 'package:productive_app/db/init_database.dart';
import 'package:productive_app/model/user.dart';

class UserDatabase {
  static Future<User> read(String userMail) async {
    if (userMail != null) {
      final db = await InitDatabase.instance.database;

      final maps = await db.query(
        tableUser,
        columns: UserFields.values,
        where: '${UserFields.email} = ?',
        whereArgs: [userMail],
      );

      if (maps.isNotEmpty) {
        return User.fromJson(maps.first);
      } else {
        return null;
      }
    } else {
      return null;
    }
  }

  static Future<int> update(User user) async {
    final db = await InitDatabase.instance.database;

    return await db.update(
      tableUser,
      user.toJson(),
      where: '${UserFields.email} = ?',
      whereArgs: [user.email],
    );
  }

  static Future<int> delete(String userMail) async {
    final db = await InitDatabase.instance.database;

    return db.delete(
      tableUser,
      where: '${UserFields.email} = ?',
      whereArgs: [userMail],
    );
  }

  static Future<void> create(User user) async {
    final db = await InitDatabase.instance.database;

    final existing = await read(user.email);

    if (existing == null) {
      await db.insert(tableUser, user.toJson());
    }
  }
}
