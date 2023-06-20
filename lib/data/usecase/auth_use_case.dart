import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:my_pet_melody/data/di/service_providers.dart';
import 'package:my_pet_melody/data/model/account_provider.dart';
import 'package:my_pet_melody/data/model/delete_account_error.dart';
import 'package:my_pet_melody/data/model/google_credential.dart';
import 'package:my_pet_melody/data/model/login_error.dart';
import 'package:my_pet_melody/data/model/login_third_party_error.dart';
import 'package:my_pet_melody/data/model/result.dart';
import 'package:my_pet_melody/data/model/twitter_credential.dart';
import 'package:my_pet_melody/data/service/auth_service.dart';
import 'package:my_pet_melody/data/service/third_party_auth_service.dart';

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

final loginWithGoogleActionProvider =
    Provider<Future<Result<void, LoginError>> Function()>((ref) {
  final thirdPartyAuthActions = ref.watch(thirdPartyAuthActionsProvider);
  final authActions = ref.watch(authActionsProvider);

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
        (loginGoogleResult as Success<GoogleCredential, LoginThirdPartyError>)
            .value;
    final loginResult = await authActions.loginWithGoogle(googleCredential);
    final convertedLinkError = loginResult.whenOrNull(
      failure: (error) => error.when(
        alreadyInUse: LoginError.alreadyInUse,
        unrecoverable: LoginError.unrecoverable,
      ),
    );
    if (convertedLinkError != null) {
      return Result.failure(convertedLinkError);
    }

    return const Result.success(null);
  }

  return action;
});

final linkWithGoogleActionProvider =
    Provider<Future<Result<void, LoginError>> Function()>((ref) {
  final thirdPartyAuthActions = ref.watch(thirdPartyAuthActionsProvider);
  final authActions = ref.watch(authActionsProvider);

  Future<Result<void, LoginError>> action() async {
    final loginGoogleResult = await thirdPartyAuthActions.loginGoogle();
    final convertedLoginError =
        loginGoogleResult.whenOrNull<Result<void, LoginError>>(
      failure: (error) => error.when(
        cancelledByUser: () =>
            const Result.failure(LoginError.cancelledByUser()),
        unrecoverable: () => const Result.failure(LoginError.unrecoverable()),
      ),
    );
    if (convertedLoginError != null) {
      return convertedLoginError;
    }

    final googleCredential =
        (loginGoogleResult as Success<GoogleCredential, LoginThirdPartyError>)
            .value;
    final linkResult = await authActions.linkWithGoogle(googleCredential);
    final convertedLinkError = linkResult.whenOrNull(
      failure: (error) => error.when(
        alreadyInUse: LoginError.alreadyInUse,
        unrecoverable: LoginError.unrecoverable,
      ),
    );
    if (convertedLinkError != null) {
      return Result.failure(convertedLinkError);
    }

    return const Result.success(null);
  }

  return action;
});

final loginWithTwitterActionProvider =
    Provider<Future<Result<void, LoginError>> Function()>((ref) {
  final thirdPartyAuthActions = ref.watch(thirdPartyAuthActionsProvider);
  final authActions = ref.watch(authActionsProvider);

  Future<Result<void, LoginError>> action() async {
    final loginTwitterResult = await thirdPartyAuthActions.loginTwitter();
    final convertedLoginError = loginTwitterResult.whenOrNull<LoginError>(
      failure: (error) => error.when(
        cancelledByUser: LoginError.cancelledByUser,
        unrecoverable: LoginError.unrecoverable,
      ),
    );
    if (convertedLoginError != null) {
      return Result.failure(convertedLoginError);
    }

    final credential =
        (loginTwitterResult as Success<TwitterCredential, LoginThirdPartyError>)
            .value;
    final loginResult = await authActions.loginWithTwitter(
      authToken: credential.authToken,
      secret: credential.secret,
    );
    final convertedLinkError = loginResult.whenOrNull(
      failure: (error) => error.when(
        alreadyInUse: LoginError.alreadyInUse,
        unrecoverable: LoginError.unrecoverable,
      ),
    );
    if (convertedLinkError != null) {
      return Result.failure(convertedLinkError);
    }

    return const Result.success(null);
  }

  return action;
});

final linkWithTwitterActionProvider =
    Provider<Future<Result<void, LoginError>> Function()>((ref) {
  final thirdPartyAuthActions = ref.watch(thirdPartyAuthActionsProvider);
  final authActions = ref.watch(authActionsProvider);

  Future<Result<void, LoginError>> action() async {
    final loginResult = await thirdPartyAuthActions.loginTwitter();
    final convertedLoginError =
        loginResult.whenOrNull<Result<void, LoginError>>(
      failure: (error) => error.when(
        cancelledByUser: () =>
            const Result.failure(LoginError.cancelledByUser()),
        unrecoverable: () => const Result.failure(LoginError.unrecoverable()),
      ),
    );
    if (convertedLoginError != null) {
      return convertedLoginError;
    }

    final credential =
        (loginResult as Success<TwitterCredential, LoginThirdPartyError>).value;
    final linkResult = await authActions.linkWithTwitter(
      authToken: credential.authToken,
      secret: credential.secret,
    );
    final convertedLinkError = linkResult.whenOrNull(
      failure: (error) => error.when(
        alreadyInUse: LoginError.alreadyInUse,
        unrecoverable: LoginError.unrecoverable,
      ),
    );
    if (convertedLinkError != null) {
      return Result.failure(convertedLinkError);
    }

    return const Result.success(null);
  }

  return action;
});

final loginWithFacebookActionProvider =
    Provider<Future<Result<void, LoginError>> Function()>((ref) {
  final thirdPartyAuthActions = ref.watch(thirdPartyAuthActionsProvider);
  final authActions = ref.watch(authActionsProvider);

  Future<Result<void, LoginError>> action() async {
    final loginFacebookResult = await thirdPartyAuthActions.loginFacebook();
    final convertedLoginError = loginFacebookResult.whenOrNull<LoginError>(
      failure: (error) => error.when(
        cancelledByUser: LoginError.cancelledByUser,
        unrecoverable: LoginError.unrecoverable,
      ),
    );
    if (convertedLoginError != null) {
      return Result.failure(convertedLoginError);
    }

    final accessToken =
        (loginFacebookResult as Success<String, LoginThirdPartyError>).value;
    final loginResult =
        await authActions.loginWithFacebook(accessToken: accessToken);
    final convertedLinkError = loginResult.whenOrNull(
      failure: (error) => error.when(
        alreadyInUse: LoginError.alreadyInUse,
        unrecoverable: LoginError.unrecoverable,
      ),
    );
    if (convertedLinkError != null) {
      return Result.failure(convertedLinkError);
    }

    return const Result.success(null);
  }

  return action;
});

final linkWithFacebookActionProvider =
    Provider<Future<Result<void, LoginError>> Function()>((ref) {
  final thirdPartyAuthActions = ref.watch(thirdPartyAuthActionsProvider);
  final authActions = ref.watch(authActionsProvider);

  Future<Result<void, LoginError>> action() async {
    final loginResult = await thirdPartyAuthActions.loginFacebook();
    final convertedLoginError =
        loginResult.whenOrNull<Result<void, LoginError>>(
      failure: (error) => error.when(
        cancelledByUser: () =>
            const Result.failure(LoginError.cancelledByUser()),
        unrecoverable: () => const Result.failure(LoginError.unrecoverable()),
      ),
    );
    if (convertedLoginError != null) {
      return convertedLoginError;
    }

    final accessToken =
        (loginResult as Success<String, LoginThirdPartyError>).value;
    final linkResult =
        await authActions.linkWithFacebook(accessToken: accessToken);
    final convertedLinkError = linkResult.whenOrNull(
      failure: (error) => error.when(
        alreadyInUse: LoginError.alreadyInUse,
        unrecoverable: LoginError.unrecoverable,
      ),
    );
    if (convertedLinkError != null) {
      return Result.failure(convertedLinkError);
    }

    return const Result.success(null);
  }

  return action;
});

final loginWithAppleActionProvider =
    Provider<Future<Result<void, LoginError>> Function()>((ref) {
  final authActions = ref.watch(authActionsProvider);

  return authActions.loginOrLinkWithApple;
});

final linkWithAppleActionProvider =
    Provider<Future<Result<void, LoginError>> Function()>((ref) {
  final authActions = ref.watch(authActionsProvider);

  return authActions.loginOrLinkWithApple;
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
  final thirdPartyAuthActions = ref.watch(thirdPartyAuthActionsProvider);

  Future<Result<void, DeleteAccountError>> action() async {
    final deleteOnFirstResult = await authActions.delete();
    final deleteOnFirstError =
        deleteOnFirstResult.whenOrNull(failure: (error) => error);
    if (deleteOnFirstError == null) {
      return const Result.success(null);
    }

    final providerNeededAuthenticate = deleteOnFirstError.when(
      needReauthenticate: (provider) => provider,
      unrecoverable: () => null,
    );
    if (providerNeededAuthenticate == null) {
      return const Result.failure(DeleteAccountError.unrecoverable());
    }

    switch (providerNeededAuthenticate) {
      case AccountProvider.google:
        final loginGoogleResult = await thirdPartyAuthActions.loginGoogle();
        final convertedLoginError =
            loginGoogleResult.whenOrNull<DeleteAccountError>(
          failure: (error) => error.when(
            cancelledByUser: DeleteAccountError.cancelledByUser,
            unrecoverable: DeleteAccountError.unrecoverable,
          ),
        );
        if (convertedLoginError != null) {
          return Result.failure(convertedLoginError);
        }

        final googleCredential = (loginGoogleResult
                as Success<GoogleCredential, LoginThirdPartyError>)
            .value;
        final reauthenticateResult =
            await authActions.reauthenticateWithGoogle(googleCredential);
        final convertedReauthenticateError = reauthenticateResult.whenOrNull(
          failure: (error) => error.when(
            alreadyInUse: DeleteAccountError.unrecoverable,
            unrecoverable: DeleteAccountError.unrecoverable,
          ),
        );
        if (convertedReauthenticateError != null) {
          return Result.failure(convertedReauthenticateError);
        }

        break;

      case AccountProvider.twitter:
        final loginTwitterResult = await thirdPartyAuthActions.loginTwitter();
        final convertedLoginError =
            loginTwitterResult.whenOrNull<DeleteAccountError>(
          failure: (error) => error.when(
            cancelledByUser: DeleteAccountError.cancelledByUser,
            unrecoverable: DeleteAccountError.unrecoverable,
          ),
        );
        if (convertedLoginError != null) {
          return Result.failure(convertedLoginError);
        }

        final twitterCredential = (loginTwitterResult
                as Success<TwitterCredential, LoginThirdPartyError>)
            .value;
        final reauthenticateResult =
            await authActions.reauthenticateWithTwitter(
          authToken: twitterCredential.authToken,
          secret: twitterCredential.secret,
        );
        final convertedReauthenticateError = reauthenticateResult.whenOrNull(
          failure: (error) => error.when(
            alreadyInUse: DeleteAccountError.unrecoverable,
            unrecoverable: DeleteAccountError.unrecoverable,
          ),
        );
        if (convertedReauthenticateError != null) {
          return Result.failure(convertedReauthenticateError);
        }

        break;

      case AccountProvider.facebook:
        final loginFacebookResult = await thirdPartyAuthActions.loginFacebook();
        final convertedLoginError =
            loginFacebookResult.whenOrNull<DeleteAccountError>(
          failure: (error) => error.when(
            cancelledByUser: DeleteAccountError.cancelledByUser,
            unrecoverable: DeleteAccountError.unrecoverable,
          ),
        );
        if (convertedLoginError != null) {
          return Result.failure(convertedLoginError);
        }

        final accessToken =
            (loginFacebookResult as Success<String, LoginThirdPartyError>)
                .value;
        final reauthenticateResult = await authActions
            .reauthenticateWithFacebook(accessToken: accessToken);
        final convertedReauthenticateError = reauthenticateResult.whenOrNull(
          failure: (error) => error.when(
            alreadyInUse: DeleteAccountError.unrecoverable,
            unrecoverable: DeleteAccountError.unrecoverable,
          ),
        );
        if (convertedReauthenticateError != null) {
          return Result.failure(convertedReauthenticateError);
        }

        break;

      case AccountProvider.apple:
        final reauthenticateWithAppleResult =
            await authActions.loginOrLinkWithApple();
        final convertedLoginError =
            reauthenticateWithAppleResult.whenOrNull<DeleteAccountError>(
          failure: (error) => error.when(
            cancelledByUser: DeleteAccountError.cancelledByUser,
            alreadyInUse: DeleteAccountError.unrecoverable,
            unrecoverable: DeleteAccountError.unrecoverable,
          ),
        );
        if (convertedLoginError != null) {
          return Result.failure(convertedLoginError);
        }

        break;
    }

    final deleteOnSecondResult = await authActions.delete();
    final deleteOnSecondError = deleteOnSecondResult.whenOrNull(
      failure: (error) => error.when(
        needReauthenticate: (_) => const DeleteAccountError.unrecoverable(),
        unrecoverable: DeleteAccountError.unrecoverable,
      ),
    );
    if (deleteOnSecondError != null) {
      return Result.failure(deleteOnSecondError);
    }

    return const Result.success(null);
  }

  return action;
});
