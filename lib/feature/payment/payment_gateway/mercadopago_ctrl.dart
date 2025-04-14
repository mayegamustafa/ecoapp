// cspell:words mercadopago
import 'package:dio/dio.dart';
import 'package:e_com/_core/_core.dart';
import 'package:e_com/feature/payment/repository/payment_repo.dart';
import 'package:e_com/feature/payment/view/web_view_page.dart';
import 'package:e_com/feature/user_dash/controller/dash_ctrl.dart';
import 'package:e_com/models/models.dart';
import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

final mercadoPaymentCtrlProvider =
    NotifierProviderFamily<MercadopagoPaymentCtrl, QMap, PaymentState>(
        MercadopagoPaymentCtrl.new);

class MercadopagoPaymentCtrl extends FamilyNotifier<QMap, PaymentState> {
  initializePayment(BuildContext context) async {
    try {
      final data = await _createPayment();

      state = data;

      final url = data['init_point']?.toString() ?? '';
      final browser = PaymentBrowser(
        title: 'Mercado Pago Payment',
        onUrlOverride: (uri, close) async {
          final url = uri.toString();
          if (url.contains(_callbackUrl)) {
            await executePayment(context, uri);
            close();
            return NavigationActionPolicy.CANCEL;
          }
          return NavigationActionPolicy.ALLOW;
        },
      );

      browser.openUrl(url);

      Toaster.remove();
    } on DioException catch (e) {
      Toaster.showError(e.message);
    }
  }

  Future<void> executePayment(BuildContext context, Uri? uri) async {
    if (uri == null) return;
    final body = {...uri.queryParameters, ...state};

    final callBack = '${_log.method.callbackUrl}/${_log.trx}';

    await PaymentRepo()
        .confirmPayment(context, body, callBack, isDeposit: arg.isDeposit);
  }

  String get _callbackUrl => Endpoints.baseUrl.replaceAll('/api', '');

  Future<QMap> _createPayment() async {
    final order = _order ?? await _orderFromLog();

    final headers = {
      'content-type': 'application/json',
      'Authorization': 'Bearer ${_mercadoCreds.accessToken}',
    };

    final body = {
      "items": [
        {
          "id": _log.trx,
          "title": "Payment",
          "description": 'Payment from user',
          "quantity": 1,
          "currency_id": _log.method.currency.name,
          "unit_price": _log.finalAmount,
        }
      ],
      "payer": {
        "email": order.billingAddress?.email,
      },
      "back_urls": {
        "success": _callbackUrl,
        "pending": '',
        "failure": _callbackUrl,
      },
      "notification_url": "http://notificationurl.com",
      'auto_return': 'approved',
    };
    final response = await _dio.post(
      'https://api.mercadopago.com/checkout/preferences',
      options: Options(headers: headers),
      data: body,
    );

    return response.data;
  }

  Dio get _dio => Dio()..interceptors.add(talk.dioLogger);

  MercadoCreds get _mercadoCreds =>
      MercadoCreds.fromMap(_log.method.paymentParameter);

  PaymentLog get _log => arg.log;

  OrderModel? get _order => arg.order;

  Future<OrderModel> _orderFromLog() async {
    final user =
        await ref.read(userDashCtrlProvider.selectAsync((x) => x.user));
    final address = BillingInfo.fromUser(user);

    return OrderModel.fromLog(_log, address);
  }

  @override
  QMap build(PaymentState arg) {
    return {};
  }
}
