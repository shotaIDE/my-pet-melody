import 'package:freezed_annotation/freezed_annotation.dart';

part 'non_silence_segment.freezed.dart';

@freezed
class NonSilenceSegment with _$NonSilenceSegment {
  const factory NonSilenceSegment({
    required int startMilliseconds,
    required int endMilliseconds,
  }) = _NonSilenceSegment;
}
