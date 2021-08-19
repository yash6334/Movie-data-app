import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class NoteProvider {
  static Database db;

  static Future open() async {
    db = await openDatabase(
      join(await getDatabasesPath(), 'notes.db'),
      version: 1,
      onCreate: (Database db, int version) async {
        await db.execute('''
      create table Notes(
        id integer primary key autoincrement,
        title text not null,
        text text not null,
        image text
        );
    ''');
      },
    );
  }

  static Future<List<Map<String, dynamic>>> getNoteList() async {
    if (db == null) await open();
    return db.query('Notes');
  }

  static Future insertedNote(Map<String, dynamic> note) async {
    db.insert('Notes', note);
  }

  static Future updateNote(Map<String, dynamic> note, int id) async {
    db.update(
      'Notes',
      note,
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  static Future deleteNode(int id) async {
    db.delete(
      'Notes',
      where: 'id = ?',
      whereArgs: [id],
    );
  }
}
