import 'package:path/path.dart';
import 'package:productive_app/model/appVersion.dart';
import 'package:productive_app/model/attachment.dart';
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

  Future<void> _onUpgrade(Database db, int oldVersion, int newVersion) async {
    if (oldVersion < newVersion) {
      switch (newVersion) {
        case 3:
          await this._version3Update(db);
          break;
        case 4:
          if (oldVersion < 3) {
            await this._version3Update(db);
          }
          await this._version4Update(db);
          break;
        default:
          break;
      }
    }
  }

  Future<void> _version3Update(Database db) async {
    await db.execute("ALTER TABLE $tableUser ADD COLUMN ${UserFields.firstLogin} INTEGER;");
    await db.execute('''
      CREATE TABLE $tableVersion(
        ${VersionFields.version} 'TEXT'
      )
      ''');
  }

  Future<void> _version4Update(Database db) async {
    await Future.wait(
      [
        db.execute("ALTER TABLE $tableAttachment ADD COLUMN ${AttachmentFields.synchronized} INTEGER;"),
        db.execute("ALTER TABLE $tableUser ADD COLUMN ${UserFields.synchronized} INTEGER;"),
      ],
    );
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    return await openDatabase(path, version: 5, onCreate: this._createDB, onUpgrade: this._onUpgrade);
  }

  Future _createDB(Database db, int version) async {
    final idType = 'INTEGER PRIMARY KEY AUTOINCREMENT';
    final integerType = 'INTEGER';
    final boolType = 'INTEGER';
    final textType = 'TEXT';
    final doubleType = 'REAL';
    final blob = 'BLOB';
    final userEmail = 'userMail';

    await db.execute('''
    CREATE TABLE $tableVersion(
      ${VersionFields.version} $textType 
    )
    ''');
    await db.execute('''
    CREATE TABLE $tableTags (
      ${TagFields.id} $idType,
      ${TagFields.name} $textType,
      ${TagFields.isSelected} $boolType,
      ${TagFields.lastUpdated} $textType,
      ${TagFields.uuid} $textType,
      $userEmail $textType
    )
    ''');
    await db.execute('''
    CREATE TABLE $tableAttachment (
      ${AttachmentFields.id} $idType,
      ${AttachmentFields.taskUuid} $integerType,
      ${AttachmentFields.fileName} $textType,
      ${AttachmentFields.toDelete} $boolType,
      ${AttachmentFields.lastUpdated} $textType,
      ${AttachmentFields.localFile} $blob,
      ${AttachmentFields.uuid} $textType,
      ${AttachmentFields.synchronized} $boolType,
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
      ${LocationFields.uuid} $textType,
      ${LocationFields.saved} $boolType,
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
      ${CollaboratorsFields.uuid} $textType,
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
      ${UserFields.localImage} $textType,
      ${UserFields.removed} $boolType,
      ${UserFields.firstLogin} $boolType,
      ${UserFields.synchronized} $boolType,
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
      ${TaskFields.parentUuid} $textType,
      ${TaskFields.childUuid} $textType,
      ${TaskFields.notificationLocalizationUuid} $textType,
      ${TaskFields.notificationLocalizationRadius} $doubleType,
      ${TaskFields.notificationOnEnter} $boolType,
      ${TaskFields.notificationOnExit} $boolType,
      ${TaskFields.lastUpdated} $textType,
      ${TaskFields.uuid} $textType,
      ${TaskFields.taskState} $textType,
      $userEmail $textType
    )
    ''');
  }

  Future close() async {
    final db = await instance.database;

    db.close();
  }
}
