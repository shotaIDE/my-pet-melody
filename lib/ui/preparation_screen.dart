import 'package:flutter/material.dart';
import 'package:meow_music/data/definitions/app_definitions.dart';
import 'package:meow_music/ui/select_template_screen.dart';
import 'package:url_launcher/url_launcher.dart';

class PreparationScreen extends StatelessWidget {
  const PreparationScreen({Key? key}) : super(key: key);

  static const name = 'PreparationScreen';

  static MaterialPageRoute route() => MaterialPageRoute<PreparationScreen>(
        builder: (_) => const PreparationScreen(),
        settings: const RouteSettings(name: name),
      );

  @override
  Widget build(BuildContext context) {
    final title = Text(
      '鳴き声を2つ\n用意しておこう',
      textAlign: TextAlign.center,
      style: Theme.of(context).textTheme.headline5,
    );

    final description = RichText(
      textAlign: TextAlign.center,
      text: TextSpan(
        children: [
          TextSpan(
            text: 'まず、鳴き声を2つ録音して',
            style: Theme.of(context).textTheme.bodyText1,
          ),
          TextSpan(
            text: 'トリミング',
            style: Theme.of(context)
                .textTheme
                .bodyText1!
                .copyWith(fontWeight: FontWeight.bold),
          ),
          TextSpan(
            text: 'しておいてね！あとで使うよ！\n一つは',
            style: Theme.of(context).textTheme.bodyText1,
          ),
          TextSpan(
            text: '高めの鳴き声',
            style: Theme.of(context)
                .textTheme
                .bodyText1!
                .copyWith(fontWeight: FontWeight.bold),
          ),
          TextSpan(
            text: '、もう一つは',
            style: Theme.of(context).textTheme.bodyText1,
          ),
          TextSpan(
            text: '低めの鳴き声',
            style: Theme.of(context)
                .textTheme
                .bodyText1!
                .copyWith(fontWeight: FontWeight.bold),
          ),
          TextSpan(
            text: 'を用意しておくといいよ！',
            style: Theme.of(context).textTheme.bodyText1,
          ),
        ],
      ),
    );

    final trimmingButton = TextButton(
      onPressed: () => launch(AppDefinitions.trimmingPageUrl),
      child: const Text('トリミングの方法を確認する'),
    );

    final musicFilesImage = Image.asset('assets/images/music_files.png');

    final body = SingleChildScrollView(
      padding: const EdgeInsets.only(top: 16, bottom: 138, left: 16, right: 16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          description,
          Padding(
            padding: const EdgeInsets.only(top: 16),
            child: trimmingButton,
          ),
          Padding(
            padding: const EdgeInsets.only(top: 32),
            child: musicFilesImage,
          ),
        ],
      ),
    );

    final footerButton = ElevatedButton(
      onPressed: () => _showSelectTemplateScreen(context),
      child: const Text('用意した！'),
    );
    final footerContent = SizedBox(
      width: MediaQuery.of(context).size.width * 0.8,
      child: footerButton,
    );

    final catImage = Image.asset('assets/images/speaking_cat_eye_closed.png');

    final footer = Container(
      alignment: Alignment.center,
      color: Theme.of(context).secondaryHeaderColor,
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 16),
          child: footerContent,
        ),
      ),
    );

    return Scaffold(
      appBar: AppBar(),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 32),
            child: title,
          ),
          Expanded(
            child: Stack(
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 16),
                  child: body,
                ),
                Positioned(bottom: 0, right: 16, child: catImage)
              ],
            ),
          ),
          footer,
        ],
      ),
    );
  }

  Future<void> _showSelectTemplateScreen(BuildContext context) async {
    await Navigator.push<void>(
      context,
      SelectTemplateScreen.route(),
    );
  }
}
