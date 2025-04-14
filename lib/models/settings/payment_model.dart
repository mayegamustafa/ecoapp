import 'dart:convert';

import 'package:e_com/_core/_core.dart';
import 'package:flutter/material.dart';

import 'region_model.dart';

class PaymentData {
  PaymentData({
    required this.percentCharge,
    required this.currency,
    required this.rate,
    required this.name,
    required this.uniqueCode,
    required this.paymentParameter,
    required this.image,
    required this.callbackUrl,
    required this.id,
    required this.isManual,
    required this.manualInputs,
  });

  factory PaymentData.fromMap(Map<String, dynamic> map) {
    return PaymentData(
      id: map.parseInt('id'),
      percentCharge: (map['percent_charge'] as String).asDouble,
      currency: Currency.fromMap(map['currency']),
      rate: map.parseNum('rate'),
      name: map['name'] ?? '',
      uniqueCode: map['unique_code'],
      image: map['image'] ?? '',
      callbackUrl: map['callback_url'] ?? '',
      isManual: map['is_manual'] ?? false,
      paymentParameter: map['payment_parameter'] is Map<String, dynamic>
          ? Map<String, dynamic>.from(map['payment_parameter'])
          : {},
      manualInputs: map['payment_parameter'] is List
          ? List<CustomPayField>.from(
              map['payment_parameter']?.map((x) => CustomPayField.fromMap(x)) ??
                  [],
            )
          : [],
    );
  }

  static PaymentData codPayment = PaymentData(
    percentCharge: 0,
    currency: Currency(uid: '', name: '', symbol: '', rate: 0),
    rate: 0,
    name: 'Cash on Delivery',
    uniqueCode: '-1',
    paymentParameter: {},
    image: Assets.logo.cod.path,
    callbackUrl: '',
    id: 0,
    isManual: false,
    manualInputs: [],
  );

  final String callbackUrl;
  final Currency currency;
  final int id;
  final String image;
  final bool isManual;
  final List<CustomPayField> manualInputs;
  final String name;
  final Map<String, dynamic> paymentParameter;
  final double percentCharge;
  final num rate;
  final String? uniqueCode;

  List<String> get inputKeys => manualInputs.map((e) => e.name).toList();

  Map<String, dynamic> toMap() => {
        'percent_charge': percentCharge.toString(),
        'currency': currency.toMap(),
        'rate': rate,
        'name': name,
        'unique_code': uniqueCode,
        'payment_parameter': paymentParameter.isNotEmpty
            ? paymentParameter
            : manualInputs.map((e) => e.toMap()).toList(),
        'image': image,
        'callback_url': callbackUrl,
        'id': id,
        'is_manual': isManual,
      };

  String toJson() => json.encode(toMap());

  bool get isCOD => uniqueCode == '-1';
}

class CustomPayField {
  const CustomPayField({
    required this.name,
    required this.typeString,
    required this.isRequired,
  });

  factory CustomPayField.fromMap(Map<String, dynamic> map) {
    return CustomPayField(
      name: map['name'] ?? '',
      typeString: map['type'] ?? '',
      isRequired: map.parseBool('is_required'),
    );
  }

  final bool isRequired;
  final String name;
  final String typeString;

  KPayFieldType get type => KPayFieldType.fromValue(typeString);

  String get displayName => name.replaceAll('_', ' ').toTitleCase;

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'type': typeString,
      'is_required': isRequired,
    };
  }
}

enum KPayFieldType {
  text,
  textarea,
  email,
  date;

  factory KPayFieldType.fromValue(String value) {
    return switch (value) {
      'text' => KPayFieldType.text,
      'textarea' => KPayFieldType.textarea,
      'email' => KPayFieldType.email,
      'date' => KPayFieldType.date,
      _ => KPayFieldType.text,
    };
  }

  TextInputType get keyboardType => switch (this) {
        KPayFieldType.text => TextInputType.text,
        KPayFieldType.textarea => TextInputType.multiline,
        KPayFieldType.email => TextInputType.emailAddress,
        KPayFieldType.date => TextInputType.datetime,
      };

  bool get isText => this == KPayFieldType.text;
  bool get isTextArea => this == KPayFieldType.textarea;
  bool get isEmail => this == KPayFieldType.email;
  bool get isDate => this == KPayFieldType.date;
}
