import 'package:e_com/feature/deposit/controller/deposit_ctrl.dart';
import 'package:e_com/feature/user_dash/provider/user_dash_provider.dart';
import 'package:e_com/main.export.dart';
import 'package:e_com/routes/go_route_name.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

class DepositAppbar extends HookConsumerWidget {
  const DepositAppbar({
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final dashBoard = ref.watch(userDashProvider);
    final depositCtrl =
        useCallback(() => ref.read(depositLogsCtrlProvider.notifier));

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
                context.tr.deposit,
                style: context.textTheme.titleLarge,
              ),
            ],
          ),
          Text(
            '${dashBoard?.user.balance.formate()}',
            style: context.textTheme.headlineMedium!.copyWith(),
          ),
          Text(
            context.tr.availableBalance,
            style: context.textTheme.bodyLarge!.copyWith(),
          ),
          const Gap(Insets.med),
          FilledButton.icon(
            style: const ButtonStyle(
              shape: WidgetStatePropertyAll(
                StadiumBorder(),
              ),
            ),
            onPressed: () {
              RouteNames.depositPayment.pushNamed(context);
            },
            icon: const Icon(
              Icons.add,
            ),
            label: Text(context.tr.deposit),
          ),
          const Gap(Insets.med),
          Padding(
            padding: Insets.padH,
            child: Row(
              children: [
                Flexible(
                  child: TextField(
                    controller: searchCtrl,
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: context.colors.onSurface.withOpacity(.03),
                      enabledBorder: InputBorder.none,
                      focusedBorder: InputBorder.none,
                      contentPadding: const EdgeInsets.symmetric(vertical: 10),
                      prefixIcon: const Icon(Icons.search),
                      suffixIcon: IconButton(
                        onPressed: () {
                          searchCtrl.clear();
                          depositCtrl().reload();
                        },
                        icon: const Icon(Icons.clear),
                      ),
                      hintText: context.tr.searchByTrxNumber,
                      border: const OutlineInputBorder(),
                    ),
                    onChanged: (value) => depositCtrl().search(value),
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
                      depositCtrl().searchWithDateRange(range);
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
