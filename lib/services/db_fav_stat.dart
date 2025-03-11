// SQLite : Gestion favoris/stats 
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DbFavStat {
  static final DbFavStat instance = DbFavStat._init();
  static Database? _database;

  DbFavStat._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('quiz_app.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    return await openDatabase(path, version: 1, onCreate: _createDB);
  }

  Future<void> _createDB(Database db, int version) async {
    await db.execute('''
      CREATE TABLE favorites (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        question TEXT NOT NULL
      )
    ''');

    await db.execute('''
      CREATE TABLE stats (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        current_series INTEGER DEFAULT 0,
        max_series_win INTEGER DEFAULT 0
      )
    ''');

    await db.execute('''
      CREATE TABLE difficulty_stats (
        difficulty TEXT PRIMARY KEY,
        correct INTEGER DEFAULT 0,
        incorrect INTEGER DEFAULT 0
      )
    ''');

    await db.insert('stats', {
      'id': 1,
      'current_series': 0,
      'max_series_win': 0,
    });

    await db.insert('difficulty_stats', {'difficulty': 'Facile', 'correct': 0, 'incorrect': 0});
    await db.insert('difficulty_stats', {'difficulty': 'Intermédiaire', 'correct': 0, 'incorrect': 0});
    await db.insert('difficulty_stats', {'difficulty': 'Difficile', 'correct': 0, 'incorrect': 0});
  }

  Future<int> addFavorite(String question) async {
    final db = await database;
    return await db.insert('favorites', {'question': question});
  }

  Future<int> removeFavorite(int id) async {
    final db = await database;
    return await db.delete('favorites', where: 'id = ?', whereArgs: [id]);
  }

  Future<List<Map<String, dynamic>>> getFavorites() async {
    final db = await database;
    return await db.query('favorites');
  }

  Future<int> updateStats(int currentSeries, int maxSeriesWin) async {
    final db = await database;
    return await db.update(
      'stats',
      {
        'current_series': currentSeries,
        'max_series_win': maxSeriesWin,
      },
      where: 'id = ?',
      whereArgs: [1],
    );
  }

  Future<Map<String, dynamic>?> getStats() async {
    final db = await database;
    final result = await db.query('stats', where: 'id = ?', whereArgs: [1]);
    return result.isNotEmpty ? result.first : null;
  }

  Future<int> countFavorites() async {
    final db = await database;
    final result = await db.rawQuery('SELECT COUNT(*) FROM favorites');
    return result.isNotEmpty ? Sqflite.firstIntValue(result) ?? 0 : 0;
  }

  Future<int> updateDifficultyStat(String difficulty, {required bool isCorrect}) async {
    final db = await database;
    final result = await db.query('difficulty_stats', where: 'difficulty = ?', whereArgs: [difficulty]);
    if (result.isNotEmpty) {
      final currentData = result.first;
      int correct = currentData['correct'] as int;
      int incorrect = currentData['incorrect'] as int;
      if (isCorrect) {
        correct++;
      } else {
        incorrect++;
      }
      return await db.update(
        'difficulty_stats',
        {'correct': correct, 'incorrect': incorrect},
        where: 'difficulty = ?',
        whereArgs: [difficulty],
      );
    }
    return 0;
  }

  Future<Map<String, Map<String, int>>> getAllDifficultyStats() async {
    final db = await database;
    final result = await db.query('difficulty_stats');
    Map<String, Map<String, int>> stats = {};
    for (var row in result) {
      stats[row['difficulty'] as String] = {
        'correct': row['correct'] as int,
        'incorrect': row['incorrect'] as int,
      };
    }
    return stats;
  }
}
