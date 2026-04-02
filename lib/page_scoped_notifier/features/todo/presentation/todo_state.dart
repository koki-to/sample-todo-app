import 'package:freezed_annotation/freezed_annotation.dart';
import '../model/todo.dart';

part 'todo_state.freezed.dart';

// ─── 画面全体の UI 状態を1つのクラスで表現 ─────────────────
//
// このクラスを見るだけで「この画面が持ちうる状態」が全て分かる。
// AsyncValue<List<Todo>> と違い、ローディングやエラーを
// 操作ごとに細かくコントロールできる。

@freezed
abstract class TodoState with _$TodoState {
  const factory TodoState({
    // Todo のリスト（空リストが初期値）
    @Default([]) List<Todo> todos,

    // 初回ロード中かどうか（true のとき全画面インジケーター表示）
    @Default(false) bool isLoading,

    // Todo 追加ボタンだけをローディング中にしたいとき用
    @Default(false) bool isAdding,

    // 何かしらのエラーメッセージ（null = エラーなし）
    @Default(null) String? errorMessage,
  }) = _TodoState;

  // カスタム getter は private constructor が必要（Freezed の仕様）
  const TodoState._();

  // ─── 派生値（getter）──────────────────────────────────
  // State から計算できる値はここに書く（View 側を薄くできる）

  /// 完了済みの件数
  int get completedCount => todos.where((t) => t.isCompleted).length;

  /// 未完了の件数
  int get uncompletedCount => todos.length - completedCount;

  /// 何も表示するものがないか
  bool get isEmpty => todos.isEmpty;

  /// ローディング中か追加中のいずれかが true のとき操作をブロック
  bool get isBusy => isLoading || isAdding;
}
