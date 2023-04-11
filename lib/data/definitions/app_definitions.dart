import 'package:meow_music/environment_config.dart';
import 'package:meow_music/flavor.dart';

class AppDefinitions {
  static const serverHost = EnvironmentConfig.apiHostForEmulatorConfiguration;

  static String get serverOrigin {
    if (F.flavor == Flavor.dev) {
      return 'https://us-central1-colomney-meow-music-dev.cloudfunctions.net';
    }

    const port = 5001;
    return 'http://$serverHost:$port';
  }
}
