import 'package:collection/collection.dart';
import 'package:e_com/feature/address/view/map_view.dart';
import 'package:e_com/feature/settings/provider/settings_provider.dart';
import 'package:e_com/feature/user_profile/controller/user_profile_ctrl.dart';
import 'package:e_com/main.export.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';

class UserProfileEditingView extends HookConsumerWidget {
  const UserProfileEditingView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userCtrl = useCallback(() => ref.read(userProfileProvider.notifier));
    final user = ref.watch(userProfileProvider);

    final formKey = useMemoized(GlobalKey<FormBuilderState>.new);
    final isLoading = useState(false);
    final countries =
        ref.watch(settingsProvider.select((v) => v?.countries ?? []));

    final tr = context.tr;
    return Scaffold(
      appBar: KAppBar(
        title: Text(tr.profile),
        leading: SquareButton.backButton(
          onPressed: () => context.pop(),
        ),
      ),
      body: SingleChildScrollView(
        padding: defaultPaddingAll,
        physics: defaultScrollPhysics,
        child: FormBuilder(
          key: formKey,
          child: Column(
            children: [
              Center(
                child: Stack(
                  clipBehavior: Clip.none,
                  children: [
                    if (user.imageFile == null)
                      CircleAvatar(
                        backgroundColor:
                            context.colors.secondary.withOpacity(.5),
                        radius: 45,
                        backgroundImage: user.image.isEmpty
                            ? null
                            : HostedImage.provider(user.image),
                        child: user.image.isEmpty
                            ? const Icon(Icons.person_rounded, size: 45)
                            : null,
                      )
                    else
                      CircleAvatar(
                        backgroundColor:
                            context.colors.secondary.withOpacity(.5),
                        radius: 45,
                        backgroundImage: FileImage(user.imageFile!),
                      ),
                    Positioned(
                      bottom: -10,
                      right: 0,
                      child: CircularButton.filled(
                        height: 40,
                        onPressed: () {
                          showDialog(
                            context: context,
                            builder: (c) {
                              return ImagePickerDialog(
                                onPick: (s) async {
                                  await userCtrl().pickAndSetImage(s);
                                  if (context.mounted) context.nPop();
                                },
                              );
                            },
                          );
                        },
                        fillColor: context.colors.primary,
                        iconColor: context.colors.onPrimary,
                        icon: const Icon(Icons.photo_camera_outlined),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 50),
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
                child: Padding(
                  padding: defaultPaddingAll,
                  child: Column(
                    children: [
                      KTextField(
                        name: 'username',
                        initialValue: user.username,
                        textInputAction: TextInputAction.next,
                        autofillHints: AutoFillHintList.name,
                        keyboardType: TextInputType.name,
                        validator: FormBuilderValidators.required(),
                        hinText: context.tr.userName,
                        title: context.tr.userName,
                      ),
                      const SizedBox(height: 15),
                      KTextField(
                        name: 'name',
                        initialValue: user.name,
                        textInputAction: TextInputAction.next,
                        autofillHints: AutoFillHintList.name,
                        keyboardType: TextInputType.name,
                        validator: FormBuilderValidators.required(),
                        hinText: tr.full_name,
                        title: tr.full_name,
                      ),
                      const SizedBox(height: 15),
                      KTextField(
                        name: 'phone',
                        initialValue: user.phone,
                        textInputAction: TextInputAction.next,
                        title: tr.phone,
                        hinText: tr.phone,
                        autofillHints: AutoFillHintList.phone,
                        keyboardType: TextInputType.phone,
                        validator: FormBuilderValidators.compose(
                          [
                            FormBuilderValidators.required(),
                            FormBuilderValidators.minLength(11),
                            FormBuilderValidators.maxLength(14),
                          ],
                        ),
                      ),
                      const SizedBox(height: 15),
                      KTextField(
                        name: 'email',
                        initialValue: user.email,
                        title: tr.email,
                        hinText: tr.email,
                        textInputAction: TextInputAction.next,
                        autofillHints: AutoFillHintList.email,
                        keyboardType: TextInputType.emailAddress,
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
                child: Padding(
                  padding: defaultPaddingAll,
                  child: Column(
                    children: [
                      KTextField(
                        name: 'address',
                        initialValue: user.address.address,
                        textInputAction: TextInputAction.next,
                        autofillHints: AutoFillHintList.address,
                        keyboardType: TextInputType.streetAddress,
                        title: tr.streetName,
                        hinText: tr.streetName,
                        validator: FormBuilderValidators.required(),
                        suffix: IconButton(
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
                                  state.patchValue(
                                    {
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
                                    },
                                  );
                                },
                              ),
                            );
                          },
                          icon: const Icon(Icons.location_on_rounded),
                        ),
                      ),
                      Opacity(
                        opacity: 0,
                        child: Row(
                          children: [
                            const Gap(10),
                            Flexible(
                              child: FormBuilderField<String>(
                                name: 'latitude',
                                initialValue: user.address.lat,
                                builder: (state) => Text(
                                  'Lat: ${state.value ?? '--'}',
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
                                initialValue: user.address.lng,
                                builder: (state) => Text(
                                  'Lng: ${state.value ?? '--'}',
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
                        initialValue: user.country?.id,
                        decoration: InputDecoration(
                          hintText: context.tr.selectCountry,
                        ),
                        onChanged: (code) => userCtrl().setCountry(
                          countries.firstWhereOrNull((e) => e.id == code),
                        ),
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
                      const SizedBox(height: 15),
                      KTextField(
                        name: 'state',
                        initialValue: user.address.state,
                        title: tr.state_name,
                        hinText: tr.state_name,
                        textInputAction: TextInputAction.next,
                        autofillHints: AutoFillHintList.state,
                        keyboardType: TextInputType.streetAddress,
                        validator: FormBuilderValidators.required(),
                      ),
                      const SizedBox(height: 15),
                      KTextField(
                        name: 'city',
                        initialValue: user.address.city,
                        title: tr.city_name,
                        hinText: tr.city_name,
                        textInputAction: TextInputAction.next,
                        autofillHints: AutoFillHintList.city,
                        keyboardType: TextInputType.streetAddress,
                        validator: FormBuilderValidators.required(),
                      ),
                      const SizedBox(height: 15),
                      KTextField(
                        name: 'zip',
                        initialValue: user.address.zip,
                        title: tr.zip_code,
                        hinText: tr.zip_code,
                        textInputAction: TextInputAction.next,
                        autofillHints: AutoFillHintList.zip,
                        keyboardType: TextInputType.streetAddress,
                        validator: FormBuilderValidators.required(),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 150),
            ],
          ),
        ),
      ),
      bottomNavigationBar: Padding(
        padding: defaultPadding,
        child: SubmitButton(
          width: context.width,
          isLoading: isLoading.value,
          onPressed: () async {
            final isValid = formKey.currentState?.saveAndValidate();
            if (isValid == false) return;
            final data = formKey.currentState?.value;
            final profile = UserModel.fromFlatMap(data!);

            userCtrl().setUser(profile);

            isLoading.value = true;
            await userCtrl().updateProfile();
            isLoading.value = false;
          },
          child: Text(tr.update),
        ),
      ),
    );
  }
}

class ImagePickerDialog extends StatelessWidget {
  const ImagePickerDialog({
    super.key,
    required this.onPick,
  });

  final Function(ImageSource source) onPick;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(context.tr.pickImage),
      actionsAlignment: MainAxisAlignment.center,
      actions: [
        ...ImageSource.values.map(
          (e) => Container(
            constraints: const BoxConstraints(
              minWidth: 100,
            ),
            decoration: BoxDecoration(
              color: context.colors.secondary.withOpacity(.05),
              borderRadius: Corners.medBorder,
              border: Border.all(color: context.colors.secondary),
            ),
            padding: const EdgeInsets.all(10),
            margin: const EdgeInsets.all(5),
            child: InkWell(
              onTap: () => onPick(e),
              child: Column(
                children: [
                  Icon(
                    e.icon,
                    color: context.colors.secondary,
                  ),
                  const SizedBox(height: 5),
                  Text(
                    e.name.toTitleCase,
                    style: context.textTheme.labelMedium?.copyWith(
                      color: context.colors.secondary,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
