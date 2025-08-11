import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:my_pet_melody/data/logger/event_reporter.dart';
import 'package:my_pet_melody/data/model/account_provider.dart';
import 'package:my_pet_melody/data/model/delete_account_error.dart';
import 'package:my_pet_melody/data/model/delete_account_with_current_session_error.dart';
import 'package:my_pet_melody/data/model/google_credential.dart';
import 'package:my_pet_melody/data/model/link_credential_error.dart';
import 'package:my_pet_melody/data/model/login_error.dart';
import 'package:my_pet_melody/data/model/login_third_party_error.dart';
import 'package:my_pet_melody/data/model/profile.dart';
import 'package:my_pet_melody/data/model/result.dart';
import 'package:my_pet_melody/data/service/auth_service.dart';
import 'package:my_pet_melody/data/service/push_notification_service.dart';
import 'package:my_pet_melody/data/service/third_party_auth_service.dart';

final Provider<Profile?> nonAnonymousProfileProvider = Provider((ref) {
  final session = ref.watch(sessionProvider);
  return session?.nonAnonymousProfile;
});

final Provider<bool> isLoggedInNotAnonymouslyProvider = Provider((ref) {
  final session = ref.watch(sessionProvider);
  return session?.nonAnonymousProfile != null;
});

final Provider<String?> profilePhotoUrlProvider = Provider((ref) {
  final session = ref.watch(sessionProvider);
  return session?.nonAnonymousProfile?.photoUrl;
});

final FutureProvider<String?> registrationTokenProvider = FutureProvider((
  ref,
) async {
  // Gets a registration token each time the session is not null.
  await ref.watch(sessionStreamProvider.future);

  final pushNotificationService = ref.watch(pushNotificationServiceProvider);

  return pushNotificationService.registrationToken();
});

final FutureProvider<bool> ensureDetermineIfLoggedInActionProvider =
    FutureProvider((ref) async {
      await ref.read(sessionProvider.notifier).setup();

      return ref.read(sessionProvider) != null;
    });

final signInActionProvider = Provider<Future<void> Function()>((ref) {
  final actions = ref.watch(authActionsProvider);

  return actions.signInAnonymously;
});

final loginWithGoogleActionProvider =
    Provider<Future<Result<void, LoginError>> Function()>((ref) {
      final thirdPartyAuthActions = ref.watch(thirdPartyAuthActionsProvider);
      final authActions = ref.watch(authActionsProvider);
      final eventReporter = ref.watch(eventReporterProvider);

      Future<Result<void, LoginError>> action() async {
        final loginGoogleResult = await thirdPartyAuthActions.loginGoogle();
        final convertedLoginError = loginGoogleResult.whenOrNull<LoginError>(
          failure: (error) => error.when(
            cancelledByUser: LoginError.cancelledByUser,
            unrecoverable: LoginError.unrecoverable,
          ),
        );
        if (convertedLoginError != null) {
          return Result.failure(convertedLoginError);
        }

        final googleCredential =
            (loginGoogleResult
                    as Success<GoogleCredential, LoginThirdPartyError>)
                .value;
        final loginResult = await authActions.loginWithGoogle(googleCredential);
        final convertedLinkError = loginResult.whenOrNull(
          failure: (error) => switch (error) {
            LinkCredentialErrorAlreadyInUse() =>
              const LoginError.alreadyInUse(),
            LinkCredentialErrorUnrecoverable() =>
              const LoginError.unrecoverable(),
          },
        );
        if (convertedLinkError != null) {
          return Result.failure(convertedLinkError);
        }

        unawaited(
          eventReporter.signUp(AccountProvider.google),
        );

        return const Result.success(null);
      }

      return action;
    });

final linkWithGoogleActionProvider =
    Provider<Future<Result<void, LoginError>> Function()>((ref) {
      final thirdPartyAuthActions = ref.watch(thirdPartyAuthActionsProvider);
      final authActions = ref.watch(authActionsProvider);
      final eventReporter = ref.watch(eventReporterProvider);

      Future<Result<void, LoginError>> action() async {
        final loginGoogleResult = await thirdPartyAuthActions.loginGoogle();
        final convertedLoginError = loginGoogleResult
            .whenOrNull<Result<void, LoginError>>(
              failure: (error) => error.when(
                cancelledByUser: () =>
                    const Result.failure(LoginError.cancelledByUser()),
                unrecoverable: () =>
                    const Result.failure(LoginError.unrecoverable()),
              ),
            );
        if (convertedLoginError != null) {
          return convertedLoginError;
        }

        final googleCredential =
            (loginGoogleResult
                    as Success<GoogleCredential, LoginThirdPartyError>)
                .value;
        final linkResult = await authActions.linkWithGoogle(googleCredential);
        final convertedLinkError = linkResult.whenOrNull(
          failure: (error) => switch (error) {
            LinkCredentialErrorAlreadyInUse() =>
              const LoginError.alreadyInUse(),
            LinkCredentialErrorUnrecoverable() =>
              const LoginError.unrecoverable(),
          },
        );
        if (convertedLinkError != null) {
          return Result.failure(convertedLinkError);
        }

        unawaited(
          eventReporter.signUp(AccountProvider.google),
        );

        return const Result.success(null);
      }

      return action;
    });

final loginWithAppleActionProvider =
    Provider<Future<Result<void, LoginError>> Function()>((ref) {
      final authActions = ref.watch(authActionsProvider);
      final eventReporter = ref.watch(eventReporterProvider);

      Future<Result<void, LoginError>> action() async {
        final result = await authActions.loginOrLinkWithApple();

        unawaited(
          eventReporter.signUp(AccountProvider.apple),
        );

        return result;
      }

      return action;
    });

final linkWithAppleActionProvider =
    Provider<Future<Result<void, LoginError>> Function()>((ref) {
      final authActions = ref.watch(authActionsProvider);
      final eventReporter = ref.watch(eventReporterProvider);

      Future<Result<void, LoginError>> action() async {
        final result = await authActions.loginOrLinkWithApple();

        unawaited(
          eventReporter.signUp(AccountProvider.apple),
        );

        return result;
      }

      return action;
    });

final Provider<Future<void> Function()> signOutActionProvider = Provider((ref) {
  final authActions = ref.watch(authActionsProvider);
  final pushNotificationService = ref.watch(pushNotificationServiceProvider);

  Future<void> action() async {
    await authActions.signOut();

    await pushNotificationService.deleteRegistrationToken();
  }

  return action;
});

final Provider<Future<Result<void, DeleteAccountError>> Function()>
deleteAccountActionProvider = Provider((ref) {
  final authActions = ref.watch(authActionsProvider);
  final thirdPartyAuthActions = ref.watch(thirdPartyAuthActionsProvider);

  Future<Result<void, DeleteAccountError>> action() async {
    final deleteOnFirstResult = await authActions.delete();
    final deleteOnFirstError = deleteOnFirstResult.whenOrNull(
      failure: (error) => error,
    );
    if (deleteOnFirstError == null) {
      return const Result.success(null);
    }

    final providerNeededAuthenticate = switch (deleteOnFirstError) {
      DeleteAccountWithCurrentSessionErrorNeedReauthenticate(:final provider) =>
        provider,
      DeleteAccountWithCurrentSessionErrorUnrecoverable() => null,
    };
    if (providerNeededAuthenticate == null) {
      return const Result.failure(DeleteAccountError.unrecoverable());
    }

    switch (providerNeededAuthenticate) {
      case AccountProvider.google:
        final loginGoogleResult = await thirdPartyAuthActions.loginGoogle();
        final convertedLoginError = loginGoogleResult
            .whenOrNull<DeleteAccountError>(
              failure: (error) => error.when(
                cancelledByUser: DeleteAccountError.cancelledByUser,
                unrecoverable: DeleteAccountError.unrecoverable,
              ),
            );
        if (convertedLoginError != null) {
          return Result.failure(convertedLoginError);
        }

        final googleCredential =
            (loginGoogleResult
                    as Success<GoogleCredential, LoginThirdPartyError>)
                .value;
        final reauthenticateResult = await authActions.reauthenticateWithGoogle(
          googleCredential,
        );
        final convertedReauthenticateError = reauthenticateResult.whenOrNull(
          failure: (error) => switch (error) {
            LinkCredentialErrorAlreadyInUse() =>
              const DeleteAccountError.unrecoverable(),
            LinkCredentialErrorUnrecoverable() =>
              const DeleteAccountError.unrecoverable(),
          },
        );
        if (convertedReauthenticateError != null) {
          return Result.failure(convertedReauthenticateError);
        }

      case AccountProvider.apple:
        final reauthenticateWithAppleResult = await authActions
            .loginOrLinkWithApple();
        final convertedLoginError = reauthenticateWithAppleResult
            .whenOrNull<DeleteAccountError>(
              failure: (error) => error.when(
                cancelledByUser: DeleteAccountError.cancelledByUser,
                alreadyInUse: DeleteAccountError.unrecoverable,
                unrecoverable: DeleteAccountError.unrecoverable,
              ),
            );
        if (convertedLoginError != null) {
          return Result.failure(convertedLoginError);
        }
    }

    final deleteOnSecondResult = await authActions.delete();
    final deleteOnSecondError = deleteOnSecondResult.whenOrNull(
      failure: (error) => switch (error) {
        DeleteAccountWithCurrentSessionErrorNeedReauthenticate() =>
          const DeleteAccountError.unrecoverable(),
        DeleteAccountWithCurrentSessionErrorUnrecoverable() =>
          const DeleteAccountError.unrecoverable(),
      },
    );
    if (deleteOnSecondError != null) {
      return Result.failure(deleteOnSecondError);
    }

    return const Result.success(null);
  }

  return action;
});
