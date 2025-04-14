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

final bkashPaymentCtrlProvider =
    NotifierProviderFamily<BkashPaymentCtrl, String?, PaymentState>(
        BkashPaymentCtrl.new);

class BkashPaymentCtrl extends FamilyNotifier<String?, PaymentState> {
  final _dio = Dio()..interceptors.add(talk.dioLogger);

  initializePayment(BuildContext context) async {
    try {
      Toaster.showLoading('Redirecting...');
      final token = await _createToken();
      state = token;

      final headers = {
        "accept": 'application/json',
        "Authorization": token,
        "X-APP-Key": _bkashCreds.apiKey,
        'content-type': 'application/json'
      };
      final body = {
        "mode": '0011',
        "payerReference": ' ',
        "callbackURL": _callbackUrl,
        "amount": _log.finalAmount,
        "currency": 'BDT',
        "intent": 'sale',
        "merchantInvoiceNumber": _log.trx,
      };

      final response = await _dio.post(
        "$_baseUrl/tokenized/checkout/create",
        options: Options(headers: headers),
        data: json.encode(body),
      );

      final url = response.data['bkashURL'] ?? '';
      final browser = PaymentBrowser(
        title: 'Bkash Payment',
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
      Toaster.showError(e.message);
    }
  }

  Future<void> executePayment(BuildContext context, Uri? uri) async {
    if (uri == null) return;

    final body = uri.queryParameters;
    final callBack = '${_log.method.callbackUrl}/${_log.trx}';

    await PaymentRepo()
        .confirmPayment(context, body, callBack, isDeposit: arg.isDeposit);
  }

  String get _callbackUrl => Endpoints.baseUrl.replaceAll('/api', '');

  BkashCredentials get _bkashCreds =>
      BkashCredentials.fromMap(_log.method.paymentParameter);

  String get _baseUrl =>
      "https://tokenized.${_bkashCreds.isSandbox ? "sandbox" : "pay"}.bka.sh/v1.2.0-beta";

  Future<String?> _createToken() async {
    try {
      final headers = {
        "accept": 'application/json',
        "username": _bkashCreds.userName,
        "password": _bkashCreds.password,
        'content-type': 'application/json'
      };
      final body = {
        "app_key": _bkashCreds.apiKey,
        "app_secret": _bkashCreds.apiSecret,
      };
      final response = await _dio.post(
        "$_baseUrl/tokenized/checkout/token/grant",
        options: Options(headers: headers),
        data: json.encode(body),
      );

      return response.data['id_token'];
    } on DioException catch (e) {
      Toaster.showError(e.message);
      return null;
    }
  }

  PaymentLog get _log => arg.log;

  @override
  String build(PaymentState arg) {
    return '';
  }
}
