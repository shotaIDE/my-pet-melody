// ignore_for_file: prefer-match-file-name

import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:my_pet_melody/data/model/google_credential.dart';
import 'package:my_pet_melody/data/model/login_third_party_error.dart';
import 'package:my_pet_melody/data/model/result.dart';

final Provider<ThirdPartyAuthActions> thirdPartyAuthActionsProvider = Provider(
  (ref) => ThirdPartyAuthActions(),
);

class ThirdPartyAuthActions {
  Future<Result<GoogleCredential, LoginThirdPartyError>> loginGoogle() async {
    final account = await GoogleSignIn.instance.authenticate();

    final authentication = account.authentication;
    final idToken = authentication.idToken;
    if (idToken == null) {
      return const Result.failure(LoginThirdPartyError.unrecoverable());
    }

    final credential = GoogleCredential(
      idToken: idToken,
    );
    return Result.success(credential);
  }
}
