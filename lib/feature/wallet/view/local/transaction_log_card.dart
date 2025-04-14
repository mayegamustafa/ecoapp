import 'package:e_com/main.export.dart';
import 'package:flutter/material.dart';

import '../../controller/transactions_ctrl.dart';

class TransactionLogCard extends HookConsumerWidget {
  const TransactionLogCard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final transactionsData = ref.watch(transactionCtrlProvider);
    final transactionCtrl =
        useCallback(() => ref.read(transactionCtrlProvider.notifier));

    return transactionsData.when(
      loading: Loader.list,
      error: ErrorView.new,
      data: (data) => ListViewWithFooter(
        physics: const NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        pagination: data.pagination,
        onNext: () => transactionCtrl().listByUrl(data.pagination?.nextPageUrl),
        onPrevious: () =>
            transactionCtrl().listByUrl(data.pagination?.prevPageUrl),
        itemCount: data.length,
        itemBuilder: (context, index) {
          final item = data[index];
          return Padding(
            padding: Insets.padH.copyWith(bottom: 10),
            child: Container(
              decoration: BoxDecoration(
                color: context.colors.onPrimaryContainer,
              ),
              child: Padding(
                padding: Insets.padAll,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          item.formattedAmount,
                          style: context.textTheme.bodyLarge,
                        ),
                        Text(
                          item.trxId,
                          style: context.textTheme.bodyLarge,
                        ),
                      ],
                    ),
                    const Gap(Insets.sm),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text.rich(
                          TextSpan(
                            children: [
                              TextSpan(
                                text: '${context.tr.postBalance}: ',
                                style: context.textTheme.bodyLarge,
                              ),
                              TextSpan(
                                text: item.postBalance.formate(),
                                style: context.textTheme.bodyLarge,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const Gap(Insets.sm),
                    const Gap(Insets.sm),
                    Flexible(
                      child: Text(
                        '${context.tr.details}: ${item.details}',
                        style: TextStyle(
                          color: context.colors.error,
                        ),
                      ),
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(item.readableTime),
                        Text(item.date),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
