import 'package:flutter/cupertino.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../../../crean_architecture/core/database/database_provider.dart';
import '../repository/todo_repository.dart';
import '../repository/todo_repository_impl.dart';
import 'todo_state.dart';

part 'todo_notifier.g.dart';

@riverpod
TodoRepository todoRepository(Ref ref) {
  return TodoRepositoryImpl(ref.watch(appDatabaseProvider));
}

// ─── Notifier（同期版：Notifier<TodoState> を使用）────────
//
// AsyncNotifier ではなく Notifier を使うのがこのパターンの特徴。
// ローディング・エラーを AsyncValue に委ねず、
// 自前の TodoState で細かくコントロールする。

@riverpod
class TodoNotifier extends _$TodoNotifier {
  // Repository への参照
  TodoRepository get _repository => ref.read(todoRepositoryProvider);

  @override
  TodoState build() {
    // 同期的に初期 State を返し、すぐに非同期でデータ取得を開始
    Future.microtask(_load); // ← これに変更
    return const TodoState();
  }

  // ─── 内部メソッド：一覧取得 ────────────────────────────

  Future<void> _load() async {
    // isLoading を true にして UI にローディングを通知
    state = state.copyWith(isLoading: true, errorMessage: null);
    try {
      final todos = await _repository.fetchAll();
      state = state.copyWith(todos: todos, isLoading: false);
    } catch (e) {
      debugPrint(e.toString());
      state = state.copyWith(
        isLoading: false,
        errorMessage: 'データの取得に失敗しました: $e',
      );
    }
  }

  // ─── 公開メソッド：外部から呼ばれる操作 ─────────────────

  /// Todo を追加する
  Future<void> addTodo(String title) async {
    // バリデーション
    final trimmed = title.trim();
    if (trimmed.isEmpty) {
      state = state.copyWith(errorMessage: 'タイトルは1文字以上入力してください');
      return;
    }

    // 追加ボタンだけローディング（リスト全体は普通に表示したまま）
    state = state.copyWith(isAdding: true, errorMessage: null);
    try {
      await _repository.add(trimmed);
      final todos = await _repository.fetchAll();
      state = state.copyWith(todos: todos, isAdding: false);
    } catch (e) {
      state = state.copyWith(
        isAdding: false,
        errorMessage: 'Todoの追加に失敗しました: $e',
      );
    }
  }

  /// 完了/未完了を切り替える
  Future<void> toggleTodo(int id) async {
    // ★ 楽観的更新：先に UI を更新してから DB に反映する
    // → ユーザーがチェックした瞬間に視覚的なフィードバックを与える
    final originalTodos = state.todos;
    state = state.copyWith(
      todos: state.todos.map((t) {
        return t.id == id ? t.copyWith(isCompleted: !t.isCompleted) : t;
      }).toList(),
    );

    try {
      await _repository.toggle(id);
    } catch (e) {
      // 失敗したら元の状態に戻す（ロールバック）
      state = state.copyWith(
        todos: originalTodos,
        errorMessage: '更新に失敗しました: $e',
      );
    }
  }

  /// Todo を削除する
  Future<void> removeTodo(int id) async {
    // 楽観的更新：先にリストから除外する
    final originalTodos = state.todos;
    state = state.copyWith(
      todos: state.todos.where((t) => t.id != id).toList(),
    );

    try {
      await _repository.remove(id);
    } catch (e) {
      // 失敗したら元に戻す
      state = state.copyWith(
        todos: originalTodos,
        errorMessage: '削除に失敗しました: $e',
      );
    }
  }

  /// エラーメッセージをクリアする
  void clearError() {
    state = state.copyWith(errorMessage: null);
  }

  /// データを再取得する（pull-to-refresh など）
  Future<void> refresh() => _load();
}
