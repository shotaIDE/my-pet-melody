import 'package:chewie/chewie.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'video_state.freezed.dart';

@freezed
class VideoState with _$VideoState {
  const factory VideoState({
    required String title,
    @Default(null) ChewieController? controller,
  }) = _VideoState;
}
