// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:ui';

import 'package:e_com/_core/_core.dart';
import 'package:e_com/feature/cart/controller/carts_ctrl.dart';
import 'package:e_com/models/models.dart';
import 'package:e_com/routes/routes.dart';
import 'package:e_com/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class WishlistTile extends HookConsumerWidget {
  const WishlistTile({
    super.key,
    required this.product,
    required this.onDelete,
    required this.onTap,
  });

  final ProductsData product;
  final Future<void> Function()? onDelete;
  final Function()? onTap;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cartCtrl = ref.read(cartCtrlProvider.notifier);
    final borderColor =
        context.colors.secondary.withOpacity(context.isDark ? 0.8 : 0.2);
    final isLoading = useState(false);
    final tr = context.tr;
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: defaultRadius,
          border: Border.all(color: borderColor),
        ),
        child: Stack(
          children: [
            Column(
              children: [
                InkWell(
                  onTap: () => RouteNames.productDetails.pushNamed(
                    context,
                    pathParams: {'id': product.uid},
                    query: {
                      'isRegular': 'true',
                      't': 'wish',
                    },
                  ),
                  child: Padding(
                    padding: const EdgeInsets.only(top: 10),
                    child: SizedBox(
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            flex: 3,
                            child: Container(
                              margin:
                                  const EdgeInsets.symmetric(horizontal: 10),
                              height: context.onMobile ? 90 : 180,
                              decoration: BoxDecoration(
                                color: context.colors.surface,
                                borderRadius: defaultRadius,
                                image: DecorationImage(
                                  image: HostedImage.provider(
                                      product.featuredImage),
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                          ),
                          Expanded(
                            flex: 8,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  product.name,
                                  style: context.textTheme.titleMedium
                                      ?.copyWith(fontWeight: FontWeight.bold),
                                ),
                                const SizedBox(height: 5),
                                Container(
                                  decoration: BoxDecoration(
                                    borderRadius: defaultRadius,
                                    color: context.colors.secondaryContainer
                                        .withOpacity(0.1),
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 10,
                                      vertical: 5,
                                    ),
                                    child: Text(
                                      product.category,
                                      style: context.textTheme.bodyLarge,
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 10),
                                Padding(
                                  padding: const EdgeInsets.only(right: 10),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        product.availableAny
                                            ? tr.in_stock
                                            : tr.stock_out,
                                        style: context.textTheme.bodyLarge!
                                            .copyWith(
                                          color: product.availableAny
                                              ? context.colors.errorContainer
                                              : context.colors.error,
                                        ),
                                      ),
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.end,
                                        children: [
                                          if (product.isDiscounted)
                                            Text(
                                              product.price.formate(),
                                              style: product.isDiscounted
                                                  ? context
                                                      .textTheme.titleMedium
                                                      ?.copyWith(
                                                      decoration: TextDecoration
                                                          .lineThrough,
                                                      decorationColor:
                                                          context.colors.error,
                                                    )
                                                  : context
                                                      .textTheme.titleMedium,
                                            ),
                                          Text(
                                            product.discountAmount.formate(),
                                            style: context.textTheme.titleLarge,
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                )
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                Divider(color: borderColor),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      TextButton(
                        onPressed: product.availableAny
                            ? () async {
                                await showModalBottomSheet(
                                  context: context,
                                  isScrollControlled: true,
                                  showDragHandle: true,
                                  builder: (_) => VariantToCartSheet(
                                    variants: product.variantPrices,
                                    onSubmit: (att) async {
                                      await cartCtrl.addToCart(
                                        product: product,
                                        attribute: att,
                                      );

                                      if (context.mounted) context.pop();
                                    },
                                  ),
                                );
                              }
                            : null,
                        child: Text(tr.add_to_cart),
                      ),
                      GestureDetector(
                        onTap: () async {
                          isLoading.value = true;
                          await onDelete?.call();
                          isLoading.value = false;
                        },
                        child: Container(
                          height: 40,
                          width: 40,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(100),
                            color:
                                context.colors.secondaryContainer.withOpacity(
                              context.isDark ? 0.1 : 0.05,
                            ),
                          ),
                          child: Icon(
                            Icons.delete_rounded,
                            color: context.colors.error,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 5),
              ],
            ),
            if (isLoading.value)
              Positioned.fill(
                child: ClipRRect(
                  child: BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 10.0, sigmaY: 10.0),
                    child: Container(
                      decoration: BoxDecoration(
                        color: context.colors.surface.withOpacity(0.5),
                        borderRadius: defaultRadius,
                      ),
                      alignment: Alignment.center,
                      child: RepaintBoundary(
                        child: Image.asset(
                          context.isDark
                              ? Assets.logo.logoDark.path
                              : Assets.logo.logoWhite.path,
                          height: 60,
                        )
                            .animate(
                              onPlay: (c) => c.repeat(reverse: true),
                            )
                            .scaleXY(
                              end: 1,
                              begin: 0.8,
                              duration: 300.ms,
                              curve: Curves.easeInOutQuad,
                            ),
                      ),
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class VariantToCartSheet extends HookConsumerWidget {
  const VariantToCartSheet({
    super.key,
    required this.variants,
    required this.onSubmit,
  });

  final Map<String, VariantPrice> variants;
  final Future<void> Function(String attribute)? onSubmit;
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tr = context.tr;
    final attribute = useState<String?>(null);
    final loading = useState(false);
    return SizedBox(
      height: context.height * 0.5,
      child: Scaffold(
        bottomNavigationBar: Padding(
          padding: const EdgeInsets.all(10),
          child: SubmitButton(
            onPressed: attribute.value == null
                ? null
                : () async {
                    loading.value = true;
                    await onSubmit?.call(attribute.value!);
                    loading.value = false;
                  },
            child: loading.value
                ? SizedBox.square(
                    dimension: 20,
                    child: CircularProgressIndicator(
                      color: context.colors.onPrimary,
                    ),
                  )
                : Text(tr.add_to_cart),
          ),
        ),
        body: Padding(
          padding: defaultPadding,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                tr.attributes,
                style: context.textTheme.titleMedium,
              ),
              const SizedBox(height: 10),
              Expanded(
                child: ListView.builder(
                  physics: defaultScrollPhysics,
                  itemCount: variants.length,
                  itemBuilder: (context, index) {
                    final variant = variants.entries.toList()[index];
                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 5),
                      child: RadioListTile<String>(
                        tileColor: context.colors.secondary.withOpacity(0.05),
                        value: variant.key,
                        title: Text(
                          variant.key,
                          style: context.textTheme.titleMedium,
                          overflow: TextOverflow.ellipsis,
                        ),
                        subtitle: Text(
                          variant.value.quantity > 0
                              ? tr.in_stock
                              : tr.stock_out,
                          style: context.textTheme.bodyLarge!.copyWith(
                            color: variant.value.quantity > 0
                                ? context.colors.errorContainer
                                : context.colors.error,
                          ),
                        ),
                        secondary: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              variant.value.price.formate(),
                              style: variant.value.isDiscounted
                                  ? context.textTheme.bodyMedium?.copyWith(
                                      decoration: TextDecoration.lineThrough,
                                      decorationColor: context.colors.error,
                                      fontWeight: FontWeight.w200,
                                    )
                                  : context.textTheme.titleLarge,
                            ),
                            const SizedBox(width: 10),
                            if (variant.value.isDiscounted)
                              Text(
                                variant.value.discount.formate(),
                                style: context.textTheme.titleMedium,
                              ),
                          ],
                        ),
                        groupValue: attribute.value,
                        onChanged: variant.value.quantity > 0
                            ? (v) => attribute.value = v
                            : null,
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
