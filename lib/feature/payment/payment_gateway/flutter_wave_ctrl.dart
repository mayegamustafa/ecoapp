import 'dart:io';

import 'package:dio/dio.dart';
import 'package:e_com/_core/_core.dart';
import 'package:e_com/feature/payment/repository/payment_repo.dart';
import 'package:e_com/feature/payment/view/web_view_page.dart';
import 'package:e_com/feature/user_dash/controller/dash_ctrl.dart';
import 'package:e_com/models/models.dart';
import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

final flutterWaveCtrlProvider =
    NotifierProviderFamily<FlutterWaveCtrlNotifier, String, PaymentState>(
        FlutterWaveCtrlNotifier.new);

class FlutterWaveCtrlNotifier extends FamilyNotifier<String, PaymentState> {
  @override
  String build(PaymentState arg) {
    return '';
  }

  PaymentLog get _log => arg.log;
  OrderModel? get _order => arg.order;

  Future<OrderModel> _orderFromLog() async {
    final user =
        await ref.read(userDashCtrlProvider.selectAsync((x) => x.user));
    final address = BillingInfo.fromUser(user);

    return OrderModel.fromLog(_log, address);
  }

  String get _callbackUrl => Endpoints.baseUrl.replaceAll('/api', '');

  FlutterWaveCredentials get _cred =>
      FlutterWaveCredentials.fromMap(_log.method.paymentParameter);

  String get _baseUrl => _cred.isSandbox
      ? "https://ravesandboxapi.flutterwave.com/v3/sdkcheckout/"
      : "https://api.ravepay.co/v3/sdkcheckout";

  final _paymentUrl = "/payments";

  Future<void> initializePayment(BuildContext context) async {
    final dio = Dio()..interceptors.add(talk.dioLogger);
    final order = _order ?? await _orderFromLog();

    final data = {
      "tx_ref": _log.trx,
      "publicKey": _cred.publicKey,
      "amount": _log.finalAmount.round().toString(),
      "currency": _log.method.currency.name,
      "payment_options": "ussd, card, barter, payattitude",
      "redirect_url": _callbackUrl,
      "customizations": {
        "title": "Flutter Wave Payment",
      },
      'customer': {
        "email": order.billingAddress!.email,
        "phonenumber": order.billingAddress!.phone,
        "name": order.billingAddress!.fullName,
      }
    };

    final headers = {
      HttpHeaders.authorizationHeader: _cred.publicKey,
      HttpHeaders.contentTypeHeader: "application/json",
    };

    final response = await dio.post(
      _baseUrl + _paymentUrl,
      options: Options(headers: headers),
      data: data,
    );
    final body = response.data;

    if (response.statusCode != 200) return;

    if (body['status'] == 'error') return;
    if (!context.mounted) return;
    final url = body['data']?['link']?.toString() ?? '';
    final browser = PaymentBrowser(
      title: 'Flutter Wave Payment',
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
  }

  Future<void> executePayment(context, Uri? uri) async {
    final data = uri!.queryParameters;
    final callBack =
        '${_log.method.callbackUrl}/${data['tx_ref']}/${data['status']}';

    await PaymentRepo()
        .confirmPayment(context, data, callBack, isDeposit: arg.isDeposit);
  }
}
