import 'package:e_com/feature/orders/controller/order_tracking_ctrl.dart';
import 'package:e_com/feature/orders/view/local/deliveryman_review_dialog.dart';
import 'package:e_com/feature/orders/view/local/order_loader.dart';
import 'package:e_com/feature/orders/view/local/order_packages_section.dart';
import 'package:e_com/feature/orders/view/pay_now_bottom_sheet_view.dart';
import 'package:e_com/feature/settings/provider/settings_provider.dart';
import 'package:e_com/feature/user_dash/provider/user_dash_provider.dart';
import 'package:e_com/main.export.dart';
import 'package:e_com/routes/go_route_name.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';

class OrderDetailsView extends ConsumerWidget {
  const OrderDetailsView({super.key, this.orderId});

  final String? orderId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(userDashProvider.select((v) => v?.user.uid));
    final orderData = ref.watch(orderDetailsProvider(orderId));
    final config = ref.watch(settingsProvider.select((s) => s?.settings));

    final borderColor =
        context.colors.secondary.withOpacity(context.isDark ? 0.8 : 0.2);
    final padding = Insets.padSym(10, 20);
    final fromTracking = context.query('from') == 'tracking';
    final tr = context.tr;

    return Scaffold(
      appBar: KAppBar(
        title: Text(tr.order_details),
        leading: SquareButton.backButton(
          onPressed: () => context.pop(),
        ),
      ),
      body: orderData.when(
        error: (e, s) => ErrorView(e, s, invalidate: orderDetailsProvider),
        loading: () => const OrderLoader(),
        data: (order) {
          final billing = order.billingAddress;
          bool isAlreadyRated() => order.isAlreadyRated(user ?? '');

          return RefreshIndicator(
            onRefresh: () async {
              return ref.refresh(orderDetailsProvider(orderId));
            },
            child: SingleChildScrollView(
              padding: defaultPadding.copyWith(top: 20),
              physics: defaultScrollPhysics,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  //!Ship & Bill Section---------------------------------------------
                  if (billing != null)
                    SelectionArea(
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: defaultRadius,
                          border: Border.all(color: borderColor),
                        ),
                        width: double.infinity,
                        margin: const EdgeInsets.symmetric(vertical: 4),
                        padding: padding,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              tr.ship_n_bill,
                              style: context.textTheme.bodyLarge!.copyWith(
                                color:
                                    context.colors.onSurface.withOpacity(0.8),
                              ),
                            ),
                            if (!billing.isNamesEmpty)
                              Text(
                                billing.fullName,
                                style: context.textTheme.titleMedium,
                              ),
                            if (billing.phone != null)
                              Text(
                                '${tr.phone} : ${billing.phone}',
                                style: context.textTheme.titleMedium,
                              ),
                            if (billing.email.isNotEmpty)
                              Text(
                                '${tr.email} : ${billing.email}',
                                style: context.textTheme.titleMedium,
                              ),
                            if (billing.city.isNotEmpty)
                              Text(
                                '${tr.city} : ${billing.city}',
                                style: context.textTheme.bodyLarge,
                              ),
                            if (billing.state.isNotEmpty)
                              Text(
                                '${tr.state} : ${billing.state}',
                                style: context.textTheme.bodyLarge,
                              ),
                            if (billing.country.isNotEmpty)
                              Text(
                                '${tr.country} : ${billing.country}',
                                style: context.textTheme.bodyLarge,
                              ),
                            if (billing.address.isNotEmpty)
                              Text(
                                '${tr.streetName} : ${billing.address}',
                                style: context.textTheme.titleMedium,
                              ),
                          ],
                        ),
                      ),
                    ),

                  //! Custom info Section ---------------------------------------------
                  if (order.customInfo.isNotEmpty)
                    SelectionArea(
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: defaultRadius,
                          border: Border.all(color: borderColor),
                        ),
                        width: double.infinity,
                        margin: const EdgeInsets.symmetric(vertical: 4),
                        padding: padding,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              tr.customInformation,
                              style: context.textTheme.bodyLarge!.copyWith(
                                color:
                                    context.colors.onSurface.withOpacity(0.8),
                              ),
                            ),
                            ...order.customInfo.entries.map((e) {
                              var MapEntry(:key, :value) = e;
                              if (value is List) value = value.join(', ');
                              if (value == null) return const SizedBox.shrink();
                              return Text('$key : $value');
                            }),
                          ],
                        ),
                      ),
                    ),

                  //! Payment Section ---------------------------------------------
                  if (order.paymentDetails.isNotEmpty)
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: defaultRadius,
                        border: Border.all(color: borderColor),
                      ),
                      width: double.infinity,
                      padding: padding,
                      margin: const EdgeInsets.symmetric(vertical: 4),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            tr.paymentInformation,
                            style: context.textTheme.bodyLarge!.copyWith(
                              color: context.colors.onSurface.withOpacity(0.8),
                            ),
                          ),
                          for (var MapEntry(:key, :value)
                              in order.paymentDetails.entries)
                            Text(
                              '$key : $value',
                              style: context.textTheme.titleMedium,
                            ),
                        ],
                      ),
                    ),

                  //! Product Package Section ---------------------------------------------
                  ...List.generate(
                    order.orderDetails.length,
                    (i) => OrderPackagesSection(index: i, order: order),
                  ),

                  //! Digital Attributes Section ---------------------------------------------
                  if (order.digitalAttributes.isNotEmpty) ...[
                    const Gap(Insets.med),
                    SelectionArea(
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: defaultRadius,
                          border: Border.all(color: borderColor),
                        ),
                        width: double.infinity,
                        padding: padding,
                        margin: const EdgeInsets.symmetric(vertical: 4),
                        child: SeparatedColumn(
                          separatorBuilder: () => const Divider(),
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              tr.attributes,
                              style: context.textTheme.bodyLarge,
                            ),
                            for (var attr in order.digitalAttributes)
                              ListTile(
                                contentPadding: EdgeInsets.zero,
                                dense: true,
                                title: Text(attr.name),
                                subtitle: Text(attr.value),
                                trailing: attr.file == null
                                    ? null
                                    : DownloadButton(url: attr.file!),
                              ),
                          ],
                        ),
                      ),
                    ),
                  ],

                  //! Delivery Man Section ---------------------------------------------
                  if (order.deliveryMan != null && order.deliveryStatusPending)
                    if (config?.deliveryManEnabled ?? false)
                      Container(
                        decoration: BoxDecoration(
                          borderRadius: defaultRadius,
                          color: context.colors.secondary.withOpacity(0.07),
                        ),
                        padding: defaultPaddingAll,
                        margin: Insets.padOnly(top: Insets.med),
                        child: Column(
                          children: [
                            Row(
                              children: [
                                CircleAvatar(
                                  backgroundImage: HostedImage.provider(
                                    order.deliveryMan!.image,
                                  ),
                                ),
                                const Gap(Insets.med),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(order.deliveryMan!.firstName),
                                    Text(order.deliveryMan!.phone),
                                  ],
                                ),
                              ],
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                GestureDetector(
                                  onTap: () => URLHelper.call(
                                    order.deliveryMan!.phone,
                                  ),
                                  child: CircleAvatar(
                                    backgroundColor: context.colors.secondary
                                        .withOpacity(0.1),
                                    child:
                                        Assets.logo.phoneCall.image(height: 25),
                                  ),
                                ),
                                if (config?.deliveryChatEnabled ?? false) ...[
                                  const Gap(Insets.med),
                                  GestureDetector(
                                    onTap: () => RouteNames.deliveryChatDetails
                                        .pushNamed(context, pathParams: {
                                      'id': order.deliveryMan!.id.toString(),
                                    }),
                                    child: CircleAvatar(
                                      backgroundColor: context.colors.secondary
                                          .withOpacity(0.1),
                                      child: Image.asset(
                                        Assets.logo.chat.path,
                                        height: 25,
                                      ),
                                    ),
                                  ),
                                ],
                                const Gap(Insets.med),
                                if (!isAlreadyRated())
                                  FilledButton(
                                    onPressed: () => showDialog(
                                      context: context,
                                      builder: (context) =>
                                          DeliverymanReviewDialog(
                                        id: order.orderId,
                                      ),
                                    ),
                                    child: const Text('Review'),
                                  ),
                              ],
                            )
                          ],
                        ),
                      ),

                  const Gap(Insets.med),
                  if (!fromTracking)
                    Align(
                      alignment: Alignment.centerRight,
                      child: FilledButton(
                        style: ButtonStyle(
                          backgroundColor: WidgetStateProperty.all(
                            context.colors.primary.withOpacity(.05),
                          ),
                        ),
                        onPressed: () {
                          RouteNames.trackOrder.pushNamed(
                            context,
                            query: {'id': order.orderId},
                          );
                        },
                        child: Text(
                          tr.track_order,
                          style: TextStyle(color: context.colors.primary),
                        ),
                      ),
                    ),
                  const Gap(Insets.med),
                  //! Order id----------------------------------------------
                  Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      borderRadius: defaultRadius,
                      border: Border.all(
                        color: borderColor,
                      ),
                    ),
                    padding: padding,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              '${tr.order_id}: ${order.orderId}',
                              style: context.textTheme.titleLarge!
                                  .copyWith(color: context.colors.primary),
                            ),
                            IconButton(
                              onPressed: () {
                                Clipboard.setData(
                                  ClipboardData(text: order.orderId),
                                );
                              },
                              icon: const Icon(Icons.copy),
                            )
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              '${tr.order_placement}: ',
                              style: context.textTheme.titleMedium!.copyWith(
                                color:
                                    context.colors.onSurface.withOpacity(0.8),
                              ),
                            ),
                            Text(
                              order.orderDate
                                  .formatDate(context, 'dd MMM yyyy'),
                              style: context.textTheme.titleMedium!.copyWith(
                                color:
                                    context.colors.onSurface.withOpacity(0.8),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 10),

                  //! Payment Details----------------------------------------------
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: defaultRadius,
                      border: Border.all(
                        color: borderColor,
                      ),
                    ),
                    padding: padding,
                    child: Column(
                      children: [
                        if (order.isWalletPayment)
                          SpacedText(
                            style: context.textTheme.titleMedium,
                            left: tr.payment_method,
                            right: tr.paymentViaWallet,
                          )
                        else
                          SpacedText(
                            style: context.textTheme.titleMedium,
                            left: tr.payment_method,
                            right: order.paymentType ?? 'N/A',
                          ),
                        const SizedBox(height: 10),
                        SpacedText(
                          style: context.textTheme.titleMedium,
                          styleBuilder: (left, right) => (
                            left,
                            right?.textColor(
                              order.paymentStatus == 'Paid'
                                  ? context.colors.errorContainer
                                  : null,
                            )
                          ),
                          left: tr.payment_status,
                          right: order.paymentStatus,
                        ),
                        const Divider(height: 10),
                        SpacedText(
                          style: context.textTheme.titleMedium,
                          left: tr.originalAmount,
                          right: order.originalAmount.formate(),
                        ),
                        const SizedBox(height: 10),
                        SpacedText(
                          style: context.textTheme.titleMedium,
                          left: tr.taxAmount,
                          right: order.totalTax.formate(),
                        ),
                        const SizedBox(height: 10),
                        SpacedText(
                          style: context.textTheme.titleMedium,
                          left: tr.shippingCost,
                          right: order.shippingCharge.formate(),
                        ),
                        const SizedBox(height: 10),
                        SpacedText(
                          style: context.textTheme.titleMedium,
                          left: tr.discount,
                          right: order.discount.formate(),
                        ),
                        const SizedBox(height: 10),
                        SpacedText(
                          style: context.textTheme.titleMedium,
                          left: tr.total,
                          right: order.amount.formate(),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 10),
                  if (!order.isPaid && !order.isCOD)
                    Center(
                      child: FilledButton(
                        style: FilledButton.styleFrom(
                          shape: const StadiumBorder(),
                        ),
                        onPressed: () {
                          showModalBottomSheet(
                            context: context,
                            scrollControlDisabledMaxHeightRatio: 0.9,
                            builder: (ctx) => PayNowBottomSheetView(order),
                          );
                        },
                        child: Text(tr.pay_now),
                      ),
                    ),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
