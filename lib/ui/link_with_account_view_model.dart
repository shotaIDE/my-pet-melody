import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:my_pet_melody/data/model/login_error.dart';
import 'package:my_pet_melody/data/model/result.dart';
import 'package:my_pet_melody/data/usecase/auth_use_case.dart';
import 'package:my_pet_melody/ui/link_with_account_state.dart';

class LinkWithAccountViewModel extends StateNotifier<LinkWithAccountState> {
  LinkWithAccountViewModel({
    required Ref ref,
  })  : _ref = ref,
        super(const LinkWithAccountState());

  final Ref _ref;

  Future<Result<void, LoginError>> loginWithTwitter() async {
    state = state.copyWith(isProcessing: true);

    final action = _ref.read(linkWithTwitterActionProvider);

    final result = await action();

    state = state.copyWith(isProcessing: false);

    return result;
  }

  Future<Result<void, LoginError>> continueWithFacebook() async {
    state = state.copyWith(isProcessing: true);

    final action = _ref.read(linkWithFacebookActionProvider);

    final result = await action();

    state = state.copyWith(isProcessing: false);

    return result;
  }
}
