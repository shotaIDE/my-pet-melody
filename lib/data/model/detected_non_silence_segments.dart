import 'package:freezed_annotation/freezed_annotation.dart';

part 'detected_non_silence_segments.freezed.dart';

@freezed
class DetectedNonSilenceSegments with _$DetectedNonSilenceSegments {
  const factory DetectedNonSilenceSegments({
    required List<NonSilenceSegment> list,
    required int lengthMilliseconds,
  }) = _DetectedNonSilenceSegments;
}

@freezed
class NonSilenceSegment with _$NonSilenceSegment {
  const factory NonSilenceSegment({
    required int startMilliseconds,
    required int endMilliseconds,
  }) = _NonSilenceSegment;
}
