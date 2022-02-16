import 'package:meow_music/data/model/preference_key.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PreferenceService {
  static Future<bool?> getBool(PreferenceKey key) async {
    final preferences = await SharedPreferences.getInstance();
    return preferences.getBool(key.name);
  }

  static Future<void> setBool(
    PreferenceKey key, {
    required bool value,
  }) async {
    final preferences = await SharedPreferences.getInstance();
    await preferences.setBool(key.name, value);
  }

  static Future<String?> getString(PreferenceKey key) async {
    final preferences = await SharedPreferences.getInstance();
    return preferences.getString(key.name);
  }

  static Future<void> setString(
    PreferenceKey key, {
    required String value,
  }) async {
    final preferences = await SharedPreferences.getInstance();
    await preferences.setString(key.name, value);
  }
}
