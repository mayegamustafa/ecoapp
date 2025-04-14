import 'package:e_com/main.export.dart';
import 'package:e_com/routes/go_route_name.dart';
import 'package:flutter/material.dart';

class OrderPackagesSection extends StatelessWidget {
  const OrderPackagesSection({
    super.key,
    required this.index,
    required this.order,
  });

  final int index;

  final OrderModel order;

  @override
  Widget build(BuildContext context) {
    final borderColor =
        context.colors.secondary.withOpacity(context.isDark ? 0.8 : 0.2);
    final padding = Insets.padSym(10, 20);

    final orderDetail = order.orderDetails[index];
    final price = orderDetail.isRegular
        ? orderDetail.product!.price
        : orderDetail.digitalProduct!.price;

    final shop =
        orderDetail.product?.store ?? orderDetail.digitalProduct?.store;

    return Container(
      decoration: BoxDecoration(
        borderRadius: defaultRadius,
        border: Border.all(color: borderColor),
      ),
      margin: const EdgeInsets.symmetric(vertical: 4),
      padding: padding,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.local_shipping_outlined),
              const SizedBox(width: 10),
              Text(
                '${context.tr.package} [${index + 1}]',
              ),
              const Spacer(),
              Text(
                order.status.name,
                style: context.textTheme.titleLarge!.copyWith(
                  color: context.colors.errorContainer,
                ),
              ),
            ],
          ),
          ListTile(
            contentPadding: EdgeInsets.zero,
            leading: ClipRRect(
              borderRadius: BorderRadius.circular(5),
              child: HostedImage(
                orderDetail.isRegular
                    ? orderDetail.product!.featuredImage
                    : orderDetail.digitalProduct!.featuredImage,
                height: 60,
                width: 60,
              ),
            ),
            isThreeLine: true,
            trailing: shop == null
                ? null
                : InkWell(
                    onTap: () {
                      RouteNames.sellerChatDetails.pushNamed(
                        context,
                        pathParams: {
                          'id': '${shop.storeId}',
                        },
                      );
                    },
                    child: Assets.logo.chat.image(height: 30),
                  ),
            title: Text(
              orderDetail.isRegular
                  ? orderDetail.product!.name
                  : order.orderDetails[index].digitalProduct!.name,
              style: context.textTheme.titleMedium,
            ),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text.rich(
                  TextSpan(
                    children: [
                      TextSpan(
                        text: price.formate(),
                      ),
                      TextSpan(
                        text: ' x ${orderDetail.quantity}',
                      ),
                      TextSpan(
                        text: ' (${orderDetail.attribute})',
                      ),
                    ],
                    style: context.textTheme.bodyLarge!.copyWith(
                      color: context.colors.outlineVariant,
                    ),
                  ),
                ),
                Row(
                  children: [
                    Text(
                      '${context.tr.original}: ${orderDetail.originalTotalPrice.formate()}',
                      style: context.textTheme.bodyLarge!,
                    ),
                    DecoratedContainer(
                      height: 10,
                      width: 1,
                      color: context.colors.primary,
                      margin: const EdgeInsets.symmetric(
                        horizontal: 10,
                      ),
                    ),
                    Text(
                      '${context.tr.tax}: ${orderDetail.totalTax.formate()}',
                      style: context.textTheme.bodyLarge!,
                    ),
                  ],
                ),
                Text(
                  '${context.tr.total}: ${orderDetail.totalPrice.formate()}',
                  style: context.textTheme.bodyLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          if (order.status.name == 'delivered')
            if (orderDetail.isRegular) ...[
              const SizedBox(height: 20),
              Align(
                alignment: Alignment.bottomRight,
                child: FilledButton(
                  onPressed: () {
                    RouteNames.productDetails.pushNamed(
                      context,
                      pathParams: {
                        'id': order.orderDetails[index].product!.uid,
                      },
                      query: {
                        'isRegular': orderDetail.isRegular ? 'true' : 'false',
                        'toReview': 'true',
                      },
                    );
                  },
                  child: Text(context.tr.write_a_review),
                ),
              ),
              const SizedBox(height: 20),
            ],
        ],
      ),
    );
  }
}
