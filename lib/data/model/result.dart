import 'package:freezed_annotation/freezed_annotation.dart';

part 'result.freezed.dart';

@freezed
abstract class Result<T, S> with _$Result<T, S> {
  const factory Result.success(T value) = Success<T, S>;
  const factory Result.failure(S error) = Failure<T, S>;
}
