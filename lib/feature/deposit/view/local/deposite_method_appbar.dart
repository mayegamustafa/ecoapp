import 'package:e_com/main.export.dart';
import 'package:flutter/material.dart';

import '../../../settings/provider/settings_provider.dart';
import '../../../user_dash/provider/user_dash_provider.dart';

class DepositMethodAppbar extends HookConsumerWidget {
  const DepositMethodAppbar({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final dashBoard = ref.watch(userDashProvider);
    final settings = ref.watch(settingsProvider);
    if (settings == null) {
      return ErrorView(
        'Settings not found',
        null,
        invalidate: settingsProvider,
      );
    }
    final SettingsModel(minDepositAmount: min, maxDepositAmount: max) =
        settings.settings;
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
                context.tr.depositMethod,
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
          Text.rich(
            TextSpan(
              children: [
                TextSpan(text: '${context.tr.min} : '),
                TextSpan(
                  text: min.formate(rateCheck: true),
                ),
                const TextSpan(text: '   '),
                TextSpan(text: '${context.tr.max} : '),
                TextSpan(
                  text: max.formate(rateCheck: true),
                ),
              ],
            ),
            style: context.textTheme.titleMedium,
          ),
        ],
      ),
    );
  }
}
