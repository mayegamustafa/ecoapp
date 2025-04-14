import 'package:collection/collection.dart';
import 'package:e_com/_core/_core.dart';
import 'package:e_com/feature/address/controller/address_ctrl.dart';
import 'package:e_com/feature/settings/provider/settings_provider.dart';
import 'package:e_com/models/user/billing_address.dart';
import 'package:e_com/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'map_view.dart';

class AddAddressView extends HookConsumerWidget {
  const AddAddressView({this.address, super.key});

  final BillingAddress? address;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final billAddress = ref.watch(addressCtrlProvider(address));
    final billAddressCtrl =
        useCallback(() => ref.read(addressCtrlProvider(address).notifier));

    final countries =
        ref.watch(settingsProvider.select((v) => v?.countries ?? []));
    final isMapEnable = ref.watch(
        settingsProvider.select((v) => v?.settings.isMapEnabled ?? false));

    final formKey = useMemoized(GlobalKey<FormBuilderState>.new);

    final isLoading = useState(false);

    onAddressSubmit() async {
      final state = formKey.currentState;

      final isValid =
          state!.saveAndValidate(autoScrollWhenFocusOnInvalid: true);

      final data = state.value;

      if (isMapEnable) {
        if (data['longitude'] == null || data['latitude'] == null) {
          Toaster.showError(context.tr.msgSelectOnMap);
          return;
        }
      }

      if (isValid) {
        isLoading.value = true;

        await billAddressCtrl().submitAddress(data);

        isLoading.value = false;
        state.reset();
        if (context.mounted) context.pop();
      }
    }

    final tr = context.tr;

    return Scaffold(
      appBar: KAppBar(
        leading: SquareButton.backButton(
          onPressed: () => context.pop(),
        ),
        title: address == null ? Text(tr.create_billing) : Text(tr.update),
      ),
      body: SingleChildScrollView(
        physics: defaultScrollPhysics,
        padding: defaultPaddingAll,
        child: FormBuilder(
          key: formKey,
          child: Column(
            children: [
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
                padding: defaultPadding,
                child: Column(
                  children: [
                    KTextField(
                      name: 'first_name',
                      initialValue: billAddress.firstName,
                      textInputAction: TextInputAction.next,
                      autofillHints: AutoFillHintList.firstName,
                      keyboardType: TextInputType.name,
                      title: tr.first_name,
                      hinText: tr.first_name,
                      validator: FormBuilderValidators.required(),
                    ),
                    const Gap(15),
                    KTextField(
                      name: 'last_name',
                      initialValue: billAddress.lastName,
                      textInputAction: TextInputAction.next,
                      autofillHints: AutoFillHintList.lastName,
                      keyboardType: TextInputType.name,
                      title: tr.last_name,
                      hinText: tr.last_name,
                      validator: FormBuilderValidators.required(),
                    ),
                    const Gap(15),
                    KTextField(
                      name: 'phone',
                      initialValue: billAddress.phone,
                      textInputAction: TextInputAction.next,
                      keyboardType: TextInputType.phone,
                      autofillHints: AutoFillHintList.phone,
                      title: tr.phone,
                      hinText: tr.phone,
                      validator: FormBuilderValidators.compose(
                        [
                          FormBuilderValidators.required(),
                        ],
                      ),
                    ),
                    const Gap(15),
                    KTextField(
                      name: 'email',
                      initialValue: billAddress.email,
                      textInputAction: TextInputAction.next,
                      keyboardType: TextInputType.emailAddress,
                      autofillHints: AutoFillHintList.email,
                      title: tr.email,
                      hinText: tr.email,
                      validator: FormBuilderValidators.compose(
                        [
                          FormBuilderValidators.required(),
                          FormBuilderValidators.email(),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const Gap(20),
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
                      initialValue: billAddress.address,
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
                                              .firstWhereOrNull(
                                                  (e) => e.code == code)
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
                    const Gap(5),
                    if (isMapEnable)
                      Row(
                        children: [
                          const Icon(Icons.my_location_rounded, size: 20),
                          const Gap(10),
                          Flexible(
                            child: FormBuilderField<String>(
                              name: 'latitude',
                              initialValue: billAddress.lat,
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
                            height: 15,
                            width: 1,
                            color: context.colors.primary,
                            margin: defaultPadding,
                          ),
                          Flexible(
                            child: FormBuilderField<String>(
                              name: 'longitude',
                              initialValue: billAddress.lng,
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
                    const Gap(15),
                    FormBuilderDropdown<int>(
                      name: 'country_id',
                      initialValue: billAddress.country?.id,
                      decoration: InputDecoration(
                        hintText: context.tr.selectCountry,
                      ),
                      onChanged: (value) {
                        final state = formKey.currentState!;
                        state.patchValue({'state_id': null, 'city_id': null});
                        billAddressCtrl().setCountry(
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
                      initialValue: billAddress.state?.id,
                      decoration: InputDecoration(
                        hintText: context.tr.selectState,
                      ),
                      onChanged: (value) {
                        final state = formKey.currentState!;
                        state.patchValue({'city_id': null});

                        billAddressCtrl().setState(
                          billAddress.country?.states
                              .firstWhereOrNull((e) => e.id == value),
                        );
                      },
                      items: [
                        ...?billAddress.country?.states.map(
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
                      initialValue: billAddress.city?.id,
                      decoration: InputDecoration(
                        hintText: context.tr.selectCity,
                      ),
                      onChanged: (value) {
                        billAddressCtrl().setCity(
                          billAddress.state?.cities
                              .firstWhereOrNull((e) => e.id == value),
                        );
                      },
                      items: [
                        ...?billAddress.state?.cities.map(
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
                      initialValue: billAddress.zipCode,
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
              const Gap(20),
              Container(
                decoration: BoxDecoration(
                  borderRadius: defaultRadius,
                  color: context.colors.surface,
                  boxShadow: [
                    BoxShadow(
                      blurRadius: 6,
                      color: context.colors.primaryContainer
                          .withOpacity(context.isDark ? 0.3 : 0.1),
                      offset: const Offset(0, 0),
                    ),
                  ],
                ),
                padding: defaultPaddingAll,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(tr.address_name),
                    const Gap(10),
                    FormBuilderTextField(
                      name: 'address_name',
                      initialValue: billAddress.addressName,
                      validator: FormBuilderValidators.required(),
                      textInputAction: TextInputAction.done,
                      decoration: InputDecoration(
                        hintText: context.tr.egHomeOffice,
                      ),
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: Padding(
        padding: defaultPaddingAll,
        child: SubmitButton(
          width: context.width,
          onPressed: onAddressSubmit,
          isLoading: isLoading.value,
          child: address != null ? Text(tr.update) : Text(tr.add_address),
        ),
      ),
    );
  }
}
