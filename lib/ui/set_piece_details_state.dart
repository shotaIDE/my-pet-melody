import 'package:flutter/material.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:meow_music/data/model/template.dart';
import 'package:meow_music/data/model/uploaded_media.dart';

part 'set_piece_details_state.freezed.dart';

@freezed
class SetPieceDetailsState with _$SetPieceDetailsState {
  const factory SetPieceDetailsState({
    required String thumbnailPath,
    required TextEditingController displayNameController,
    @Default(null) bool? isRequestStepExists,
    @Default(false) bool isProcessing,
  }) = _SetPieceDetailsState;
}

@freezed
class SetPieceDetailsArgs with _$SetPieceDetailsArgs {
  const factory SetPieceDetailsArgs({
    required Template template,
    required List<UploadedMedia> sounds,
    required String thumbnailPath,
    required String displayName,
  }) = _SetPieceDetailsArgs;
}
