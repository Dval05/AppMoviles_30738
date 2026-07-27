import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class SQLiteService {
  static Future<Database> init() async {
    final databasePath = await getDatabasesPath();
    final path = join(databasePath, 'contactos.db');

    return openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE contactos(
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            nombre TEXT NOT NULL,
            telefono TEXT NOT NULL,
            correo TEXT NOT NULL
          )
        ''');
      },
    );
  }
}
