import 'package:collection/collection.dart';
import 'package:e_com/feature/auth/controller/auth_ctrl.dart';
import 'package:e_com/feature/cart/controller/carts_ctrl.dart';
import 'package:e_com/feature/check_out/controller/checkout_ctrl.dart';
import 'package:e_com/feature/check_out/view/local/checkout_product_card.dart';
import 'package:e_com/feature/settings/provider/settings_provider.dart';
import 'package:e_com/feature/user_dash/provider/user_dash_provider.dart';
import 'package:e_com/main.export.dart';
import 'package:e_com/routes/routes.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class CheckoutSummeryView extends HookConsumerWidget {
  const CheckoutSummeryView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final config = ref.watch(settingsProvider.select((v) => v?.settings));

    if (config == null) return ErrorView.withScaffold('Settings not found');

    final userBalance =
        ref.watch(userDashProvider.select((value) => value?.user.balance));

    final carts = ref
        .watch(cartCtrlProvider.select((data) => data.valueOrNull?.listData));
    final checkout = ref.watch(checkoutCtrlProvider);
    final checkoutCtrl =
        useCallback(() => ref.read(checkoutCtrlProvider.notifier));
    final isLoggedIn = ref.read(authCtrlProvider);
    final isLoading = useState(false);

    //! Calculation

    final originalTotal = carts?.map((e) => e.originalTotal).sum ?? 0;
    final allTax = (carts?.map((e) => e.totalTaxes).sum ?? 0).formateSelf();
    final totalDiscount = carts?.map((e) => e.discount * e.quantity).sum ?? 0;

    num shipping() {
      final result = switch (config.shippingConfig.type) {
        ShippingType.carrierSpecific =>
          checkout.priceConfig()?.formateSelf(rateCheck: true),
        ShippingType.productCentric =>
          checkout.carts.map((e) => e.shippingFeeFormatted).sum,
        ShippingType.flat =>
          config.shippingConfig.standardFee.formateSelf(rateCheck: true),
        ShippingType.locationBased => checkout
            .billingAddress?.city?.shippingFees
            .formateSelf(rateCheck: true),
      };

      return result ?? 0;
    }

    final cartTotal = (carts?.map((e) => e.total).sum ?? 0).formateSelf();

    num total = cartTotal + shipping();

    if (!isLoggedIn) total += allTax;

    final couponCodeCtrl = useTextEditingController();

    final ifFreeShipping = config.shippingConfig.type.isCarrierSpecific &&
        (checkout.shipping?.isFreeShipping ?? false);

    bool insufficientBallance() {
      if (!checkout.isWallet) return false;

      return (userBalance ?? 0) < total;
    }

    final canShowPoint =
        config.pointSystemActive && config.pointBy.isProduct && isLoggedIn;

    num? pointEarned() {
      if (!canShowPoint) return null;

      final pointBy = config.pointBy;
      final pointConfig = config.pointConfig;

      final productPoints = carts?.map((e) => e.product.clubPoint).sum ?? 0;

      if (pointBy == PointBy.product) return productPoints;

      final orderPoints =
          pointConfig.firstWhereOrNull((x) => x.isBetween(total))?.point;

      return orderPoints ?? config.defOrderReward;
    }

    final tr = context.tr;
    return Scaffold(
      appBar: KAppBar(
        title: Text(tr.summary),
        leading: SquareButton.backButton(
          onPressed: () => context.pop(),
        ),
      ),
      bottomNavigationBar: Padding(
        padding: defaultPaddingAll,
        child: SubmitButton(
          width: context.width,
          isLoading: isLoading.value,
          onPressed: insufficientBallance()
              ? null
              : () async {
                  if (couponCodeCtrl.text.isNotEmpty) {
                    checkoutCtrl().setCoupon(couponCodeCtrl.text);
                  }
                  isLoading.value = true;

                  await checkoutCtrl().submitOrder(
                    (x, oId) => x.fold(
                      (l) => RouteNames.afterPayment.goNamed(
                        context,
                        query: {'status': 'w', 'id': l, 'orderId': oId},
                      ),
                      (r) => RouteNames.orderPlaced.goNamed(context, extra: r),
                    ),
                  );

                  isLoading.value = false;
                },
          child: Text(tr.submit_order),
        ),
      ),
      body: SingleChildScrollView(
        physics: defaultScrollPhysics,
        padding: defaultPadding.copyWith(top: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            //! shipping
            Container(
              decoration: BoxDecoration(
                borderRadius: defaultRadius,
                color: context.colors.secondaryContainer.withOpacity(0.05),
              ),
              padding: defaultPaddingAll,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(width: context.width),
                  Text(
                    tr.shipping_details,
                    style: context.textTheme.titleLarge,
                  ),
                  const SizedBox(height: 10),
                  Text(
                    checkout.billingAddress?.fullName ?? '--',
                    style: context.textTheme.titleMedium,
                  ),
                  Text(
                    checkout.billingAddress?.phone ?? '',
                    style: context.textTheme.titleMedium,
                  ).removeIfEmpty(),
                  Text(
                    checkout.billingAddress?.email ?? '',
                    style: context.textTheme.titleMedium,
                  ).removeIfEmpty(),
                  Text(
                    'Country : ${checkout.billingAddress?.country?.name ?? '--'}',
                    style: context.textTheme.bodyLarge,
                  ),
                  Text(
                    'State :${checkout.billingAddress?.state?.name ?? '--'}',
                    style: context.textTheme.bodyLarge,
                  ),
                  Text(
                    'City :${checkout.billingAddress?.city?.name ?? '--'}',
                    style: context.textTheme.bodyLarge,
                  ),
                  Text(
                    checkout.billingAddress?.address ?? '--',
                    style: context.textTheme.bodyLarge,
                  ),
                ],
              ),
            ),

            //! shipping method
            if (checkout.shipping != null)
              Container(
                decoration: BoxDecoration(
                  borderRadius: defaultRadius,
                  color: context.colors.secondaryContainer.withOpacity(0.05),
                ),
                padding: defaultPaddingAll,
                margin: const EdgeInsets.only(top: 15),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      tr.shipping_by,
                      style: context.textTheme.titleLarge,
                    ),
                    const SizedBox(height: 10),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ClipRRect(
                          borderRadius: defaultRadius,
                          child: HostedImage.square(
                            checkout.shipping?.image ?? 'N/A',
                            dimension: 50,
                          ),
                        ),
                        const SizedBox(width: 10),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              checkout.shipping?.methodName ?? 'N/A',
                              style: context.textTheme.titleMedium,
                            ),
                            Text(
                              '${tr.estimate_time}: ${checkout.shipping?.duration ?? 'N/A'} days',
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),

            const SizedBox(height: 15),

            //! payment method
            Container(
              decoration: BoxDecoration(
                borderRadius: defaultRadius,
                color: context.colors.secondaryContainer.withOpacity(0.05),
              ),
              padding: defaultPaddingAll,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    tr.payment_method,
                    style: context.textTheme.titleLarge,
                  ),
                  const SizedBox(height: 10),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (checkout.isWallet)
                        Container(
                          decoration: BoxDecoration(
                            borderRadius: defaultRadius,
                            color: context.colors.surface,
                          ),
                          height: 50,
                          width: 50,
                          padding: const EdgeInsets.all(5),
                          child: Icon(
                            Icons.wallet_rounded,
                            color: context.colors.outlineVariant,
                          ),
                        )
                      else if (checkout.payment?.isCOD ?? false)
                        Container(
                          decoration: BoxDecoration(
                            borderRadius: defaultRadius,
                            color: context.colors.surface,
                          ),
                          height: 50,
                          width: 50,
                          padding: const EdgeInsets.all(5),
                          child: Image.asset(Assets.logo.cod.path),
                        )
                      else
                        ClipRRect(
                          borderRadius: defaultRadius,
                          child: HostedImage.square(
                            checkout.payment?.image ?? '',
                            dimension: 50,
                          ),
                        ),
                      const SizedBox(width: 10),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          if (checkout.isWallet) ...[
                            Text(
                              'Wallet Payment',
                              style: context.textTheme.titleMedium,
                            ),
                            Text(
                              'Balance: ${userBalance?.formate() ?? 0}',
                              style: context.textTheme.bodyMedium?.textColor(
                                insufficientBallance()
                                    ? context.colors.error
                                    : null,
                              ),
                            ),
                          ] else ...[
                            Text(
                              checkout.payment?.name ?? 'N/A',
                              style: context.textTheme.titleMedium,
                            ),
                            Text(
                              '${tr.charge}: ${checkout.payment?.percentCharge}%',
                            ),
                          ]
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
            if (insufficientBallance())
              InkWell(
                onTap: () {
                  checkoutCtrl().updateWallet(false);
                  context.pop();
                },
                child: DecoratedContainer(
                  margin: Insets.padV,
                  padding: Insets.padAll,
                  color: context.colors.error.withOpacity(0.1),
                  borderRadius: Corners.med,
                  child: Row(
                    children: [
                      Icon(
                        Icons.error_outline_rounded,
                        color: context.colors.error,
                      ),
                      const Gap(Insets.med),
                      Text(
                        'Insufficient Balance',
                        style: context.textTheme.titleMedium
                            ?.textColor(context.colors.error),
                      ),
                      const Spacer(),
                      Icon(
                        Icons.arrow_forward_ios_rounded,
                        color: context.colors.error,
                        size: 20,
                      ),
                    ],
                  ),
                ),
              ),

            if (checkout.inputs.isNotEmpty)
              Container(
                decoration: BoxDecoration(
                  borderRadius: defaultRadius,
                  color: context.colors.secondaryContainer.withOpacity(0.05),
                ),
                padding: defaultPaddingAll,
                width: context.width,
                margin: const EdgeInsets.symmetric(vertical: 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Payment Information',
                      style: context.textTheme.titleLarge,
                    ),
                    const SizedBox(height: 10),
                    for (var MapEntry(:key, :value) in checkout.inputs.entries)
                      Text(
                        '$key : $value',
                        style: context.textTheme.titleMedium,
                      ),
                  ],
                ),
              ),

            const SizedBox(height: 15),
            //! Products
            Container(
              decoration: BoxDecoration(
                borderRadius: defaultRadius,
                color: context.colors.secondaryContainer.withOpacity(0.05),
              ),
              padding: defaultPaddingAll,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '${tr.products}: [${carts?.length}]',
                    style: context.textTheme.titleLarge,
                  ),
                  const SizedBox(height: 10),
                  if (carts == null)
                    Text(tr.something_went_wrong)
                  else
                    ListView.builder(
                      physics: const NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      itemCount: carts.length,
                      itemBuilder: (context, index) {
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 5),
                          child: CheckoutProductCard(
                            cart: carts[index],
                            canShowPoint: canShowPoint,
                          ),
                        );
                      },
                    ),
                ],
              ),
            ),
            const Divider(height: 40),

            //! Coupon
            if (isLoggedIn) ...[
              Text(
                tr.coupon_code,
                style: context.textTheme.titleLarge,
              ),
              const SizedBox(height: 10),
              TextField(
                controller: couponCodeCtrl,
                onSubmitted: (v) {
                  checkoutCtrl().setCoupon(v);
                  couponCodeCtrl.clear();
                },
                textInputAction: TextInputAction.done,
                decoration: InputDecoration(
                  prefixIcon: const Icon(Icons.discount_outlined),
                  hintText: tr.enter_coupon,
                  suffixIcon: TextButton(
                    onPressed: () {
                      checkoutCtrl().setCoupon(couponCodeCtrl.text);
                      couponCodeCtrl.clear();
                    },
                    child: Text(tr.apply),
                  ),
                ),
              ),
              if (checkout.couponCode.isNotEmpty) ...[
                const SizedBox(height: 10),
                SpacedText(
                  left: tr.your_coupon,
                  right: checkout.couponCode,
                  styleBuilder: (left, right) =>
                      (left, context.textTheme.titleMedium),
                  trailing: IconButton(
                    padding: const EdgeInsets.all(3),
                    constraints: const BoxConstraints(),
                    onPressed: () => checkoutCtrl().setCoupon(''),
                    icon: const Icon(Icons.cancel_outlined),
                  ),
                ),
                Row(
                  children: [
                    const Icon(Icons.info_outline_rounded),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(context.tr.couponWillApply),
                    ),
                  ],
                ),
              ],
              const SizedBox(height: 15),
            ],

            //! calculation
            Container(
              decoration: BoxDecoration(
                borderRadius: defaultRadius,
                color: context.colors.secondaryContainer.withOpacity(0.05),
              ),
              padding: defaultPaddingAll,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    tr.billing_info,
                    style: context.textTheme.titleLarge,
                  ),
                  const Gap(10),
                  SpacedText(
                    left: 'Subtotal',
                    right: originalTotal.formate(),
                  ),
                  const Divider(),
                  const Gap(5),
                  SpacedText(
                    left: 'All Taxes',
                    right: allTax.formate(),
                  ),
                  if (isLoggedIn)
                    SpacedText(
                      left: 'Discount',
                      right: totalDiscount.formate(),
                    ),
                  SpacedText(
                    left: tr.shipping_charge,
                    right: ifFreeShipping ? 'Free' : shipping().formate(),
                  ),
                  const Gap(5),
                ],
              ),
            ),
            const SizedBox(height: 10),
            Container(
              decoration: BoxDecoration(
                borderRadius: defaultRadius,
                color: context.colors.secondaryContainer.withOpacity(0.05),
              ),
              padding: defaultPaddingAll,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SpacedText(
                    left: tr.total,
                    right: total.formate(),
                    style: context.textTheme.titleLarge,
                  ),
                  if (canShowPoint) ...[
                    const Divider(),
                    SpacedText(
                      left: 'Point Earned',
                      right: pointEarned().toString(),
                      style: context.textTheme.titleMedium,
                    ),
                  ],
                ],
              ),
            ),

            const SizedBox(height: 10),
            if (!isLoggedIn) ...[
              Card(
                elevation: 0,
                color: context.colors.secondaryContainer.withOpacity(0.05),
                child: CheckboxListTile(
                  title: Text(tr.register_with_email),
                  controlAffinity: ListTileControlAffinity.leading,
                  value: checkout.createAccount,
                  onChanged: (v) => checkoutCtrl().toggleCreateAccount(),
                ),
              ),
              const SizedBox(height: 10),
              Row(
                children: [
                  const Icon(Icons.info_outline_rounded),
                  const SizedBox(width: 10),
                  Flexible(
                    child: Text(tr.submit_without_account_warn),
                  ),
                ],
              ),
            ],
            const SizedBox(height: 80),
          ],
        ),
      ),
    );
  }
}
