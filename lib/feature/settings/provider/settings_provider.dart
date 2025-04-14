import 'package:e_com/_core/_core.dart';
import 'package:e_com/locator.dart';
import 'package:e_com/models/settings/config_model.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

final settingsProvider = Provider<ConfigModel?>((ref) {
  final pref = locate<SharedPreferences>();

  final data = pref.getString(CachedKeys.config);

  if (data == null) return null;

  return ConfigModel.fromJson(data);
});
