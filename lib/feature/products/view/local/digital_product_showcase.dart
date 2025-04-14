import 'package:carousel_slider/carousel_slider.dart';
import 'package:e_com/feature/products/view/local/digital_buy_view.dart';
import 'package:e_com/feature/products/view/local/digital_product_card_animated.dart';
import 'package:e_com/main.export.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';

class DigitalProductShowcase extends HookConsumerWidget {
  const DigitalProductShowcase({super.key, required this.data});
  final List<DigitalProduct> data;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentIndex = useState(0);
    final autoScroll = useState(true);
    return CarouselSlider.builder(
      options: CarouselOptions(
        autoPlayCurve: Curves.easeOutQuart,
        viewportFraction: context.onMobile ? 0.75 : 0.4,
        onPageChanged: (index, reason) => currentIndex.value = index,
        clipBehavior: Clip.none,
        autoPlay: autoScroll.value,
        height: 400,
      ),
      itemCount: data.length,
      itemBuilder: (context, index, _) {
        return DigitalProductCardAnimated(
          product: data[index],
          height: 200,
          isExpanded: index == currentIndex.value,
          onButtonTap: () async {
            autoScroll.value = false;
            await showDialog(
              context: context,
              builder: (_) => DigitalBuyView(product: data[index]),
            );
            autoScroll.value = true;
          },
        );
      },
    );
  }
}

class CustomFieldsWidget extends ConsumerWidget {
  const CustomFieldsWidget({super.key, required this.customFields});

  final Map<String, CustomInfo> customFields;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    if (customFields.isEmpty) return const SizedBox.shrink();

    TextInputType? textInputType(KFieldType type) => switch (type) {
          KFieldType.number => TextInputType.number,
          KFieldType.textarea => TextInputType.multiline,
          KFieldType.text => null,
          KFieldType.select => null,
        };
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          context.tr.productOptions,
          style: context.textTheme.titleMedium,
        ),
        for (final value in customFields.values) ...[
          const Gap(Insets.med),
          Text(
            value.label,
            style: context.textTheme.bodyMedium,
          ).markAsRequired(value.isRequired),
          const Gap(Insets.sm),
          if (value.type == KFieldType.select)
            FormBuilderCheckboxGroup<String>(
              name: value.name,
              options: [
                ...value.optionsList.map(
                  (e) => FormBuilderFieldOption(
                    value: e,
                    child: Text(e),
                  ),
                ),
              ],
              validator:
                  value.isRequired ? FormBuilderValidators.required() : null,
            )
          else
            FormBuilderTextField(
              name: value.name,
              validator:
                  value.isRequired ? FormBuilderValidators.required() : null,
              inputFormatters: [
                if (value.type == KFieldType.number)
                  FilteringTextInputFormatter.digitsOnly,
              ],
              keyboardType: textInputType(value.type),
              decoration: const InputDecoration(
                alignLabelWithHint: true,
              ),
              maxLines: value.type == KFieldType.textarea ? 4 : 1,
            ),
        ],
      ],
    );
  }
}
