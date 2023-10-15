import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:my_pet_melody/data/model/preference_key.dart';
import 'package:my_pet_melody/data/service/in_app_review_service.dart';
import 'package:my_pet_melody/data/service/preference_service.dart';
import 'package:my_pet_melody/data/usecase/play_video_use_case.dart';

import '../service/preference_service_mock.dart';

class Action {
  Future<void> requestInAppReview() async {}
}

class ActionMock extends Mock implements Action {}

void main() {
  late ActionMock action;
  late PreferenceServiceMock preferenceService;
  late ProviderContainer providerContainer;

  setUpAll(() {
    registerFallbackValue(PreferenceKey.appCompletedToPlayVideoCount);
  });

  group('Request in-app review when completed to play video.', () {
    setUp(() {
      action = ActionMock();
      when(action.requestInAppReview).thenAnswer((_) async {});
      preferenceService = PreferenceServiceMock();
      when(() => preferenceService.setInt(any(), value: any(named: 'value')))
          .thenAnswer((_) async {});
      providerContainer = ProviderContainer(
        overrides: [
          requestInAppReviewActionProvider
              .overrideWithValue(action.requestInAppReview),
          preferenceServiceProvider.overrideWithValue(preferenceService),
        ],
      );
    });

    test('Play count is 1, then request.', () async {
      when(
        () => preferenceService
            .getInt(PreferenceKey.appCompletedToPlayVideoCount),
      ).thenAnswer((_) async => null);

      await providerContainer
          .read(onAppCompletedToPlayVideoActionProvider)
          .call();

      verify(action.requestInAppReview).called(1);
      verify(
        () => preferenceService.setInt(
          PreferenceKey.appCompletedToPlayVideoCount,
          value: 1,
        ),
      ).called(1);
    });

    test('Play count is 2, then skip request.', () async {
      when(
        () => preferenceService
            .getInt(PreferenceKey.appCompletedToPlayVideoCount),
      ).thenAnswer((_) async => 1);

      await providerContainer
          .read(onAppCompletedToPlayVideoActionProvider)
          .call();

      verifyNever(action.requestInAppReview);
      verify(
        () => preferenceService.setInt(
          PreferenceKey.appCompletedToPlayVideoCount,
          value: 2,
        ),
      ).called(1);
    });

    test('Play count is 4, then skip request.', () async {
      when(
        () => preferenceService
            .getInt(PreferenceKey.appCompletedToPlayVideoCount),
      ).thenAnswer((_) async => 3);

      await providerContainer
          .read(onAppCompletedToPlayVideoActionProvider)
          .call();

      verifyNever(action.requestInAppReview);
      verify(
        () => preferenceService.setInt(
          PreferenceKey.appCompletedToPlayVideoCount,
          value: 4,
        ),
      ).called(1);
    });

    test('Play count is 5, then request.', () async {
      when(
        () => preferenceService
            .getInt(PreferenceKey.appCompletedToPlayVideoCount),
      ).thenAnswer((_) async => 4);

      await providerContainer
          .read(onAppCompletedToPlayVideoActionProvider)
          .call();

      verify(action.requestInAppReview).called(1);
      verify(
        () => preferenceService.setInt(
          PreferenceKey.appCompletedToPlayVideoCount,
          value: 5,
        ),
      ).called(1);
    });

    test('Play count is 6, then skip request.', () async {
      when(
        () => preferenceService
            .getInt(PreferenceKey.appCompletedToPlayVideoCount),
      ).thenAnswer((_) async => 5);

      await providerContainer
          .read(onAppCompletedToPlayVideoActionProvider)
          .call();

      verifyNever(action.requestInAppReview);
      verify(
        () => preferenceService.setInt(
          PreferenceKey.appCompletedToPlayVideoCount,
          value: 6,
        ),
      ).called(1);
    });

    test('Play count is 19, then skip request.', () async {
      when(
        () => preferenceService
            .getInt(PreferenceKey.appCompletedToPlayVideoCount),
      ).thenAnswer((_) async => 18);

      await providerContainer
          .read(onAppCompletedToPlayVideoActionProvider)
          .call();

      verifyNever(action.requestInAppReview);
      verify(
        () => preferenceService.setInt(
          PreferenceKey.appCompletedToPlayVideoCount,
          value: 19,
        ),
      ).called(1);
    });

    test('Play count is 20, then request.', () async {
      when(
        () => preferenceService
            .getInt(PreferenceKey.appCompletedToPlayVideoCount),
      ).thenAnswer((_) async => 19);

      await providerContainer
          .read(onAppCompletedToPlayVideoActionProvider)
          .call();

      verify(action.requestInAppReview).called(1);
      verify(
        () => preferenceService.setInt(
          PreferenceKey.appCompletedToPlayVideoCount,
          value: 20,
        ),
      ).called(1);
    });

    test('Play count is 21, then skip request.', () async {
      when(
        () => preferenceService
            .getInt(PreferenceKey.appCompletedToPlayVideoCount),
      ).thenAnswer((_) async => 20);

      await providerContainer
          .read(onAppCompletedToPlayVideoActionProvider)
          .call();

      verifyNever(action.requestInAppReview);
      verify(
        () => preferenceService.setInt(
          PreferenceKey.appCompletedToPlayVideoCount,
          value: 21,
        ),
      ).called(1);
    });

    test('Play count is 39, then skip request.', () async {
      when(
        () => preferenceService
            .getInt(PreferenceKey.appCompletedToPlayVideoCount),
      ).thenAnswer((_) async => 38);

      await providerContainer
          .read(onAppCompletedToPlayVideoActionProvider)
          .call();

      verifyNever(action.requestInAppReview);
      verify(
        () => preferenceService.setInt(
          PreferenceKey.appCompletedToPlayVideoCount,
          value: 39,
        ),
      ).called(1);
    });

    test('Play count is 40, then request.', () async {
      when(
        () => preferenceService
            .getInt(PreferenceKey.appCompletedToPlayVideoCount),
      ).thenAnswer((_) async => 39);

      await providerContainer
          .read(onAppCompletedToPlayVideoActionProvider)
          .call();

      verify(action.requestInAppReview).called(1);
      verify(
        () => preferenceService.setInt(
          PreferenceKey.appCompletedToPlayVideoCount,
          value: 40,
        ),
      ).called(1);
    });

    test('Play count is 41, then skip request.', () async {
      when(
        () => preferenceService
            .getInt(PreferenceKey.appCompletedToPlayVideoCount),
      ).thenAnswer((_) async => 40);

      await providerContainer
          .read(onAppCompletedToPlayVideoActionProvider)
          .call();

      verifyNever(action.requestInAppReview);
      verify(
        () => preferenceService.setInt(
          PreferenceKey.appCompletedToPlayVideoCount,
          value: 41,
        ),
      ).called(1);
    });
  });
}
