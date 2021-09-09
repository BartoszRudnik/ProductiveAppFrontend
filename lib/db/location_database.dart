import 'package:productive_app/db/init_database.dart';
import 'package:productive_app/model/location.dart';

class LocationDatabase {
  static Future<void> deleteAll(String userMail) async {
    final db = await InitDatabase.instance.database;

    db.delete(
      tableLocations,
      where: 'userMail = ?',
      whereArgs: [userMail],
    );
  }

  static Future<Location> create(Location location, String userMail) async {
    final db = await InitDatabase.instance.database;

    Map locationMap = location.toJson();

    locationMap['userMail'] = userMail;

    final id = await db.insert(tableLocations, locationMap);

    print(id);

    return location.copy(id: id);
  }

  static Future<Location> read(int id) async {
    final db = await InitDatabase.instance.database;

    final maps = await db.query(
      tableLocations,
      columns: LocationFields.values,
      where: '${LocationFields.id} = ?',
      whereArgs: [id],
    );

    if (maps.isNotEmpty) {
      return Location.fromJson(maps.first);
    } else {
      throw Exception('ID $id not found');
    }
  }

  static Future<List<Location>> readAll(String userMail) async {
    final db = await InitDatabase.instance.database;

    final result = await db.query(
      tableLocations,
      where: 'userMail = ?',
      whereArgs: [userMail],
    );

    return result.map((location) => Location.fromJson(location)).toList();
  }

  static Future<int> update(Location location, String userMail) async {
    final db = await InitDatabase.instance.database;

    location.lastUpdated = DateTime.now();

    Map locationMap = location.toJson();

    locationMap['userMail'] = userMail;

    return await db.update(
      tableLocations,
      locationMap,
      where: '${LocationFields.id} = ?',
      whereArgs: [location.id],
    );
  }

  static Future<int> deleteByUuid(String uuid) async {
    final db = await InitDatabase.instance.database;

    return db.delete(
      tableLocations,
      where: '${LocationFields.uuid} = ?',
      whereArgs: [uuid],
    );
  }

  static Future<int> delete(int id) async {
    final db = await InitDatabase.instance.database;

    return db.delete(
      tableLocations,
      where: '${LocationFields.id} = ?',
      whereArgs: [id],
    );
  }
}
