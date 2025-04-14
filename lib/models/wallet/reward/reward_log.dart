import 'package:e_com/main.export.dart';
import 'package:flutter/material.dart';
import 'package:fpdart/fpdart.dart';

class RewardLog {
  const RewardLog({
    required this.id,
    required this.order,
    required this.product,
    required this.point,
    required this.status,
    required String expiredAt,
    required this.createdAt,
    required this.details,
    required this.redeemedAt,
  }) : _expiredAt = expiredAt;

  factory RewardLog.fromMap(Map<String, dynamic> map) {
    ({
      Either<DigitalProduct, ProductsData> product,
      bool isDigital
    })? productInfo;

    if (map['product'] != null) {
      final isDigital = map['product']['is_digital'];

      final product = isDigital
          ? left<DigitalProduct, ProductsData>(
              DigitalProduct.fromMap(map['product']['resource']),
            )
          : right<DigitalProduct, ProductsData>(
              ProductsData.fromMap(map['product']['resource']),
            );

      productInfo = (product: product, isDigital: isDigital);
    }

    return RewardLog(
      id: map.parseInt('id'),
      order: map['order'] != null ? OrderModel.fromMap(map['order']) : null,
      product: productInfo,
      point: map.parseNum('point'),
      status: RewardStatus.fromValue(map['status']),
      expiredAt: map['expired_at'],
      createdAt: map['created_at'],
      details: map['details'],
      redeemedAt: map['redeemed_at'],
    );
  }

  final String createdAt;
  final String details;
  final int id;
  final OrderModel? order;
  final num point;
  final String? redeemedAt;
  final RewardStatus status;

  final String _expiredAt;

  final ({
    Either<DigitalProduct, ProductsData> product,
    bool isDigital
  })? product;

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'order': order?.toMap(),
      if (product != null)
        'product': {
          'resource': product?.product.fold((l) => l.toMap(), (r) => r.toMap()),
          'is_digital': product?.isDigital,
        },
      'point': point,
      'status': status.index,
      'expired_at': _expiredAt,
      'created_at': createdAt,
      'details': details,
      'redeemed_at': redeemedAt,
    };
  }

  DateTime get expiredAt => DateTime.parse(_expiredAt);

  Duration get remaining => expiredAt.difference(DateTime.now());
}

enum RewardStatus {
  all,
  pending,
  redeemed,
  expired;

  factory RewardStatus.fromValue(int value) {
    return switch (value) {
      1 => pending,
      2 => redeemed,
      3 => expired,
      _ => pending,
    };
  }

  Color get color {
    return switch (this) {
      RewardStatus.all => Colors.grey,
      RewardStatus.pending => Colors.blue,
      RewardStatus.redeemed => Colors.green,
      RewardStatus.expired => Colors.red,
    };
  }

  int? get code => switch (this) {
        RewardStatus.all => null,
        RewardStatus.pending => 1,
        RewardStatus.redeemed => 2,
        RewardStatus.expired => 3
      };
}
