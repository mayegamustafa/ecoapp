import 'package:e_com/feature/deposit/controller/deposit_ctrl.dart';
import 'package:e_com/feature/deposit/view/local/deposite_appbar.dart';
import 'package:e_com/main.export.dart';
import 'package:flutter/material.dart';

class DepositView extends HookConsumerWidget {
  const DepositView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final depositList = ref.watch(depositLogsCtrlProvider);
    final depositCtrl =
        useCallback(() => ref.read(depositLogsCtrlProvider.notifier));

    return Scaffold(
      appBar: const PreferredSize(
        preferredSize: Size(double.infinity, 250),
        child: DepositAppbar(),
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          return depositCtrl().reload();
        },
        child: GestureDetector(
          onTap: () {
            FocusScope.of(context).unfocus();
          },
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            padding: Insets.padAll,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  context.tr.depositHistory,
                  style: context.textTheme.titleLarge,
                ),
                const Gap(Insets.med),
                depositList.when(
                  error: (e, s) => ErrorView(e, s),
                  loading: () => Loader.list(),
                  data: (data) {
                    return ListViewWithFooter(
                      physics: const NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      pagination: data.pagination,
                      onNext: () =>
                          depositCtrl().listByUrl(data.pagination?.nextPageUrl),
                      onPrevious: () =>
                          depositCtrl().listByUrl(data.pagination?.prevPageUrl),
                      itemCount: data.length,
                      itemBuilder: (context, index) {
                        final tStyle = context.onTab
                            ? context.textTheme.bodyLarge
                            : context.textTheme.labelMedium;
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
                                children: [
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(item.amount,
                                          style: context.textTheme.bodyLarge),
                                      GestureDetector(
                                        onTap: () => Clipper.copy(item.trx),
                                        child: Text(
                                          item.trx,
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
                                      Text(
                                        '${context.tr.payable}: ${item.payable}',
                                        style: context.textTheme.bodyLarge,
                                      ),
                                      Text.rich(
                                        TextSpan(
                                          children: [
                                            TextSpan(
                                              text: '${context.tr.charge}: ',
                                              style:
                                                  context.textTheme.bodyLarge,
                                            ),
                                            TextSpan(
                                              text: item.charge,
                                              style: context
                                                  .textTheme.bodyLarge!
                                                  .textColor(
                                                context.colors.error,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                  const Gap(Insets.sm),
                                  Row(
                                    mainAxisAlignment: item.feedback != null
                                        ? MainAxisAlignment.spaceBetween
                                        : MainAxisAlignment.end,
                                    children: [
                                      if (item.feedback != null)
                                        Text(item.feedback!,
                                            style: context.textTheme.bodyLarge),
                                      Text(
                                        item.readableTime,
                                        style: context.textTheme.bodyLarge,
                                      ),
                                    ],
                                  ),
                                  const Gap(Insets.sm),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Row(
                                        children: [
                                          Container(
                                            decoration: BoxDecoration(
                                              color: context.colors.primary
                                                  .withOpacity(.1),
                                              borderRadius: Corners.smBorder,
                                            ),
                                            padding: Insets.padSym(3, 8),
                                            child: Text(
                                              item.method.name,
                                              style: tStyle?.textColor(
                                                context.colors.primary,
                                              ),
                                            ),
                                          ),
                                          const Gap(Insets.sm),
                                          Container(
                                            decoration: BoxDecoration(
                                              color: item.status.color
                                                  .withOpacity(.1),
                                              borderRadius: Corners.smBorder,
                                            ),
                                            padding: Insets.padSym(3, 8),
                                            child: Text(
                                              item.status.name.titleCaseSingle,
                                              style: tStyle?.textColor(
                                                  item.status.color),
                                            ),
                                          ),
                                        ],
                                      ),
                                      Text(
                                        item.dateTime,
                                        style: context.textTheme.bodyLarge,
                                      ),
                                    ],
                                  ),
                                  const Gap(Insets.sm),
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
