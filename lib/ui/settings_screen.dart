import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:meow_music/flavor.dart';
import 'package:meow_music/ui/debug_screen.dart';
import 'package:meow_music/ui/settings_state.dart';
import 'package:meow_music/ui/settings_view_model.dart';

final _loginViewModelProvider =
    StateNotifierProvider.autoDispose<SettingsViewModel, SettingsState>(
  (ref) => SettingsViewModel(
    ref: ref,
  ),
);

class SettingsScreen extends ConsumerStatefulWidget {
  SettingsScreen({
    Key? key,
  }) : super(key: key);

  static const name = 'SettingsScreen';

  final viewModel = _loginViewModelProvider;

  static MaterialPageRoute<SettingsScreen> route() =>
      MaterialPageRoute<SettingsScreen>(
        builder: (_) => SettingsScreen(),
        settings: const RouteSettings(name: name),
        fullscreenDialog: true,
      );

  @override
  ConsumerState<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends ConsumerState<SettingsScreen> {
  @override
  Widget build(BuildContext context) {
    final state = ref.watch(widget.viewModel);

    final profileTile = ListTile(
      leading: const Icon(Icons.account_circle),
      title: const Text('Benjamin Armstrong'),
      trailing: const Icon(Icons.chevron_right),
      onTap: () {},
    );

    const currentPlanTile = ListTile(
      title: Text('現在のプラン'),
      trailing: Text('プレミアムプラン'),
    );
    final registerPremiumPlanTile = ListTile(
      title: const Text('プレミアムプランに登録する'),
      trailing: const Icon(Icons.chevron_right),
      onTap: () {},
    );

    final writeReviewTile = ListTile(
      title: const Text('レビューを書く'),
      trailing: const Icon(Icons.open_in_browser),
      onTap: _writeReview,
    );
    final shareWithFriendsTile = ListTile(
      title: const Text('友達に教える'),
      trailing: const Icon(Icons.open_in_browser),
      onTap: _shareWithFriends,
    );
    final termsOfServiceTile = ListTile(
      title: const Text('利用規約'),
      trailing: const Icon(Icons.open_in_browser),
      onTap: _shareWithFriends,
    );
    final privacyPolicyTile = ListTile(
      title: const Text('プライバシーポリシー'),
      trailing: const Icon(Icons.open_in_browser),
      onTap: _shareWithFriends,
    );
    final debugTile = ListTile(
      title: const Text('デバッグ'),
      trailing: const Icon(Icons.chevron_right),
      onTap: () => Navigator.push(context, DebugScreen.route()),
    );
    const versionTile = ListTile(
      title: Text('バージョン'),
      trailing: Text('0.0.1 (1)'),
    );

    final body = SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.only(top: 16, bottom: 138),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            profileTile,
            const SizedBox(height: 32),
            currentPlanTile,
            registerPremiumPlanTile,
            const SizedBox(height: 32),
            writeReviewTile,
            shareWithFriendsTile,
            termsOfServiceTile,
            privacyPolicyTile,
            const SizedBox(height: 32),
            if (F.flavor == Flavor.emulator || F.flavor == Flavor.dev)
              debugTile,
            versionTile,
          ],
        ),
      ),
    );

    final catImage = Image.asset('assets/images/speaking_cat_eye_closed.png');

    return Scaffold(
      appBar: AppBar(
        title: const Text('設定'),
      ),
      body: SafeArea(
        bottom: false,
        left: false,
        right: false,
        child: Column(
          children: [
            Expanded(
              child: Stack(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 16),
                    child: body,
                  ),
                  Positioned(bottom: 0, right: 16, child: catImage),
                ],
              ),
            ),
          ],
        ),
      ),
      resizeToAvoidBottomInset: false,
    );
  }

  Future<void> _writeReview() async {}

  Future<void> _shareWithFriends() async {}
}
