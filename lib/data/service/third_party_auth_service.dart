// ignore_for_file: prefer-match-file-name

import 'dart:async';

import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:my_pet_melody/data/definitions/app_definitions.dart';
import 'package:my_pet_melody/data/model/apple_credential.dart';
import 'package:my_pet_melody/data/model/login_twitter_error.dart';
import 'package:my_pet_melody/data/model/result.dart';
import 'package:my_pet_melody/data/model/twitter_credential.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';
import 'package:twitter_login/twitter_login.dart';

final thirdPartyAuthActionsProvider = Provider(
  (ref) => ThirdPartyAuthActions(),
);

class ThirdPartyAuthActions {
  Future<Result<TwitterCredential, LoginTwitterError>> loginTwitter() async {
    final executor = TwitterLogin(
      apiKey: AppDefinitions.twitterConsumerApiKey,
      apiSecretKey: AppDefinitions.twitterConsumerSecret,
      redirectURI: AppDefinitions.twitterRedirectUri,
    );

    final results = await executor.login();
    final status = results.status;
    if (status == null) {
      return const Result.failure(LoginTwitterError.unrecoverable());
    }

    switch (status) {
      case TwitterLoginStatus.loggedIn:
        final authToken = results.authToken;
        final secret = results.authTokenSecret;
        if (authToken == null || secret == null) {
          return const Result.failure(LoginTwitterError.unrecoverable());
        }

        final credential =
            TwitterCredential(authToken: authToken, secret: secret);
        return Result.success(credential);

      case TwitterLoginStatus.cancelledByUser:
        return const Result.failure(LoginTwitterError.cancelledByUser());

      case TwitterLoginStatus.error:
        return const Result.failure(LoginTwitterError.unrecoverable());
    }
  }

  Future<Result<String, LoginTwitterError>> loginFacebook() async {
    final results = await FacebookAuth.instance.login();

    switch (results.status) {
      case LoginStatus.success:
        final accessToken = results.accessToken?.token;
        if (accessToken == null) {
          return const Result.failure(LoginTwitterError.unrecoverable());
        }

        return Result.success(accessToken);

      case LoginStatus.cancelled:
        return const Result.failure(LoginTwitterError.cancelledByUser());

      case LoginStatus.failed:
      case LoginStatus.operationInProgress:
        return const Result.failure(LoginTwitterError.unrecoverable());
    }
  }

  Future<Result<AppleCredential, LoginTwitterError>> loginApple() async {
    final AuthorizationCredentialAppleID results;

    try {
      results = await SignInWithApple.getAppleIDCredential(
        scopes: [
          AppleIDAuthorizationScopes.email,
          AppleIDAuthorizationScopes.fullName,
        ],
      );
    } on SignInWithAppleAuthorizationException catch (error) {
      switch (error.code) {
        case AuthorizationErrorCode.canceled:
          return const Result.failure(LoginTwitterError.cancelledByUser());

        case AuthorizationErrorCode.failed:
        case AuthorizationErrorCode.invalidResponse:
        case AuthorizationErrorCode.notHandled:
        case AuthorizationErrorCode.notInteractive:
        case AuthorizationErrorCode.unknown:
          return const Result.failure(LoginTwitterError.unrecoverable());
      }
    }

    final idToken = results.identityToken;
    if (idToken == null) {
      return const Result.failure(LoginTwitterError.unrecoverable());
    }

    final appleCredential = AppleCredential(
      idToken: idToken,
      accessToken: results.authorizationCode,
    );

    return Result.success(appleCredential);
  }
}
