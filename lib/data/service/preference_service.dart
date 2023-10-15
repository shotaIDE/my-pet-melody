import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:my_pet_melody/data/model/preference_key.dart';
import 'package:shared_preferences/shared_preferences.dart';

final preferenceServiceProvider = Provider((ref) => PreferenceService());

class PreferenceService {
  Future<bool?> getBool(PreferenceKey key) async {
    final preferences = await SharedPreferences.getInstance();
    return preferences.getBool(key.name);
  }

  Future<void> setBool(
    PreferenceKey key, {
    required bool value,
  }) async {
    final preferences = await SharedPreferences.getInstance();
    await preferences.setBool(key.name, value);
  }

  Future<int?> getInt(PreferenceKey key) async {
    final preferences = await SharedPreferences.getInstance();
    return preferences.getInt(key.name);
  }

  Future<void> setInt(
    PreferenceKey key, {
    required int value,
  }) async {
    final preferences = await SharedPreferences.getInstance();
    await preferences.setInt(key.name, value);
  }

  Future<String?> getString(PreferenceKey key) async {
    final preferences = await SharedPreferences.getInstance();
    return preferences.getString(key.name);
  }

  Future<void> setString(
    PreferenceKey key, {
    required String value,
  }) async {
    final preferences = await SharedPreferences.getInstance();
    await preferences.setString(key.name, value);
  }
}
