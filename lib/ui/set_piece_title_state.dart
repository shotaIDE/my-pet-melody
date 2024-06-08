import 'package:flutter/material.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:my_pet_melody/data/model/uploaded_media.dart';
import 'package:my_pet_melody/ui/model/localized_template.dart';

part 'set_piece_title_state.freezed.dart';

@freezed
class SetPieceTitleState with _$SetPieceTitleState {
  const factory SetPieceTitleState({
    required String thumbnailLocalPath,
    required TextEditingController displayNameController,
    required FocusNode displayNameFocusNode,
    required bool isFooterButtonEnabled,
    @Default(null) bool? isRequestStepExists,
    @Default(false) bool isProcessing,
  }) = _SetPieceTitleState;
}

@freezed
class SetPieceTitleArgs with _$SetPieceTitleArgs {
  const factory SetPieceTitleArgs({
    required LocalizedTemplate template,
    required List<UploadedMedia> sounds,
    required String thumbnailLocalPath,
    required String displayName,
  }) = _SetPieceTitleArgs;
}
