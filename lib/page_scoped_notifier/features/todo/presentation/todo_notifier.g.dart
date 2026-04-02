// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'todo_notifier.dart';

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

@ProviderFor(TodoNotifier)
final todoProvider = TodoNotifierProvider._();

final class TodoNotifierProvider
    extends $NotifierProvider<TodoNotifier, TodoState> {
  TodoNotifierProvider._()
      : super(
          from: null,
          argument: null,
          retry: null,
          name: r'todoProvider',
          isAutoDispose: true,
          dependencies: null,
          $allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$todoNotifierHash();

  @$internal
  @override
  TodoNotifier create() => TodoNotifier();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(TodoState value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<TodoState>(value),
    );
  }
}

String _$todoNotifierHash() => r'dd02bace2d370e6e75d96dca3ecc31970cc099cc';

abstract class _$TodoNotifier extends $Notifier<TodoState> {
  TodoState build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<TodoState, TodoState>;
    final element = ref.element as $ClassProviderElement<
        AnyNotifier<TodoState, TodoState>, TodoState, Object?, Object?>;
    element.handleCreate(ref, build);
  }
}
