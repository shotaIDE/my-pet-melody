import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:meow_music/ui/set_piece_details_state.dart';

class SetPieceDetailsViewModel extends StateNotifier<SetPieceDetailsState> {
  SetPieceDetailsViewModel({
    required Reader reader,
    required SetPieceDetailsArgs args,
  })  : _reader = reader,
        super(
          SetPieceDetailsState(
            thumbnailPath: args.thumbnailPath,
            labelController: TextEditingController(),
          ),
        );

  final Reader _reader;
}
