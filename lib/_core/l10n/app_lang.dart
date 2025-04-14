import 'package:e_com/main.export.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AppLang {
  static const String en = 'en';
  static const Locale enLocale = Locale(en);
  static const String bn = 'bn';
  static const Locale bnLocale = Locale(bn);
  static const String hi = 'hi';
  static const Locale hiLocale = Locale(hi);
  static const String id = 'id';
  static const Locale idLocale = Locale(id);
  static const String fr = 'fr';
  static const Locale frLocale = Locale(fr);
  static const String ar = 'ar';
  static const Locale arLocale = Locale(ar);
  static const String zh = 'zh';
  static const Locale zhLocale = Locale(zh);
  static const String ur = 'ur';
  static const Locale urLocale = Locale(ur);
  static const String vi = 'vi';
  static const Locale viLocale = Locale(vi);
  static const String az = 'az';
  static const Locale azLocale = Locale(az);
  static const String ja = 'ja';
  static const Locale jaLocale = Locale(ja);
  static const String tr = 'tr';
  static const Locale trLocale = Locale(tr);

  static Map<Locale, AppLanguage> mappedLocale = {
    arLocale: const AppLanguage(key: ar, name: 'Arabic'),
    azLocale: const AppLanguage(key: az, name: 'Azerbaijani'),
    bnLocale: const AppLanguage(key: bn, name: 'Bangla'),
    enLocale: const AppLanguage(key: en, name: 'English'),
    frLocale: const AppLanguage(key: fr, name: 'French'),
    hiLocale: const AppLanguage(key: hi, name: 'Hindi'),
    idLocale: const AppLanguage(key: id, name: 'Indonesian'),
    jaLocale: const AppLanguage(key: ja, name: 'Japanese'),
    urLocale: const AppLanguage(key: ur, name: 'Urdu'),
    viLocale: const AppLanguage(key: vi, name: 'Vietnamese'),
    zhLocale: const AppLanguage(key: zh, name: 'Chinese'),
    trLocale: const AppLanguage(key: tr, name: 'Turkish'),
  };

  static AppLanguage getAppLang(Locale local) =>
      mappedLocale[local] ?? mappedLocale.values.first;
}

class AppLanguage {
  const AppLanguage({
    required this.key,
    required this.name,
  });

  final String key;
  final String name;
}

final localeProvider =
    NotifierProvider<LocaleNotifier, Locale>(LocaleNotifier.new);

class LocaleNotifier extends Notifier<Locale> {
  final _key = 'locale';

  final _pref = locate<SharedPreferences>();

  @override
  Locale build() {
    final l = _pref.getString(_key);
    return Locale.fromSubtags(
      languageCode: l ?? Intl.getCurrentLocale(),
    );
  }

  Future<void> setLocale(Locale locale) async {
    state = locale;
    await TR.load(locale);
    await _pref.setString(_key, locale.languageCode);
  }

  Future<void> setFromCode(String code) async {
    final locale = Locale.fromSubtags(languageCode: code);
    state = locale;
    await TR.load(locale);
    await _pref.setString(_key, locale.languageCode);
  }
}
