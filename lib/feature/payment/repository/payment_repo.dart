import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:e_com/_core/_core.dart';
import 'package:e_com/routes/routes.dart';
import 'package:flutter/material.dart';

class PaymentRepo {
  PaymentRepo();

  Future<void> confirmPayment(
    BuildContext context,
    Map<String, dynamic> body,
    String callBack, {
    String method = 'POST',
    bool isDeposit = false,
  }) async {
    try {
      final dio = Dio()..interceptors.add(talk.dioLogger);

      final options = Options(
        method: method,
        headers: {'Accept': 'application/json'},
      );

      final response =
          await dio.request(callBack, data: body, options: options);

      final res = json.decode(response.data);

      if (!context.mounted) {
        Toaster.showInfo('Unknown error\n${res['message']}');
        return;
      }

      RouteNames.afterPayment.goNamed(
        context,
        query: {
          'status': res['status'] ? 's' : 'f',
          'dep': isDeposit.toString(),
        },
      );
    } on DioException catch (e) {
      Toaster.showError(e.response?.data['message']);
    }
  }
}
