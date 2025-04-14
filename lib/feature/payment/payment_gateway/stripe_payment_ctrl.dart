// ignore_for_file: use_build_context_synchronously

import 'package:dio/dio.dart';
import 'package:e_com/_core/_core.dart';
import 'package:e_com/feature/payment/repository/payment_repo.dart';
import 'package:e_com/feature/payment/view/web_view_page.dart';
import 'package:e_com/feature/user_dash/controller/dash_ctrl.dart';
import 'package:e_com/models/models.dart';
import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

final stripePaymentCtrlProvider =
    NotifierProviderFamily<StripePaymentCtrlNotifier, String, PaymentState>(
        StripePaymentCtrlNotifier.new);

class StripePaymentCtrlNotifier extends FamilyNotifier<String, PaymentState> {
  Future<void> initializePayment(BuildContext context) async {
    try {
      final customer = await _createCustomer();
      final session = await _createSession(customer['id']);

      state = session['id'];

      final url = session['url']?.toString() ?? '';

      if (url.isEmpty) {
        return Toaster.showError('Something went wrong').andReturn(null);
      }

      final browser = PaymentBrowser(
        title: 'Stripe Payment',
        onUrlOverride: (uri, close) async {
          final url = uri.toString();
          Logger(uri, 'Overload');
          Logger(_callbackUrl, '_callbackUrl');
          Logger(url.contains(_callbackUrl) ? 'con' : 'not', 'contains');

          if (url.contains(_callbackUrl)) {
            await executePayment(context, uri);
            close();
            return NavigationActionPolicy.CANCEL;
          }
          return NavigationActionPolicy.ALLOW;
        },
      );

      browser.openUrl(url);
    } on DioException catch (e) {
      Toaster.showError(e.response?.data['message']);
    }
  }

  Future<void> executePayment(BuildContext context, Uri? url) async {
    Logger(url, 'url');

    final type = url!.queryParameters['type'];

    final body = {'payment_id': state};

    final trx = _log.trx;
    final callbackUrl = '${_log.method.callbackUrl}/$trx/$type';

    Logger.json(body);

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

  Dio get _dio => Dio()..interceptors.add(talk.dioLogger);

  String get _callbackUrl => Endpoints.baseUrl.replaceAll('/api', '');

  StripeParam get _cred => StripeParam.fromMap(_log.method.paymentParameter);

  // creates payment intent from stripe API
  Future<Map<String, dynamic>> _createCustomer() async {
    const api = 'https://api.stripe.com/v1/customers';

    final order = _order ?? await _orderFromLog();

    final body = {
      'name': order.billingAddress?.fullName,
      'email': order.billingAddress?.email,
      'phone': order.billingAddress?.phone,
      'shipping': {
        'name': order.billingAddress?.fullName,
        'address': {
          'line1': order.billingAddress?.address,
          'city': order.billingAddress?.city,
          'postal_code': order.billingAddress?.zip,
          'state': order.billingAddress?.state,
          'country': order.billingAddress?.country,
        },
      },
    };

    final option = Options(
      headers: {
        'Authorization': 'Bearer ${_cred.secretKey}',
        'Content-Type': 'application/x-www-form-urlencoded',
      },
    );

    final response = await _dio.post(api, data: body, options: option);

    return response.data;
  }

  int get _finalAmount => _log.finalAmount.round();

  Future<Map<String, dynamic>> _createSession(customerID) async {
    final currencyCode = _log.method.currency.name;
    const api = 'https://api.stripe.com/v1/checkout/sessions';
    final order = _order ?? await _orderFromLog();
    final body = {
      'mode': 'payment',
      'customer': customerID,
      'success_url': '$_callbackUrl?type=success',
      'cancel_url': '$_callbackUrl?type=failed',
      'line_items': [
        {
          'quantity': 1,
          'price_data': {
            'currency': currencyCode.toLowerCase(),
            'unit_amount': (_finalAmount * 100).toInt(),
            'product_data': {'name': order.orderId},
          },
        }
      ],
    };

    final option = Options(
      headers: {
        'Authorization': 'Bearer ${_cred.secretKey}',
        'Content-Type': 'application/x-www-form-urlencoded',
      },
    );

    final response = await _dio.post(api, data: body, options: option);

    Logger.json(response.data, 'SESSION');

    return response.data;
  }

  @override
  String build(PaymentState arg) {
    return '';
  }
}
