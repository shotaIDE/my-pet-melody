import 'dart:async';
import 'dart:ui';

import 'package:audioplayers/audioplayers.dart';
import 'package:collection/collection.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:my_pet_melody/data/definitions/types.dart';
import 'package:my_pet_melody/data/service/database_service.dart';
import 'package:my_pet_melody/data/service/device_service.dart';
import 'package:my_pet_melody/data/usecase/piece_use_case.dart';
import 'package:my_pet_melody/ui/helper/audio_position_helper.dart';
import 'package:my_pet_melody/ui/model/localized_template.dart';
import 'package:my_pet_melody/ui/model/play_status.dart';
import 'package:my_pet_melody/ui/model/player_choice.dart';
import 'package:my_pet_melody/ui/select_template_state.dart';

class SelectTemplateViewModel extends StateNotifier<SelectTemplateState> {
  SelectTemplateViewModel({
    required Ref ref,
    required Listener listener,
  })  : _ref = ref,
        super(const SelectTemplateState()) {
    _setup(listener: listener);
  }

  final Ref _ref;
  final _player = AudioPlayer();

  Duration? _currentAudioDuration;
  StreamSubscription<Duration>? _audioDurationSubscription;
  StreamSubscription<Duration>? _audioPositionSubscription;
  StreamSubscription<void>? _audioStoppedSubscription;

  @override
  Future<void> dispose() async {
    final tasks = [
      _audioDurationSubscription?.cancel(),
      _audioPositionSubscription?.cancel(),
      _audioStoppedSubscription?.cancel(),
    ].whereType<Future<void>>().toList();

    await Future.wait<void>(tasks);

    super.dispose();
  }

  void didChangeLocale(Locale locale) {
    _ref.read(deviceLocaleProvider.notifier).updateIfNeeded(locale);
  }

  Future<void> play({required PlayerChoiceTemplate template}) async {
    final url = template.uri;
    if (url == null) {
      return;
    }

    final templates = state.templates;
    if (templates == null) {
      return;
    }

    final stoppedList = PlayerChoiceConverter.getStoppedOrNull(
          originalList: templates,
        ) ??
        [...templates];

    final playingList = PlayerChoiceConverter.getTargetStatusReplaced(
      originalList: stoppedList,
      targetId: template.id,
      newStatus: const PlayStatus.loadingMedia(),
    );

    state = state.copyWith(
      templates: playingList.whereType<PlayerChoiceTemplate>().toList(),
    );

    final source = UrlSource(url);

    await _player.play(source);
  }

  Future<void> stop({required PlayerChoiceTemplate template}) async {
    final templates = state.templates;
    if (templates == null) {
      return;
    }

    final stoppedList = PlayerChoiceConverter.getTargetStopped(
      originalList: templates,
      targetId: template.id,
    );

    state = state.copyWith(
      templates: stoppedList.whereType<PlayerChoiceTemplate>().toList(),
    );

    await _player.stop();
  }

  Future<void> beforeHideScreen() async {
    final templates = state.templates;
    if (templates == null) {
      return;
    }

    final stoppedList =
        PlayerChoiceConverter.getStoppedOrNull(originalList: templates);

    if (stoppedList != null) {
      state = state.copyWith(
        templates: stoppedList.whereType<PlayerChoiceTemplate>().toList(),
      );
    }

    await _player.stop();
  }

  Future<void> _setup({required Listener listener}) async {
    listener<Future<List<LocalizedTemplate>>>(
      _localizedTemplatesProvider.future,
      (_, next) async {
        final templateDataList = await next;

        final templates = templateDataList
            .map(
              (template) => PlayerChoiceTemplate(
                template: template,
                status: const PlayStatus.stop(),
              ),
            )
            .toList();

        final previousPlaying = state.templates?.firstWhereOrNull(
          (template) => template.status.map(
            stop: (_) => false,
            loadingMedia: (_) => true,
            playing: (_) => true,
          ),
        );

        final List<PlayerChoiceTemplate> fixedTemplates;
        if (previousPlaying != null) {
          fixedTemplates = PlayerChoiceConverter.getTargetStatusReplaced(
            originalList: templates,
            targetId: previousPlaying.id,
            newStatus: previousPlaying.status,
          ).whereType<PlayerChoiceTemplate>().toList();
        } else {
          fixedTemplates = templates;
        }

        state = state.copyWith(
          templates: fixedTemplates,
        );
      },
      fireImmediately: true,
    );

    _audioDurationSubscription = _player.onDurationChanged.listen((duration) {
      _currentAudioDuration = duration;
    });

    _audioPositionSubscription =
        _player.onPositionChanged.listen(_onAudioPositionReceived);

    _audioStoppedSubscription = _player.onPlayerComplete.listen((_) {
      _onAudioFinished();
    });
  }

  void _onAudioPositionReceived(Duration position) {
    final duration = _currentAudioDuration;
    if (duration == null) {
      return;
    }

    final positionRatio = getAudioPositionRatio(
      duration: duration,
      position: position,
    );

    final templates = state.templates;
    if (templates == null) {
      return;
    }

    final positionUpdatedList = PlayerChoiceConverter.getPositionUpdatedOrNull(
      originalList: templates,
      position: positionRatio,
    );
    if (positionUpdatedList == null) {
      return;
    }

    state = state.copyWith(
      templates: positionUpdatedList.whereType<PlayerChoiceTemplate>().toList(),
    );
  }

  void _onAudioFinished() {
    final templates = state.templates;
    if (templates == null) {
      return;
    }

    final stoppedList = PlayerChoiceConverter.getStoppedOrNull(
      originalList: templates,
    );
    if (stoppedList == null) {
      return;
    }

    state = state.copyWith(
      templates: stoppedList.whereType<PlayerChoiceTemplate>().toList(),
    );
  }
}

final _localizedTemplatesProvider = FutureProvider((ref) async {
  final deviceLocale = ref.watch(deviceLocaleProvider);
  final localizedTemplateMetadataList = await ref
      .watch(localizedTemplateMetadataListProvider(deviceLocale).future);
  final templates = await ref.watch(templatesProvider.future);

  return templates.map(
    (template) {
      final localizedTemplateMetadata =
          localizedTemplateMetadataList.firstWhereOrNull(
        (templateMetadata) => templateMetadata.id == template.id,
      );

      if (localizedTemplateMetadata == null) {
        return LocalizedTemplate(
          id: template.id,
          defaultName: template.name,
          localizedName: template.name,
          publishedAt: template.publishedAt,
          musicUrl: template.musicUrl,
          thumbnailUrl: template.thumbnailUrl,
        );
      }

      return LocalizedTemplate(
        id: template.id,
        defaultName: template.name,
        localizedName: localizedTemplateMetadata.name,
        publishedAt: template.publishedAt,
        musicUrl: template.musicUrl,
        thumbnailUrl: template.thumbnailUrl,
      );
    },
  ).toList();
});
