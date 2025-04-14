import 'dart:convert';

import 'package:e_com/_core/_core.dart';
import 'package:e_com/models/models.dart';
import 'package:flex_color_scheme/flex_color_scheme.dart';
import 'package:flutter/material.dart';

class SettingsModel {
  const SettingsModel({
    required this.siteName,
    required this.siteLogo,
    required this.cashOnDelivery,
    required this.address,
    required this.copyrightText,
    required this.primaryColor,
    required this.secondaryColor,
    required this.fontColor,
    required this.email,
    required this.phone,
    required this.orderIdPrefix,
    required this.filterMinRange,
    required this.filterMaxRange,
    required this.googleOAuth,
    required this.facebookOAuth,
    required this.onBoarding,
    required this.guestCheckout,
    required this.phoneOTP,
    required this.emailOTP,
    required this.isPasswordEnabled,
    required this.digitalPayment,
    required this.offlinePayment,
    required this.currencyOnLeft,
    required this.minOrderAmount,
    required this.minOrderCheck,
    required this.whatsappConfig,
    required this.shippingConfig,
    required this.walletActive,
    required this.minDepositAmount,
    required this.maxDepositAmount,
    required this.pointSystemActive,
    required this.pointBy,
    required this.pointRate,
    required this.defOrderReward,
    required this.pointConfig,
    required this.deliveryChatEnabled,
    required this.deliveryManEnabled,
    required this.isMapEnabled,
  });

  factory SettingsModel.fromJson(String source) =>
      SettingsModel.fromMap(json.decode(source));

  factory SettingsModel.fromMap(Map<String, dynamic> map) {
    return SettingsModel(
      siteName: map['site_name'] ?? '',
      siteLogo: map['site_logo'] ?? '',
      cashOnDelivery: map['cash_on_delevary'],
      guestCheckout: map['guest_checkout'] ?? false,
      address: map['address'] ?? '',
      copyrightText: map['copyright_text'] ?? '',
      primaryColor: ((map['primary_color'] ?? '') as String).toColorK(),
      fontColor: ((map['font_color'] ?? '') as String).toColorK(),
      secondaryColor: ((map['secondary_color'] ?? '') as String).toColorK(),
      email: map['email'] ?? '',
      phone: map['phone'] ?? '',
      orderIdPrefix: map['order_id_prefix'] ?? '',
      filterMinRange: intFromAny(map['filter_min_range']),
      filterMaxRange: intFromAny(map['filter_max_range']),
      googleOAuth: GoogleOAuth.fromMap(map['google_oauth']),
      facebookOAuth: FacebookOAuth.fromMap(map['facebook_oauth']),
      onBoarding: List<OneBoardingData>.from(
          map['onboarding_pages'].map((x) => OneBoardingData.fromMap(x))),
      emailOTP: map['email_otp'] ?? false,
      phoneOTP: map['phone_otp'] ?? false,
      isPasswordEnabled: map['login_with_password'] ?? false,
      digitalPayment: map['digital_payment'] ?? false,
      offlinePayment: map['offline_payment'] ?? false,
      currencyOnLeft: map['currency_position_is_left'] ?? false,
      minOrderAmount: map.parseInt('minimum_order_amount'),
      minOrderCheck: map['minimum_order_amount_check'] ?? false,
      whatsappConfig: WhatsappConfig.fromMap(map),
      shippingConfig: ShippingConfig.fromMap(map['shipping_configuration']),
      walletActive: map.parseBool('wallet_system'),
      minDepositAmount: map.parseNum('min_deposit_amount'),
      maxDepositAmount: map.parseNum('max_deposit_amount'),
      pointSystemActive: map.parseBool('reward_point_system'),
      pointBy: PointBy.fromString(map['reward_point_by'] ?? ''),
      pointRate: map.parseNum('customer_wallet_point_conversion_rate'),
      defOrderReward: map.parseNum('default_order_based_reward_point'),
      pointConfig: switch (map) {
        {'reward_point_configurations': List v} =>
          List<PointConfig>.from(v.map((x) => PointConfig.fromMap(x))),
        _ => [],
      },
      deliveryChatEnabled: map.parseBool('chat_with_deliveryman'),
      deliveryManEnabled: map.parseBool('delivery_man_module'),
      isMapEnabled: map.parseBool('is_map_enabled'),
    );
  }

  final String address;
  final bool cashOnDelivery;
  final String copyrightText;
  final bool currencyOnLeft;
  final num defOrderReward;
  final bool digitalPayment;
  final String email;
  final bool emailOTP;
  final FacebookOAuth? facebookOAuth;
  final int filterMaxRange;
  final int filterMinRange;
  final Color? fontColor;
  final GoogleOAuth? googleOAuth;
  final bool guestCheckout;
  final bool isPasswordEnabled;
  final num maxDepositAmount;
  final num minDepositAmount;
  final int minOrderAmount;
  final bool minOrderCheck;
  final bool offlinePayment;
  final List<OneBoardingData> onBoarding;
  final String orderIdPrefix;
  final String phone;
  final bool phoneOTP;
  final List<PointConfig> pointConfig;
  final num pointRate;
  final bool pointSystemActive;
  final PointBy pointBy;
  final Color? primaryColor;
  final Color? secondaryColor;
  final ShippingConfig shippingConfig;
  final String siteLogo;
  final String siteName;
  final bool walletActive;
  final WhatsappConfig whatsappConfig;
  final bool deliveryManEnabled;
  final bool deliveryChatEnabled;
  final bool isMapEnabled;

  RangeValues get filterRange =>
      RangeValues(filterMinRange.toDouble(), filterMaxRange.toDouble());

  Map<String, dynamic> toMap() => {
        'site_name': siteName,
        'site_logo': siteLogo,
        'guest_checkout': guestCheckout,
        'cash_on_delevary': cashOnDelivery,
        'address': address,
        'copyright_text': copyrightText,
        'primary_color': primaryColor?.hex,
        'secondary_color': secondaryColor?.hex,
        'font_color': fontColor?.hex,
        'email': email,
        'phone': phone,
        'order_id_prefix': orderIdPrefix,
        'filter_min_range': filterMinRange,
        'filter_max_range': filterMaxRange,
        'google_oauth': googleOAuth?.toMap(),
        'facebook_oauth': facebookOAuth?.toMap(),
        'onboarding_pages': onBoarding.map((x) => x.toMap()).toList(),
        'email_otp': emailOTP,
        'phone_otp': phoneOTP,
        'login_with_password': isPasswordEnabled,
        'digital_payment': digitalPayment,
        'offline_payment': offlinePayment,
        'currency_position_is_left': currencyOnLeft,
        'minimum_order_amount_check': minOrderCheck,
        'minimum_order_amount': minOrderAmount,
        'shipping_configuration': shippingConfig.toMap(),
        ...whatsappConfig.toMap(),
        'wallet_system': walletActive,
        'min_deposit_amount': minDepositAmount,
        'max_deposit_amount': maxDepositAmount,
        'reward_point_system': pointSystemActive,
        'reward_point_by': pointBy.name,
        'customer_wallet_point_conversion_rate': pointRate,
        'default_order_based_reward_point': defOrderReward,
        'reward_point_configurations':
            pointConfig.map((x) => x.toMap()).toList(),
        'delivery_man_module': deliveryManEnabled,
        'chat_with_deliveryman': deliveryChatEnabled,
        'is_map_enabled': isMapEnabled,
      };

  String toJson() => json.encode(toMap());
}

class PointConfig {
  PointConfig({
    required this.point,
    required this.lessThanEq,
    required this.minAmount,
  });

  factory PointConfig.fromMap(Map<String, dynamic> map) {
    return PointConfig(
      point: map.parseNum('point'),
      lessThanEq: map.parseNum('less_than_eq'),
      minAmount: map.parseNum('min_amount'),
    );
  }

  Map<String, dynamic> toMap() => {
        'point': point,
        'less_than_eq': lessThanEq,
        'min_amount': minAmount,
      };

  final num lessThanEq;
  final num minAmount;
  final num point;

  bool isBetween(num amount) {
    final data = amount <= lessThanEq && amount >= minAmount;
    return data;
  }
}

enum PointBy {
  order,
  product;

  static PointBy fromString(String value) {
    return switch (value) {
      'order_amount_based' || 'order' => order,
      'product_based' || 'product' => product,
      _ => product,
    };
  }

  bool get isOrder => this == order;
  bool get isProduct => this == product;
}
