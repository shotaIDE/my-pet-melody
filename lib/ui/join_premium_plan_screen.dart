import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
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

    const largeStorageFeatureTile = ListTile(
      leading: Icon(Icons.cloud_done),
      title: Text('広大な制作スペース'),
      subtitle: Text('最大100作品を保存しておくことができるようになります。'),
      contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
    );
    const rapidGenerationFeatureTile = ListTile(
      leading: Icon(Icons.hourglass_disabled),
      title: Text('高速な制作スピード'),
      subtitle: Text('フリープランよりも優先して作品制作が行われるようになり、作品完成までの待ち時間が短くなります。'),
      contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
    );
    const highQualityGenerationFeatureTile = ListTile(
      leading: Icon(Icons.music_video),
      title: Text('高い制作クオリティ'),
      subtitle: Text('自分でトリミングした鳴き声を作品に指定できるようになります。'),
      contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
    );

    final featureCard = Card(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: const [
          largeStorageFeatureTile,
          rapidGenerationFeatureTile,
          highQualityGenerationFeatureTile,
        ],
      ),
    );

    final joinButton = ElevatedButton(
      onPressed: () async {
        await viewModel.joinPremiumPlan();
      },
      child: const Text('プレミアムプラン 1,000円 / 月'),
    );
    final restoreButton =
        TextButton(onPressed: () {}, child: const Text('機種変更時の復元'));

    const subscriptionDescription1Tile = ListTile(
      title: Text('自動継続課金について'),
      subtitle: Text('期間終了日の24時間以上前に自動更新の解除を行わない場合、契約期間が自動更新されます。'),
    );
    final subscriptionDescription2Tile = ListTile(
      title: const Text('確認と解約'),
      subtitle: Text(
        Platform.isIOS
            ? '設定アプリを開き、[ご自分の名前] > [サブスクリプション] > [MeowMusic]の画面から、'
                '次回の自動更新タイミングの確認や、自動更新の解除ができます。'
            : 'Play ストアアプリを開き、設定 > [定期購入] > [MeowMusic]の画面から、'
                '次回の自動更新タイミングの確認や、自動更新の解除ができます。',
      ),
    );
    final subscriptionDescription3Tile = ListTile(
      title: const Text('機種変更時の復元'),
      subtitle: Text(
        Platform.isIOS
            ? '機種変更時には、本画面から以前購入したプランを無料で復元できます。'
                '購入時と同じ Apple ID で App Store にログインした上で復元してください。'
            : '機種変更時には、本画面から以前購入したプランを無料で復元できます。'
                '購入時と同じ Google アカウントで Play ストアにログインした上で復元してください。',
      ),
    );
    final subscriptionDescription4Tile = ListTile(
      title: const Text('注意点'),
      subtitle: Text(
        Platform.isIOS
            ? 'アプリ内で課金された方は上記以外の方法での解約できません。'
                '当月分のキャンセルについては受け付けておりません。'
                'Apple ID アカウントを経由して課金されます。'
            : 'アプリ内で課金された方は上記以外の方法での解約できません。'
                '当月分のキャンセルについては受け付けておりません。'
                'Google アカウントを経由して課金されます。',
      ),
    );

    final body = SingleChildScrollView(
      padding: const EdgeInsets.only(top: 16, bottom: 203),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: featureCard,
          ),
          const SizedBox(height: 32),
          joinButton,
          const SizedBox(height: 16),
          restoreButton,
          const SizedBox(height: 32),
          subscriptionDescription1Tile,
          const SizedBox(height: 16),
          subscriptionDescription2Tile,
          const SizedBox(height: 16),
          subscriptionDescription3Tile,
          const SizedBox(height: 16),
          subscriptionDescription4Tile,
        ],
      ),
    );

    final scaffold = Scaffold(
      appBar: AppBar(
        title: const Text('プレミアムプラン'),
      ),
      body: body,
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
