import 'package:e_com/_core/_core.dart';
import 'package:e_com/models/models.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_html/flutter_html.dart';

class ShippingTabView extends HookWidget {
  const ShippingTabView({
    super.key,
    required this.product,
  });

  final ProductsData product;

  @override
  Widget build(BuildContext context) {
    final selectedShipping = useState<ShippingData?>(null);
    return Container(
      color: context.colors.secondaryContainer.withOpacity(0.01),
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 20,
          vertical: 20,
        ),
        child: SingleChildScrollView(
          clipBehavior: Clip.none,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              DropdownMenu<String?>(
                leadingIcon: const Icon(Icons.local_shipping_outlined),
                hintText: context.tr.Select_shipping_method,
                width: context.width - 40,
                onSelected: (value) => selectedShipping.value = product
                    .shippingInfo
                    .firstWhere((element) => element.uid == value),
                dropdownMenuEntries: [
                  ...product.shippingInfo.map(
                    (shipping) => DropdownMenuEntry(
                      value: shipping.uid,
                      label: shipping.methodName,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              if (selectedShipping.value == null)
                Center(
                  child: Text(context.tr.No_Shipping_information_to_Show),
                )
              else
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(selectedShipping.value!.methodName),
                        const SizedBox(width: 10),
                        Text(selectedShipping.value!.priceConfigs.toString()),
                      ],
                    ),
                    const SizedBox(height: 5),
                    Text(
                      context.tr
                          .deliveryDuration(selectedShipping.value!.duration),
                    ),
                    Html(
                      data: selectedShipping.value!.description,
                      style: {
                        "*": Style(
                          color: context.colors.onSurface,
                          fontSize: FontSize(16.0),
                          fontWeight: FontWeight.w400,
                          lineHeight: const LineHeight(1.3),
                        ),
                      },
                    ),
                  ],
                ),
            ],
          ),
        ),
      ),
    );
  }
}
