import 'package:productive_app/db/init_database.dart';
import 'package:productive_app/model/collaborator.dart';

class CollaboratorDatabase {
  static Future<Collaborator> create(Collaborator collaborator) async {
    final db = await InitDatabase.instance.database;

    if (collaborator.id != null) {
      collaborator.id = null;
    }

    final id = await db.insert(tableCollaborators, collaborator.toJson());

    return collaborator.copy(id: id, lastUpdated: DateTime.now());
  }

  static Future<Collaborator> read(int id) async {
    final db = await InitDatabase.instance.database;

    final maps = await db.query(
      tableCollaborators,
      columns: CollaboratorsFields.values,
      where: '${CollaboratorsFields.id} = ?',
      whereArgs: [id],
    );

    if (maps.isNotEmpty) {
      return Collaborator.fromJson(maps.first);
    } else {
      throw Exception("ID $id not found");
    }
  }

  static Future<List<Collaborator>> readAll() async {
    final db = await InitDatabase.instance.database;

    final result = await db.query(tableCollaborators);

    return result.map((collaborator) => Collaborator.fromJson(collaborator)).toList();
  }

  static Future<int> update(Collaborator collaborator) async {
    final db = await InitDatabase.instance.database;

    collaborator.lastUpdated = DateTime.now();

    return await db.update(
      tableCollaborators,
      collaborator.toJson(),
      where: '${CollaboratorsFields.id} = ?',
      whereArgs: [collaborator.id],
    );
  }

  static Future<int> delete(int id) async {
    final db = await InitDatabase.instance.database;

    return db.delete(
      tableCollaborators,
      where: '${CollaboratorsFields.id} = ?',
      whereArgs: [id],
    );
  }
}
