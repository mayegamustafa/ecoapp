import 'package:e_com/feature/user_dash/controller/dash_ctrl.dart';
import 'package:e_com/feature/wallet/controller/transactions_ctrl.dart';
import 'package:e_com/main.export.dart';
import 'package:flutter/material.dart';

import 'local/wallet_appbar.dart';

class TransactionsView extends HookConsumerWidget {
  const TransactionsView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final dashboard = ref.watch(userDashCtrlProvider);

    final transactionsData = ref.watch(transactionCtrlProvider);
    final transactionCtrl =
        useCallback(() => ref.read(transactionCtrlProvider.notifier));

    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size(double.infinity, 290),
        child: dashboard.when(
          error: (e, s) => ErrorView(
            e,
            s,
            invalidate: userDashCtrlProvider,
          ),
          loading: Loader.new,
          data: (dash) => WalletAppbar(dash: dash),
        ),
      ),
      body: RefreshIndicator(
        onRefresh: () async => transactionCtrl().reload(),
        child: SingleChildScrollView(
          padding: Insets.padAll,
          physics: defaultScrollPhysics,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                context.tr.transactions,
                style: context.textTheme.titleLarge,
              ),
              const Gap(Insets.lg),
              transactionsData.when(
                loading: Loader.list,
                error: ErrorView.new,
                data: (data) => ListViewWithFooter(
                  physics: const NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  pagination: data.pagination,
                  onNext: () =>
                      transactionCtrl().listByUrl(data.pagination?.nextPageUrl),
                  onPrevious: () =>
                      transactionCtrl().listByUrl(data.pagination?.prevPageUrl),
                  itemCount: data.length,
                  itemBuilder: (context, index) {
                    final item = data[index];
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 10.0),
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: Corners.medBorder,
                          color: context.colors.onSurface.withOpacity(.03),
                        ),
                        child: Padding(
                          padding: Insets.padAll,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    item.formattedAmount,
                                    style: context.textTheme.bodyLarge!
                                        .textColor(item.amountColor),
                                  ),
                                  GestureDetector(
                                    onTap: () => Clipper.copy(item.trxId),
                                    child: Text(
                                      item.trxId,
                                      style: context.textTheme.bodyLarge,
                                    ),
                                  ),
                                ],
                              ),
                              const Gap(Insets.sm),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text.rich(
                                    TextSpan(
                                      children: [
                                        TextSpan(
                                            text: '${context.tr.postBalance}: ',
                                            style: context.textTheme.bodyLarge),
                                        TextSpan(
                                          text: item.postBalance.formate(),
                                          style: context.textTheme.bodyLarge,
                                        ),
                                      ],
                                    ),
                                  ),
                                  Text(
                                    item.readableTime,
                                  ),
                                ],
                              ),
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Flexible(
                                    child: Text(
                                      '${context.tr.details}: ${item.details}',
                                    ),
                                  ),
                                  const Gap(Insets.sm),
                                  Text(
                                    item.date,
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
