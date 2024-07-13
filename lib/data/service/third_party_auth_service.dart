// ignore_for_file: prefer-match-file-name

import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:my_pet_melody/data/model/google_credential.dart';
import 'package:my_pet_melody/data/model/login_third_party_error.dart';
import 'package:my_pet_melody/data/model/result.dart';

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
}
