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

final paystackCtrlProvider =
    NotifierProviderFamily<PaystackCtrlNotifier, String?, PaymentState>(
        PaystackCtrlNotifier.new);

class PaystackCtrlNotifier extends FamilyNotifier<String?, PaymentState> {
  final _baseUrl = 'https://api.paystack.co/transaction';
  final _dio = Dio()..interceptors.add(talk.dioLogger);

  Future<void> initializePayment(BuildContext context) async {
    try {
      final headers = {'Authorization': 'Bearer ${_cred.secretKey}'};
      final order = _order ?? await _orderFromLog();

      final response = await _dio.post(
        '$_baseUrl/initialize',
        options: Options(headers: headers),
        data: {
          'email': order.billingAddress!.email,
          'amount': _log.finalAmount.round(),
          'callback_url': _callbackUrl,
        },
      );

      state = response.data['data']['reference'];
      final url = response.data['data']['authorization_url'];
      if (url.isEmpty) {
        return Toaster.showError('Something went wrong').andReturn(null);
      }

      final browser = PaymentBrowser(
        title: 'Paystack Payment',
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
    } on DioException catch (e) {
      Toaster.showError(e.response?.data['message']);
    }
  }

  Future<void> executePayment(BuildContext context, Uri? url) async {
    final body = url!.queryParameters;
    final trx = _log.trx;
    final callbackUrl = '${_log.method.callbackUrl}/$trx';
    await PaymentRepo().confirmPayment(context, body, callbackUrl);
  }

  String get _callbackUrl => Endpoints.baseUrl.replaceAll('/api', '');

  PaystackCredentials get _cred =>
      PaystackCredentials.fromMap(_log.method.paymentParameter);

  PaymentLog get _log => arg.log;
  OrderModel? get _order => arg.order;

  Future<OrderModel> _orderFromLog() async {
    final user =
        await ref.read(userDashCtrlProvider.selectAsync((x) => x.user));
    final address = BillingInfo.fromUser(user);

    return OrderModel.fromLog(_log, address);
  }

  @override
  String? build(PaymentState arg) {
    return '';
  }
}
