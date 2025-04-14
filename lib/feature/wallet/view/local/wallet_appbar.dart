import 'package:e_com/feature/wallet/controller/transactions_ctrl.dart';
import 'package:e_com/main.export.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

import '../../../../routes/go_route_name.dart';

class WalletAppbar extends HookConsumerWidget {
  const WalletAppbar({
    super.key,
    required this.dash,
  });
  final UserDashModel dash;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final transactionCtrl =
        useCallback(() => ref.read(transactionCtrlProvider.notifier));
    final searchCtrl = useTextEditingController();
    return DiagonalCutContainer(
      height: context.height / 2,
      width: double.infinity,
      cutSize: 150,
      gradient: LinearGradient(
        colors: [
          context.colors.primary.withOpacity(.1),
          context.colors.primary.withOpacity(.03),
        ],
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
      ),
      child: Column(
        children: [
          const Gap(40),
          Row(
            children: [
              const Gap(Insets.med),
              IconButton.filled(
                style: ButtonStyle(
                  backgroundColor: WidgetStatePropertyAll(
                    context.colors.onSurface.withOpacity(.05),
                  ),
                ),
                onPressed: () => Navigator.pop(context),
                icon: Icon(Icons.arrow_back, color: context.colors.onSurface),
              ),
              const Gap(Insets.lg),
              Text(
                'Wallet',
                style: context.textTheme.titleLarge!,
              ),
            ],
          ),
          Padding(
            padding: Insets.padAll,
            child: Column(
              children: [
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
                  child: Text(
                    dash.user.balance.formate(),
                    style: context.textTheme.headlineMedium!.copyWith(),
                  ),
                ),
                Text(
                  'Available Balance',
                  style: context.textTheme.bodyLarge!.copyWith(),
                ),
              ],
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              FilledButton.icon(
                  style: const ButtonStyle(
                    shape: WidgetStatePropertyAll(
                      StadiumBorder(),
                    ),
                  ),
                  onPressed: () => RouteNames.deposit.pushNamed(context),
                  label: Text(context.tr.deposit),
                  icon: const Icon(Icons.wallet_rounded)),
              const Gap(Insets.lg),
              FilledButton.icon(
                style: const ButtonStyle(
                  shape: WidgetStatePropertyAll(
                    StadiumBorder(),
                  ),
                ),
                onPressed: () => RouteNames.withdraw.pushNamed(context),
                label: Text(context.tr.withdraw),
                icon: const Icon(Icons.payments_rounded),
              ),
            ],
          ),
          const Gap(Insets.lg),
          Padding(
            padding: Insets.padH,
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: searchCtrl,
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: context.colors.onSurface.withOpacity(.03),
                      enabledBorder: InputBorder.none,
                      focusedBorder: InputBorder.none,
                      contentPadding: const EdgeInsets.symmetric(vertical: 10),
                      prefixIcon: const Icon(Icons.search),
                      hintText: context.tr.searchByTrxNumber,
                      border: const OutlineInputBorder(),
                      suffixIcon: IconButton(
                        onPressed: () {
                          searchCtrl.clear();
                          transactionCtrl().reload();
                        },
                        icon: const Icon(Icons.clear),
                      ),
                    ),
                    onChanged: (value) =>
                        transactionCtrl().filter(search: value),
                  ),
                ),
                const Gap(Insets.sm),
                SizedBox.square(
                  dimension: 46,
                  child: IconButton.filled(
                    style: const ButtonStyle(
                      shape: WidgetStatePropertyAll(
                        RoundedRectangleBorder(
                          borderRadius: Corners.medBorder,
                        ),
                      ),
                    ),
                    onPressed: () async {
                      final range = await showDateRangePicker(
                        context: context,
                        firstDate: DateTime(1950),
                        lastDate: DateTime.now().add(30.days),
                      );
                      transactionCtrl().filter(dateRange: range);
                    },
                    icon: const Icon(
                      Icons.calendar_month_rounded,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
