import 'dart:io';

import 'package:app_review/app_review.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:meow_music/data/model/profile.dart';
import 'package:meow_music/data/usecase/auth_use_case.dart';
import 'package:meow_music/flavor.dart';
import 'package:meow_music/ui/debug_screen.dart';
import 'package:meow_music/ui/settings_state.dart';
import 'package:meow_music/ui/settings_view_model.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';

final _loginViewModelProvider =
    StateNotifierProvider.autoDispose<SettingsViewModel, SettingsState>(
  (ref) => SettingsViewModel(
    ref: ref,
  ),
);

class SettingsScreen extends StatefulWidget {
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
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  @override
  Widget build(BuildContext context) {
    final profileTile = _ProfileTile(onTap: () {});

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
      onTap: _openTermsOfService,
    );
    final privacyPolicyTile = ListTile(
      title: const Text('プライバシーポリシー'),
      trailing: const Icon(Icons.open_in_browser),
      onTap: _openPrivacyPolicy,
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

  Future<void> _writeReview() async {
    if (Platform.isIOS) {
      // In-app reviews are limited to the number of times they can be displayed,
      // so go to the App Store and open the page to write a review.
      await AppReview.openIosReview(compose: true);
    } else if (Platform.isAndroid) {
      //In-app reviews are limited in the number of times they can be displayed,
      // so only make the transition to Google Play.
      await AppReview.openGooglePlay();
    }
  }

  Future<void> _shareWithFriends() async {
    // TODO(ide): Replace URL
    final storeUrl = Platform.isIOS
        ? 'https://apps.apple.com/jp/app/xxxx'
        : 'https://play.google.com/store/apps/details?id=xxxx';
    await Share.share('あなたのネコのオリジナルソングを作ろう！ $storeUrl');
  }

  Future<void> _openTermsOfService() async {
    await launchUrl(
      Uri.parse(
        'https://tricolor-fright-c89.notion.site/8b169d10b790461ab72b961064e16c49',
      ),
    );
  }

  Future<void> _openPrivacyPolicy() async {
    await launchUrl(
      Uri.parse(
        'https://tricolor-fright-c89.notion.site/19903a30a07e4499887f37ee67fdf876',
      ),
    );
  }
}

class _ProfileTile extends ConsumerWidget {
  const _ProfileTile({
    required this.onTap,
    Key? key,
  }) : super(key: key);

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final profile = ref.watch(nonAnonymousProfileProvider);
    return profile != null
        ? _LoggedInProfileTile(profile: profile, onTap: onTap)
        : _NotLoggedInTile(onTap: onTap);
  }
}

class _LoggedInProfileTile extends StatelessWidget {
  const _LoggedInProfileTile({
    required this.profile,
    required this.onTap,
    Key? key,
  }) : super(key: key);

  final Profile profile;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final photoUrl = profile.photoUrl;
    final icon = photoUrl != null
        ? Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              image: DecorationImage(
                fit: BoxFit.fill,
                image: NetworkImage(photoUrl),
              ),
            ),
          )
        : const Icon(Icons.account_circle);

    final name = profile.name;
    final titleText = name ?? '(No Name)';

    return ListTile(
      leading: icon,
      title: Text(titleText),
      trailing: const Icon(Icons.chevron_right),
      onTap: onTap,
    );
  }
}

class _NotLoggedInTile extends StatelessWidget {
  const _NotLoggedInTile({
    required this.onTap,
    Key? key,
  }) : super(key: key);

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: const Text('アカウントを作成する'),
      trailing: const Icon(Icons.chevron_right),
      onTap: onTap,
    );
  }
}
