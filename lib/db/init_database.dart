import 'package:productive_app/model/collaborator.dart';
import 'package:productive_app/model/location.dart';
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
    final doubleType = 'REAL NOT NULL';

    await db.execute('''
    CREATE TABLE $tableTags (
      ${TagFields.id} $idType,
      ${TagFields.name} $textType,
      ${TagFields.isSelected} $boolType,
      ${TagFields.lastUpdated} $textType
    )
    ''');
    await db.execute('''
    CREATE TABLE $tableLocations(
      ${LocationFields.id} $idType,
      ${LocationFields.country} $textType,
      ${LocationFields.lastUpdated} $textType,
      ${LocationFields.locality} $textType,
      ${LocationFields.localizationName} $textType,
      ${LocationFields.street} $textType,
      ${LocationFields.latitude} $doubleType,
      ${LocationFields.longitude} $doubleType,
      ${LocationFields.isSelected} $boolType
    )
    ''');
    await db.execute('''
    CREATE TABLE $tableCollaborators(
      ${CollaboratorsFields.id} $idType,
      ${CollaboratorsFields.collaboratorName} $textType,
      ${CollaboratorsFields.email} $textType,
      ${CollaboratorsFields.lastUpdated} $textType,
      ${CollaboratorsFields.alreadyAsked} $boolType,
      ${CollaboratorsFields.isAskingForPermission} $boolType,
      ${CollaboratorsFields.isSelected} $boolType,
      ${CollaboratorsFields.relationState} $textType,
      ${CollaboratorsFields.receivedPermission} $boolType,
      ${CollaboratorsFields.received} $boolType,
      ${CollaboratorsFields.sentPermission} $boolType
    )
    ''');
    await db.execute('''
    CREATE TABLE LOCALE(
      'id' $idType,
      'localeName' $textType,
      'lastUpdated' $textType
    )
    ''');
    await db.execute('''
    CREATE TABLE GRAPHIC(
      'id' $idType,
      'mode' $textType,
      'lastUpdated' $textType
    )
    ''');
  }

  Future close() async {
    final db = await instance.database;

    db.close();
  }
}
