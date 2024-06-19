import 'package:path/path.dart' as path;
import 'package:riverpod/riverpod.dart';
import 'package:sqflite/sqflite.dart' as sql;
import 'package:sqflite/sqlite_api.dart';
import 'package:todolist/objects/item.dart';

class ListItemNotifier extends StateNotifier<List<ListItem>> {
  ListItemNotifier() : super(const []);
  TaskCategory parseCategory(String categoryString) {
    return TaskCategory.values.firstWhere(
      (e) => e.toString().split('.').last == categoryString,
      orElse: () => TaskCategory.others, // Default or error handling
    );
  }

  Future<Database> _getDatabase() async {
    final dbpath = await sql.getDatabasesPath();
    final db = await sql.openDatabase(
      path.join(dbpath, 'todolist.db'),
      onCreate: (db, version) {
        return db.execute(
            'CREATE TABLE tasks(title TEXT,description TEXT,category TEXT,completed INTEGER)');
      },
      version: 1,
    );
    return db;
  }

  Future<void> addItem(
      String title, String description, TaskCategory category) async {
    final newTask = ListItem(
      description: description,
      title: title,
      completed: false,
      category: category,
    );
    final db = await _getDatabase();
    await db.insert('tasks', {
      'title': newTask.title,
      'description': newTask.description,
      'completed': newTask.completed ? 1 : 0,
      'category': newTask.category.toString().split('.').last,
    });
    state = [newTask, ...state];
  }

  Future<void> loadItems() async {
    final db = await _getDatabase();
    final data = await db.query('tasks');
    print(data);
    final List<ListItem> tasks = data.map((row) {
      return ListItem(
        title: row['title'] as String,
        description: row['description'] as String,
        completed: row['completed'] == 1,
        category:
            parseCategory(row['category'] as String), // Handle INTEGER 1 or 0
      );
    }).toList();
    state = tasks;
  }

  void updateItem(int index, String newTitle, String newDescription,
      TaskCategory newCategory) async {
    final item = state[index];
    final updatedItem = ListItem(
      title: newTitle,
      description: newDescription,
      completed: item.completed,
      category: newCategory,
    );

    state = [
      ...state.sublist(0, index),
      updatedItem,
      ...state.sublist(index + 1),
    ];

    final db = await _getDatabase();
    await db.update(
      'tasks',
      {
        'title': newTitle,
        'description': newDescription,
        'category': newCategory.toString().split('.').last,
      },
      where: 'title = ? AND description = ? AND category = ?',
      whereArgs: [
        item.title,
        item.description,
        item.category.toString().split('.').last
      ],
    );

    loadItems();
  }

  Future<void> toggleCompleted(int index) async {
    // Toggle the completed status in the in-memory state
    final newItem = ListItem(
      title: state[index].title,
      description: state[index].description,
      category: state[index].category,
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
