// ignore_for_file: use_build_context_synchronously

import 'package:dio/dio.dart';
import 'package:e_com/_core/_core.dart';
import 'package:e_com/feature/payment/view/web_view_page.dart';
import 'package:e_com/feature/user_dash/controller/dash_ctrl.dart';
import 'package:e_com/models/models.dart';
import 'package:e_com/routes/routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

final instaMojoCtrlProvider =
    NotifierProviderFamily<InstaMojoCtrlNotifier, String, PaymentState>(
        InstaMojoCtrlNotifier.new);

class InstaMojoCtrlNotifier extends FamilyNotifier<String, PaymentState> {
  final _dio = Dio()..interceptors.add(talk.dioLogger);

  Future<void> initializePayment(BuildContext context) async {
    try {
      final response = await _dio.request(
        "$_baseUrl/payment-requests/",
        options: Options(method: 'POST', headers: _headers()),
        data: FormData.fromMap(await _paymentData()),
      );

      final body = response.data;

      final url = body['payment_request']?['longurl']?.toString() ?? '';
      if (url.isEmpty) {
        return Toaster.showError('Something went wrong').andReturn(null);
      }

      final browser = PaymentBrowser(
        title: 'Instamojo Payment',
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
    } on DioException catch (err) {
      final response = err.response?.data['message'] as Map<String, dynamic>;
      final msg =
          response.entries.first.value ?? context.tr.something_went_wrong;
      Toaster.showError(msg);
    }
  }

  Future<dynamic> executePayment(BuildContext context, Uri? uri) async {
    if (uri == null) return;

    final status = uri.queryParameters['payment_status'];

    RouteNames.afterPayment.goNamed(
      context,
      query: {
        'status': status == 'Credit' ? 's' : 'f',
        'dep': '${arg.isDeposit}',
      },
    );
  }

  String get _callbackUrl => Endpoints.baseUrl.replaceAll('/api', '');

  InstaMojoCredentials get _creds =>
      InstaMojoCredentials.fromMap(_log.method.paymentParameter);

  String get _baseUrl => _creds.isSandbox
      ? 'https://test.instamojo.com/api/1.1'
      : 'https://www.instamojo.com/api/1.1';

  Map<String, String> _headers() {
    final header = {
      'X-Api-Key': _creds.apiKey,
      'X-Auth-Token': _creds.authToken,
    };
    return header;
  }

  Future<Map<String, dynamic>> _paymentData() async {
    final order = _order ?? await _orderFromLog();

    return {
      'amount': _log.finalAmount.toString(),
      'purpose': 'Payment',
      'buyer_name': order.billingAddress!.firstName,
      'email': order.billingAddress!.email,
      'phone': order.billingAddress!.phone,
      'redirect_url': _callbackUrl,
      'webhook': '${_log.method.callbackUrl}/${_log.trx}',
      'allow_repeated_payments': 'false',
      'send_email': _creds.isSandbox ? 'false' : 'true',
      'send_sms': _creds.isSandbox ? 'false' : 'true',
    };
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
