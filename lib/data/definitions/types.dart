import 'package:flutter_riverpod/flutter_riverpod.dart';

typedef Listener = void Function<T>(
  ProviderListenable<T> provider,
  void Function(T? previous, T next) listener, {
  bool fireImmediately,
  void Function(Object error, StackTrace stackTrace)? onError,
});
