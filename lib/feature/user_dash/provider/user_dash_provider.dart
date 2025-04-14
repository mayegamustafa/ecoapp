import 'package:e_com/_core/_core.dart';
import 'package:e_com/models/user/user_dash_model.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

final userDashProvider = Provider<UserDashModel?>((ref) {
  final pref = ref.watch(sharedPrefProvider);

  final data = pref.getString(CachedKeys.userDash);

  if (data == null) return null;

  return UserDashModel.fromJson(data);
});
