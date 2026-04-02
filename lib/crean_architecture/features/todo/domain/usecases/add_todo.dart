import '../repositories/todo_repository.dart';

class AddTodo {
  final TodoRepository _repository;
  AddTodo(this._repository);

  Future<void> call(String title) async {
    // ビジネスルール：空文字・空白のみは登録できない
    final trimmed = title.trim();
    if (trimmed.isEmpty) {
      throw ArgumentError('タイトルは1文字以上入力してください');
    }
    await _repository.addTodo(trimmed);
  }
}
