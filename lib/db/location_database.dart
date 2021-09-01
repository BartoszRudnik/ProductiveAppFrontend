import 'package:productive_app/db/init_database.dart';
import 'package:productive_app/model/location.dart';

class LocationDatabase {
  static Future<Location> create(Location location) async {
    final db = await InitDatabase.instance.database;

    if (location.id != null) {
      location.id = null;
    }

    final id = await db.insert(tableLocations, location.toJson());

    return location.copy(id: id, lastUpdated: DateTime.now());
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
