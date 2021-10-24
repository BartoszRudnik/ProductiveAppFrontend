import 'package:productive_app/db/init_database.dart';
import 'package:productive_app/model/appVersion.dart';

class VersionDatabase {
  static Future<AppVersion> read() async {
    final db = await InitDatabase.instance.database;

    final result = await db.query(
      tableVersion,
      columns: VersionFields.values,
    );

    if (result != null && result.length > 0) {
      return AppVersion.fromJson(result.first);
    } else {
      return null;
    }
  }

  static Future<void> delete() async {
    final db = await InitDatabase.instance.database;

    await db.delete(tableVersion);
  }

  static Future<void> create(AppVersion version) async {
    final db = await InitDatabase.instance.database;

    await db.insert(tableVersion, version.toJson());
  }
}
