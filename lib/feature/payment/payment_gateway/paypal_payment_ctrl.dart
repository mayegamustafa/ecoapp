// ignore_for_file: use_build_context_synchronously

import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:e_com/_core/_core.dart';
import 'package:e_com/feature/payment/repository/payment_repo.dart';
import 'package:e_com/feature/payment/view/web_view_page.dart';
import 'package:e_com/models/models.dart';
import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

final paypalPaymentCtrlProvider =
    NotifierProviderFamily<PaypalPaymentCtrlNotifier, String?, PaymentState>(
        PaypalPaymentCtrlNotifier.new);

class PaypalPaymentCtrlNotifier extends FamilyNotifier<String?, PaymentState> {
  Future<void> initializePayment(BuildContext context) async {
    try {
      final token = await _getAccessToken();
      if (token.isEmpty) {
        return Toaster.showError('Failed to get access token').andReturn(null);
      }

      final response = await _dio.post(
        '/v2/checkout/orders',
        data: _transactionData,
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
            'Content-Type': 'application/json',
          },
        ),
      );

      final body = response.data;

      final links = List<Map<String, dynamic>>.from(body['links']);

      String url = '';

      for (final link in links) {
        final parse = Map<String, String>.from(link);
        if (parse['rel'] == 'approve') {
          url = parse['href'] ?? '';
        }
      }

      if (url.isEmpty) {
        Toaster.showError(context.tr.something_went_wrong);
        return;
      }
      final browser = PaymentBrowser(
        title: 'Paypal Payment',
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
      Toaster.showError(err.message);
    }
  }

  Future<void> executePayment(BuildContext context, Uri? url) async {
    final body = url!.queryParameters;
    final payerID = body['PayerID'];

    final trx = _log.trx;

    final callbackUrl = '${_log.method.callbackUrl}/$trx/$payerID';
    await PaymentRepo()
        .confirmPayment(context, body, callbackUrl, isDeposit: arg.isDeposit);
  }

  PaymentLog get _log => arg.log;

  String get _transactionData {
    return json.encode(
      {
        "intent": "CAPTURE",
        "purchase_units": [
          {
            "invoice_id": _log.trx,
            "amount": {
              "currency_code": _log.method.currency.name,
              "value": _log.finalAmount,
            }
          }
        ],
        "application_context": {
          "return_url": _callbackUrl,
          "cancel_url": _callbackUrl,
        }
      },
    );
  }

  String get _authToken =>
      base64.encode(utf8.encode("${_cred.clientId}:${_cred.secret}"));

  String get _callbackUrl => Endpoints.baseUrl.replaceAll('/api', '');

  String get _baseUrl => _cred.isSandbox
      ? "https://api-m.sandbox.paypal.com"
      : "https://api.paypal.com/v1";

  Dio get _dio => Dio()
    ..options = BaseOptions(baseUrl: _baseUrl)
    ..interceptors.add(talk.dioLogger);

  PaypalCredentials get _cred =>
      PaypalCredentials.fromMap(_log.method.paymentParameter);

  Future<String> _getAccessToken() async {
    try {
      final data = {'grant_type': 'client_credentials'};

      final response = await _dio.post(
        '/v1/oauth2/token',
        data: data,
        options: Options(
          headers: {
            'Authorization': 'Basic $_authToken',
            'Content-Type': 'application/x-www-form-urlencoded',
          },
        ),
      );

      final token = response.data['access_token'];

      return token;
    } on DioException {
      return '';
    }
  }

  @override
  String? build(PaymentState arg) {
    return '';
  }
}
