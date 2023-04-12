import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:meow_music/data/model/link_credential_error.dart';
import 'package:meow_music/data/model/result.dart';
import 'package:meow_music/data/usecase/auth_use_case.dart';
import 'package:meow_music/ui/login_state.dart';

class LoginViewModel extends StateNotifier<LoginState> {
  LoginViewModel({
    required Ref ref,
  })  : _ref = ref,
        super(const LoginState());

  final Ref _ref;

  Future<Result<void, LinkCredentialError>> loginWithTwitter() async {
    state = state.copyWith(isProcessing: true);

    final action = _ref.read(linkWithTwitterActionProvider);

    final result = await action();

    state = state.copyWith(isProcessing: false);

    return result;
  }
}
