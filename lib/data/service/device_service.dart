import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final deviceLocaleProvider =
    StateNotifierProvider<DeviceLocaleNotifier, Locale>((_) {
  return DeviceLocaleNotifier();
});

class DeviceLocaleNotifier extends StateNotifier<Locale> {
  DeviceLocaleNotifier()
      : super(WidgetsBinding.instance.platformDispatcher.locale);

  void updateIfNeeded(Locale locale) {
    if (state == locale) {
      return;
    }

    debugPrint('Device locale updated: from $state to $locale.');

    state = locale;
  }
}
