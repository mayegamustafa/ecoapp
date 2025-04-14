import 'package:e_com/_core/_core.dart';
import 'package:e_com/feature/region_settings/repository/region_repo.dart';
import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';

final locate = GetIt.instance;

Future<void> locatorSetUp() async {
  final pref = await SharedPreferences.getInstance();

  locate.registerSingleton<SharedPreferences>(pref);
  locate.registerSingleton<TalkerConfig>(TalkerConfig());
  locate.registerSingleton<LocalDB>(LocalDB());
  locate.registerSingleton<RegionRepo>(RegionRepo());
}
