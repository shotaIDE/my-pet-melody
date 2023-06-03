import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:meow_music/ui/component/primary_button.dart';
import 'package:meow_music/ui/definition/display_definition.dart';
import 'package:meow_music/ui/definition/list_tile_position_in_group.dart';
import 'package:meow_music/ui/join_premium_plan_state.dart';
import 'package:meow_music/ui/join_premium_plan_view_model.dart';

final _joinPremiumPlanViewModelProvider = StateNotifierProvider.autoDispose<
    JoinPremiumPlanViewModel, JoinPremiumPlanState>(
  (_) => JoinPremiumPlanViewModel(),
);

class JoinPremiumPlanScreen extends ConsumerStatefulWidget {
  JoinPremiumPlanScreen({Key? key}) : super(key: key);

  static const name = 'SetPieceTitleScreen';

  final viewModelProvider = _joinPremiumPlanViewModelProvider;

  static MaterialPageRoute route() => MaterialPageRoute<JoinPremiumPlanScreen>(
        builder: (_) => JoinPremiumPlanScreen(),
        settings: const RouteSettings(name: name),
      );

  @override
  ConsumerState<JoinPremiumPlanScreen> createState() =>
      _JoinPremiumPlanScreenState();
}

class _JoinPremiumPlanScreenState extends ConsumerState<JoinPremiumPlanScreen> {
  @override
  Widget build(BuildContext context) {
    final state = ref.watch(widget.viewModelProvider);
    final viewModel = ref.watch(widget.viewModelProvider.notifier);

    const iconSize = 48.0;
    const largeStorageFeatureTile = _RoundedDescriptionListTile(
      leading: Icon(
        Icons.cloud_done,
        size: iconSize,
      ),
      title: Text('広大な制作スペース'),
      description: Text('最大100作品を保存しておくことができるようになります。'),
      positionInGroup: ListTilePositionInGroup.first,
    );
    const rapidGenerationFeatureTile = _RoundedDescriptionListTile(
      leading: Icon(
        Icons.hourglass_disabled,
        size: iconSize,
      ),
      title: Text('高速な制作スピード'),
      description: Text('フリープランよりも優先して作品制作が行われるようになり、作品完成までの待ち時間が短くなります。'),
      positionInGroup: ListTilePositionInGroup.middle,
    );
    const highQualityGenerationFeatureTile = _RoundedDescriptionListTile(
      leading: Icon(
        Icons.music_video,
        size: iconSize,
      ),
      title: Text('高い制作クオリティ'),
      description: Text('自分でトリミングした鳴き声を作品に指定できるようになります。'),
      positionInGroup: ListTilePositionInGroup.last,
    );

    final featuresPanel = Column(
      mainAxisSize: MainAxisSize.min,
      children: const [
        largeStorageFeatureTile,
        rapidGenerationFeatureTile,
        highQualityGenerationFeatureTile,
      ],
    );

    final joinButton = PrimaryButton(
      text: 'プレミアムプラン 1,000円 / 月',
      onPressed: () async {
        await viewModel.joinPremiumPlan();
      },
    );
    final restoreButton =
        TextButton(onPressed: () {}, child: const Text('機種変更時の復元'));

    const subscriptionDescription1Tile = _RoundedDescriptionListTile(
      title: Text('自動継続課金について'),
      description: Text('期間終了日の24時間以上前に自動更新の解除を行わない場合、契約期間が自動更新されます。'),
      positionInGroup: ListTilePositionInGroup.first,
    );
    final subscriptionDescription2Tile = _RoundedDescriptionListTile(
      title: const Text('確認と解約'),
      description: Text(
        Platform.isIOS
            ? '設定アプリを開き、[ご自分の名前] > [サブスクリプション] > [MeowMusic]の画面から、'
                '次回の自動更新タイミングの確認や、自動更新の解除ができます。'
            : 'Play ストアアプリを開き、設定 > [定期購入] > [MeowMusic]の画面から、'
                '次回の自動更新タイミングの確認や、自動更新の解除ができます。',
      ),
      positionInGroup: ListTilePositionInGroup.middle,
    );
    final subscriptionDescription3Tile = _RoundedDescriptionListTile(
      title: const Text('機種変更時の復元'),
      description: Text(
        Platform.isIOS
            ? '機種変更時には、本画面から以前購入したプランを無料で復元できます。'
                '購入時と同じ Apple ID で App Store にログインした上で復元してください。'
            : '機種変更時には、本画面から以前購入したプランを無料で復元できます。'
                '購入時と同じ Google アカウントで Play ストアにログインした上で復元してください。',
      ),
      positionInGroup: ListTilePositionInGroup.middle,
    );
    final subscriptionDescription4Tile = _RoundedDescriptionListTile(
      title: const Text('注意点'),
      description: Text(
        Platform.isIOS
            ? 'アプリ内で課金された方は上記以外の方法での解約できません。'
                '当月分のキャンセルについては受け付けておりません。'
                'Apple ID アカウントを経由して課金されます。'
            : 'アプリ内で課金された方は上記以外の方法での解約できません。'
                '当月分のキャンセルについては受け付けておりません。'
                'Google アカウントを経由して課金されます。',
      ),
      positionInGroup: ListTilePositionInGroup.last,
    );

    final body = SingleChildScrollView(
      padding: EdgeInsets.only(
        top: 16,
        bottom: MediaQuery.of(context).viewPadding.bottom,
        left: DisplayDefinition.screenPaddingSmall,
        right: DisplayDefinition.screenPaddingSmall,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          largeStorageFeatureTile,
          rapidGenerationFeatureTile,
          highQualityGenerationFeatureTile,
          const SizedBox(height: 32),
          joinButton,
          const SizedBox(height: 16),
          restoreButton,
          const SizedBox(height: 32),
          subscriptionDescription1Tile,
          subscriptionDescription2Tile,
          subscriptionDescription3Tile,
          subscriptionDescription4Tile,
        ],
      ),
    );

    final scaffold = Scaffold(
      appBar: AppBar(
        title: const Text('プレミアムプラン'),
      ),
      body: SafeArea(
        top: false,
        bottom: false,
        child: body,
      ),
      resizeToAvoidBottomInset: false,
    );

    return state.isProcessing
        ? Stack(
            children: [
              scaffold,
              Container(
                alignment: Alignment.center,
                color: Colors.black.withOpacity(0.5),
                child: const LinearProgressIndicator(),
              )
            ],
          )
        : scaffold;
  }
}

class _RoundedDescriptionListTile extends StatelessWidget {
  const _RoundedDescriptionListTile({
    required this.title,
    required this.description,
    this.leading,
    this.positionInGroup = ListTilePositionInGroup.only,
    Key? key,
  }) : super(key: key);

  final Widget title;
  final Widget description;
  final Widget? leading;
  final ListTilePositionInGroup positionInGroup;

  @override
  Widget build(BuildContext context) {
    final titleAndDescription = Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        DefaultTextStyle.merge(
          style: Theme.of(context).textTheme.bodyMedium,
          child: title,
        ),
        const SizedBox(height: 8),
        DefaultTextStyle.merge(
          style: Theme.of(context).textTheme.bodySmall,
          child: description,
        ),
      ],
    );

    final bodyWidgets = <Widget>[];
    if (leading != null) {
      bodyWidgets.addAll([
        leading!,
        const SizedBox(width: 16),
      ]);
    }

    bodyWidgets.add(
      Expanded(
        child: titleAndDescription,
      ),
    );

    final body = Row(
      children: bodyWidgets,
    );

    final BorderRadius borderRadius;
    switch (positionInGroup) {
      case ListTilePositionInGroup.first:
        borderRadius = const BorderRadius.only(
          topLeft: Radius.circular(
            DisplayDefinition.cornerRadiusSizeSmall,
          ),
          topRight: Radius.circular(
            DisplayDefinition.cornerRadiusSizeSmall,
          ),
        );
        break;
      case ListTilePositionInGroup.middle:
        borderRadius = BorderRadius.zero;
        break;
      case ListTilePositionInGroup.last:
        borderRadius = const BorderRadius.only(
          bottomLeft: Radius.circular(
            DisplayDefinition.cornerRadiusSizeSmall,
          ),
          bottomRight: Radius.circular(
            DisplayDefinition.cornerRadiusSizeSmall,
          ),
        );
        break;
      case ListTilePositionInGroup.only:
        borderRadius = const BorderRadius.all(
          Radius.circular(
            DisplayDefinition.cornerRadiusSizeSmall,
          ),
        );
    }

    return ClipRRect(
      borderRadius: borderRadius,
      child: Material(
        color: Theme.of(context).cardColor,
        shape: RoundedRectangleBorder(
          borderRadius: borderRadius,
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
          child: body,
        ),
      ),
    );
  }
}
