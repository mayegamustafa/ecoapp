import 'package:collection/collection.dart';
import 'package:e_com/feature/reward/controller/reward_ctrl.dart';
import 'package:e_com/feature/settings/provider/settings_provider.dart';
import 'package:e_com/main.export.dart';
import 'package:e_com/routes/routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

import 'local/reward_appbar.dart';

class RewardView extends HookConsumerWidget {
  const RewardView({super.key});

  static const expDuration = Duration(days: 15);

  num getNearExpPoints(List<RewardLog> rewardLogs) {
    final now = DateTime.now();
    final date = DateTime(now.year, now.month, now.day);

    return rewardLogs
        .where(
          (x) =>
              x.expiredAt.isBefore(date.add(expDuration)) &&
              x.status == RewardStatus.pending,
        )
        .map((e) => e.point)
        .sum;
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final rewardLogs = ref.watch(rewardLogsCtrlProvider);
    final rewardLogCtrl =
        useCallback(() => ref.read(rewardLogsCtrlProvider.notifier));

    final isFiltering = useState(false);

    return rewardLogs.when(
      error: (e, st) => Scaffold(
        body: ErrorView(e, st, invalidate: rewardLogsCtrlProvider),
      ),
      loading: () => Scaffold(
        body: Loader.list(),
      ),
      data: (rewardInfo) {
        final RewardInfo(:overview, :rewardLogs) = rewardInfo;
        num points() => getNearExpPoints(rewardLogs.listData);

        return Scaffold(
          appBar: PreferredSize(
            preferredSize: const Size(double.infinity, 220),
            child: RewardAppbar(overview: overview),
          ),
          body: RefreshIndicator(
            onRefresh: () => rewardLogCtrl().reload(),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Gap(Insets.med),
                DecoratedContainer(
                  color: context.colors.onSurface.withOpacity(.03),
                  padding: Insets.padAll,
                  margin: Insets.padH,
                  child: Row(
                    children: [
                      const Icon(Icons.watch_later_outlined),
                      const Gap(Insets.med),
                      Text.rich(
                        TextSpan(
                          children: [
                            TextSpan(
                              text: '${points()} ${context.tr.points} ',
                              style: context.textTheme.bodyMedium?.bold,
                            ),
                            TextSpan(text: '${context.tr.willExpireIn} '),
                            TextSpan(
                              text: '${expDuration.inDays} ${context.tr.days}',
                              style: context.textTheme.bodyMedium?.bold,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                const Gap(Insets.med),
                Padding(
                  padding: Insets.padH,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        context.tr.rewardLogs,
                        style: context.textTheme.titleLarge,
                      ),
                      CustomCutContainer(
                        cutSize: 40,
                        height: 45,
                        width: isFiltering.value ? context.width / 2.2 : 150,
                        gradient: LinearGradient(
                          colors: [
                            context.colors.primary,
                            context.colors.primary
                          ],
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            IconButton(
                              onPressed: () async {
                                final date = await showDateRangePicker(
                                  context: context,
                                  firstDate: DateTime(1980),
                                  lastDate: DateTime.now().add(30.days),
                                );
                                isFiltering.value = true;
                                rewardLogCtrl().filter(dateRange: date);
                              },
                              icon: Icon(
                                Icons.date_range,
                                color: context.colors.onPrimary,
                              ),
                            ),
                            MenuAnchor(
                              menuChildren: [
                                ...RewardStatus.values.map(
                                  (e) => MenuItemButton(
                                    child: Text(e.name.toTitleCase),
                                    onPressed: () {
                                      isFiltering.value = true;
                                      rewardLogCtrl().filter(status: e);
                                    },
                                  ),
                                ),
                              ],
                              builder: (_, ctrl, child) => IconButton(
                                onPressed: () =>
                                    ctrl.isOpen ? ctrl.close() : ctrl.open(),
                                icon: child!,
                              ),
                              child: Icon(
                                Icons.sort,
                                color: context.colors.onPrimary,
                              ),
                            ),
                            if (isFiltering.value)
                              IconButton(
                                onPressed: () async {
                                  isFiltering.value = false;
                                  rewardLogCtrl().reload();
                                },
                                icon: Icon(
                                  Icons.close_rounded,
                                  color: context.colors.onPrimary,
                                ),
                              ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                const Gap(Insets.med),
                Expanded(
                  child: Padding(
                    padding: Insets.padH,
                    child: ListViewWithFooter(
                      physics: defaultScrollPhysics,
                      shrinkWrap: true,
                      pagination: rewardLogs.pagination,
                      itemCount: rewardLogs.length,
                      onNext: () => rewardLogCtrl().listByUrl(
                        rewardLogs.pagination?.nextPageUrl,
                      ),
                      onPrevious: () => rewardLogCtrl().listByUrl(
                        rewardLogs.pagination?.prevPageUrl,
                      ),
                      itemBuilder: (context, index) {
                        final item = rewardLogs[index];
                        return RewardLogTile(item: item);
                      },
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class RewardLogTile extends HookConsumerWidget {
  const RewardLogTile({
    super.key,
    required this.item,
  });

  final RewardLog item;

  @override
  Widget build(BuildContext context, ref) {
    return GestureDetector(
      onTap: () async {
        await showDialog<bool>(
          context: context,
          builder: (c) => RewardDetailsDialog(item: item),
        );
      },
      child: Container(
        margin: Insets.padOnly(bottom: Insets.med),
        decoration: BoxDecoration(
          borderRadius: Corners.medBorder,
          color: context.colors.onSurface.withOpacity(.03),
        ),
        padding: Insets.padAll,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  decoration: BoxDecoration(
                    borderRadius: Corners.medBorder,
                    color: context.colors.primary.withOpacity(.03),
                  ),
                  child: Padding(
                    padding: Insets.padAll,
                    child: Assets.svg.redeemPoints.svg(
                      height: 50,
                      colorFilter: ColorFilter.mode(
                        context.colors.primary,
                        BlendMode.srcIn,
                      ),
                    ),
                  ),
                ),
                const Gap(Insets.med),
                Flexible(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        item.details,
                      ),
                      Text(
                        '${context.tr.expireAt} : ${item.expiredAt.formate('dd MMM, yyyy')}',
                      ),
                      const Gap(Insets.med),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          if (item.status == RewardStatus.pending)
                            GestureDetector(
                              onTap: () async {
                                await showDialog<bool>(
                                  context: context,
                                  builder: (c) =>
                                      RewardDetailsDialog(item: item),
                                );
                              },
                              child: DecoratedContainer(
                                color: Colors.amber.withOpacity(.1),
                                borderRadius: 100,
                                padding:
                                    Insets.padSym(5, 20).copyWith(left: 10),
                                child: Row(
                                  children: [
                                    Assets.svg.coin.svg(height: 20),
                                    const Gap(Insets.sm),
                                    Text(
                                      '${context.tr.claim} ${item.point}',
                                      style: context.textTheme.bodyLarge!.bold
                                          .textColor(Colors.amber),
                                    ),
                                  ],
                                ),
                              ),
                            )
                          else
                            const SizedBox.shrink(),
                          DecoratedContainer(
                            color: item.status.color.withOpacity(.1),
                            padding: Insets.padSym(3, 6),
                            borderRadius: Corners.med,
                            child: Text(
                              item.status.name.titleCaseSingle,
                              style: context.textTheme.bodyLarge!
                                  .textColor(item.status.color),
                            ),
                          ),
                        ],
                      )
                    ],
                  ),
                )
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class RewardDetailsDialog extends ConsumerWidget {
  const RewardDetailsDialog({
    super.key,
    required this.item,
  });

  final RewardLog item;

  @override
  Widget build(BuildContext context, ref) {
    final isPending = item.status == RewardStatus.pending;
    final rate =
        ref.watch(settingsProvider.select((x) => x?.settings.pointRate ?? 1));

    String calculatedPoint() {
      final p = item.point;

      final result = p / rate;

      return result.formate(rateCheck: true);
    }

    return AlertDialog(
      contentPadding: Insets.padSym(0, 20),
      actionsPadding: Insets.padSym(10, 20).copyWith(top: 0),
      title: isPending
          ? Text(context.tr.redeemPoint)
          : Text(context.tr.rewardPoint),
      content: SeparatedColumn(
        separatorBuilder: () => const Gap(Insets.sm),
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(width: context.width * .9),
          SpacedText(
            left: context.tr.point,
            right: item.point.toString(),
            style: context.textTheme.bodyLarge,
          ),
          SpacedText(
            left: context.tr.expireAt,
            right: item.expiredAt.formate('dd MMM, yyyy'),
            style: context.textTheme.bodyLarge,
          ),
          SpacedText(
            left: context.tr.createdAt,
            right: DateTime.parse(item.createdAt).formate('dd MMM, yyyy'),
            style: context.textTheme.bodyLarge,
          ),
          if (item.redeemedAt != null)
            SpacedText(
              left: context.tr.redeemedAt,
              right: DateTime.parse(item.redeemedAt!).formate('dd MMM, yyyy'),
              style: context.textTheme.bodyLarge,
            ),
          if (item.product != null)
            SpacedText(
              left: context.tr.product,
              right: item.product?.product.fold((l) => l.name, (r) => r.name) ??
                  'N/A',
              style: context.textTheme.bodyLarge,
            ),
          if (item.order != null)
            SpacedText(
              left: context.tr.order,
              right: item.order?.orderId ?? 'N/A',
              trailing: GestureDetector(
                onTap: () {
                  RouteNames.orderDetails.pushNamed(
                    context,
                    query: {'id': item.order!.orderId},
                  );
                },
                child: Icon(
                  Icons.open_in_new_rounded,
                  color: context.colors.primary,
                  size: 18,
                ),
              ),
              style: context.textTheme.bodyLarge,
            ),
          const Divider(),
          if (isPending)
            Text.rich(
              TextSpan(
                children: [
                  TextSpan(
                    text: '${context.tr.youWillGet} ',
                  ),
                  TextSpan(
                    text: calculatedPoint(),
                    style: context.textTheme.bodyLarge!.bold,
                  ),
                  TextSpan(
                    text: ' ${context.tr.fromRedeeming}',
                  ),
                ],
              ),
            ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => context.nPop(false),
          child: Text(context.tr.close),
        ),
        if (isPending)
          SubmitLoadButton.dense(
            onPressed: (l) async {
              l.value = true;
              await ref.read(rewardLogsCtrlProvider.notifier).redeem(item);
              l.value = false;
              if (context.mounted) context.nPop(true);
            },
            child: Text(context.tr.claim),
          ),
      ],
    );
  }
}

class RewardOverviewView extends StatelessWidget {
  const RewardOverviewView({
    super.key,
    required this.overview,
  });

  final RewardOverview overview;

  @override
  Widget build(BuildContext context) {
    return DecoratedContainer(
      width: context.width,
      padding: Insets.padAll,
      color: context.colors.primary,
      child: Column(
        children: [
          DecoratedContainer(
            color: context.colors.onPrimary,
            borderRadius: Corners.lg,
            padding: Insets.padSym(3, 16),
            child: Text.rich(
              TextSpan(
                text: '${context.tr.totalPoints}\n',
                children: [
                  TextSpan(
                    text: overview.total.toString(),
                    style: context.textTheme.titleMedium?.bold,
                  ),
                ],
              ),
              textAlign: TextAlign.center,
              style: context.textTheme.bodyLarge?.bold,
            ),
          ),
          const Gap(Insets.lg),
          DefaultTextStyle(
            style: context.textTheme.bodyMedium!
                .textColor(context.colors.onPrimary),
            child: SeparatedRow(
              separatorBuilder: () => const Gap(Insets.med),
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Text.rich(
                  TextSpan(
                    text: '${context.tr.pending} : ',
                    children: [
                      TextSpan(
                        text: overview.pending.toString(),
                        style: context.textTheme.titleMedium?.bold
                            .textColor(context.colors.onPrimary),
                      ),
                    ],
                  ),
                  textAlign: TextAlign.center,
                ),
                Text.rich(
                  TextSpan(
                    text: '${context.tr.redeemed} : ',
                    children: [
                      TextSpan(
                        text: overview.redeemed.toString(),
                        style: context.textTheme.titleMedium?.bold
                            .textColor(context.colors.onPrimary),
                      ),
                    ],
                  ),
                  textAlign: TextAlign.center,
                ),
                Text.rich(
                  TextSpan(
                    text: '${context.tr.expired} : ',
                    children: [
                      TextSpan(
                        text: overview.expired.toString(),
                        style: context.textTheme.titleMedium?.bold
                            .textColor(context.colors.onPrimary),
                      ),
                    ],
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
          const Gap(Insets.med),
        ],
      ),
    );
  }
}
