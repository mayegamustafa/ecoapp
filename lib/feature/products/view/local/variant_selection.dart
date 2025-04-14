import 'package:e_com/_core/_core.dart';
import 'package:e_com/models/models.dart';
import 'package:flutter/material.dart';

import '../../../../widgets/widgets.dart';

class VariantSelection extends StatelessWidget {
  const VariantSelection({
    super.key,
    required this.product,
    required this.selectedVariant,
    required this.onVariantChange,
  });

  final ProductsData product;
  final Function(String variantName, String variant) onVariantChange;
  final Map<String, String> selectedVariant;

  @override
  Widget build(BuildContext context) {
    bool isSelected(String variantName, String variant) {
      return selectedVariant[variantName] != null &&
          selectedVariant[variantName] == variant;
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        for (var vName in product.variants)
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                vName.name,
                style: context.textTheme.titleLarge,
              ),
              const SizedBox(height: 10),
              Wrap(
                spacing: 10,
                children: [
                  ...vName.attributes.map(
                    (attr) => SelectableChip(
                      isSelected: isSelected(vName.name, attr.name),
                      child: Text(
                        attr.displayName,
                        style: context.textTheme.bodyLarge,
                      ),
                      onTap: () => onVariantChange(vName.name, attr.name),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
            ],
          ),
      ],
    );
  }
}
