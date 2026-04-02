// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'todo_viewmodel.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(todoRepository)
final todoRepositoryProvider = TodoRepositoryProvider._();

final class TodoRepositoryProvider
    extends $FunctionalProvider<TodoRepository, TodoRepository, TodoRepository>
    with $Provider<TodoRepository> {
  TodoRepositoryProvider._()
      : super(
          from: null,
          argument: null,
          retry: null,
          name: r'todoRepositoryProvider',
          isAutoDispose: true,
          dependencies: null,
          $allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$todoRepositoryHash();

  @$internal
  @override
  $ProviderElement<TodoRepository> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  TodoRepository create(Ref ref) {
    return todoRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(TodoRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<TodoRepository>(value),
    );
  }
}

String _$todoRepositoryHash() => r'fb37acd1fda19463a6f803cbb7cce27997d82f1b';

@ProviderFor(TodoViewModel)
final todoViewModelProvider = TodoViewModelProvider._();

final class TodoViewModelProvider
    extends $AsyncNotifierProvider<TodoViewModel, List<Todo>> {
  TodoViewModelProvider._()
      : super(
          from: null,
          argument: null,
          retry: null,
          name: r'todoViewModelProvider',
          isAutoDispose: true,
          dependencies: null,
          $allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$todoViewModelHash();

  @$internal
  @override
  TodoViewModel create() => TodoViewModel();
}

String _$todoViewModelHash() => r'162c74aaff9059825c0b9bea0c9ec238217a6574';

abstract class _$TodoViewModel extends $AsyncNotifier<List<Todo>> {
  FutureOr<List<Todo>> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<AsyncValue<List<Todo>>, List<Todo>>;
    final element = ref.element as $ClassProviderElement<
        AnyNotifier<AsyncValue<List<Todo>>, List<Todo>>,
        AsyncValue<List<Todo>>,
        Object?,
        Object?>;
    element.handleCreate(ref, build);
  }
}
