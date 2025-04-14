import 'dart:async';

import 'package:e_com/feature/wallet/repository/transactions_repo.dart';
import 'package:e_com/main.export.dart';
import 'package:flutter/material.dart';

final transactionCtrlProvider = AutoDisposeAsyncNotifierProvider<
    TransactionCtrlNotifier,
    PagedItem<TransactionData>>(TransactionCtrlNotifier.new);

class TransactionCtrlNotifier
    extends AutoDisposeAsyncNotifier<PagedItem<TransactionData>> {
  TransactionRepo get _repo => ref.read(transactionsRepoProvider);

  Future<void> reload() async {
    state = const AsyncValue.loading();
    ref.invalidateSelf();
  }

  Future<void> filter({DateTimeRange? dateRange, String? search}) async {
    String date = '';
    if (dateRange != null) {
      date =
          '${dateRange.start.formate('yyyy-MM-dd')}+to+${dateRange.end.formate('yyyy-MM-dd')}';
    }
    final data = await _repo.transactionList(date: date, search: search ?? '');

    data.fold(
      (l) => state = l.toAsyncError(),
      (r) => state = AsyncData(r.data),
    );
  }

  Future<void> listByUrl(String? url) async {
    if (url == null) return;
    state = const AsyncValue.loading();
    final data = await _repo.transactionListFromUrl(url);
    data.fold(
      (l) => state = l.toAsyncError(),
      (r) => state = AsyncData(r.data),
    );
  }

  @override
  FutureOr<PagedItem<TransactionData>> build() async {
    final data = await _repo.transactionList();

    return data.fold((l) => l.toFError(), (r) => r.data);
  }
}
