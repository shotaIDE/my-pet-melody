import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:meow_music/data/model/template.dart';
import 'package:meow_music/data/model/uploaded_media.dart';
import 'package:meow_music/data/usecase/submission_use_case.dart';
import 'package:meow_music/ui/request_push_notification_permission_state.dart';
import 'package:meow_music/ui/set_piece_title_state.dart';
import 'package:path/path.dart';

class SetPieceTitleViewModel extends StateNotifier<SetPieceTitleState> {
  SetPieceTitleViewModel({
    required Ref ref,
    required SetPieceTitleArgs args,
  })  : _template = args.template,
        _sounds = args.sounds,
        _ref = ref,
        super(
          SetPieceTitleState(
            thumbnailLocalPath: args.thumbnailLocalPath,
            displayNameController:
                TextEditingController(text: args.displayName),
            displayNameFocusNode: FocusNode(),
          ),
        ) {
    _setup();
  }

  final Template _template;
  final List<UploadedMedia> _sounds;

  final Ref _ref;

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

    final uploadAction = await _ref.read(uploadActionProvider.future);
    final uploadedThumbnail = await uploadAction(
      thumbnail,
      fileName: basename(thumbnailLocalPath),
    );

    if (uploadedThumbnail == null) {
      return;
    }

    final displayName = state.displayNameController.text;

    final submitAction = await _ref.read(submitActionProvider.future);
    await submitAction(
      template: _template,
      sounds: _sounds,
      displayName: displayName,
      thumbnail: uploadedThumbnail,
    );

    state = state.copyWith(isProcessing: false);
  }

  Future<void> _setup() async {
    state.displayNameFocusNode.addListener(() {
      if (!state.displayNameFocusNode.hasFocus) {
        return;
      }

      state.displayNameController.selection = TextSelection(
        baseOffset: 0,
        extentOffset: state.displayNameController.text.length,
      );
    });

    final isRequestStepExists = await _ref
        .read(
          getShouldShowRequestPushNotificationPermissionActionProvider,
        )
        .call();

    state = state.copyWith(isRequestStepExists: isRequestStepExists);
  }
}
