// ignore_for_file: use_build_context_synchronously

import 'dart:convert';

import 'package:e_com/_core/_core.dart';
import 'package:e_com/feature/payment/repository/payment_repo.dart';
import 'package:e_com/models/models.dart';
import 'package:esewa_flutter_sdk/esewa_config.dart';
import 'package:esewa_flutter_sdk/esewa_flutter_sdk.dart';
import 'package:esewa_flutter_sdk/esewa_payment.dart';
import 'package:esewa_flutter_sdk/esewa_payment_success_result.dart';
import 'package:flutter/widgets.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

final eSewaPaymentCtrlProvider =
    NotifierProviderFamily<ESewaPaymentCtrlNotifier, String, PaymentState>(
        ESewaPaymentCtrlNotifier.new);

class ESewaPaymentCtrlNotifier extends FamilyNotifier<String, PaymentState> {
  Future<void> initiatePayment(BuildContext context) async {
    try {
      EsewaFlutterSdk.initPayment(
        esewaConfig: EsewaConfig(
          environment: _creds.isSandbox ? Environment.test : Environment.live,
          clientId: _creds.clientId,
          secretId: _creds.clientSecret,
        ),
        esewaPayment: EsewaPayment(
          productId: _log.trx,
          productName: _log.trx,
          productPrice: _log.finalAmount.toString(),
          callbackUrl: Endpoints.baseApiUrl,
        ),
        onPaymentSuccess: (data) async {
          Logger.json(data.toJson(), 'success');
          Toaster.showInfo('please wait ...');
          await onPaymentSuccess(data, context);
        },
        onPaymentFailure: (data) async {
          Logger(":::FAILURE::: => $data");
          Toaster.showInfo('please wait ...');
          await _confirm(context);
        },
        onPaymentCancellation: (data) async {
          Logger(":::CANCELLATION::: => $data");
        },
      );
    } catch (e, s) {
      talk.ex(e, s);
    }
  }

  Future<void> onPaymentSuccess(
    EsewaPaymentSuccessResult data,
    BuildContext context,
  ) async {
    final jsonData = {"status": data.status};
    await _confirm(context, jsonData);
  }

  ESewaCredentials get _creds =>
      ESewaCredentials.fromMap(_log.method.paymentParameter);

  Future<void> _confirm(
    BuildContext context, [
    Map<String, String>? data,
  ]) async {
    final trx = _log.trx;
    final status = data == null ? 'failed' : 'success';

    String callback = '${_log.method.callbackUrl}/$trx/$status';

    String encodedData = base64Encode(utf8.encode(jsonEncode(data)));

    await PaymentRepo().confirmPayment(
      context,
      {'data': encodedData},
      callback,
      isDeposit: arg.isDeposit,
    );
  }

  PaymentLog get _log => arg.log;

  @override
  String build(PaymentState arg) {
    return '';
  }
}
