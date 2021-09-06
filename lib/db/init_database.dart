import 'package:path/path.dart';
import 'package:productive_app/model/collaborator.dart';
import 'package:productive_app/model/collaboratorTask.dart';
import 'package:productive_app/model/location.dart';
import 'package:productive_app/model/settings.dart';
import 'package:productive_app/model/tag.dart';
import 'package:productive_app/model/task.dart';
import 'package:productive_app/model/user.dart';
import 'package:sqflite/sqflite.dart';

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
    final integerType = 'INTEGER';
    final boolType = 'BOOLEAN';
    final textType = 'TEXT';
    final doubleType = 'REAL';
    final blob = 'BLOB';
    final userEmail = 'userMail';

    await db.execute('''
    CREATE TABLE $tableTags (
      ${TagFields.id} $idType,
      ${TagFields.name} $textType,
      ${TagFields.isSelected} $boolType,
      ${TagFields.lastUpdated} $textType,
      $userEmail $textType
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
      ${LocationFields.isSelected} $boolType,
      $userEmail $textType
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
      ${CollaboratorsFields.sentPermission} $boolType,
      $userEmail $textType
    )
    ''');
    await db.execute('''
    CREATE TABLE LOCALE(
      'id' $idType,
      'localeName' $textType,
      'lastUpdated' $textType,
      $userEmail $textType
    )
    ''');
    await db.execute('''
    CREATE TABLE GRAPHIC(
      'id' $idType,
      'mode' $textType,
      'lastUpdated' $textType,
      $userEmail $textType
    )
    ''');
    await db.execute('''
    CREATE TABLE $tableUser(
      ${UserFields.id} $idType,
      ${UserFields.email} $textType,
      ${UserFields.firstName} $textType,
      ${UserFields.lastName} $textType,
      ${UserFields.lastUpdatedImage} $textType,
      ${UserFields.lastUpdatedName} $textType,
      ${UserFields.userType} $textType,
      ${UserFields.localImage} $blob,
      ${UserFields.removed} $boolType,
      $userEmail $textType
    )
    ''');
    await db.execute('''
    CREATE TABLE $tableSettings(
      ${SettingsFields.id} $idType,
      ${SettingsFields.collaborators} $textType,
      ${SettingsFields.lastUpdated} $textType,
      ${SettingsFields.locations} $textType,
      ${SettingsFields.priorities} $textType,
      ${SettingsFields.tags} $textType,
      ${SettingsFields.showOnlyDelegated} $boolType,
      ${SettingsFields.showOnlyUnfinished} $boolType,
      ${SettingsFields.showOnlyWithLocalization} $boolType,
      ${SettingsFields.sortingMode} $integerType,
      $userEmail $textType      
    )
    ''');
    await db.execute('''
    CREATE TABLE $tableCollaboratorTask(
      ${CollaboratorTaskFields.id} $idType,
      ${CollaboratorTaskFields.title} $textType,
      ${CollaboratorTaskFields.description} $textType,
      ${CollaboratorTaskFields.startDate} $textType,
      ${CollaboratorTaskFields.endDate} $textType,
      ${CollaboratorTaskFields.lastUpdated} $textType,
      $userEmail $textType
    )
    ''');
    await db.execute('''
    CREATE TABLE $tableTask(
      ${TaskFields.id} $idType,
      ${TaskFields.position} $doubleType,
      ${TaskFields.title} $textType,
      ${TaskFields.description} $textType,
      ${TaskFields.priority} $textType,
      ${TaskFields.localization} $textType,
      ${TaskFields.delegatedEmail} $textType,
      ${TaskFields.taskStatus} $textType,
      ${TaskFields.supervisorEmail} $textType,
      ${TaskFields.startDate} $textType,
      ${TaskFields.endDate} $textType,
      ${TaskFields.tags} $textType,
      ${TaskFields.done} $boolType,
      ${TaskFields.isDelegated} $boolType,
      ${TaskFields.isCanceled} $boolType,
      ${TaskFields.parentId} $integerType,
      ${TaskFields.childId} $integerType,
      ${TaskFields.notificationLocalizationId} $integerType,
      ${TaskFields.notificationLocalizationRadius} $doubleType,
      ${TaskFields.notificationOnEnter} $boolType,
      ${TaskFields.notificationOnExit} $boolType,
      ${TaskFields.lastUpdated} $textType,
      $userEmail $textType
    )
    ''');
  }

  Future close() async {
    final db = await instance.database;

    db.close();
  }
}
