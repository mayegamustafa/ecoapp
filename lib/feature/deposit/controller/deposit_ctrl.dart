import 'dart:async';

import 'package:e_com/feature/deposit/repository/deposit_repo.dart';
import 'package:e_com/main.export.dart';
import 'package:flutter/material.dart';

final depositLogsCtrlProvider = AutoDisposeAsyncNotifierProvider<
    DepositLogsCtrlNotifier,
    PagedItem<PaymentLog>>(DepositLogsCtrlNotifier.new);

class DepositLogsCtrlNotifier
    extends AutoDisposeAsyncNotifier<PagedItem<PaymentLog>> {
  DepositRepo get _repo => ref.read(depositRepoProvider);

  Future<void> reload() async {
    state = const AsyncValue.loading();
    ref.invalidateSelf();
  }

  Future<void> search(String trx) async {
    final data = await _repo.getDepositLog(trx: trx);
    data.fold(
      (l) => state = l.toAsyncError(),
      (r) => state = AsyncData(r.data),
    );
  }

  Future<void> searchWithDateRange(DateTimeRange? range) async {
    if (range == null) return;
    final date =
        '${range.start.formate('yyyy-MM-dd')}+to+${range.end.formate('yyyy-MM-dd')}';

    final data = await _repo.getDepositLog(date: date);
    data.fold(
      (l) => state = l.toAsyncError(),
      (r) => state = AsyncData(r.data),
    );
  }

  Future<void> listByUrl(String? url) async {
    if (url == null) return;
    state = const AsyncValue.loading();
    final data = await _repo.fromUrl(url);
    data.fold(
      (l) => state = l.toAsyncError(),
      (r) => state = AsyncData(r.data),
    );
  }

  @override
  FutureOr<PagedItem<PaymentLog>> build() async {
    final data = await _repo.getDepositLog();
    return data.fold((l) => l.toFError(), (r) => r.data);
  }
}

final depositCtrlProvider =
    AutoDisposeNotifierProvider<DepositCtrlNotifier, PaymentData?>(
        DepositCtrlNotifier.new);

class DepositCtrlNotifier extends AutoDisposeNotifier<PaymentData?> {
  Future<PaymentLog?> makeDeposit(QMap formData) async {
    if (state == null) {
      Toaster.showError('Please select payment method');
      return null;
    }

    formData['payment_id'] = state?.id;

    final data = await _repo.makeDeposit(formData);

    final deposit = data.fold(
      (l) {
        Toaster.showError(l);
        return null;
      },
      (r) {
        if (r.data.msg != null) Toaster.showSuccess(r.data.msg);
        ref.invalidate(depositLogsCtrlProvider);
        // state = null;
        return r.data.data;
      },
    );
    return deposit;
  }

  void setMethod(PaymentData? method) {
    if (method == state) return state = null;
    state = method;
  }

  @override
  PaymentData? build() {
    return null;
  }

  DepositRepo get _repo => ref.read(depositRepoProvider);
}
