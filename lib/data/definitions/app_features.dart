import 'package:flutter/foundation.dart';
import 'package:my_pet_melody/flavor.dart';

final bool debugScreenAvailable = !(flavor == Flavor.prod && kReleaseMode);
