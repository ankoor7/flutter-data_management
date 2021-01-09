import 'package:bloc_and_sembast/data/todo.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart';
import 'package:sembast/sembast.dart';
import 'package:sembast/sembast_io.dart';

class TodoDb {
  static final TodoDb _singleton = TodoDb._internal();
  static final String id = 'id';
  static final String priority = 'priority';
  final store = intMapStoreFactory.store('todos');

  DatabaseFactory dbFactory = databaseFactoryIo;
  Database _database;

  TodoDb._internal();

  factory TodoDb() {
    return _singleton;
  }

  Future<Database> get database async {
    if (_database == null) {
      await _openDb().then((db) {
        _database = db;
      });
    }

    return _database;
  }

  Future<Database> _openDb() async {
    final docsPath = await getApplicationDocumentsDirectory();
    final dbPath = join(docsPath.path, 'todos.db');

    return dbFactory.openDatabase(dbPath);
  }

  Future insertTodo(Todo todo) async {
    await store.add(_database, todo.toMap());
  }

  Finder finderById(Todo todo) => Finder(filter: Filter.byKey(todo.id));
  final Finder sorterFoView = Finder(sortOrders: [
    SortOrder(priority),
    SortOrder(id),
  ]);

  Future<List<Todo>> getTodos() async {
    await database;
    final todosSnapshot = await store.find(_database, finder: sorterFoView);
    return todosSnapshot.map((snapshot) {
      final todo = Todo.fromMap(snapshot.value);
      todo.id = snapshot.key;
      return todo;
    }).toList();
  }

  Future updateTodo(Todo todo) async {
    await store.update(_database, todo.toMap(), finder: finderById(todo));
  }

  Future deleteTodo(Todo todo) async {
    await store.delete(_database, finder: finderById(todo));
  }

  Future deleteAll() async {
    await store.delete(_database);
  }

}
