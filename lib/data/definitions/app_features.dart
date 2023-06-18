import 'package:flutter/foundation.dart';
import 'package:my_pet_melody/flavor.dart';

class AppFeatures {
  static final debugScreenAvailable =
      !(F.flavor == Flavor.prod && kReleaseMode);
}
