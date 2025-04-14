import 'package:e_com/feature/auth/controller/auth_ctrl.dart';
import 'package:e_com/main.export.dart';
import 'package:flutter/material.dart';

class CheckoutProductCard extends ConsumerWidget {
  const CheckoutProductCard({
    required this.cart,
    required this.canShowPoint,
    super.key,
  });
  final CartData cart;
  final bool canShowPoint;
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isLoggedIn = ref.read(authCtrlProvider);

    final tr = context.tr;

    return Container(
      decoration: BoxDecoration(
        borderRadius: defaultRadius,
        color: context.colors.surface,
      ),
      padding: defaultPaddingAll,
      child: Row(
        children: [
          ClipRRect(
            child: HostedImage.square(
              cart.product.featuredImage,
              dimension: 80,
            ),
          ),
          const SizedBox(width: 10),
          Flexible(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  cart.product.name,
                  style: context.textTheme.bodyLarge!
                      .copyWith(fontWeight: FontWeight.bold),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                Text.rich(
                  TextSpan(
                    children: [
                      if (isLoggedIn)
                        TextSpan(
                          text: cart.price.formate(),
                        )
                      else
                        TextSpan(
                          text: cart.baseDiscount.formate(rateCheck: true),
                        ),
                      TextSpan(
                        text: ' x ${cart.quantity}',
                      ),
                      TextSpan(
                        text: ' (${cart.variant})',
                      ),
                    ],
                    style: context.textTheme.bodyLarge!
                        .copyWith(color: context.colors.outlineVariant),
                  ),
                  maxLines: 2,
                ),
                Row(
                  children: [
                    Text(
                      '${tr.total}: ${cart.total.formate()}',
                      style: context.textTheme.bodyLarge!,
                    ),
                    if (canShowPoint) ...[
                      Container(
                        color: context.colors.primary,
                        margin: Insets.padH,
                        height: 10,
                        width: 1,
                      ),
                      Text(
                        '${tr.point}: ${cart.product.clubPoint}',
                        style: context.textTheme.bodyLarge!,
                      ),
                    ]
                  ],
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
