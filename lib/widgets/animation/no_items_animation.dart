import 'package:e_com/_core/_core.dart';
import 'package:flutter/material.dart';

class NoItemsAnimation extends StatelessWidget {
  const NoItemsAnimation({super.key, this.hight = 250, this.style, this.title});
  final double? hight;
  final TextStyle? style;
  final String? title;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Assets.lottie.noProduct.lottie(
          height: hight,
        ),
        Text(
          context.tr.no_item_found,
          style: style ?? context.textTheme.titleLarge,
        )
      ],
    );
  }
}

class NoItemsAnimationWithFooter extends StatelessWidget {
  const NoItemsAnimationWithFooter({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        SizedBox(height: context.height / 6),
        Assets.lottie.noProduct.lottie(
          height: 250,
        ),
        Text(
          context.tr.no_item_found,
          style: context.textTheme.titleLarge,
        )
      ],
    );
  }
}
