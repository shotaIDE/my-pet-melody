import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:my_pet_melody/data/service/auth_service.dart';
import 'package:my_pet_melody/data/service/in_app_purchase_service.dart';
import 'package:my_pet_melody/data/service/in_app_purchase_service_mock.dart';
import 'package:my_pet_melody/data/usecase/auth_use_case.dart';
import 'package:my_pet_melody/ui/component/is_premium_plan_text.dart';
import 'package:my_pet_melody/ui/component/rounded_settings_list_tile.dart';
import 'package:my_pet_melody/ui/definition/display_definition.dart';
import 'package:my_pet_melody/ui/definition/list_tile_position_in_group.dart';

class DebugScreen extends ConsumerWidget {
  const DebugScreen({
    super.key,
  });

  static const name = 'DebugScreen';

  static MaterialPageRoute<DebugScreen> route() =>
      MaterialPageRoute<DebugScreen>(
        builder: (_) => const DebugScreen(),
        settings: const RouteSettings(name: name),
      );

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final session = ref.watch(sessionProvider);

    final accountLabel = Text(
      'アカウント',
      style: Theme.of(context).textTheme.labelLarge,
    );
    final signOutTile = session != null
        ? RoundedSettingsListTile(
            title: const Text('サインアウト'),
            onTap: ref.watch(signOutActionProvider),
          )
        : RoundedSettingsListTile(
            title: const Text('サインイン'),
            onTap: ref.watch(signInActionProvider),
          );

    final planLabel = Text(
      'プラン',
      style: Theme.of(context).textTheme.labelLarge,
    );
    final isPremiumPlan = ref.watch(isPremiumPlanProvider);
    final toggleCurrentPlanTile = RoundedSettingsListTile(
      title: const Text('プランをトグルする'),
      trailing: IsPremiumPlanText(isPremiumPlan: isPremiumPlan),
      onTap: ref.watch(toggleIsPremiumPlanForDebugActionProvider),
    );

    final crashlyticsLabel = Text(
      'Crashlytics',
      style: Theme.of(context).textTheme.labelLarge,
    );
    final errorTile = RoundedSettingsListTile(
      title: const Text('強制エラー'),
      onTap: () => throw Error(),
      positionInGroup: ListTilePositionInGroup.first,
    );
    final crashTile = RoundedSettingsListTile(
      title: const Text('強制クラッシュ'),
      onTap: () => FirebaseCrashlytics.instance.crash(),
      positionInGroup: ListTilePositionInGroup.last,
    );

    final body = SingleChildScrollView(
      padding: EdgeInsets.only(
        top: 16,
        bottom: MediaQuery.of(context).viewPadding.bottom + 16,
        left: DisplayDefinition.screenPaddingSmall,
        right: DisplayDefinition.screenPaddingSmall,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          accountLabel,
          const SizedBox(height: 16),
          signOutTile,
          const SizedBox(height: 32),
          planLabel,
          const SizedBox(height: 16),
          toggleCurrentPlanTile,
          const SizedBox(height: 32),
          crashlyticsLabel,
          const SizedBox(height: 16),
          errorTile,
          crashTile,
        ],
      ),
    );

    return Scaffold(
      appBar: AppBar(
        title: const Text('デバッグ'),
      ),
      body: SafeArea(
        top: false,
        bottom: false,
        child: body,
      ),
      resizeToAvoidBottomInset: false,
    );
  }
}
