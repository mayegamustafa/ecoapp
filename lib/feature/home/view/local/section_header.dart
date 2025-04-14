import 'package:e_com/_core/_core.dart';
import 'package:flutter/material.dart';

class SectionHeader extends StatelessWidget {
  const SectionHeader({
    super.key,
    required this.title,
    required this.onTrailingTap,
    this.trailing,
  });

  final String title;
  final String? trailing;
  final Function()? onTrailingTap;
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Flexible(
          child: Text(
            title,
            style: context.textTheme.titleLarge,
          ),
        ),
        TextButton(
          onPressed: onTrailingTap,
          child: Text(
            trailing ?? context.tr.all,
            style: TextStyle(
              decorationColor: context.colors.primary,
            ),
          ),
        ),
      ],
    );
  }
}
