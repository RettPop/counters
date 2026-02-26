import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/app_settings.dart';

class SettingsNotifier extends AsyncNotifier<AppSettings> {
  static const _keySync = 'settings.sync_enabled';

  @override
  Future<AppSettings> build() async {
    final prefs = await SharedPreferences.getInstance();
    return AppSettings(
      syncEnabled: prefs.getBool(_keySync) ?? false,
    );
  }

  Future<void> setSyncEnabled(bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_keySync, value);
    state = AsyncValue.data(
      (state.valueOrNull ?? const AppSettings()).copyWith(syncEnabled: value),
    );
  }
}

final settingsNotifierProvider =
    AsyncNotifierProvider<SettingsNotifier, AppSettings>(
  () => SettingsNotifier(),
);
