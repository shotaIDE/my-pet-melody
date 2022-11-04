import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:meow_music/data/model/template.dart';
import 'package:meow_music/data/model/uploaded_media.dart';
import 'package:meow_music/data/usecase/submission_use_case.dart';
import 'package:meow_music/ui/request_push_notification_permission_state.dart';
import 'package:meow_music/ui/set_piece_details_state.dart';
import 'package:path/path.dart';

class SetPieceDetailsViewModel extends StateNotifier<SetPieceDetailsState> {
  SetPieceDetailsViewModel({
    required Reader reader,
    required SetPieceDetailsArgs args,
  })  : _template = args.template,
        _sounds = args.sounds,
        _reader = reader,
        super(
          SetPieceDetailsState(
            thumbnailLocalPath: args.thumbnailLocalPath,
            displayNameController:
                TextEditingController(text: args.displayName),
          ),
        ) {
    setup();
  }

  final Template _template;
  final List<UploadedMedia> _sounds;

  final Reader _reader;

  Future<void> setup() async {
    final isRequestStepExists = await _reader(
      getShouldShowRequestPushNotificationPermissionActionProvider,
    ).call();

    state = state.copyWith(isRequestStepExists: isRequestStepExists);
  }

  RequestPushNotificationPermissionArgs getRequestPermissionArgs() {
    final displayName = state.displayNameController.text;

    return RequestPushNotificationPermissionArgs(
      template: _template,
      sounds: _sounds,
      displayName: displayName,
      thumbnailLocalPath: state.thumbnailLocalPath,
    );
  }

  Future<void> submit() async {
    state = state.copyWith(isProcessing: true);

    final thumbnailLocalPath = state.thumbnailLocalPath;
    final thumbnail = File(thumbnailLocalPath);

    final uploadAction = await _reader(uploadActionProvider.future);
    final uploadedThumbnail = await uploadAction(
      thumbnail,
      fileName: basename(thumbnailLocalPath),
    );

    if (uploadedThumbnail == null) {
      return;
    }

    final displayName = state.displayNameController.text;

    final submitAction = await _reader(submitActionProvider.future);
    await submitAction(
      template: _template,
      sounds: _sounds,
      displayName: displayName,
      thumbnail: uploadedThumbnail,
    );

    state = state.copyWith(isProcessing: false);
  }
}
