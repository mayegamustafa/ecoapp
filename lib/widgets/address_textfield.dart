import 'package:e_com/_core/_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:gap/gap.dart';

class KTextField extends StatelessWidget {
  const KTextField({
    super.key,
    required this.hinText,
    required this.title,
    required this.name,
    this.controller,
    this.keyboardType,
    this.textInputAction,
    this.validator,
    this.onSubmitted,
    this.onChanged,
    this.initialValue,
    this.autofillHints = const [],
    this.suffix,
  }) : assert(initialValue == null || controller == null);

  final String hinText;
  final String title;
  final String name;
  final TextEditingController? controller;
  final String? initialValue;
  final TextInputType? keyboardType;
  final TextInputAction? textInputAction;
  final String? Function(String?)? validator;
  final void Function(String? value)? onSubmitted;
  final void Function(String? value)? onChanged;
  final Iterable<String>? autofillHints;
  final Widget? suffix;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Flexible(
          child: FormBuilderTextField(
            name: name,
            onChanged: onChanged,
            validator: validator,
            initialValue: initialValue,
            autofillHints: autofillHints,
            onSubmitted: onSubmitted,
            textInputAction: textInputAction,
            controller: controller,
            keyboardType: keyboardType,
            decoration: InputDecoration(
              hintText: hinText,
            ),
          ),
        ),
        if (suffix != null) ...[const Gap(Insets.sm), suffix!],
      ],
    );
  }
}
