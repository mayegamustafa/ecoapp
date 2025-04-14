import 'package:e_com/_core/_core.dart';
import 'package:e_com/models/models.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

final storeListProvider = Provider<PagedItem<StoreModel>?>((ref) {
  final pref = ref.watch(sharedPrefProvider);
  final stores = pref.getString(CachedKeys.shops);
  if (stores == null) return null;

  return PagedItem<StoreModel>.fromJson(
    stores,
    (source) => StoreModel.fromJson(source),
  );
});
