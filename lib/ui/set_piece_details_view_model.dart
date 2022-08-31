import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:meow_music/data/model/template.dart';
import 'package:meow_music/data/model/uploaded_sound.dart';
import 'package:meow_music/data/usecase/submission_use_case.dart';
import 'package:meow_music/ui/request_push_notification_permission_state.dart';
import 'package:meow_music/ui/set_piece_details_state.dart';

class SetPieceDetailsViewModel extends StateNotifier<SetPieceDetailsState> {
  SetPieceDetailsViewModel({
    required Reader reader,
    required SetPieceDetailsArgs args,
  })  : _template = args.template,
        _sounds = args.sounds,
        _reader = reader,
        super(
          SetPieceDetailsState(
            thumbnailPath: args.thumbnailPath,
            labelController: TextEditingController(),
          ),
        ) {
    setup();
  }

  final Template _template;
  final List<UploadedSound> _sounds;

  final Reader _reader;

  Future<void> setup() async {
    final isRequestStepExists = await _reader(
      getShouldShowRequestPushNotificationPermissionActionProvider,
    ).call();

    state = state.copyWith(isRequestStepExists: isRequestStepExists);
  }

  RequestPushNotificationPermissionArgs getRequestPermissionArgs() {
    return RequestPushNotificationPermissionArgs(
      template: _template,
      sounds: _sounds,
    );
  }

  Future<void> submit() async {
    state = state.copyWith(isProcessing: true);

    final submitAction = await _reader(submitActionProvider.future);
    await submitAction(
      template: _template,
      sounds: _sounds,
    );

    state = state.copyWith(isProcessing: true);
  }
}
