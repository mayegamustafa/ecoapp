// ignore_for_file: use_build_context_synchronously

import 'package:e_com/_core/_core.dart';
import 'package:e_com/feature/payment/repository/payment_repo.dart';
import 'package:e_com/feature/user_dash/controller/dash_ctrl.dart';
import 'package:e_com/models/models.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:payment_module/payment_module.dart';

final aamarPayCtrlProvider =
    NotifierProviderFamily<AmarPayCtrlNotifier, String, PaymentState>(
        AmarPayCtrlNotifier.new);

class AmarPayCtrlNotifier extends FamilyNotifier<String, PaymentState> {
  String get _storeId => _log.method.paymentParameter['store_id'];
  String get _storeKey => _log.method.paymentParameter['signature_key'];
  String get _isSand => _log.method.paymentParameter['is_sandbox'];

  final _module = const PaymentModule();

  Future<String?> payWithAamarPay(BuildContext context) async {
    if (_order == null) return 'Something went wrong, please try again';
    final order = _order ?? await _orderFromLog();

    final config = AamarPayConfig(
      email: order.billingAddress?.email ?? '',
      mobile: order.billingAddress?.phone ?? '',
      name: order.billingAddress?.fullName,
      signature: _storeKey,
      storeID: _storeId,
      amount: _log.finalAmount.toString(),
      transactionId: _log.trx,
      description: 'Payment for order ${_log.trx}',
      isSandBox: _isSand == '1',
    );
    await _module.payWithAamarPay(
      context,
      config: config,
      urlCallback: (status, url) async {
        Logger('$url ::  ${status.name}}', 'status');

        if (status == AamarPayStatus.success) {
          await _executePayment(context, 'success');
        }
        if (status == AamarPayStatus.failed) {
          await _executePayment(context, 'failed');
        }
      },
      eventCallback: (event, url) {
        Logger('$url ::  ${event.name}}', 'event');
      },
    );
    return null;
  }

  Future<void> _executePayment(BuildContext context, String type) async {
    final body = {'currency': _log.method.currency.name};

    final trx = _log.trx;
    final callbackUrl = '${_log.method.callbackUrl}/$trx/$type';

    await PaymentRepo()
        .confirmPayment(context, body, callbackUrl, isDeposit: arg.isDeposit);
  }

  PaymentLog get _log => arg.log;
  OrderModel? get _order => arg.order;

  Future<OrderModel> _orderFromLog() async {
    final user =
        await ref.read(userDashCtrlProvider.selectAsync((x) => x.user));
    final address = BillingInfo.fromUser(user);

    return OrderModel.fromLog(_log, address);
  }

  @override
  String build(PaymentState arg) {
    return '';
  }
}
