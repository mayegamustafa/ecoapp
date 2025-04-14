import 'dart:async';

import 'package:e_com/_core/_core.dart';
import 'package:e_com/feature/region_settings/controller/region_ctrl.dart';
import 'package:e_com/feature/region_settings/repository/region_repo.dart';
import 'package:e_com/feature/settings/repository/settings_repo.dart';
import 'package:e_com/locator.dart';
import 'package:e_com/models/models.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../provider/settings_provider.dart';

final settingsCtrlProvider =
    AsyncNotifierProvider<SettingsCtrlNotifier, ConfigModel>(
  SettingsCtrlNotifier.new,
);

class SettingsCtrlNotifier extends AsyncNotifier<ConfigModel> {
  SettingsRepo get _repo => ref.watch(settingsRepoProvider);

  @override
  FutureOr<ConfigModel> build() {
    return _init();
  }

  FutureOr<ConfigModel> _init() async {
    final res = await _repo.getConfig();

    return await res.fold(
      (l) => Future.error(l.message, l.stackTrace),
      (r) async {
        await _setConfigState(r.data);
        final regionRepo = locate<RegionRepo>();
        await regionRepo.setDefLanguage(r.data.defaultLanguage.code);
        ref.invalidate(regionCtrlProvider);

        locate<SharedPreferences>()
            .setBool(PrefKeys.currencyOnLeft, r.data.settings.currencyOnLeft);
        return r.data;
      },
    );
  }

  reload() async {
    state = const AsyncValue.loading();
    ref.invalidateSelf();
  }

  Future<void> reloadSilently() async {
    state = await AsyncValue.guard(() async => await _init());
  }

  Future<void> _setConfigState(ConfigModel config) async {
    final pref = locate<SharedPreferences>();
    await pref.setString(CachedKeys.config, config.toJson());

    ref.invalidate(settingsProvider);
  }
}
