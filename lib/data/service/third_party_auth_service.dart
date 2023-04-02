// ignore_for_file: prefer-match-file-name

import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:meow_music/data/model/login_twitter_error.dart';
import 'package:meow_music/data/model/result.dart';
import 'package:meow_music/data/model/twitter_credential.dart';
import 'package:meow_music/environment_config.dart';
import 'package:twitter_login/twitter_login.dart';

final thirdPartyAuthActionsProvider = Provider(
  (ref) => ThirdPartyAuthActions(),
);

class ThirdPartyAuthActions {
  Future<Result<TwitterCredential, LoginTwitterError>> loginTwitter() async {
    final twitterLogin = TwitterLogin(
      apiKey: EnvironmentConfig.twitterApiKey,
      apiSecretKey: EnvironmentConfig.twitterApiKeySecret,
      redirectURI: EnvironmentConfig.twitterRedirectUri,
    );

    final results = await twitterLogin.login();
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
}
