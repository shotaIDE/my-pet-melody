import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:my_pet_melody/data/model/preference_key.dart';
import 'package:my_pet_melody/data/service/in_app_review_service.dart';
import 'package:my_pet_melody/data/service/preference_service.dart';
import 'package:my_pet_melody/data/usecase/play_video_use_case.dart';

import '../service/preference_service_mock.dart';

class Action {
  Future<void> call() async {}
}

class ActionMock extends Mock implements Action {}

void main() {
  late ActionMock action;
  late PreferenceServiceMock preferenceService;
  late ProviderContainer providerContainer;

  group('OnAppCompletedToPlayVideoAction', () {
    setUp(() {
      action = ActionMock();
      preferenceService = PreferenceServiceMock();
      providerContainer = ProviderContainer(
        overrides: [
          requestInAppReviewActionProvider.overrideWithValue(action.call),
          preferenceServiceProvider.overrideWithValue(preferenceService),
        ],
      );
    });

    test('when newCount is 1, 5, 20 or 40 trigger requestInAppReviewAction',
        () async {
      when(
        () => preferenceService
            .getInt(PreferenceKey.appCompletedToPlayVideoCount),
      ).thenAnswer((_) async => 1);

      await providerContainer.read(onAppCompletedToPlayVideoActionProvider)();

      verify(action).called(1);
      verify(
        () => preferenceService.setInt(
          PreferenceKey.appCompletedToPlayVideoCount,
          value: 2,
        ),
      ).called(1);
    });

    test('when newCount is any number that is not 1, 5, 20 or 40', () async {
      when(
        () => preferenceService
            .getInt(PreferenceKey.appCompletedToPlayVideoCount),
      ).thenAnswer((_) async => 2);

      await providerContainer.read(onAppCompletedToPlayVideoActionProvider)();

      verifyNever(action);
      verify(
        () => preferenceService.setInt(
          PreferenceKey.appCompletedToPlayVideoCount,
          value: 2,
        ),
      ).called(3);
    });
  });
}
