import '../entities/todo.dart';

abstract interface class TodoRepository {
  Future<List<Todo>> getTodoList();
  Future<void> addTodo(String title);
  Future<void> toggleTodo(int id);
  Future<void> deleteTodo(int id);
}
