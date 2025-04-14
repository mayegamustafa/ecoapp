import 'package:collection/collection.dart';
import 'package:e_com/_core/_core.dart';
import 'package:e_com/feature/cart/controller/carts_ctrl.dart';
import 'package:e_com/feature/cart/view/local/cart_tile.dart';
import 'package:e_com/feature/region_settings/controller/region_ctrl.dart';
import 'package:e_com/feature/settings/provider/settings_provider.dart';
import 'package:e_com/routes/routes.dart';
import 'package:e_com/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class CartsView extends HookConsumerWidget {
  const CartsView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cartList = ref.watch(cartCtrlProvider);
    final cartCtrl = useCallback(() => ref.read(cartCtrlProvider.notifier));
    final currency = ref.watch(regionCtrlProvider.select((v) => v.currency));

    final (minAmountDB, amountCheck) = ref.watch(
      settingsProvider.select(
        (v) {
          if (v == null) return (0, false);
          return (v.settings.minOrderAmount, v.settings.minOrderCheck);
        },
      ),
    );

    final minAmount = minAmountDB * (currency?.rate ?? 1);
    final tr = context.tr;
    return cartList.when(
      error: (error, s) =>
          Scaffold(body: ErrorView.reload(error, s, () => cartCtrl().reload())),
      loading: () => const CartLoading(),
      data: (carts) {
        num subTotal = carts.listData.map((e) => e.total).sum.formateSelf();

        final isDisable = amountCheck && subTotal < minAmount;

        final progress = ((subTotal / minAmount) * 100) / 100;

        return PopScope(
          canPop: false,
          onPopInvokedWithResult: (didPop, r) {
            if (didPop) return;
            RouteNames.home.goNamed(context);
          },
          child: Scaffold(
            appBar: KAppBar(
              title: Text(tr.shopping_cart),
            ),
            bottomNavigationBar: BottomAppBar(
              height: amountCheck ? 150 : 120,
              padding: defaultPadding,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Divider(),
                  SpacedText(
                    left: tr.subtotal,
                    right: subTotal.formate(),
                    style: context.textTheme.titleLarge,
                  ),
                  if (amountCheck) ...[
                    const SizedBox(height: 10),
                    if (subTotal < minAmount)
                      Text.rich(
                        TextSpan(
                          children: [
                            TextSpan(text: '${context.tr.spend} '),
                            TextSpan(
                              text: (minAmount - subTotal).formate(),
                              style: context.textTheme.labelMedium?.copyWith(
                                color: context.colors.primary,
                              ),
                            ),
                            TextSpan(text: ' ${context.tr.moreToPlaceOrder}'),
                          ],
                        ),
                        style: context.textTheme.labelSmall,
                      ),
                    const SizedBox(height: 5),
                    LinearProgressIndicator(
                      value: progress.clamp(0, 1),
                      minHeight: 8,
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ],
                  const SizedBox(height: 5),
                  SubmitButton(
                    onPressed: isDisable || subTotal <= 0
                        ? null
                        : () => RouteNames.shippingDetails.goNamed(context),
                    child: Text(tr.submit_order),
                  ),
                  const SizedBox(height: 10),
                ],
              ),
            ),
            body: Padding(
              padding: defaultPadding,
              child: RefreshIndicator(
                onRefresh: () => cartCtrl().reload(),
                child: ListViewWithFooter(
                  pagination: carts.pagination,
                  onNext: () => cartCtrl().paginationHandler(true),
                  onPrevious: () => cartCtrl().paginationHandler(false),
                  physics: defaultScrollPhysics,
                  itemCount: carts.length,
                  emptyListWidget:
                      const Center(child: NoItemsAnimationWithFooter()),
                  itemBuilder: (BuildContext context, int index) {
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 10),
                      child: CartTile(cart: carts.listData[index]),
                    );
                  },
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

class CartLoading extends ConsumerWidget {
  const CartLoading({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
        body: ListView.builder(
      itemCount: 4,
      itemBuilder: (context, index) {
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 10),
          child: Padding(
            padding: defaultPaddingAll,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                KShimmer.card(height: 100, width: 100),
                const SizedBox(width: 10),
                Flexible(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      FractionallySizedBox(
                        widthFactor: .9,
                        child: KShimmer.card(height: 25),
                      ),
                      const SizedBox(height: 10),
                      FractionallySizedBox(
                        widthFactor: .7,
                        child: KShimmer.card(height: 25),
                      ),
                      const SizedBox(height: 10),
                      FractionallySizedBox(
                        widthFactor: .6,
                        child: KShimmer.card(height: 25),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    ));
  }
}
