import 'dart:async';

import 'package:e_com/_core/_core.dart';
import 'package:e_com/feature/check_out/repository/checkout_repo.dart';
import 'package:e_com/feature/payment/payment_gateway/payment_gateway.dart';
import 'package:e_com/models/models.dart';
import 'package:e_com/routes/routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:url_launcher/url_launcher_string.dart';

final paymentCtrlProvider =
    NotifierProvider<PaymentCtrl, PaymentState?>(PaymentCtrl.new);

class PaymentCtrl extends Notifier<PaymentState?> {
  Future<void> payNow(
    BuildContext context,
    String orderUid,
    PaymentData? method,
  ) async {
    Toaster.showLoading('Loading...');

    final order = await _setPaymentLog(
      orderUid,
      method,
      (id) => RouteNames.afterPayment
          .goNamed(context, query: {'status': 'w', 'id': id}),
    );

    Toaster.remove();

    if (order == null || !context.mounted) return;

    RouteNames.orderPlaced
        .pushNamed(context, query: {'from': 'payNow'}, extra: order);
  }

  Future<void> initializePayment(
    BuildContext context,
    PaymentLog log, {
    OrderModel? order,
    bool isDeposit = false,
  }) async {
    state = PaymentState(log: log, order: order, isDeposit: isDeposit);

    if (log.paymentUrl != null) {
      await launchUrlString(log.paymentUrl!);
      if (!context.mounted) return;
      RouteNames.afterPayment.goNamed(context, query: {
        'status': 'w',
        'id': log.trx,
        'dep': '$isDeposit',
      });
      return;
    }

    final res = await switch (log.method.uniqueCode) {
      'STRIPE101' => _payWithStripe(context),
      'PAYPAL102' => _payWithPaypal(context),
      'PAYSTACK103' => _payWithPayStack(context),
      'FLUTTERWAVE105' => _payWithFlutterWave(context),
      'RAZORPAY106' => _payWithRazorPay(context),
      'INSTA106' => _payWithInstaMojo(context),
      'BKASH102' => _payWithBkash(context),
      'NAGAD104' => _payWithNagad(context),
      'MERCADO101' => _payWithMercado(context),
      'AAMARPAY107' => _payWithAamarPay(context),
      'ESEWA107' => _payWithEsewa(context),
      _ => Future(() => 'Unsupported Payment Method'),
    };

    if (res != null) Toaster.showInfo(res);
  }

  Future<OrderBaseModel?> _setPaymentLog(
    String orderUid,
    PaymentData? method,
    Function(String trx)? onUrlLaunch,
  ) async {
    final repo = ref.read(checkoutRepoProvider);
    final res = await repo.getPaymentLog(orderUid, method?.id);

    return await res.fold(
      (l) {
        Toaster.showError(l);
        return null;
      },
      (r) async {
        if (r.data.paymentUrl != null) {
          await launchUrlString(r.data.paymentUrl!);
          onUrlLaunch?.call(r.data.paymentLog.trx);
          return null;
        }
        return r.data;
      },
    );
  }

  Future<String?> _payWithStripe(BuildContext context) async {
    final stripeCtrl = ref.read(stripePaymentCtrlProvider(state!).notifier);
    await stripeCtrl.initializePayment(context);
    return null;
  }

  Future<String?> _payWithPaypal(BuildContext context) async {
    final paypalCtrl = ref.read(paypalPaymentCtrlProvider(state!).notifier);
    await paypalCtrl.initializePayment(context);
    return null;
  }

  Future<String?> _payWithPayStack(BuildContext context) async {
    final payStackCtrl = ref.read(paystackCtrlProvider(state!).notifier);
    await payStackCtrl.initializePayment(context);
    return null;
  }

  Future<String?> _payWithFlutterWave(BuildContext context) async {
    await ref
        .read(flutterWaveCtrlProvider(state!).notifier)
        .initializePayment(context);
    return null;
  }

  Future<String?> _payWithRazorPay(BuildContext context) async {
    // await ref
    //     .read(razorPayPaymentCtrlProvider((state!)))
    //     .initializePayment(context);
    return 'Razorpay is not available';
  }

  Future<String?> _payWithInstaMojo(BuildContext context) async {
    await ref
        .read(instaMojoCtrlProvider(state!).notifier)
        .initializePayment(context);
    return null;
  }

  Future<String?> _payWithBkash(BuildContext context) async {
    await ref
        .read(bkashPaymentCtrlProvider(state!).notifier)
        .initializePayment(context);
    return null;
  }

  Future<String?> _payWithNagad(BuildContext context) async {
    await ref
        .read(nagadPaymentCtrlProvider(state!).notifier)
        .initializePayment(context);
    return null;
  }

  Future<String?> _payWithMercado(BuildContext context) async {
    final stripeCtrl = ref.read(mercadoPaymentCtrlProvider(state!).notifier);
    await stripeCtrl.initializePayment(context);
    return null;
  }

  Future<String?> _payWithAamarPay(BuildContext context) async {
    return ref
        .read(aamarPayCtrlProvider(state!).notifier)
        .payWithAamarPay(context);
  }

  Future<String> _payWithEsewa(BuildContext context) async {
    final stripeCtrl = ref.read(eSewaPaymentCtrlProvider(state!).notifier);
    await stripeCtrl.initiatePayment(context);
    return '';
  }

  @override
  PaymentState? build() {
    return null;
  }
}
