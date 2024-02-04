// ignore_for_file: prefer-match-file-name

import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:my_pet_melody/data/definitions/app_definitions.dart';
import 'package:my_pet_melody/data/model/google_credential.dart';
import 'package:my_pet_melody/data/model/login_third_party_error.dart';
import 'package:my_pet_melody/data/model/result.dart';
import 'package:my_pet_melody/data/model/twitter_credential.dart';
import 'package:twitter_login/twitter_login.dart';

final thirdPartyAuthActionsProvider = Provider(
  (ref) => ThirdPartyAuthActions(),
);

class ThirdPartyAuthActions {
  Future<Result<GoogleCredential, LoginThirdPartyError>> loginGoogle() async {
    final executor = GoogleSignIn();

    final result = await executor.signIn();
    if (result == null) {
      return const Result.failure(LoginThirdPartyError.cancelledByUser());
    }

    final authentication = await result.authentication;
    final idToken = authentication.idToken;
    final accessToken = authentication.accessToken;
    if (idToken == null || accessToken == null) {
      return const Result.failure(LoginThirdPartyError.unrecoverable());
    }

    final credential =
        GoogleCredential(idToken: idToken, accessToken: accessToken);
    return Result.success(credential);
  }

  Future<Result<TwitterCredential, LoginThirdPartyError>> loginTwitter() async {
    final executor = TwitterLogin(
      apiKey: twitterConsumerApiKey,
      apiSecretKey: twitterConsumerSecret,
      redirectURI: twitterRedirectUri,
    );

    final results = await executor.login();
    final status = results.status;
    if (status == null) {
      return const Result.failure(LoginThirdPartyError.unrecoverable());
    }

    switch (status) {
      case TwitterLoginStatus.loggedIn:
        final authToken = results.authToken;
        final secret = results.authTokenSecret;
        if (authToken == null || secret == null) {
          return const Result.failure(LoginThirdPartyError.unrecoverable());
        }

        final credential =
            TwitterCredential(authToken: authToken, secret: secret);
        return Result.success(credential);

      case TwitterLoginStatus.cancelledByUser:
        return const Result.failure(LoginThirdPartyError.cancelledByUser());

      case TwitterLoginStatus.error:
        return const Result.failure(LoginThirdPartyError.unrecoverable());
    }
  }
}
