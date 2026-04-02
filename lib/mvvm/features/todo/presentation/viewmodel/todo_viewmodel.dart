import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../../../../crean_architecture/core/database/database_provider.dart';
import '../../model/todo.dart';
import '../../repository/todo_repository.dart';
import '../../repository/todo_repository_impl.dart';

part 'todo_viewmodel.g.dart'; // build_runner が自動生成

@riverpod
TodoRepository todoRepository(Ref ref) {
  return TodoRepositoryImpl(ref.watch(appDatabaseProvider));
}

// ─── ViewModel ───────────────────────────────────────────
//
// AsyncNotifier を継承することで、非同期の状態管理が簡単になる
// build() が「初期化処理」= 画面表示時に Todo 一覧を取得する

@riverpod
class TodoViewModel extends _$TodoViewModel {
  // Repository への参照（ViewModel のメソッド内で使いまわす）
  TodoRepository get _repository => ref.read(todoRepositoryProvider);

  @override
  Future<List<Todo>> build() async {
    // 初回ビルド時に全件取得（画面表示のたびに呼ばれる）
    return _repository.fetchAll();
  }

  // ─── ビジネスロジック ─────────────────────────────────

  /// Todo を追加する
  /// バリデーション（空文字チェック）はここで行う
  Future<void> addTodo(String title) async {
    final trimmed = title.trim();
    if (trimmed.isEmpty) {
      // バリデーションエラー → state にエラーをセットして View に通知
      state = AsyncError(
        ArgumentError('タイトルは1文字以上入力してください'),
        StackTrace.current,
      );
      return;
    }

    // ローディング状態を示しつつ、前のデータを保持（画面がちらつかない）
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      await _repository.add(trimmed);
      return _repository.fetchAll();
    });
  }

  /// 完了/未完了を切り替える
  Future<void> toggleTodo(int id) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      await _repository.toggle(id);
      return _repository.fetchAll();
    });
  }

  /// Todo を削除する
  Future<void> removeTodo(int id) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      await _repository.remove(id);
      return _repository.fetchAll();
    });
  }

  /// エラー状態をリセットして再取得する
  Future<void> refresh() async {
    ref.invalidateSelf();
    await future;
  }
}
