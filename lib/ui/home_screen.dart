import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  static const name = 'HomeScreen';

  static MaterialPageRoute route() => MaterialPageRoute<HomeScreen>(
        builder: (_) => const HomeScreen(),
        settings: const RouteSettings(name: name),
      );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Meow Music'),
      ),
      body: const Placeholder(),
    );
  }
}
