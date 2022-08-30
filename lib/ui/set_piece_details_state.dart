import 'package:flutter/material.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'set_piece_details_state.freezed.dart';

@freezed
class SetPieceDetailsState with _$SetPieceDetailsState {
  const factory SetPieceDetailsState({
    required String thumbnailPath,
    required TextEditingController labelController,
  }) = _SetPieceDetailsState;
}

@freezed
class SetPieceDetailsArgs with _$SetPieceDetailsArgs {
  const factory SetPieceDetailsArgs({
    required String thumbnailPath,
    required TextEditingController labelController,
  }) = _SetPieceDetailsArgs;
}
