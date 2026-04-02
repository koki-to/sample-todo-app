import 'package:drift/drift.dart';

import '../../../core/database/app_database.dart';

// Drift（SQLite）への「生の」アクセスをここにまとめる
// → Repository はこのクラスを通じてのみ DB に触れる
class TodoLocalDatasource {
  final AppDatabase _db;

  TodoLocalDatasource(this._db);

  // 全件取得（作成日時の降順）
  Future<List<TodoData>> getTodos() {
    return (_db.select(_db.todoDatas)
          ..orderBy([(t) => OrderingTerm.desc(t.createdAt)]))
        .get();
  }

  // 新規追加
  Future<void> addTodo(String title) {
    return _db.into(_db.todoDatas).insert(
          TodoDatasCompanion.insert(
            title: title,
            createdAt: DateTime.now(),
          ),
        );
  }

  // 完了/未完了の切り替え（トランザクションで整合性を保証）
  Future<void> toggleTodo(int id) {
    return _db.transaction(() async {
      final todo = await (_db.select(_db.todoDatas)
            ..where((t) => t.id.equals(id)))
          .getSingle();
      await (_db.update(_db.todoDatas)..where((t) => t.id.equals(id))).write(
        TodoDatasCompanion(isCompleted: Value(!todo.isCompleted)),
      );
    });
  }

  // 削除
  Future<void> deleteTodo(int id) {
    return (_db.delete(_db.todoDatas)..where((t) => t.id.equals(id))).go();
  }
}
