import 'package:e_com/feature/user_dash/provider/user_dash_provider.dart';
import 'package:e_com/main.export.dart';
import 'package:flutter/material.dart';

class WalletSelector extends ConsumerWidget {
  const WalletSelector({
    super.key,
    required this.isWallet,
    required this.selector,
  });

  final bool isWallet;
  final Function(bool isWallet) selector;

  static final walletTypes = [TR.current.traditional, TR.current.wallet];

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userBalance =
        ref.watch(userDashProvider.select((value) => value?.user.balance));

    return IntrinsicHeight(
      child: SeparatedRow(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        separatorBuilder: () => const Gap(Insets.med),
        children: [
          ...walletTypes.map(
            (e) {
              final isThisWallet = e == context.tr.wallet;
              final selected = isWallet == isThisWallet;
              return Stack(
                children: [
                  InkWell(
                    onTap: () => selector(isThisWallet),
                    child: DecoratedContainer(
                      width: context.width * .45,
                      padding: Insets.padAll,
                      color: context.colors.secondaryContainer.withOpacity(.05),
                      borderRadius: Corners.med,
                      borderWidth: 1,
                      borderColor: selected ? context.colors.primary : null,
                      alignment: Alignment.center,
                      child: Row(
                        children: [
                          Icon(
                            isThisWallet
                                ? Icons.wallet_rounded
                                : Icons.payments_rounded,
                            color: context.colors.outlineVariant,
                          ),
                          const Gap(Insets.sm),
                          Text.rich(
                            TextSpan(
                              text: e,
                              children: [
                                if (isThisWallet && userBalance != null)
                                  TextSpan(
                                    text: '\n${userBalance.formate()}',
                                    style: context.textTheme.bodyMedium,
                                  ),
                              ],
                            ),
                            style: context.textTheme.titleMedium?.bold,
                          ),
                        ],
                      ),
                    ),
                  ),
                  if (selected)
                    const Positioned(
                      right: 5,
                      top: 5,
                      child: Icon(
                        Icons.check_circle_outline_rounded,
                        size: 20,
                      ),
                    ),
                ],
              );
            },
          ),
        ],
      ),
    );
  }
}
