import 'package:e_com/feature/withdraw/controller/withdraw_ctrl.dart';
import 'package:e_com/main.export.dart';
import 'package:flutter/material.dart';
import 'local/local.dart';

class WithdrawView extends HookConsumerWidget {
  const WithdrawView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final withdrawList = ref.watch(withdrawListCtrlProvider);
    final withdrawCtrl =
        useCallback(() => ref.read(withdrawListCtrlProvider.notifier));

    final searchCtrl = useTextEditingController();

    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size(double.infinity, 200),
        child: WithdrawAppbar(
          searchCtrl: searchCtrl,
          withdrawCtrl: withdrawCtrl,
          withdrawList: withdrawList,
        ),
      ),
      body: RefreshIndicator(
        onRefresh: () async => withdrawCtrl().reload(),
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          child: Column(
            children: [
              const Gap(Insets.med),
              AllWithdrawTable(
                withdrawCtrl: withdrawCtrl,
                withdrawList: withdrawList,
              ),
              const Gap(Insets.sm),
            ],
          ),
        ),
      ),
    );
  }
}
