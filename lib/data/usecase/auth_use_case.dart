import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:meow_music/data/di/service_providers.dart';
import 'package:meow_music/data/model/link_credential_error.dart';
import 'package:meow_music/data/model/login_twitter_error.dart';
import 'package:meow_music/data/model/result.dart';
import 'package:meow_music/data/model/twitter_credential.dart';
import 'package:meow_music/data/service/auth_service.dart';
import 'package:meow_music/data/service/third_party_auth_service.dart';

final nonAnonymousProfileProvider = Provider((ref) {
  final session = ref.watch(sessionProvider);
  return session?.nonAnonymousProfile;
});

final isLoggedInNotAnonymouslyProvider = Provider((ref) {
  final session = ref.watch(sessionProvider);
  return session?.nonAnonymousProfile != null;
});

final profilePhotoUrlProvider = Provider((ref) {
  final session = ref.watch(sessionProvider);
  return session?.nonAnonymousProfile?.photoUrl;
});

final registrationTokenProvider = FutureProvider((ref) async {
  // Gets a registration token each time the session is not null.
  await ref.watch(sessionStreamProvider.future);

  final pushNotificationService = ref.watch(pushNotificationServiceProvider);

  return pushNotificationService.registrationToken();
});

final ensureDetermineIfLoggedInActionProvider = FutureProvider((ref) async {
  // TODO(ide): Not a good idea to write a process here
  //  that waits until initialization is complete.
  await ref.read(sessionProvider.notifier).setup();

  return ref.read(sessionProvider) != null;
});

final signInActionProvider = Provider<Future<void> Function()>((ref) {
  final actions = ref.watch(authActionsProvider);

  return actions.signInAnonymously;
});

final loginWithTwitterActionProvider =
    Provider<Future<Result<void, LinkCredentialError>> Function()>((ref) {
  final thirdPartyAuthActions = ref.watch(thirdPartyAuthActionsProvider);
  final authActions = ref.watch(authActionsProvider);

  Future<Result<void, LinkCredentialError>> action() async {
    final loginTwitterResult = await thirdPartyAuthActions.loginTwitter();
    final convertedLoginError =
        loginTwitterResult.whenOrNull<Result<void, LinkCredentialError>>(
      failure: (error) => error.when(
        cancelledByUser: () =>
            const Result.failure(LinkCredentialError.cancelledByUser()),
        unrecoverable: () =>
            const Result.failure(LinkCredentialError.unrecoverable()),
      ),
    );
    if (convertedLoginError != null) {
      return convertedLoginError;
    }

    final credential =
        (loginTwitterResult as Success<TwitterCredential, LoginTwitterError>)
            .value;
    final loginResult = await authActions.loginWithTwitter(
      authToken: credential.authToken,
      secret: credential.secret,
    );
    final convertedLinkError = loginResult.whenOrNull(failure: Result.failure);
    if (convertedLinkError != null) {
      return convertedLinkError;
    }

    return const Result.success(null);
  }

  return action;
});

final linkWithTwitterActionProvider =
    Provider<Future<Result<void, LinkCredentialError>> Function()>((ref) {
  final thirdPartyAuthActions = ref.watch(thirdPartyAuthActionsProvider);
  final authActions = ref.watch(authActionsProvider);

  Future<Result<void, LinkCredentialError>> action() async {
    final loginResult = await thirdPartyAuthActions.loginTwitter();
    final convertedLoginError =
        loginResult.whenOrNull<Result<void, LinkCredentialError>>(
      failure: (error) => error.when(
        cancelledByUser: () =>
            const Result.failure(LinkCredentialError.cancelledByUser()),
        unrecoverable: () =>
            const Result.failure(LinkCredentialError.unrecoverable()),
      ),
    );
    if (convertedLoginError != null) {
      return convertedLoginError;
    }

    final credential =
        (loginResult as Success<TwitterCredential, LoginTwitterError>).value;
    final linkResult = await authActions.linkWithTwitter(
      authToken: credential.authToken,
      secret: credential.secret,
    );
    final convertedLinkError = linkResult.whenOrNull(failure: Result.failure);
    if (convertedLinkError != null) {
      return convertedLinkError;
    }

    return const Result.success(null);
  }

  return action;
});

final signOutActionProvider = Provider((ref) {
  final authActions = ref.watch(authActionsProvider);
  final pushNotificationService = ref.watch(pushNotificationServiceProvider);

  Future<void> action() async {
    await authActions.signOut();

    await pushNotificationService.deleteRegistrationToken();
  }

  return action;
});

final deleteAccountActionProvider = Provider((ref) {
  final authActions = ref.watch(authActionsProvider);

  Future<void> action() async {
    await authActions.delete();
  }

  return action;
});
