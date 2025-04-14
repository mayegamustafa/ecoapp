import 'dart:async';

import 'package:e_com/feature/reward/repository/reward_repo.dart';
import 'package:e_com/main.export.dart';
import 'package:flutter/material.dart';

final rewardLogsCtrlProvider =
    AutoDisposeAsyncNotifierProvider<RewardCtrlNotifier, RewardInfo>(
        RewardCtrlNotifier.new);

class RewardCtrlNotifier extends AutoDisposeAsyncNotifier<RewardInfo> {
  RewardRepo get _repo => ref.read(rewardRepoProvider);

  Future<void> reload() async {
    state = const AsyncValue.loading();
    ref.invalidateSelf();
  }

  Future<void> filter({DateTimeRange? dateRange, RewardStatus? status}) async {
    String date = '';
    if (dateRange != null) {
      date =
          '${dateRange.start.formate('yyyy-MM-dd')}+to+${dateRange.end.formate('yyyy-MM-dd')}';
    }
    final data = await _repo.getRewardInfo(date: date, status: status?.code);

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

  Future<void> redeem(RewardLog log) async {
    final data = await _repo.redeemPoint(log.id);
    data.fold(
      (l) => Toaster.showError(l),
      (r) {
        Toaster.showError(r.data.message);
        ref.invalidateSelf();
      },
    );
  }

  @override
  FutureOr<RewardInfo> build() async {
    final data = await _repo.getRewardInfo();

    return data.fold(
      (l) => l.toFError(),
      (r) => r.data,
    );
  }
}
