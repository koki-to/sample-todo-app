import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../core/database/database_provider.dart';
import '../../datasources/todo_local_datasource.dart';
import '../../domain/entities/todo.dart';
import '../../domain/repositories/todo_repository.dart';
import '../../domain/repositories/todo_repository_impl.dart';
import '../../domain/usecases/add_todo.dart';
import '../../domain/usecases/delete_todo.dart';
import '../../domain/usecases/get_todos.dart';
import '../../domain/usecases/toggle_todo.dart';

part 'todo_provider.g.dart';

@riverpod
TodoLocalDatasource todoLocalDatasource(Ref ref) {
  return TodoLocalDatasource(ref.watch(appDatabaseProvider));
}

@riverpod
TodoRepository todoRepository(Ref ref) {
  return TodoRepositoryImpl(ref.watch(todoLocalDatasourceProvider));
}

// ─── UseCase の Provider ─────────────────────────────────

@riverpod
GetTodos getTodos(Ref ref) => GetTodos(ref.watch(todoRepositoryProvider));

@riverpod
AddTodo addTodo(Ref ref) => AddTodo(ref.watch(todoRepositoryProvider));

@riverpod
ToggleTodo toggleTodo(Ref ref) => ToggleTodo(ref.watch(todoRepositoryProvider));

@riverpod
DeleteTodo deleteTodo(Ref ref) => DeleteTodo(ref.watch(todoRepositoryProvider));

@riverpod
class TodoNotifier extends _$TodoNotifier {
  @override
  Future<List<Todo>> build() async {
    return ref.watch(getTodosProvider).call();
  }

  Future<void> addTodo(String title) async {
    await ref.watch(addTodoProvider).call(title);
    ref.invalidateSelf();
    await future;
  }

  Future<void> toggleTodo(int id) async {
    await ref.watch(toggleTodoProvider).call(id);
    ref.invalidateSelf();
    await future;
  }

  Future<void> deleteTodo(int id) async {
    await ref.watch(deleteTodoProvider).call(id);
    ref.invalidateSelf();
    await future;
  }
}
