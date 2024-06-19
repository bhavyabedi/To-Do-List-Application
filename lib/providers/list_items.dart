import 'package:path/path.dart' as path;
import 'package:riverpod/riverpod.dart';
import 'package:sqflite/sqflite.dart' as sql;
import 'package:sqflite/sqlite_api.dart';
import 'package:todolist/objects/item.dart';

class ListItemNotifier extends StateNotifier<List<ListItem>> {
  ListItemNotifier() : super(const []);

  Future<Database> _getDatabase() async {
    final dbpath = await sql.getDatabasesPath();
    final db = await sql.openDatabase(
      path.join(dbpath, 'todolist.db'),
      onCreate: (db, version) {
        return db.execute(
            'CREATE TABLE tasks(title TEXT,description TEXT,completed INTEGER)');
      },
      version: 1,
    );
    return db;
  }

  Future<void> toggleCompleted(int index) async {
    // Toggle the completed status in the in-memory state
    final newItem = ListItem(
      title: state[index].title,
      description: state[index].description,
      completed: !state[index].completed, // Toggle completed status
    );

    state = [
      ...state.sublist(0, index),
      newItem,
      ...state.sublist(index + 1),
    ];

    // Update the database with the new completed status
    final db = await _getDatabase();
    await db.update(
      'tasks',
      {
        'completed': newItem.completed ? 1 : 0, // Use INTEGER 1 or 0
      },
      where: 'title = ?',
      whereArgs: [newItem.title],
    );

    // Optionally reload items after update
    await loadItems();
  }

  Future<void> loadItems() async {
    final db = await _getDatabase();
    final data = await db.query('tasks');
    final List<ListItem> tasks = data.map((row) {
      return ListItem(
        title: row['title'] as String,
        description: row['description'] as String,
        completed: row['completed'] == 1, // Handle INTEGER 1 or 0
      );
    }).toList();
    state = tasks;
  }

  Future<void> addItem(String title, String description) async {
    final newTask =
        ListItem(description: description, title: title, completed: false);
    final db = await _getDatabase();
    await db.insert('tasks', {
      'title': newTask.title,
      'description': newTask.description,
      'completed': newTask.completed ? 1 : 0, // Handle INTEGER 1 or 0
    });
    state = [newTask, ...state];
  }

  void updateItem(int index, String title, String description) async {
    final item = state[index];
    final updatedItem = ListItem(
      title: title,
      description: description,
      completed: item.completed,
    );

    state = [
      ...state.sublist(0, index),
      updatedItem,
      ...state.sublist(index + 1),
    ];

    final db = await _getDatabase();
    await db.update(
      'tasks',
      {'title': title, 'description': description},
      where: 'title = ? AND description = ?',
      whereArgs: [item.title, item.description],
    );

    loadItems();
  }

  void deleteItem(int index) async {
    final item = state[index];
    state = List<ListItem>.from(state)..removeAt(index);
    final db = await _getDatabase();
    await db.delete(
      'tasks',
      where: 'title = ?',
      whereArgs: [item.title],
    );
    loadItems();
  }
}

final listItemsProvider =
    StateNotifierProvider<ListItemNotifier, List<ListItem>>(
        (ref) => ListItemNotifier());
