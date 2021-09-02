import 'package:productive_app/db/init_database.dart';
import 'package:productive_app/model/location.dart';

class LocationDatabase {
  static Future<void> deleteAll() async {
    final db = await InitDatabase.instance.database;

    db.delete(tableLocations);
  }

  static Future<void> create(Location location) async {
    final db = await InitDatabase.instance.database;

    await db.insert(tableLocations, location.toJson());
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

  static Future<List<Location>> readAll() async {
    final db = await InitDatabase.instance.database;

    final result = await db.query(tableLocations);

    return result.map((location) => Location.fromJson(location)).toList();
  }

  static Future<int> update(Location location) async {
    final db = await InitDatabase.instance.database;

    location.lastUpdated = DateTime.now();

    return await db.update(
      tableLocations,
      location.toJson(),
      where: '${LocationFields.id} = ?',
      whereArgs: [location.id],
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
