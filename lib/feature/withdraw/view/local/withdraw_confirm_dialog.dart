import 'package:e_com/feature/withdraw/controller/withdraw_ctrl.dart';
import 'package:e_com/main.export.dart';
import 'package:e_com/routes/routes.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class WithdrawConfirmDialog extends ConsumerWidget {
  const WithdrawConfirmDialog({
    super.key,
    required this.formData,
  });

  final Map<String, dynamic> formData;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final withdrawData = ref.watch(withdrawCtrlProvider);

    final extraData = formData.entries.where((e) => e.key != 'amount').toList();

    if (withdrawData == null) {
      return AlertDialog(
        title: Text(context.tr.withdrawRequest),
        content: Text(context.tr.msgSomethingWrongWithdraw),
        actions: [
          TextButton(
            onPressed: () => context.pop(),
            child: Text(context.tr.ok),
          ),
        ],
      );
    }

    Future<void> withdrawConfirm() async {
      final ctrl = ref.read(withdrawCtrlProvider.notifier);
      final data = <String, dynamic>{};
      for (var e in extraData) {
        data.addAll({e.key: e.value});
      }
      await ctrl.store('${withdrawData.id}', data);
    }

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 25),
      decoration: const BoxDecoration(
        borderRadius: Corners.medBorder,
      ),
      clipBehavior: Clip.antiAliasWithSaveLayer,
      child: Scaffold(
        appBar: AppBar(
          title: Text(context.tr.withdrawPreview),
          centerTitle: true,
          leading: IconButton(
            onPressed: () => context.pop(),
            icon: const Icon(Icons.close_rounded),
          ),
        ),
        bottomNavigationBar: SubmitLoadButton(
          padding: Insets.padAll,
          onPressed: (l) async {
            l.value = true;
            await withdrawConfirm();
            l.value = false;

            if (context.mounted) RouteNames.withdraw.goNamed(context);
          },
          child: Text(context.tr.withdraw),
        ),
        body: SingleChildScrollView(
          padding: Insets.padAll,
          child: SeparatedColumn(
            separatorBuilder: () => const Gap(Insets.lg),
            children: [
              SpacedText(
                left: context.tr.withdrawMethod,
                right: withdrawData.method.name,
                style: context.textTheme.bodyLarge,
              ),
              SpacedText(
                left: context.tr.withdrawAmount,
                right: withdrawData.amount.formate(useBase: true),
                style: context.textTheme.bodyLarge,
              ),
              SpacedText(
                left: context.tr.charge,
                right: withdrawData.charge.formate(useBase: true),
                style: context.textTheme.bodyLarge,
              ),
              SpacedText(
                left: context.tr.conversionRate,
                right: '${withdrawData.rate} ${withdrawData.currency.name}',
                style: context.textTheme.bodyLarge,
              ),
              const Divider(),
              SpacedText(
                left: context.tr.finalAmount,
                right: withdrawData.finalAmount
                    .formate(currency: withdrawData.currency),
                style: context.textTheme.titleMedium,
                styleBuilder: (left, right) => (
                  left,
                  context.textTheme.titleLarge?.copyWith(
                    color: context.colors.primary,
                  ),
                ),
              ),
              const Divider(),
              for (var MapEntry(:key, :value) in extraData)
                SpacedText(
                  left: withdrawData.method.inputLabelFromName(key),
                  right: value,
                  style: context.textTheme.bodyLarge,
                ),
            ],
          ),
        ),
      ),
    );
  }
}
