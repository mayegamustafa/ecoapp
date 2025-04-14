import 'dart:convert';

import 'package:e_com/_core/_core.dart';
import 'package:intl/intl.dart';

class RegionModel {
  RegionModel({
    required this.currency,
    required this.defCurrency,
    required this.langCode,
    required this.defLanguage,
  });

  final Currency? currency;
  final Currency? defCurrency;
  final String langCode;
  final String defLanguage;

  RegionModel setLanguage(String? langCode) {
    return RegionModel(
      currency: currency,
      defCurrency: defCurrency,
      defLanguage: defLanguage,
      langCode: langCode ?? this.langCode,
    );
  }

  RegionModel setCurrency(Currency? currency) {
    return RegionModel(
      currency: currency ?? this.currency,
      defCurrency: defCurrency,
      langCode: langCode,
      defLanguage: defLanguage,
    );
  }

  RegionModel setBaseCurrency(Currency? defCurrency) {
    return RegionModel(
      currency: currency,
      defCurrency: defCurrency ?? this.defCurrency,
      langCode: langCode,
      defLanguage: defLanguage,
    );
  }

  RegionModel copyWith({
    Currency? currency,
    String? langCode,
    String? defLangCode,
    Currency? defCurrency,
  }) {
    return RegionModel(
      currency: currency ?? this.currency,
      defCurrency: defCurrency ?? this.defCurrency,
      langCode: langCode ?? this.langCode,
      defLanguage: defLangCode ?? defLanguage,
    );
  }

  static RegionModel def = RegionModel(
    langCode: Intl.getCurrentLocale(),
    defLanguage: Intl.getCurrentLocale(),
    currency: null,
    defCurrency: null,
  );
}

class LocalCurrency {
  LocalCurrency({
    required this.langCode,
    required this.currency,
  });

  factory LocalCurrency.fromMap(Map<String, dynamic> map) {
    return LocalCurrency(
      currency: Currency.fromMap(map['currency']),
      langCode: map['locale'],
    );
  }

  final Currency? currency;
  final String? langCode;
}

class Languages {
  Languages({
    required this.name,
    required this.code,
    required this.image,
  });

  factory Languages.fromJson(String source) =>
      Languages.fromMap(json.decode(source));

  factory Languages.fromMap(Map<String, dynamic> map) {
    return Languages(
      name: map['name'] ?? '',
      code: map['code'] ?? '',
      image: map['image'] ?? '',
    );
  }

  final String code;
  final String image;
  final String name;

  Map<String, dynamic> toMap() => {
        'name': name,
        'code': code,
        'image': image,
      };

  String toJson() => json.encode(toMap());
}

class Currency {
  Currency({
    required this.uid,
    required this.name,
    required this.symbol,
    required this.rate,
  });

  factory Currency.fromJson(String source) =>
      Currency.fromMap(json.decode(source));

  factory Currency.fromMap(Map<String, dynamic> map) {
    return Currency(
      uid: map['uid'] ?? '',
      name: map['name'] ?? '',
      symbol: map['symbol'] ?? '',
      rate: map.parseNum('rate'),
    );
  }

  final String name;
  final num rate;
  final String symbol;
  final String uid;

  Map<String, dynamic> toMap() => {
        'uid': uid,
        'name': name,
        'symbol': symbol,
        'rate': rate,
      };

  String toJson() => json.encode(toMap());
}
