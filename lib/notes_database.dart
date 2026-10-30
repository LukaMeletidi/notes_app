import 'package:notes_app/note.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class NotesDatabase {
  static Database? _database;

  static Future<Database> _getDatabase() async {
    if (_database != null) return _database!;

    final dbPath = await getDatabasesPath();
    _database = await openDatabase(
      join(dbPath, 'notes.db'),
      version: 1,
      onCreate: (db, version) => db.execute(
        'CREATE TABLE notes(id INTEGER PRIMARY KEY AUTOINCREMENT, title TEXT, text TEXT)',
      ),
    );
    return _database!;
  }

  static Future<Note> insertNote(Note note) async {
    final db = await _getDatabase();
    final id = await db.insert('notes', note.toMap());
    return Note(id: id, title: note.title, text: note.text);
  }

  static Future<List<Note>> getNotes() async {
    final db = await _getDatabase();
    final rows = await db.query('notes', orderBy: 'id ASC');
    return rows.map((row) => Note.fromMap(row)).toList();
  }

  static Future<void> deleteNote(int id) async {
    final db = await _getDatabase();
    await db.delete('notes', where: 'id = ?', whereArgs: [id]);
  }

  static Future<void> updateNote(Note note) async {
    final db = await _getDatabase();
    await db.update(
      'notes',
      note.toMap(),
      where: 'id = ?',
      whereArgs: [note.id],
    );
  }
}
