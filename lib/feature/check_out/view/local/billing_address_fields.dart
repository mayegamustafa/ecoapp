import 'package:collection/collection.dart';
import 'package:e_com/feature/address/view/map_view.dart';
import 'package:e_com/feature/check_out/controller/checkout_ctrl.dart';
import 'package:e_com/feature/settings/provider/settings_provider.dart';
import 'package:e_com/main.export.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';

class BillingAddressFields extends HookConsumerWidget {
  const BillingAddressFields({super.key, required this.formKey});
  final GlobalKey<FormBuilderState> formKey;
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tr = context.tr;
    final checkout = ref.watch(checkoutCtrlProvider);
    final checkoutCtrl =
        useCallback(() => ref.read(checkoutCtrlProvider.notifier));
    final countries =
        ref.watch(settingsProvider.select((v) => v?.countries ?? []));
    final isMapEnable = ref.watch(
        settingsProvider.select((v) => v?.settings.isMapEnabled ?? false));

    return Column(
      children: [
        Container(
          decoration: BoxDecoration(
            borderRadius: defaultRadius,
            color: context.colors.surface,
            boxShadow: [
              BoxShadow(
                blurRadius: 6,
                color: context.colors.primaryContainer.withOpacity(
                  context.isDark ? 0.3 : 0.1,
                ),
                offset: const Offset(0, 0),
              ),
            ],
          ),
          padding: defaultPaddingAll,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                tr.basic_info,
                style: context.textTheme.titleLarge,
              ),
              const SizedBox(height: 15),
              KTextField(
                name: 'first_name',
                keyboardType: TextInputType.name,
                autofillHints: AutoFillHintList.firstName,
                textInputAction: TextInputAction.next,
                validator: FormBuilderValidators.required(),
                hinText: tr.first_name,
                title: tr.first_name,
              ),
              const SizedBox(height: 15),
              KTextField(
                name: 'last_name',
                title: tr.last_name,
                hinText: tr.last_name,
                keyboardType: TextInputType.name,
                autofillHints: AutoFillHintList.lastName,
                textInputAction: TextInputAction.next,
                validator: FormBuilderValidators.required(),
              ),
              const SizedBox(height: 15),
              KTextField(
                name: 'phone',
                title: tr.phone,
                hinText: tr.phone,
                keyboardType: TextInputType.phone,
                autofillHints: AutoFillHintList.phone,
                textInputAction: TextInputAction.next,
                validator: FormBuilderValidators.compose(
                  [
                    FormBuilderValidators.required(),
                  ],
                ),
              ),
              const SizedBox(height: 15),
              KTextField(
                name: 'email',
                title: tr.email,
                hinText: tr.email,
                keyboardType: TextInputType.emailAddress,
                autofillHints: AutoFillHintList.email,
                textInputAction: TextInputAction.next,
                validator: FormBuilderValidators.compose(
                  [
                    FormBuilderValidators.required(),
                    FormBuilderValidators.email(),
                  ],
                ),
              ),
              const SizedBox(height: 10),
            ],
          ),
        ),
        const SizedBox(height: 15),
        Container(
          decoration: BoxDecoration(
            borderRadius: defaultRadius,
            color: context.colors.surface,
            boxShadow: [
              BoxShadow(
                blurRadius: 6,
                color: context.colors.primaryContainer
                    .withOpacity(context.isDark ? 0.3 : 0.06),
                offset: const Offset(0, 0),
              ),
            ],
          ),
          padding: defaultPaddingAll,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              KTextField(
                name: 'address',
                textInputAction: TextInputAction.next,
                autofillHints: AutoFillHintList.address,
                keyboardType: TextInputType.streetAddress,
                title: tr.streetName,
                hinText: tr.streetName,
                validator: FormBuilderValidators.required(),
                suffix: !isMapEnable
                    ? null
                    : IconButton(
                        style: IconButton.styleFrom(
                          fixedSize: const Size.square(63),
                          backgroundColor:
                              context.colors.primary.withOpacity(.1),
                          foregroundColor: context.colors.primary,
                          shape: const RoundedRectangleBorder(
                            borderRadius: Corners.medBorder,
                          ),
                        ),
                        onPressed: () {
                          showDialog(
                            context: context,
                            builder: (_) => AddressMapView(
                              onLocationSelect: (latLng, address, code) {
                                final state = formKey.currentState!;
                                state.patchValue({
                                  'address': address,
                                  if (latLng != null) ...{
                                    'latitude': '${latLng.latitude}',
                                    'longitude': '${latLng.longitude}',
                                  },
                                  if (code != null) ...{
                                    'country_id': countries
                                        .firstWhereOrNull((e) => e.code == code)
                                        ?.id,
                                  },
                                });
                              },
                            ),
                          );
                        },
                        icon: const Icon(Icons.location_on_rounded),
                      ),
              ),
              // const Gap(5),
              Opacity(
                opacity: 0,
                child: Row(
                  children: [
                    const Gap(10),
                    Flexible(
                      child: FormBuilderField<String>(
                        name: 'latitude',
                        builder: (state) => Text.rich(
                          TextSpan(
                            children: [
                              const TextSpan(text: 'Lat: '),
                              TextSpan(text: state.value ?? '--'),
                            ],
                          ),
                          style: context.textTheme.bodySmall,
                          maxLines: 1,
                        ),
                      ),
                    ),
                    DecoratedContainer(
                      height: 10,
                      width: 1,
                      color: context.colors.primary,
                      margin: defaultPadding,
                    ),
                    Flexible(
                      child: FormBuilderField<String>(
                        name: 'longitude',
                        builder: (state) => Text.rich(
                          TextSpan(
                            children: [
                              const TextSpan(text: 'Lng: '),
                              TextSpan(text: state.value ?? '--'),
                            ],
                          ),
                          style: context.textTheme.bodySmall,
                          maxLines: 1,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              FormBuilderDropdown<int>(
                name: 'country_id',
                decoration: InputDecoration(
                  hintText: tr.selectCountry,
                ),
                onChanged: (value) {
                  final state = formKey.currentState!;
                  state.patchValue({'state_id': null, 'city_id': null});
                  checkoutCtrl().copyWithAddress(
                    country: () =>
                        countries.firstWhereOrNull((e) => e.id == value),
                  );
                },
                items: [
                  ...countries.map(
                    (e) => DropdownMenuItem(
                      value: e.id,
                      child: Text(e.name),
                    ),
                  ),
                ],
                validator: FormBuilderValidators.required(),
              ),
              const Gap(15),
              FormBuilderDropdown<int>(
                name: 'state_id',
                decoration: InputDecoration(
                  hintText: tr.selectState,
                ),
                onChanged: (value) {
                  final state = formKey.currentState!;
                  state.patchValue({'city_id': null});

                  checkoutCtrl().copyWithAddress(
                    cState: () => checkout.billingAddress?.country?.states
                        .firstWhereOrNull((e) => e.id == value),
                  );
                },
                items: [
                  ...?checkout.billingAddress?.country?.states.map(
                    (e) => DropdownMenuItem(
                      value: e.id,
                      child: Text(e.name),
                    ),
                  ),
                ],
                validator: FormBuilderValidators.required(),
              ),
              const Gap(15),
              FormBuilderDropdown<int>(
                name: 'city_id',
                decoration: InputDecoration(
                  hintText: tr.selectCity,
                ),
                onChanged: (value) {
                  checkoutCtrl().copyWithAddress(
                    city: () => checkout.billingAddress?.state?.cities
                        .firstWhereOrNull((e) => e.id == value),
                  );
                },
                items: [
                  ...?checkout.billingAddress?.state?.cities.map(
                    (e) => DropdownMenuItem(
                      value: e.id,
                      child: Text(e.name),
                    ),
                  ),
                ],
                validator: FormBuilderValidators.required(),
              ),
              const Gap(15),
              KTextField(
                name: 'zip',
                textInputAction: TextInputAction.next,
                autofillHints: AutoFillHintList.zip,
                keyboardType: TextInputType.streetAddress,
                title: tr.zip_code,
                hinText: tr.zip_code,
                validator: FormBuilderValidators.required(),
              ),
              const Gap(15),
            ],
          ),
        ),
      ],
    );
  }
}
