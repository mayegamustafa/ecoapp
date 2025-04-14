import 'package:e_com/_core/_core.dart';
import 'package:e_com/feature/orders/view/pay_now_bottom_sheet_view.dart';
import 'package:e_com/models/order/order_model.dart';
import 'package:e_com/routes/routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class OrderTile extends ConsumerWidget {
  const OrderTile({super.key, required this.order});

  final OrderModel order;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tr = context.tr;
    final borderColor =
        context.colors.secondary.withOpacity(context.isDark ? 0.8 : 0.2);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      child: InkWell(
        onTap: () {
          RouteNames.orderDetails
              .pushNamed(context, query: {'id': order.orderId});
        },
        child: Container(
          decoration: BoxDecoration(
            borderRadius: defaultRadius,
            border: Border.all(color: borderColor),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 10),
              Row(
                children: [
                  Text(
                    '${tr.order_id} ${order.orderId}',
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
                    ('${tr.order_placement}: '),
                    style: context.textTheme.titleMedium!.copyWith(
                      color: context.colors.onSurface.withOpacity(0.5),
                    ),
                  ),
                  Text(
                    order.orderDate.formatDate(context, 'dd MMM yyyy'),
                    style: context.textTheme.titleMedium!.copyWith(
                      color: context.colors.onSurface.withOpacity(0.5),
                    ),
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    order.status.title,
                    style: context.textTheme.titleMedium!.copyWith(
                      color: context.colors.onSurface.withOpacity(0.5),
                    ),
                  ),
                  Text(
                    order.paymentStatus,
                    style: context.textTheme.titleMedium!.copyWith(
                      color: order.isPaid
                          ? context.colors.errorContainer
                          : context.colors.error,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Row(
                children: [
                  Text(
                    ('${tr.total}: '),
                    style: context.textTheme.titleLarge,
                  ),
                  Text(
                    order.amount.formate(),
                    style: context.textTheme.titleLarge,
                  ),
                  const Spacer(),
                  if (!order.isPaid)
                    if (!order.isCOD)
                      Align(
                        alignment: Alignment.bottomRight,
                        child: FilledButton(
                          style: FilledButton.styleFrom(
                              shape: const StadiumBorder()),
                          onPressed: () {
                            showModalBottomSheet(
                              context: context,
                              scrollControlDisabledMaxHeightRatio: 0.9,
                              builder: (ctx) => PayNowBottomSheetView(order),
                            );
                          },
                          child: Text(tr.pay_now),
                        ),
                      )
                    else
                      Text(
                        order.paymentType ?? 'N/A',
                        style: context.textTheme.titleMedium,
                      ),
                ],
              ),
              const SizedBox(height: 10),
            ],
          ),
        ),
      ),
    );
  }
}
