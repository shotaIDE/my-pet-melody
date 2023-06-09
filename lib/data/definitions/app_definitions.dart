import 'package:my_pet_melody/environment_config.dart';
import 'package:my_pet_melody/flavor.dart';

class AppDefinitions {
  static const serverHostForEmulatorConfiguration =
      EnvironmentConfig.serverHostForEmulatorConfiguration;

  static String get serverOrigin {
    if (F.flavor == Flavor.dev) {
      return 'https://asia-east1-colomney-my-pet-melody-dev.cloudfunctions.net';
    }

    const port = 5001;
    return 'http://$serverHostForEmulatorConfiguration:$port';
  }
}
