import 'package:sample_todo_app/crean_architecture/features/todo/domain/repositories/todo_repository.dart';

import '../entities/todo.dart';

class GetTodos {
  final TodoRepository _repository;

  GetTodos(this._repository);

  Future<List<Todo>> call() {
    return _repository.getTodoList();
  }
}
