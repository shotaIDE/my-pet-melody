import 'package:meow_music/flavor.dart';

class AppDefinitions {
  static const serverHost =
      String.fromEnvironment('API_HOST', defaultValue: '127.0.0.1');

  static String get serverOrigin {
    if (F.flavor == Flavor.dev) {
      return 'https://us-central1-colomney-meow-music-dev.cloudfunctions.net';
    }

    const port = 5001;
    return 'http://$serverHost:$port';
  }
}
