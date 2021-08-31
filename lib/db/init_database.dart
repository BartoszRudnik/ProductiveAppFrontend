import 'package:productive_app/model/tag.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class InitDatabase {
  static final InitDatabase instance = InitDatabase._init();

  static Database _database;

  InitDatabase._init();

  Future<Database> get database async {
    if (_database != null) {
      return _database;
    }

    _database = await _initDB('productive.db');
    return _database;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    return await openDatabase(path, version: 1, onCreate: _createDB);
  }

  Future _createDB(Database db, int version) async {
    final idType = 'INTEGER PRIMARY KEY AUTOINCREMENT';
    final boolType = 'BOOLEAN NOT NULL';
    final textType = 'TEXT NOT NULL';

    await db.execute('''
    CREATE TABLE $tableTags(
      ${TagFields.id} $idType,
      ${TagFields.name} $textType,
      ${TagFields.isSelected} $boolType
    )
    ''');
  }

  Future close() async {
    final db = await instance.database;

    db.close();
  }
}
