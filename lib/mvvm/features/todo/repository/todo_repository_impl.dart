import 'package:drift/drift.dart';

import '../../../../crean_architecture/core/database/app_database.dart';
import '../model/todo.dart';
import 'package:sample_todo_app/mvvm/features/todo/repository/todo_repository.dart';

class TodoRepositoryImpl implements TodoRepository {
  final AppDatabase _db;

  TodoRepositoryImpl(this._db);

  @override
  Future<List<Todo>> fetchAll() async {
    final rows = await (_db.select(_db.todoDatas)
          ..orderBy([(t) => OrderingTerm.desc(t.createdAt)]))
        .get();
    return rows.map(_toModel).toList();
  }

  @override
  Future<void> add(String title) {
    return _db.into(_db.todoDatas).insert(
          TodoDatasCompanion.insert(
            title: title,
            createdAt: DateTime.now(),
          ),
        );
  }

  @override
  Future<void> remove(int id) {
    return (_db.delete(_db.todoDatas)..where((t) => t.id.equals(id))).go();
  }

  @override
  Future<void> toggle(int id) {
    return _db.transaction(
      () async {
        final todo = await (_db.select(_db.todoDatas)
              ..where((t) => t.id.equals(id)))
            .getSingle();
        await (_db.update(_db.todoDatas)..where((t) => t.id.equals(id))).write(
          TodoDatasCompanion(isCompleted: Value(!todo.isCompleted)),
        );
      },
    );
  }

  // DB の行データ → Model への変換
  Todo _toModel(TodoData data) => Todo(
        id: data.id,
        title: data.title,
        isCompleted: data.isCompleted,
        createdAt: data.createdAt,
      );
}
