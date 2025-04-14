import 'package:e_com/feature/withdraw/controller/withdraw_ctrl.dart';
import 'package:e_com/main.export.dart';
import 'package:e_com/routes/go_route_name.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

class WithdrawAppbar extends ConsumerWidget {
  const WithdrawAppbar({
    super.key,
    required this.searchCtrl,
    required this.withdrawCtrl,
    required this.withdrawList,
  });
  final TextEditingController searchCtrl;
  final WithdrawListCtrlNotifier Function() withdrawCtrl;
  final AsyncValue<PagedItem<WithdrawData>> withdrawList;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
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
              Text('Withdraw', style: context.textTheme.titleLarge),
            ],
          ),
          FilledButton.icon(
            style: const ButtonStyle(
              shape: WidgetStatePropertyAll(
                StadiumBorder(),
              ),
            ),
            onPressed: () => RouteNames.withdrawNow.goNamed(context),
            label: const Icon(Icons.add),
            icon: Text(context.tr.withdrawNow),
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
                      suffixIcon: IconButton(
                        onPressed: () {
                          searchCtrl.clear();
                          withdrawCtrl().reload();
                        },
                        icon: const Icon(Icons.clear),
                      ),
                      hintText: 'Search by trx number',
                      border: const OutlineInputBorder(),
                    ),
                    onChanged: (value) => withdrawCtrl().search(value),
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
                      withdrawCtrl().search(searchCtrl.text, range);
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
