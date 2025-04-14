import 'package:e_com/main.export.dart';
import 'package:flutter/material.dart';

class SelectableCheckCard extends StatelessWidget {
  const SelectableCheckCard({
    super.key,
    this.onTap,
    required this.isSelected,
    this.header,
    required this.title,
    this.subTitle,
  });

  final Function()? onTap;
  final bool isSelected;
  final Widget? header;
  final Widget? title;
  final Widget? subTitle;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Stack(
        children: [
          Container(
            alignment: Alignment.center,
            decoration: BoxDecoration(
              borderRadius: defaultRadius,
              color: context.colors.secondaryContainer.withOpacity(.05),
              border: isSelected
                  ? Border.all(
                      color: context.colors.secondaryContainer,
                      width: 1,
                    )
                  : null,
            ),
            child: Wrap(
              children: [
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    if (header != null) header!,
                    const SizedBox(height: 10),
                    if (title != null) title!,
                    const SizedBox(height: 5),
                    if (subTitle != null) subTitle!,
                  ],
                ),
              ],
            ),
          ),
          if (isSelected)
            Positioned(
              top: 5,
              right: 15,
              child: CircleAvatar(
                radius: 12,
                child: Icon(
                  Icons.done,
                  size: 15,
                  color: context.colors.onError,
                ),
              ),
            ),
        ],
      ),
    );
  }
}
