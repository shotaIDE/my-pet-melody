import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:meow_music/ui/login_state.dart';

class LoginViewModel extends StateNotifier<LoginState> {
  LoginViewModel() : super(const LoginState());
}
