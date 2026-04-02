import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../model/todo.dart';
import 'todo_notifier.dart';

class PageScopedTodoPage extends ConsumerWidget {
  const PageScopedTodoPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // TodoState を丸ごと監視する
    final state = ref.watch(todoProvider);
    final notifier = ref.read(todoProvider.notifier);

    return Scaffold(
      appBar: AppBar(
        title: const Text('📝 Todoリスト'),
        centerTitle: true,
        actions: [
          // State の getter を使って件数表示（View 側で計算しない）
          if (!state.isEmpty)
            Padding(
              padding: const EdgeInsets.only(right: 16),
              child: Center(
                child: Text(
                  '${state.completedCount} / ${state.todos.length} 完了',
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              ),
            ),
        ],
      ),
      body: Column(
        children: [
          // ─── エラーバナー ────────────────────────────────
          // AsyncValue の `error` ケースと違い、
          // リストを表示しながらエラーだけ上部に表示できる
          if (state.errorMessage != null)
            _ErrorBanner(
              message: state.errorMessage!,
              onDismiss: notifier.clearError,
            ),

          // ─── リスト本体 ──────────────────────────────────
          Expanded(
            child: state.isLoading
                ? const Center(child: CircularProgressIndicator())
                : state.isEmpty
                    ? const _EmptyView()
                    : RefreshIndicator(
                        onRefresh: notifier.refresh,
                        child: ListView.builder(
                          padding: const EdgeInsets.symmetric(vertical: 8),
                          itemCount: state.todos.length,
                          itemBuilder: (context, index) {
                            return _TodoListItem(
                              key: ValueKey(state.todos[index].id),
                              todo: state.todos[index],
                              onToggle: () =>
                                  notifier.toggleTodo(state.todos[index].id),
                              onDelete: () =>
                                  notifier.removeTodo(state.todos[index].id),
                            );
                          },
                        ),
                      ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        // isBusy のとき操作をブロック（State の getter を利用）
        onPressed:
            state.isBusy ? null : () => _showAddDialog(context, notifier),
        tooltip: 'Todoを追加',
        child: state.isAdding
            // 追加中だけスピナー表示（リストはそのまま）
            ? const SizedBox(
                width: 24,
                height: 24,
                child: CircularProgressIndicator(
                  color: Colors.white,
                  strokeWidth: 2,
                ),
              )
            : const Icon(Icons.add),
      ),
    );
  }

  Future<void> _showAddDialog(
    BuildContext context,
    TodoNotifier notifier,
  ) async {
    await showDialog<void>(
      context: context,
      builder: (context) => _AddTodoDialog(
        onAdd: (title) => notifier.addTodo(title),
      ),
    );
  }
}

// ─── エラーバナー ────────────────────────────────────────
// リストを表示しながらエラーを伝えられる（AsyncError とは異なる体験）
class _ErrorBanner extends StatelessWidget {
  final String message;
  final VoidCallback onDismiss;

  const _ErrorBanner({required this.message, required this.onDismiss});

  @override
  Widget build(BuildContext context) {
    return MaterialBanner(
      backgroundColor: Colors.red.shade50,
      leading: Icon(Icons.error_outline, color: Colors.red.shade700),
      content: Text(
        message,
        style: TextStyle(color: Colors.red.shade700),
      ),
      actions: [
        TextButton(
          onPressed: onDismiss,
          child: const Text('閉じる'),
        ),
      ],
    );
  }
}

// ─── 空状態の表示 ────────────────────────────────────────
class _EmptyView extends StatelessWidget {
  const _EmptyView();

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.check_circle_outline, size: 64, color: Colors.grey),
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
}

// ─── Todo リストアイテム ─────────────────────────────────
class _TodoListItem extends StatelessWidget {
  final Todo todo;
  final VoidCallback onToggle;
  final VoidCallback onDelete;

  const _TodoListItem({
    super.key,
    required this.todo,
    required this.onToggle,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: Key('dismissible_${todo.id}'),
      direction: DismissDirection.endToStart,
      background: Container(
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 20),
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
        decoration: BoxDecoration(
          color: Colors.red.shade400,
          borderRadius: BorderRadius.circular(12),
        ),
        child: const Icon(Icons.delete_outline, color: Colors.white, size: 28),
      ),
      confirmDismiss: (_) => showDialog<bool>(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('削除確認'),
          content: Text('「${todo.title}」を削除しますか？'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: const Text('キャンセル'),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(true),
              style: TextButton.styleFrom(foregroundColor: Colors.red),
              child: const Text('削除'),
            ),
          ],
        ),
      ),
      onDismissed: (_) => onDelete(),
      child: Card(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: ListTile(
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
          leading: Checkbox(
            value: todo.isCompleted,
            onChanged: (_) => onToggle(),
            shape: const CircleBorder(),
          ),
          title: Text(
            todo.title,
            style: TextStyle(
              decoration: todo.isCompleted ? TextDecoration.lineThrough : null,
              color: todo.isCompleted ? Colors.grey : null,
              fontSize: 16,
            ),
          ),
          subtitle: Padding(
            padding: const EdgeInsets.only(top: 4),
            child: Text(
              _formatDate(todo.createdAt),
              style: const TextStyle(fontSize: 12, color: Colors.grey),
            ),
          ),
          trailing: IconButton(
            icon: const Icon(Icons.delete_outline),
            color: Colors.red.shade300,
            onPressed: onDelete,
            tooltip: '削除',
          ),
        ),
      ),
    );
  }

  String _formatDate(DateTime dt) =>
      '${dt.year}/${dt.month.toString().padLeft(2, '0')}/'
      '${dt.day.toString().padLeft(2, '0')}';
}

// ─── Todo 追加ダイアログ ─────────────────────────────────
class _AddTodoDialog extends StatefulWidget {
  final void Function(String title) onAdd;

  const _AddTodoDialog({required this.onAdd});

  @override
  State<_AddTodoDialog> createState() => _AddTodoDialogState();
}

class _AddTodoDialogState extends State<_AddTodoDialog> {
  final _controller = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _submit() {
    if (!_formKey.currentState!.validate()) return;
    widget.onAdd(_controller.text);
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Todo を追加'),
      content: Form(
        key: _formKey,
        child: TextFormField(
          controller: _controller,
          autofocus: true,
          decoration: const InputDecoration(
            labelText: 'タイトル',
            hintText: 'やることを入力...',
            border: OutlineInputBorder(),
            prefixIcon: Icon(Icons.edit_outlined),
          ),
          maxLength: 200,
          textInputAction: TextInputAction.done,
          validator: (value) =>
              (value == null || value.trim().isEmpty) ? '1文字以上入力してください' : null,
          onFieldSubmitted: (_) => _submit(),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('キャンセル'),
        ),
        ElevatedButton(
          onPressed: _submit,
          child: const Text('追加'),
        ),
      ],
    );
  }
}
