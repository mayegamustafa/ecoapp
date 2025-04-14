import 'package:e_com/main.export.dart';
import 'package:flutter/material.dart';

import '../../controller/withdraw_ctrl.dart';

class AllWithdrawTable extends StatelessWidget {
  const AllWithdrawTable({
    super.key,
    required this.withdrawCtrl,
    required this.withdrawList,
  });

  final WithdrawListCtrlNotifier Function() withdrawCtrl;
  final AsyncValue<PagedItem<WithdrawData>> withdrawList;

  @override
  Widget build(BuildContext context) {
    final tStyle = context.onTab
        ? context.textTheme.bodyLarge
        : context.textTheme.labelMedium;
    return Padding(
      padding: Insets.padH,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            context.tr.withdrawHistory,
            style: context.textTheme.titleLarge,
          ),
          const Gap(Insets.lg),
          withdrawList.when(
            loading: Loader.list,
            error: ErrorView.new,
            data: (data) => ListViewWithFooter(
              physics: const NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              pagination: data.pagination,
              onNext: () =>
                  withdrawCtrl().listByUrl(data.pagination?.nextPageUrl),
              onPrevious: () =>
                  withdrawCtrl().listByUrl(data.pagination?.prevPageUrl),
              itemCount: data.length,
              itemBuilder: (context, index) {
                final item = data[index];
                return Container(
                  margin: const EdgeInsets.only(bottom: 10),
                  decoration: BoxDecoration(
                    borderRadius: Corners.medBorder,
                    color: context.colors.onSurface.withOpacity(.03),
                  ),
                  padding: Insets.padAll,
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            item.amount.formate(useBase: true),
                            style: context.textTheme.bodyLarge!.copyWith(
                              color: context.colors.errorContainer,
                            ),
                          ),
                          GestureDetector(
                            onTap: () => Clipper.copy(item.trxNo),
                            child: Text(
                              item.trxNo,
                              style: context.textTheme.bodyLarge,
                            ),
                          ),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            '${context.tr.receivable}: ${item.finalAmount.formate(currency: item.currency)}',
                            style: context.textTheme.bodyLarge,
                          ),
                          Text.rich(
                            TextSpan(children: [
                              TextSpan(
                                text: '${context.tr.charge}: ',
                                style: context.textTheme.bodyLarge,
                              ),
                              TextSpan(
                                text: item.charge.formate(useBase: true),
                                style: context.textTheme.bodyLarge!.copyWith(
                                  color: context.colors.error,
                                ),
                              ),
                            ]),
                          ),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: item.feedback.isNotEmpty
                            ? MainAxisAlignment.spaceBetween
                            : MainAxisAlignment.end,
                        children: [
                          if (item.feedback.isNotEmpty)
                            Text(
                              item.feedback,
                              style: context.textTheme.bodyLarge!.copyWith(
                                color: context.colors.errorContainer,
                              ),
                            ),
                          SelectableText(
                            item.readableTime,
                            style: context.textTheme.bodyLarge,
                          ),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              Container(
                                decoration: BoxDecoration(
                                  color: context.colors.primary.withOpacity(.1),
                                  borderRadius: Corners.smBorder,
                                ),
                                padding: Insets.padSym(5, 10),
                                child: Text(
                                  item.method.name,
                                  style:
                                      tStyle?.textColor(context.colors.primary),
                                ),
                              ),
                              const Gap(Insets.sm),
                              Container(
                                decoration: BoxDecoration(
                                  color: item.statusColor.withOpacity(.1),
                                  borderRadius: Corners.smBorder,
                                ),
                                padding: Insets.padSym(5, 10),
                                child: Text(
                                  item.status,
                                  style: tStyle?.textColor(item.statusColor),
                                ),
                              ),
                            ],
                          ),
                          SelectableText(
                            item.date,
                            style: context.textTheme.bodyLarge,
                          ),
                        ],
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
