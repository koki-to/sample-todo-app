import '../repositories/todo_repository.dart';

class ToggleTodo {
  final TodoRepository _repository;
  ToggleTodo(this._repository);

  Future<void> call(int id) => _repository.toggleTodo(id);
}
