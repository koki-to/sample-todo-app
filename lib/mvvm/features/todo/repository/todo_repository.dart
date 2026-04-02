import '../model/todo.dart';

abstract interface class TodoRepository {
  Future<List<Todo>> fetchAll();
  Future<void> add(String title);
  Future<void> toggle(int id);
  Future<void> remove(int id);
}
