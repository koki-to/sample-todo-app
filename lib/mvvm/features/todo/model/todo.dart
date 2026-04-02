import 'package:freezed_annotation/freezed_annotation.dart';

part 'todo.freezed.dart';

@freezed
abstract class Todo with _$Todo {
  const factory Todo({
    required int id,
    required String title,
    required bool isCompleted,
    required DateTime createdAt,
  }) = _Todo;
}
