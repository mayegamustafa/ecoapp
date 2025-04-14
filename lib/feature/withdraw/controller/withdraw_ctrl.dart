import 'dart:async';

import 'package:e_com/feature/user_dash/controller/dash_ctrl.dart';
import 'package:e_com/feature/withdraw/repository/withdraw_repo.dart';
import 'package:e_com/main.export.dart';
import 'package:flutter/material.dart';

final withdrawMethodsProvider =
    FutureProvider.autoDispose<List<WithdrawMethod>>((ref) async {
  final data = await ref.read(withdrawRepoProvider).getMethods();

  return data.fold((l) => l.toFError(), (r) => r.data);
});

/// --------------------------------------------------------
/// Withdraw List
/// --------------------------------------------------------

final withdrawListCtrlProvider = AutoDisposeAsyncNotifierProvider<
    WithdrawListCtrlNotifier,
    PagedItem<WithdrawData>>(WithdrawListCtrlNotifier.new);

class WithdrawListCtrlNotifier
    extends AutoDisposeAsyncNotifier<PagedItem<WithdrawData>> {
  WithdrawRepo get _repo => ref.read(withdrawRepoProvider);

  Future<void> reload() async {
    state = const AsyncValue.loading();
    ref.invalidateSelf();
  }

  Future<void> search(String query, [DateTimeRange? range]) async {
    if (range == null) return;
    final date =
        '${range.start.formate('yyyy-MM-dd')}+to+${range.end.formate('yyyy-MM-dd')}';

    final data = await _repo.getWithdrawList(search: query, date: date);
    data.fold(
      (l) => state = l.toAsyncError(),
      (r) => state = AsyncData(r.data),
    );
  }

  Future<void> listByUrl(String? url) async {
    if (url == null) return;
    state = const AsyncValue.loading();
    final data = await _repo.getWithdrawListFromUrl(url);
    data.fold(
      (l) => state = l.toAsyncError(),
      (r) => state = AsyncData(r.data),
    );
  }

  @override
  FutureOr<PagedItem<WithdrawData>> build() async {
    final data = await _repo.getWithdrawList();
    return data.fold((l) => l.toFError(), (r) => r.data);
  }
}

/// --------------------------------------------------------
/// Withdraw Controller
/// --------------------------------------------------------
final withdrawCtrlProvider =
    AutoDisposeNotifierProvider<WithdrawCtrlNotifier, WithdrawData?>(
        WithdrawCtrlNotifier.new);

class WithdrawCtrlNotifier extends AutoDisposeNotifier<WithdrawData?> {
  WithdrawRepo get _repo => ref.read(withdrawRepoProvider);

  @override
  WithdrawData? build() {
    return null;
  }

  Future<bool> request(String id, String amount) async {
    ref.keepAlive();
    final data = await _repo.request(id, amount);

    data.fold(
      (l) => Toaster.showError(l),
      (r) {
        state = r.data.data;
        Toaster.showSuccess(r.data.msg);
      },
    );

    return data.isRight();
  }

  Future<void> store(String id, Map<String, dynamic> formData) async {
    final data = await _repo.storeWithdraw(id, formData);
    await ref.read(userDashCtrlProvider.notifier).reload();

    data.fold(
      (l) => Toaster.showError(l),
      (r) => Toaster.showSuccess(r.data),
    );

    ref.invalidate(withdrawListCtrlProvider);
  }
}
