import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sample_todo_app/app.dart';

void main() {
  /// WidgetsFlutterBinding.ensureInitializedは、
  /// Flutterのバインディングを初期化するためのメソッドで、
  /// runAppの前に非同期処理やプラグインの初期化を行う場合に使用します。
  /// これを呼び出すことでFlutterの内部処理が正しく初期化され、
  /// Firebaseなどの初期化処理を安全に実行できるようになります。
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const ProviderScope(child: App()));
}
