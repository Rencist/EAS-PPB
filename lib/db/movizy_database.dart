import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:ets_ppb/model/movizy.dart';

class MoviziesDatabase {
  static final MoviziesDatabase instance = MoviziesDatabase._init();

  static Database? _database;

  MoviziesDatabase._init();

  Future<Database?> get database async {
    if (_database != null) return _database;

    _database = await _initDB('movizies2.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    return await openDatabase(path, version: 1, onCreate: _createDB);
  }

  Future _createDB(Database db, int version) async {
    const idType = 'INTEGER PRIMARY KEY AUTOINCREMENT';
    const stringType = 'STRING NOT NULL';

    await db.execute('''
    CREATE TABLE $tableMovizies (
      ${MovizyFields.id} $idType,
      ${MovizyFields.title} $stringType,
      ${MovizyFields.picture} $stringType,
      ${MovizyFields.description} $stringType,
      ${MovizyFields.time} $stringType
    )
    ''');
  }

  Future<Movizy> create(Movizy note) async {
    final db = await instance.database;

    final id = await db?.insert(tableMovizies, note.toJson());
    return note.copy(id: id);
  }

  Future<Movizy> readMovizy(int id) async {
    final db = await instance.database;
    final maps = await db?.query(tableMovizies,
        columns: MovizyFields.values,
        where: '${MovizyFields.id} = ?',
        whereArgs: [id]);

    if (maps!.isNotEmpty) {
      return Movizy.fromJson(maps.first);
    } else {
      throw Exception('ID $id Not Found');
    }
  }

  Future<List<Movizy>> readAllMovizies() async {
    final db = await instance.database;
    const orderBy = '${MovizyFields.time} ASC';
    final result = await db?.query(tableMovizies, orderBy: orderBy);
    return result!.map((json) => Movizy.fromJson(json)).toList();
  }

  Future<Future<int>?> update(Movizy note) async {
    final db = await instance.database;

    return db?.update(tableMovizies, note.toJson(),
        where: '${MovizyFields.id} = ?', whereArgs: [note.id]);
  }

  Future<int?> delete(int id) async {
    final db = await instance.database;

    return await db?.delete(tableMovizies,
        where: '${MovizyFields.id} = ?', whereArgs: [id]);
  }

  Future close() async {
    final db = await instance.database;

    db?.close();
  }
}
