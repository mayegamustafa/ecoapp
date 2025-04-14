import 'package:e_com/_core/_core.dart';
import 'package:flutter/material.dart';

extension TextEx on Text {
  Widget removeIfEmpty() {
    if (data != null && data!.isNotEmpty) return this;
    return const SizedBox.shrink();
  }

  Widget flexible([flex = 1]) => Flexible(flex: flex, child: this);

  Widget markAsRequired([bool isRequired = true]) {
    return Builder(
      builder: (context) {
        return Text.rich(
          TextSpan(
            children: [
              TextSpan(
                text: data,
                style: style,
              ),
              if (isRequired)
                TextSpan(
                  text: '*',
                  style: style?.copyWith(
                    color: context.colors.error,
                  ),
                ),
            ],
          ),
        );
      },
    );
  }
}
