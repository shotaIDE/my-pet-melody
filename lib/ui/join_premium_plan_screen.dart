import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:my_pet_melody/data/definitions/app_definitions.dart';
import 'package:my_pet_melody/data/service/in_app_purchase_service.dart';
import 'package:my_pet_melody/data/usecase/purchase_use_case.dart';
import 'package:my_pet_melody/ui/component/rounded_and_chained_list_tile.dart';
import 'package:my_pet_melody/ui/definition/display_definition.dart';
import 'package:my_pet_melody/ui/definition/list_tile_position_in_group.dart';
import 'package:my_pet_melody/ui/join_premium_plan_state.dart';
import 'package:my_pet_melody/ui/join_premium_plan_view_model.dart';

final _joinPremiumPlanViewModelProvider = StateNotifierProvider.autoDispose<
    JoinPremiumPlanViewModel, JoinPremiumPlanState>(
  (ref) => JoinPremiumPlanViewModel(ref: ref),
);

class JoinPremiumPlanScreen extends ConsumerStatefulWidget {
  JoinPremiumPlanScreen({Key? key}) : super(key: key);

  static const name = 'SetPieceTitleScreen';

  final viewModelProvider = _joinPremiumPlanViewModelProvider;

  static MaterialPageRoute<JoinPremiumPlanScreen> route() => MaterialPageRoute(
        builder: (_) => JoinPremiumPlanScreen(),
        settings: const RouteSettings(name: name),
      );

  @override
  ConsumerState<JoinPremiumPlanScreen> createState() =>
      _JoinPremiumPlanScreenState();
}

class _JoinPremiumPlanScreenState extends ConsumerState<JoinPremiumPlanScreen> {
  @override
  void initState() {
    super.initState();

    ref.read(widget.viewModelProvider.notifier).registerListener(
      showCompletedJoiningPremiumPlan: () {
        const snackBar = SnackBar(
          content: Text('プレミアムプランに加入しました'),
        );

        ScaffoldMessenger.of(context).showSnackBar(snackBar);
      },
      showFailedJoiningPremiumPlan: () {
        const snackBar = SnackBar(
          content: Text('エラーが発生しました。しばらくしてから再度お試しください'),
        );

        ScaffoldMessenger.of(context).showSnackBar(snackBar);
      },
      showCompletedRestoring: () {
        const snackBar = SnackBar(
          content: Text('購入履歴を復元しました'),
        );

        ScaffoldMessenger.of(context).showSnackBar(snackBar);
      },
      showFailedRestoring: () {
        const snackBar = SnackBar(
          content: Text('エラーが発生しました。しばらくしてから再度お試しください'),
        );

        ScaffoldMessenger.of(context).showSnackBar(snackBar);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(widget.viewModelProvider);

    const iconSize = 48.0;
    const largeStorageFeatureTile = _RoundedDescriptionListTile(
      leading: Icon(
        Icons.cloud_done,
        size: iconSize,
      ),
      title: Text('広大な制作スペース'),
      description: Text(
        '最大$maxPiecesOnPremiumPlan作品を保存しておくことができるようになります。',
      ),
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

    final purchaseActionsPanel = _PurchaseActionsPanel(
      viewModelProvider: widget.viewModelProvider,
    );

    final restoreButton = TextButton(
      onPressed: ref.read(widget.viewModelProvider.notifier).restore,
      child: const Text('機種変更時の復元'),
    );

    const subscriptionDescription1Tile = _RoundedDescriptionListTile(
      title: Text('自動継続課金について'),
      description: Text('期間終了日の24時間以上前に自動更新の解除を行わない場合、契約期間が自動更新されます。'),
      positionInGroup: ListTilePositionInGroup.first,
    );
    final subscriptionDescription2Tile = _RoundedDescriptionListTile(
      title: const Text('確認と解約'),
      description: Text(
        Platform.isIOS
            ? '設定アプリを開き、[ご自分の名前] > [サブスクリプション] > [うちのコメロディー]の画面から、'
                '次回の自動更新タイミングの確認や、自動更新の解除ができます。'
            : 'Play ストアアプリを開き、設定 > [定期購入] > [うちのコメロディー]の画面から、'
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
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: purchaseActionsPanel,
          ),
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
              ),
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

    return RoundedAndChainedListTile(
      positionInGroup: positionInGroup,
      child: body,
    );
  }
}

class _PurchaseActionsPanel extends ConsumerWidget {
  const _PurchaseActionsPanel({
    required this.viewModelProvider,
    Key? key,
  }) : super(key: key);

  final AutoDisposeStateNotifierProvider<JoinPremiumPlanViewModel,
      JoinPremiumPlanState> viewModelProvider;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isPremiumPlan = ref.watch(isPremiumPlanProvider);

    if (isPremiumPlan == null) {
      return const CircularProgressIndicator();
    }

    if (isPremiumPlan) {
      return const Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.check_circle,
            color: Colors.green,
          ),
          SizedBox(width: 16),
          Text('プレミアムプランに加入済み'),
          SizedBox(width: 8),
        ],
      );
    }

    return _PurchaseButtonsPanel(viewModelProvider: viewModelProvider);
  }
}

class _PurchaseButtonsPanel extends ConsumerWidget {
  const _PurchaseButtonsPanel({
    required this.viewModelProvider,
    Key? key,
  }) : super(key: key);

  final AutoDisposeStateNotifierProvider<JoinPremiumPlanViewModel,
      JoinPremiumPlanState> viewModelProvider;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final purchasableListValue = ref.watch(currentUserPurchasableListProvider);

    return purchasableListValue.when(
      data: (purchasableList) {
        if (purchasableList == null || purchasableList.isEmpty) {
          return const _NoAvailablePurchasableText();
        }

        return ListView.separated(
          physics: const NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          itemBuilder: (_, index) {
            final purchasable = purchasableList[index];

            return _PurchasableButton(
              text: '${purchasable.title} : ${purchasable.price}',
              onPressed: () async {
                await ref
                    .read(viewModelProvider.notifier)
                    .joinPremiumPlan(purchasable: purchasable);
              },
            );
          },
          separatorBuilder: (_, __) => const SizedBox(height: 32),
          itemCount: purchasableList.length,
        );
      },
      loading: () {
        return const CircularProgressIndicator();
      },
      error: (_, __) {
        return const _NoAvailablePurchasableText();
      },
    );
  }
}

class _NoAvailablePurchasableText extends StatelessWidget {
  const _NoAvailablePurchasableText({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(
      '購入可能な商品が見つかりません',
      style: Theme.of(context).textTheme.bodySmall,
    );
  }
}

class _PurchasableButton extends StatelessWidget {
  const _PurchasableButton({
    required this.text,
    required this.onPressed,
    Key? key,
  }) : super(key: key);

  final String text;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ButtonStyle(
          shape: MaterialStateProperty.all<RoundedRectangleBorder>(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(
                DisplayDefinition.cornerRadiusSizeLarge,
              ),
            ),
          ),
          textStyle: MaterialStateProperty.all<TextStyle>(
            Theme.of(context).textTheme.labelLarge!.copyWith(
                  fontSize: 16,
                  // Specify a default text theme to apply the system font
                  // to allow the Japanese yen symbol to be displayed.
                  fontFamily: '',
                ),
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Text(text),
        ),
      ),
    );
  }
}
