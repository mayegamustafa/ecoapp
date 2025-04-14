import 'package:collection/collection.dart';
import 'package:e_com/_core/_core.dart';
import 'package:e_com/models/models.dart';
import 'package:flutter/material.dart';

enum DepositStatus {
  pending(1),
  success(2),
  cancel(3);

  const DepositStatus(this.code);
  final int code;

  factory DepositStatus.fromCode(int? code) {
    return DepositStatus.values.firstWhereOrNull((e) => e.code == code) ??
        pending;
  }

  Color get color {
    return switch (this) {
      DepositStatus.pending => Colors.blue,
      DepositStatus.success => Colors.green,
      DepositStatus.cancel => Colors.red,
    };
  }
}

class PaymentLog {
  PaymentLog({
    required this.method,
    required this.charge,
    required this.uid,
    required this.trx,
    required this.amount,
    required this.finalAmount,
    required this.exchangeRate,
    required this.payable,
    required this.payStatus,
    required this.feedback,
    required this.customInfo,
    required this.readableTime,
    required this.dateTime,
    required this.paymentUrl,
  });

  factory PaymentLog.fromMap(Map<String, dynamic>? map, [dynamic url]) {
    if (map == null) return PaymentLog.codLog;
    return PaymentLog(
      method: PaymentData.fromMap(map['payment_method']),
      uid: map['uid'] ?? '',
      trx: map['trx_number'] ?? '',
      amount: map['amount'] ?? 'n/a',
      charge: map['charge'] ?? 'n/a',
      payable: map['payable'] ?? 'n/a',
      exchangeRate: doubleFromAny(map['exchange_rate']),
      finalAmount: doubleFromAny(map['final_amount']),
      payStatus: map.parseInt('status'),
      feedback: map['feedback'] ?? '',
      customInfo: map['custom_info'] ?? {},
      readableTime: map['human_readable_time'] ?? '',
      dateTime: map['date_time'] ?? '',
      paymentUrl: url is String ? url : null,
    );
  }

  static final PaymentLog codLog = PaymentLog(
    method: PaymentData.codPayment,
    charge: '0',
    uid: 'cod',
    trx: 'cod',
    amount: '0',
    finalAmount: 0,
    exchangeRate: 0,
    payable: '0',
    payStatus: 0,
    feedback: '',
    customInfo: {},
    readableTime: '',
    dateTime: '',
    paymentUrl: null,
  );

  final String amount;
  final String charge;
  final String payable;
  final double finalAmount;
  final double exchangeRate;
  final PaymentData method;
  final String trx;
  final String uid;

  /// 1 pending 2 success, 3 cancel
  final int payStatus;

  final String? feedback;
  final QMap? customInfo;
  final String readableTime;
  final String dateTime;
  final String? paymentUrl;

  DepositStatus get status => DepositStatus.fromCode(payStatus);

  Map<String, dynamic> toMap() {
    return {
      'payment_method': method.toMap(),
      'uid': uid,
      'trx_number': trx,
      'amount': amount,
      'final_amount': finalAmount,
      'charge': charge,
      'payable': payable,
      'exchange_rate': exchangeRate,
      'status': payStatus,
      'feedback': feedback,
      'custom_info': customInfo,
      'human_readable_time': readableTime,
      'date_time': dateTime,
      'payment_url': paymentUrl
    };
  }
}

class PaymentState {
  const PaymentState({
    required this.log,
    required this.order,
    this.isDeposit = false,
  });

  final PaymentLog log;
  final OrderModel? order;
  final bool isDeposit;

  PaymentState copyWith({
    PaymentLog? log,
    ValueGetter<OrderModel?>? order,
  }) {
    return PaymentState(
      log: log ?? this.log,
      order: order != null ? order() : this.order,
    );
  }
}
