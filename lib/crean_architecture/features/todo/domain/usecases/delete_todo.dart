import '../repositories/todo_repository.dart';

class DeleteTodo {
  final TodoRepository _repository;
  DeleteTodo(this._repository);

  Future<void> call(int id) => _repository.deleteTodo(id);
}
