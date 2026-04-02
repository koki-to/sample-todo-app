import 'package:sample_todo_app/crean_architecture/features/todo/datasources/todo_local_datasource.dart';
import 'package:sample_todo_app/crean_architecture/features/todo/domain/entities/todo.dart';
import 'package:sample_todo_app/crean_architecture/features/todo/domain/repositories/todo_repository.dart';

import '../../../../core/database/app_database.dart';

class TodoRepositoryImpl implements TodoRepository {
  final TodoLocalDatasource _datasource;

  TodoRepositoryImpl(this._datasource);

  @override
  Future<List<Todo>> getTodoList() async {
    final todoList = await _datasource.getTodos();
    return todoList.map(_toEntity).toList();
  }

  @override
  Future<void> addTodo(String title) {
    return _datasource.addTodo(title);
  }

  @override
  Future<void> deleteTodo(int id) {
    return _datasource.deleteTodo(id);
  }

  @override
  Future<void> toggleTodo(int id) {
    return _datasource.toggleTodo(id);
  }

  // DB の TodoData → Domain の Todo に変換するヘルパー
  Todo _toEntity(TodoData data) => Todo(
        id: data.id,
        title: data.title,
        isCompleted: data.isCompleted,
        createdAt: data.createdAt,
      );
}
