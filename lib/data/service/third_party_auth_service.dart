// ignore_for_file: prefer-match-file-name

import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:my_pet_melody/data/definitions/app_definitions.dart';
import 'package:my_pet_melody/data/model/login_twitter_error.dart';
import 'package:my_pet_melody/data/model/result.dart';
import 'package:my_pet_melody/data/model/twitter_credential.dart';
import 'package:my_pet_melody/environment_config.dart';
import 'package:twitter_login/twitter_login.dart';

final thirdPartyAuthActionsProvider = Provider(
  (ref) => ThirdPartyAuthActions(),
);

class ThirdPartyAuthActions {
  Future<Result<TwitterCredential, LoginTwitterError>> loginTwitter() async {
    final executor = TwitterLogin(
      apiKey: EnvironmentConfig.twitterConsumerApiKey,
      apiSecretKey: EnvironmentConfig.twitterConsumerSecret,
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
}
