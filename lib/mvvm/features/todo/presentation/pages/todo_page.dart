import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sample_todo_app/mvvm/features/todo/presentation/viewmodel/todo_viewmodel.dart';

import '../widgets/add_todo_dialog.dart';
import '../widgets/todo_list_item.dart';

class MvvmTodoPage extends ConsumerWidget {
  const MvvmTodoPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final todoList = ref.watch(todoViewModelProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Todoリスト'),
        centerTitle: true,
        actions: [
          if (todoList.hasValue)
            Padding(
              padding: const EdgeInsets.only(right: 16),
              child: Center(
                child: Text(
                  '${todoList.value!.where((todo) => !todo.isCompleted).length} / '
                  '${todoList.value!.length} 完了',
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              ),
            )
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showAddDialog(context, ref),
        tooltip: 'Todoを追加',
        child: const Icon(Icons.add),
      ),
      body: todoList.when(
        // 読み込み中
        loading: () => const Center(child: CircularProgressIndicator()),

        // エラー発生時
        error: (error, stack) => Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.error_outline, size: 48, color: Colors.red),
              const SizedBox(height: 16),
              Text(
                'エラーが発生しました\n$error',
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 16),
              ElevatedButton.icon(
                onPressed: () => ref.invalidate(todoViewModelProvider),
                icon: const Icon(Icons.refresh),
                label: const Text('再読み込み'),
              ),
            ],
          ),
        ),
        // データ取得成功
        data: (todos) {
          if (todos.isEmpty) {
            return const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.check_circle_outline,
                      size: 64, color: Colors.grey),
                  SizedBox(height: 16),
                  Text(
                    'Todoがありません\n右下のボタンから追加してください',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 16, color: Colors.grey),
                  ),
                ],
              ),
            );
          }
          return ListView.builder(
            padding: const EdgeInsets.symmetric(vertical: 8),
            itemCount: todos.length,
            itemBuilder: (context, index) {
              final todo = todos[index];
              return TodoListItem(
                key: ValueKey(todo.id), // リスト更新の最適化
                todo: todo,
                onToggle: () => ref
                    .read(todoViewModelProvider.notifier)
                    .toggleTodo(todo.id),
                onDelete: () => ref
                    .read(todoViewModelProvider.notifier)
                    .removeTodo(todo.id),
              );
            },
          );
        },
      ),
    );
  }

  Future<void> _showAddDialog(BuildContext context, WidgetRef ref) async {
    await showDialog<void>(
      context: context,
      builder: (context) => AddTodoDialog(
        onAdd: (title) =>
            ref.read(todoViewModelProvider.notifier).addTodo(title),
      ),
    );
  }
}
