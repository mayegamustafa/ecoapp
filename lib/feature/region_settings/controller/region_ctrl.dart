import 'package:e_com/feature/auth/controller/auth_ctrl.dart';
import 'package:e_com/feature/home/controller/home_page_ctrl.dart';
import 'package:e_com/feature/region_settings/repository/region_repo.dart';
import 'package:e_com/feature/settings/controller/settings_ctrl.dart';
import 'package:e_com/feature/user_dash/controller/dash_ctrl.dart';
import 'package:e_com/locator.dart';
import 'package:e_com/models/settings/region_model.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

final regionCtrlProvider =
    NotifierProvider<RegionCtrlNotifier, RegionModel>(RegionCtrlNotifier.new);

class RegionCtrlNotifier extends Notifier<RegionModel> {
  final _repo = locate<RegionRepo>();

  @override
  RegionModel build() => _repo.getRegion();

  Future<void> setLangCode(String code, {bool resetState = false}) async {
    final region = state.copyWith(langCode: code);
    _repo.setLanguage(code);
    state = region;
    if (resetState) _invalidate();
  }

  setCurrencyCode(Currency currency, {bool resetState = false}) async {
    final region = state.copyWith(currency: currency);
    _repo.setCurrency(currency);
    state = region;
    if (resetState) _invalidate();
  }

  void _invalidate() {
    ref.invalidate(homeCtrlProvider);
    ref.invalidate(settingsCtrlProvider);
    if (ref.watch(authCtrlProvider)) ref.invalidate(userDashCtrlProvider);
  }
}
