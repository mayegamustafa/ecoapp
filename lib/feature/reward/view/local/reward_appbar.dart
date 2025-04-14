import 'package:e_com/main.export.dart';
import 'package:flutter/material.dart';

class RewardAppbar extends ConsumerWidget {
  const RewardAppbar({
    super.key,
    required this.overview,
  });

  final RewardOverview overview;

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
              Text(
                context.tr.reward,
                style: context.textTheme.titleLarge,
              ),
            ],
          ),
          Text(
            overview.total.toString(),
            style: context.textTheme.headlineMedium,
          ),
          Text(
            context.tr.totalRewardPoints,
          ),
          const Gap(Insets.lg),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              StatusCard(
                value: overview.pending.toString(),
                status: context.tr.pending,
              ),
              const Gap(Insets.lg),
              Container(
                height: 50,
                width: 1,
                color: context.colors.primary,
              ),
              const Gap(Insets.lg),
              StatusCard(
                value: overview.redeemed.toString(),
                status: context.tr.redeemed,
              ),
              const Gap(Insets.lg),
              Container(
                height: 50,
                width: 1,
                color: context.colors.primary,
              ),
              const Gap(Insets.lg),
              StatusCard(
                value: overview.expired.toString(),
                status: context.tr.expired,
              ),
            ],
          )
        ],
      ),
    );
  }
}

class StatusCard extends StatelessWidget {
  const StatusCard({
    super.key,
    required this.value,
    required this.status,
  });
  final String value;
  final String status;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          value,
          style: context.textTheme.titleLarge,
        ),
        Text(
          status,
          style: TextStyle(
            color: context.colors.onSurface.withOpacity(.7),
          ),
        ),
      ],
    );
  }
}
