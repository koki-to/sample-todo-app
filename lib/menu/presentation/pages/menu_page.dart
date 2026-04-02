import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sample_todo_app/mvvm/features/todo/presentation/pages/todo_page.dart';
import 'package:sample_todo_app/page_scoped_notifier/features/todo/presentation/todo_page.dart';

import '../../../crean_architecture/features/todo/presentation/pages/todo_page.dart';

class MenuPage extends ConsumerWidget {
  const MenuPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('menu'),
        centerTitle: true,
      ),
      body: Center(
        child: Column(
          children: [
            ElevatedButton(
              onPressed: () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => CreanArchitectureTodoPage(),
                ),
              ),
              child: Text("crean architecture"),
            ),
            ElevatedButton(
              onPressed: () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => MvvmTodoPage(),
                ),
              ),
              child: Text("mvvm architecture"),
            ),
            ElevatedButton(
              onPressed: () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => PageScopedTodoPage(),
                ),
              ),
              child: Text("PageScopedTodoPage"),
            ),
          ],
        ),
      ),
    );
  }
}
