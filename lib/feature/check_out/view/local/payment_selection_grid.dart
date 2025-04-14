import 'package:e_com/feature/check_out/view/local/method_selector_card.dart';
import 'package:e_com/main.export.dart';
import 'package:flutter/material.dart';

class PaymentSelectionGrid extends ConsumerWidget {
  const PaymentSelectionGrid({
    super.key,
    required this.methods,
    required this.onChange,
    required this.selected,
  });

  final List<PaymentData> methods;

  final Function(PaymentData data) onChange;

  final PaymentData? selected;
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: context.onMobile ? 3 : 6,
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
      ),
      itemCount: methods.length,
      itemBuilder: (context, index) {
        return MethodSelectorCard(
          method: methods[index],
          isSelected: selected?.id == methods[index].id,
          onTap: (data) => onChange(data),
        );
      },
    );
  }
}
