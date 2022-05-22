import 'package:meow_music/flavor.dart';

class AppDefinitions {
  static String get serverOrigin {
    if (F.flavor == Flavor.dev) {
      return 'https://us-central1-colomney-meow-music-dev.cloudfunctions.net';
    }

    const host = String.fromEnvironment('API_HOST');
    const port = 5001;
    if (host.isNotEmpty) {
      return 'http://$host:$port';
    }

    return 'http://127.0.0.1:$port';
  }
}
