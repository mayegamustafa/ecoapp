import 'package:e_com/_core/_core.dart';
import 'package:e_com/feature/auth/controller/auth_ctrl.dart';
import 'package:e_com/feature/payment/controller/payment_ctrl.dart';
import 'package:e_com/models/base/order_base.dart';
import 'package:e_com/routes/routes.dart';
import 'package:e_com/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:lottie/lottie.dart';

class OrderPlacedPage extends ConsumerWidget {
  const OrderPlacedPage(this.order, {super.key});

  final OrderBaseModel order;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final from = context.query('from');

    final isFromPayNow = from == 'payNow';
    final tr = context.tr;
    return Scaffold(
      appBar: KAppBar(title: Text(tr.complete_payment)),
      body: SingleChildScrollView(
        physics: defaultScrollPhysics,
        padding: defaultPadding,
        child: Column(
          children: [
            Assets.lottie.readyForPayment.lottie(
              delegates: LottieDelegates(
                values: [
                  ValueDelegate.color(
                    ['**', 'Group 2', '**'],
                    value: context.colors.errorContainer,
                  ),
                  ValueDelegate.color(
                    ['**', 'plane Outlines', '**'],
                    value: context.colors.errorContainer,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 30),
            Text(
              isFromPayNow ? tr.ready_for_payment : tr.order_successful,
              style: context.textTheme.titleLarge,
            ),
            const SizedBox(height: 10),
            Text(
              isFromPayNow
                  ? tr.your_order_ready_for_payment
                  : tr.your_order_placement_was_successful,
              textAlign: TextAlign.center,
              style: context.textTheme.titleMedium,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  '${tr.order_id}: ',
                  style: context.textTheme.titleMedium,
                ),
                Text(
                  order.order.orderId,
                  style: context.textTheme.titleMedium?.copyWith(
                    color: context.colors.primary,
                  ),
                ),
                IconButton(
                  onPressed: () => Clipboard.setData(
                      ClipboardData(text: order.order.orderId)),
                  icon: const Icon(Icons.copy, size: 16),
                ),
              ],
            ),
            if (!ref.watch(authCtrlProvider))
              Container(
                padding: const EdgeInsets.all(10),
                alignment: Alignment.center,
                width: context.width,
                decoration: BoxDecoration(
                  borderRadius: defaultRadius,
                  border: Border.all(color: context.colors.error),
                  color: context.colors.error.withOpacity(.1),
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.warning_amber_rounded,
                      color: context.colors.error,
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        tr.not_logged_in_order_warn,
                        style: context.textTheme.titleMedium?.copyWith(
                          color: context.colors.error,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            const SizedBox(height: 20),
            if (!order.paymentLog.method.isCOD) ...[
              SpacedText(
                left: tr.total,
                right: order.paymentLog.amount,
                style: context.textTheme.titleMedium,
              ),
              SpacedText(
                left: tr.charge,
                right: order.paymentLog.charge,
                style: context.textTheme.titleMedium,
              ),
              SpacedText(
                left: tr.payable,
                right: order.paymentLog.payable,
                style: context.textTheme.titleMedium,
              ),
              const Divider(),
              SpacedText(
                left: 'In ${order.paymentLog.method.currency.name}',
                right: order.paymentLog.finalAmount
                    .currency(order.paymentLog.method.currency),
                style: context.textTheme.titleLarge,
              ),
            ],

            //! pay button
            if (!order.paymentLog.method.isCOD) ...[
              const SizedBox(height: 50),
              SubmitLoadButton(
                style: FilledButton.styleFrom(
                  fixedSize: Size(context.width, 50),
                ),
                onPressed: (l) async {
                  l.value = true;
                  final ctrl = ref.read(paymentCtrlProvider.notifier);
                  await ctrl.initializePayment(
                    context,
                    order.paymentLog,
                    order: order.order,
                  );

                  l.value = false;
                },
                child: Text(
                  '${tr.pay_now} - ${order.paymentLog.method.name}',
                ),
              ),
            ],
            const SizedBox(height: 20),
            FilledButton(
              style: OutlinedButton.styleFrom(
                fixedSize: Size(context.width, 50),
                backgroundColor: context.colors.secondary.withOpacity(.05),
                foregroundColor: context.colors.secondary,
                side:
                    BorderSide(color: context.colors.secondary.withOpacity(.4)),
              ),
              onPressed: () {
                RouteNames.trackOrder.goNamed(
                  context,
                  query: {'id': order.order.orderId},
                );
              },
              child: Text(tr.track_now),
            ),
            const SizedBox(height: 10),
            OutlinedButton(
              style: OutlinedButton.styleFrom(
                fixedSize: Size(context.width, 50),
                backgroundColor: context.colors.secondary.withOpacity(.05),
                foregroundColor: context.colors.secondary,
                side:
                    BorderSide(color: context.colors.secondary.withOpacity(.4)),
              ),
              onPressed: () => RouteNames.home.goNamed(context),
              child: Text(tr.Back_to_home),
            ),
            const SizedBox(height: 150)
          ],
        ),
      ),
    );
  }
}
