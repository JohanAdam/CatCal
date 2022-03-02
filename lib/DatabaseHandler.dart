import 'package:sqflite/sqflite.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

import 'model/Item.dart';

class DatabaseHandler {

  static const String DB_NAME = "content";
  
  //Use map for more readability , the key represents the version of db.
  Map<int, String> migrationScripts = {
    1: "CREATE TABLE $DB_NAME(id INTEGER PRIMARY KEY AUTOINCREMENT, content TEXT NOT NULL)",
    2: "ALTER TABLE $DB_NAME ADD isCheck INTEGER"
  };

  Future<Database> initializeDB() async {

    //Get the default database location.
    String path = await getDatabasesPath();

    //Count the number of scripts to define the version of the database.
    int noMigrationScripts = migrationScripts.length;

    return openDatabase(
      //Join the default path with the db file name.
      join(path, 'test.db'),
      version: noMigrationScripts,
      //If the database does not exist, onCreate executes all the sql requests of the "migrationScripts" map.
      onCreate: (database, version) async {
        // await database.execute(
        //   "CREATE TABLE $DB_NAME(id INTEGER PRIMARY KEY AUTOINCREMENT, content TEXT NOT NULL)",
        // );
        for (int i = 1; i <= noMigrationScripts; i++) {
          await database.execute(migrationScripts[i]!);
        }
      },
      ///If the database exists but the version of the database is different 
      ///from the version defined in parameter, onUpgrade will execute all sql requests greater than the old version
      onUpgrade: (database, oldVersion, newVersion) async {
        for (int i = oldVersion + 1; i <= newVersion; i++) {
          await database.execute(migrationScripts[i]!);
        }
      },
    );
  }

  //Total number of items in db.
  Future<int> totalCount() async {
    int count = 0;
  
    final Database db = await initializeDB();
    count = Sqflite.firstIntValue(
      await db.rawQuery('SELECT COUNT(*) FROM content')
    )!;

    return count;
  }

  //Insert list of data.
  Future<int> insertContents(List<Item> items) async {
    int result = 0;
    final Database db = await initializeDB();
    for (var item in items) {
      result = await db.insert(DB_NAME, item.toMap());
    }
    return result;
  }

  //Insert item and return the last id that inserted.
  Future<int> insertContent(Item item) async {
    int result = 0;
    final Database db = await initializeDB();
    result = await db.insert(DB_NAME, item.toMap());
    return result;
  }

  //Update item and return the last id that inserted.
  Future<int> updateContent(Item item) async {
    final Database db = await initializeDB();
    return await db.update(DB_NAME, 
      item.toMap(),
      where: "id = ?",
      whereArgs: [item.id]);
  }

  //Retrieve all data.
  Future<List<Item>> retrieveItems() async {
    
    final Database db = await initializeDB();

    final List<Map<String, Object?>> queryResult = await db.query(DB_NAME);

    return queryResult.map((e) => Item.fromMap(e)).toList();
  }

  //Delete data.
  Future<void> deleteItem(int id) async {

    final db = await initializeDB();

    await db.delete(
      DB_NAME,
      where: "id = ?",
      whereArgs: [id],
    );

  }

  //Delete all data.
  Future<void> deleteAll() async {

    final db = await initializeDB();

    await db.delete(
      DB_NAME
    );

  }

}