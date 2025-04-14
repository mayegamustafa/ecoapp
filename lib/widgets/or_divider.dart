import 'package:e_com/_core/_core.dart';
import 'package:flutter/material.dart';

class OrDivider extends StatelessWidget {
  const OrDivider({
    super.key,
    this.text = 'or',
    this.thickness = 1,
    this.height = 20,
  });

  final String text;
  final double thickness;
  final double height;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: height),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Expanded(
            child: Container(
              height: thickness,
              color: context.colors.outline,
              margin: const EdgeInsets.symmetric(horizontal: 20),
            ),
          ),
          Text(context.tr.or),
          Expanded(
            child: Container(
              height: thickness,
              color: context.colors.outline,
              margin: const EdgeInsets.symmetric(horizontal: 20),
            ),
          )
        ],
      ),
    );
  }
}
