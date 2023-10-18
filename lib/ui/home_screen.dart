import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:my_pet_melody/data/usecase/auth_use_case.dart';
import 'package:my_pet_melody/ui/component/fetched_thumbnail.dart';
import 'package:my_pet_melody/ui/component/lying_down_cat_image.dart';
import 'package:my_pet_melody/ui/component/profile_icon.dart';
import 'package:my_pet_melody/ui/definition/display_definition.dart';
import 'package:my_pet_melody/ui/home_state.dart';
import 'package:my_pet_melody/ui/home_view_model.dart';
import 'package:my_pet_melody/ui/join_premium_plan_screen.dart';
import 'package:my_pet_melody/ui/select_template_screen.dart';
import 'package:my_pet_melody/ui/settings_screen.dart';
import 'package:my_pet_melody/ui/video_screen.dart';

final homeViewModelProvider =
    StateNotifierProvider.autoDispose<HomeViewModel, HomeState>(
  (ref) => HomeViewModel(
    ref: ref,
    listener: ref.listen,
  ),
);

class HomeScreen extends ConsumerStatefulWidget {
  HomeScreen({
    Key? key,
  }) : super(key: key);

  static const name = 'HomeScreen';

  final viewModelProvider = homeViewModelProvider;

  static MaterialPageRoute<HomeScreen> route() => MaterialPageRoute<HomeScreen>(
        builder: (_) => HomeScreen(),
        settings: const RouteSettings(name: name),
      );

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  @override
  void initState() {
    super.initState();

    ref.read(widget.viewModelProvider.notifier).registerListener(
      moveToSelectTemplateScreen: () async {
        if (!mounted) {
          return;
        }

        await Navigator.push<void>(context, SelectTemplateScreen.route());
      },
      displayMakingPieceIsRestricted: () async {
        if (!mounted) {
          return;
        }

        final shouldShowJoinPremiumPlanScreen = await showDialog<bool>(
          context: context,
          builder: (context) {
            return AlertDialog(
              content: const Text(
                '所有できる作品の最大数を超えました。'
                '新しく作品をつくるには、今ある作品の保存期限が過ぎるのを待つか、プレミアムプランへの加入を検討してください。',
              ),
              actions: [
                TextButton(
                  child: const Text('プレミアムプランとは'),
                  onPressed: () => Navigator.pop(context, true),
                ),
              ],
            );
          },
        );

        if (shouldShowJoinPremiumPlanScreen != true) {
          return;
        }

        if (!mounted) {
          return;
        }

        await Navigator.push<void>(context, JoinPremiumPlanScreen.route());
      },
      confirmToMakePieceWithWarnings: () async {
        if (!mounted) {
          return null;
        }

        return showDialog<ConfirmToMakePieceResult>(
          context: context,
          builder: (context) {
            var requestedDoNotShowAgain = false;

            return StatefulBuilder(
              builder: (context, setState) {
                return AlertDialog(
                  content: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Text(
                        '所有できる作品の最大数を超えました。新しく作品を1つ完成させると過去の作品が1つ削除されていきます。',
                      ),
                      const SizedBox(height: 16),
                      CheckboxListTile(
                        value: requestedDoNotShowAgain,
                        onChanged: (value) {
                          setState(() {
                            requestedDoNotShowAgain = value!;
                          });
                        },
                        title: const Text('今後表示しない'),
                      ),
                    ],
                  ),
                  contentPadding:
                      const EdgeInsets.only(top: 20, left: 24, right: 24),
                  actions: [
                    TextButton(
                      child: const Text('続ける'),
                      onPressed: () => Navigator.pop(
                        context,
                        ConfirmToMakePieceResult.continued(
                          requestedDoNotShowWarningsAgain:
                              requestedDoNotShowAgain,
                        ),
                      ),
                    ),
                    TextButton(
                      child: const Text('キャンセル'),
                      onPressed: () => Navigator.pop(
                        context,
                        const ConfirmToMakePieceResult.canceled(),
                      ),
                    ),
                  ],
                );
              },
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(widget.viewModelProvider);
    final pieces = state.pieces;
    final Widget body;
    if (pieces == null) {
      body = const Center(
        child: CircularProgressIndicator(),
      );
    } else {
      final currentDateTime = DateTime.now();

      if (pieces.isNotEmpty) {
        body = ListView.separated(
          padding: const EdgeInsets.only(
            top: DisplayDefinition.screenPaddingSmall,
            bottom: LyingDownCatImage.height,
            left: DisplayDefinition.screenPaddingSmall,
            right: DisplayDefinition.screenPaddingSmall,
          ),
          itemBuilder: (_, index) {
            final playablePiece = pieces[index];

            final thumbnailImageUrl = playablePiece.piece.thumbnailUrl;
            final thumbnailImage = FetchedThumbnail(url: thumbnailImageUrl);

            final thumbnail = SizedBox(
              width: DisplayDefinition.thumbnailWidthLarge,
              height: DisplayDefinition.thumbnailHeightLarge,
              child: thumbnailImage,
            );

            final piece = playablePiece.piece;
            final foregroundColor = piece.map(
              generating: (_) => Theme.of(context).disabledColor,
              generated: (_) => null,
            );
            final nameText = Text(
              piece.name,
              style: TextStyle(color: foregroundColor),
            );

            final detailsText = piece.map(
              generating: (generating) => Text(
                '製作中',
                style: TextStyle(color: foregroundColor),
              ),
              generated: (generated) {
                final availableUntil = generated.availableUntil;
                if (availableUntil == null) {
                  return null;
                }

                final dateFormatter = DateFormat.yMd('ja');
                final timeFormatter = DateFormat.Hm('ja');
                final text = '保存期限: '
                    '${dateFormatter.format(availableUntil)} '
                    '${timeFormatter.format(availableUntil)}';
                final color = currentDateTime.isAfter(
                  availableUntil.add(const Duration(days: -1)),
                )
                    ? Theme.of(context).colorScheme.error
                    : foregroundColor;

                return Text(
                  text,
                  style: TextStyle(color: color),
                );
              },
            );
            final body = <Widget>[nameText];
            if (detailsText != null) {
              body.addAll([
                const SizedBox(height: 8),
                detailsText,
              ]);
            }

            final onTap = piece.map(
              generating: (_) => null,
              generated: (generatedPiece) => () => Navigator.push(
                    context,
                    VideoScreen.route(piece: generatedPiece),
                  ),
            );

            final borderColor = piece.map(
              generating: (_) => Theme.of(context).dividerColor,
              generated: (_) => Colors.transparent,
            );
            final backgroundColor = piece.map(
              generating: (_) => Colors.transparent,
              generated: (_) => Theme.of(context).cardColor,
            );

            return ClipRRect(
              borderRadius: const BorderRadius.all(
                Radius.circular(
                  DisplayDefinition.cornerRadiusSizeSmall,
                ),
              ),
              child: Material(
                color: backgroundColor,
                shape: RoundedRectangleBorder(
                  side: BorderSide(color: borderColor),
                  borderRadius: BorderRadius.circular(
                    DisplayDefinition.cornerRadiusSizeSmall,
                  ),
                ),
                child: InkWell(
                  onTap: onTap,
                  child: Row(
                    children: [
                      thumbnail,
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: body,
                        ),
                      ),
                      const SizedBox(width: 16),
                    ],
                  ),
                ),
              ),
            );
          },
          itemCount: pieces.length,
          separatorBuilder: (_, __) => const SizedBox(height: 8),
        );
      } else {
        body = Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Text(
              'まだ作品を製作していません。\n右下の “+” ボタンから作品を製作しましょう。',
              textAlign: TextAlign.center,
              style: Theme.of(context)
                  .textTheme
                  .bodyLarge!
                  .copyWith(color: Theme.of(context).disabledColor),
            ),
          ),
        );
      }
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('つくった作品'),
        actions: [
          _SettingsButton(
            onPressed: () => Navigator.push(context, SettingsScreen.route()),
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: Stack(
              children: [
                SafeArea(
                  top: false,
                  bottom: false,
                  child: body,
                ),
                const Positioned(
                  bottom: 0,
                  left: 16,
                  child: LyingDownCatImage(),
                ),
              ],
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: ref.read(widget.viewModelProvider.notifier).onMakePiece,
        child: const Icon(Icons.add),
      ),
      resizeToAvoidBottomInset: false,
    );
  }
}

class _SettingsButton extends ConsumerWidget {
  const _SettingsButton({
    required this.onPressed,
    Key? key,
  }) : super(key: key);

  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final photoUrl = ref.watch(profilePhotoUrlProvider);

    return IconButton(
      onPressed: onPressed,
      icon: ProfileIcon(photoUrl: photoUrl),
    );
  }
}
