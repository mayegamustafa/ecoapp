import 'package:e_com/main.export.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

class ProductDescHeader extends ConsumerWidget {
  const ProductDescHeader({
    super.key,
    required this.product,
    required this.variantPrice,
  });

  final ProductsData product;
  final VariantPrice? variantPrice;
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final vp = variantPrice ??
        product.variantPrices.values.first.copyWith(quantity: 0);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 5),
        Row(
          children: [
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(5),
                color: context.colors.secondaryContainer.withOpacity(0.1),
              ),
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
                child: Text(
                  product.category,
                  style: context.textTheme.bodyLarge,
                ),
              ),
            ),
            const SizedBox(width: 10),
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(5),
                color: context.colors.secondaryContainer.withOpacity(0.1),
              ),
              child: Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: product.brand.isEmpty ? 0 : 12,
                  vertical: product.brand.isEmpty ? 0 : 5,
                ),
                child: Text(
                  product.brand,
                  style: context.textTheme.bodyLarge,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 10),
        Row(
          children: [
            KRatingBar(rating: product.rating.avgRating),
            Container(
              height: 20,
              width: 1,
              color: context.colors.secondaryContainer,
              margin: const EdgeInsets.symmetric(
                horizontal: 12,
              ),
            ),
            Text(
              '${product.order} ${context.tr.orders}',
            ),
          ],
        ),
        const SizedBox(height: 10),
        Row(
          children: [
            Text(
              vp.quantity > 0 ? context.tr.in_stock : context.tr.stock_out,
              style: context.textTheme.bodyLarge!.copyWith(
                color: vp.quantity > 0
                    ? context.colors.errorContainer
                    : context.colors.error,
              ),
            ),
            if (product.weight > 0) ...[
              Container(
                height: 10,
                width: 1,
                color: context.colors.secondaryContainer,
                margin: const EdgeInsets.symmetric(
                  horizontal: 12,
                ),
              ),
              Text(
                'Weight: ${product.weight}',
                style: context.textTheme.bodyLarge,
              ),
            ]
          ],
        ),
        const SizedBox(height: 5),
        HeroWidget(
          tag: HeroTags.productPriceTag(product, context.query('t')),
          child: Text.rich(
            TextSpan(
              style: context.textTheme.titleLarge!.copyWith(
                color: context.colors.primary,
              ),
              children: [
                if (vp.isDiscounted)
                  TextSpan(
                    text: vp.discount.formate(),
                  ),
                if (vp.isDiscounted) const TextSpan(text: '  '),
                TextSpan(
                  text: vp.price.formate(),
                  style: vp.isDiscounted
                      ? context.textTheme.titleMedium?.copyWith(
                          decoration: TextDecoration.lineThrough,
                        )
                      : null,
                ),
                if (product.taxes.isNotEmpty)
                  TextSpan(
                    text: '  ( TAX information)  ',
                    style: context.textTheme.labelMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                    recognizer: TapGestureRecognizer()
                      ..onTap = () => _showTaxDialog(context),
                    children: [
                      WidgetSpan(
                        child: GestureDetector(
                          onTap: () => _showTaxDialog(context),
                          child:
                              const Icon(Icons.info_outline_rounded, size: 18),
                        ),
                      ),
                    ],
                  ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Future<dynamic> _showTaxDialog(BuildContext context) {
    return showDialog(
      context: context,
      builder: (context) => TaxDialog(taxes: product.taxes),
    );
  }
}

class TaxDialog extends StatelessWidget {
  const TaxDialog({
    super.key,
    required this.taxes,
  });

  final List<Tax> taxes;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      scrollable: true,
      title: Text(context.tr.taxInformation),
      content: SizedBox(
        width: context.width * .9,
        child: SingleChildScrollView(
          child: SeparatedColumn(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            separatorBuilder: () => const Divider(),
            children: [
              for (final tax in taxes)
                SpacedText(
                  left: tax.name,
                  right: tax.amountFormatted(),
                  style: context.textTheme.bodyLarge,
                ),
            ],
          ),
        ),
      ),
    );
  }
}
