import 'package:e_com/main.export.dart';
import 'package:flutter/material.dart';

class MethodSelectorCard extends StatelessWidget {
  const MethodSelectorCard({
    super.key,
    required this.method,
    required this.isSelected,
    required this.onTap,
  });

  final PaymentData method;
  final bool isSelected;
  final Function(PaymentData data) onTap;

  @override
  Widget build(BuildContext context) {
    return SelectableCheckCard(
      header: ClipRRect(
        borderRadius: defaultRadius,
        child: method.isCOD
            ? Container(
                margin: const EdgeInsets.only(top: 5),
                decoration: BoxDecoration(
                  borderRadius: defaultRadius,
                  color: context.colors.onErrorContainer,
                ),
                height: 60,
                width: 60,
                child: Padding(
                  padding: const EdgeInsets.all(5),
                  child: Image.asset(
                    Assets.logo.cod.path,
                  ),
                ),
              )
            : HostedImage.square(method.image, dimension: 60),
      ),
      title: Text(
        method.name,
        overflow: TextOverflow.ellipsis,
        textAlign: TextAlign.center,
      ),
      isSelected: isSelected,
      onTap: () => onTap(method),
    );
  }
}
