import 'package:dio/dio.dart';
import 'package:e_com/_core/_core.dart';
import 'package:e_com/locator.dart';
import 'package:e_com/models/models.dart';

class RegionRepo {
  final ldb = locate<LocalDB>();

  Future<bool> setLanguage(String langCode) async {
    return await ldb.setLanguage(langCode);
  }

  Future<void> setDefLanguage(String langCode) async {
    await ldb.setDefLanguage(langCode);
  }

  Future<void> setCurrency(Currency currency) async {
    await ldb.setCurrency(currency);
  }

  Future<void> setDefCurrency(Currency currency) async {
    await ldb.setDefCurrency(currency);
  }

  Future<void> set({
    Currency? currency,
    Currency? defCurrency,
    String? langCode,
    String? defLangCode,
  }) async {
    await Future.wait([
      if (currency != null) ldb.setCurrency(currency),
      if (langCode != null) ldb.setLanguage(langCode),
      if (defCurrency != null) ldb.setDefCurrency(defCurrency),
      if (defLangCode != null) ldb.setDefLanguage(defLangCode),
    ]);
  }

  Future<void> setFromResponse(Response response) async {
    final data = response.data;
    if (data case {'currency': QMap c, 'default_currency': QMap b}) {
      await set(
        currency: Currency.fromMap(c),
        defCurrency: Currency.fromMap(b),
      );
    }
  }

  Currency? getCurrency() {
    final currency = ldb.getCurrency();
    return currency;
  }

  Currency? getBaseCurrency() {
    return ldb.getDefCurrency() ?? ldb.getDefCurrency();
  }

  String? getLanguage() {
    final lang = ldb.getLanguage() ?? ldb.getDefLanguage();
    return lang;
  }

  RegionModel getRegion() {
    final data = RegionModel.def.copyWith(
      langCode: ldb.getLanguage(),
      currency: ldb.getCurrency(),
      defCurrency: ldb.getDefCurrency(),
      defLangCode: ldb.getDefLanguage(),
    );
    return data;
  }
}
