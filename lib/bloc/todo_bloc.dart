import 'dart:async';
import 'dart:core';


import 'package:bloc_and_sembast/data/todo.dart';
import 'package:bloc_and_sembast/data/todo_db.dart';

class TodoBloc {
  TodoDb db;
  List<Todo> todoList;


  TodoBloc() {
    db = TodoDb();
    getTodos();
    _todosStreamController.stream.listen(returnTodos);
    _todoInsertController.stream.listen(_addTodo);
    _todoUpdateController.stream.listen(_updateTodo);
    _todoDeleteController.stream.listen(_deleteTodo);

  }

  dispose() {
    _todosStreamController.close();
    _todoInsertController.close();
    _todoUpdateController.close();
    _todoDeleteController.close();
  }

  final _todosStreamController = StreamController<List<Todo>>.broadcast();
  final _todoInsertController = StreamController<Todo>();
  final _todoUpdateController = StreamController<Todo>();
  final _todoDeleteController = StreamController<Todo>();

  Stream<List<Todo>> get todos => _todosStreamController.stream;
  StreamSink<List<Todo>> get todosSink => _todosStreamController.sink;
  StreamSink<Todo> get todosInsertSink => _todoInsertController.sink;
  StreamSink<Todo> get todosUpdateSink => _todoUpdateController.sink;
  StreamSink<Todo> get todosDeleteSink => _todoDeleteController.sink;

  Future getTodos() async {
    List<Todo> todos = await db.getTodos();
    todoList = todos;
    todosSink.add(todos);
  }

  List<Todo> returnTodos(todos) => todos;

  void _deleteTodo(Todo todo) => {
    db.deleteTodo(todo).then((_) {
      getTodos();
    })
  };

  void _updateTodo(Todo todo) => {
    db.updateTodo(todo).then((_) {
      getTodos();
    })
  };

  void _addTodo(Todo todo) => {
    db.insertTodo(todo).then((_) {
      getTodos();
    })
  };
  // StreamSink

}
