import 'package:e_com/feature/auth/controller/auth_ctrl.dart';
import 'package:e_com/feature/check_out/controller/checkout_ctrl.dart';
import 'package:e_com/feature/check_out/view/local/payment_selection_grid.dart';
import 'package:e_com/feature/check_out/view/local/wallet_selector.dart';
import 'package:e_com/feature/products/view/local/digital_product_showcase.dart';
import 'package:e_com/feature/settings/provider/settings_provider.dart';
import 'package:e_com/main.export.dart';
import 'package:e_com/routes/routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:form_builder_validators/form_builder_validators.dart';

class DigitalBuyView extends HookConsumerWidget {
  const DigitalBuyView({
    super.key,
    required this.product,
  });

  final DigitalProduct product;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final digitalUid = useState<String?>(null);
    final payment = useState<PaymentData?>(null);
    final isWallet = useState<bool>(false);
    final fieldKey = useMemoized(GlobalKey<FormBuilderFieldState>.new);
    final formKey = useMemoized(GlobalKey<FormBuilderState>.new);

    final config = ref.watch(settingsProvider);
    if (config == null) return ErrorView.withScaffold('Settings not found');

    final ConfigModel(:settings, :paymentMethods) = config;

    final tr = context.tr;
    return Scaffold(
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(10),
        child: SubmitButton(
          onPressed: product.attribute.isEmpty
              ? null
              : () async {
                  if (!ref.watch(authCtrlProvider)) {
                    final isValid = fieldKey.currentState?.validate();
                    if (isValid != true) return;
                  }

                  final formValid = formKey.currentState!.saveAndValidate();
                  if (!formValid) return;

                  if (digitalUid.value == null) {
                    Toaster.showError(
                      tr.select_item_digital,
                    );
                    return;
                  }
                  if (payment.value == null && !isWallet.value) {
                    Toaster.showError(
                      tr.select_payment_method,
                    );
                    return;
                  }

                  final formData = formKey.currentState!.value;

                  await ref.read(checkoutCtrlProvider.notifier).buyNow(
                        productUid: product.uid,
                        digitalUid: digitalUid.value!,
                        paymentUid: payment.value?.id,
                        email: fieldKey.currentState?.value ?? '',
                        formData: formData,
                        isWallet: isWallet.value,
                        onSuccess: (x) => x.fold(
                          (l) => RouteNames.afterPayment.goNamed(
                            context,
                            query: {'status': 'w', 'id': l},
                          ),
                          (r) =>
                              RouteNames.orderPlaced.goNamed(context, extra: r),
                        ),
                      );

                  if (context.mounted) context.nPop();
                },
          child: Text(tr.buy_now),
        ),
      ),
      appBar: KAppBar(
        leading: SquareButton.backButton(
          onPressed: () => context.nPop(),
        ),
        title: Text(product.name, maxLines: 1),
      ),
      body: SingleChildScrollView(
        padding: Insets.padAll,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Gap(Insets.med),
            Text(
              tr.attributes,
              style: context.textTheme.titleMedium,
            ),
            const Gap(Insets.med),
            if (product.attribute.isEmpty)
              Container(
                height: 60,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: context.colors.error.withOpacity(.05),
                  borderRadius: defaultRadius,
                ),
                alignment: Alignment.center,
                child: Text(
                  tr.no_attribute,
                  style: context.textTheme.titleMedium,
                ),
              )
            else
              MasonryGridView.builder(
                gridDelegate:
                    const SliverSimpleGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                ),
                mainAxisSpacing: Insets.med,
                crossAxisSpacing: Insets.med,
                itemCount: product.attribute.length,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemBuilder: (context, index) {
                  final attribute = product.attribute.entries.toList()[index];
                  final selected = digitalUid.value == attribute.value.uid;
                  return ListTile(
                    onTap: () {
                      selected
                          ? digitalUid.value = null
                          : digitalUid.value = attribute.value.uid;
                    },
                    title: Text(
                      attribute.key,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    subtitle: Text(attribute.value.price.formate()),
                    leading: selected
                        ? const Icon(Icons.check_circle_rounded)
                        : const Icon(Icons.circle_outlined),
                    shape: RoundedRectangleBorder(
                      side: selected
                          ? BorderSide(
                              width: 1,
                              color: context.colors.secondary,
                            )
                          : BorderSide.none,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    tileColor:
                        context.colors.secondaryContainer.withOpacity(0.05),
                    iconColor: context.colors.secondaryContainer,
                  );
                },
              ),
            const Gap(Insets.med),
            if (!ref.watch(authCtrlProvider)) ...[
              Text(
                tr.email,
                style: context.textTheme.titleMedium,
              ),
              const Gap(Insets.med),
              FormBuilderTextField(
                name: 'email',
                key: fieldKey,
                keyboardType: TextInputType.emailAddress,
                autofillHints: const [AutofillHints.email],
                decoration: InputDecoration(
                  hintText: tr.email,
                ),
                validator: FormBuilderValidators.compose(
                  [
                    FormBuilderValidators.required(),
                    FormBuilderValidators.email(),
                  ],
                ),
              ),
              const Gap(Insets.med),
            ],
            FormBuilder(
              key: formKey,
              child: CustomFieldsWidget(customFields: product.customInfo),
            ),
            const Gap(Insets.sm),
            const Divider(),
            const Gap(Insets.sm),
            if (settings.walletActive)
              WalletSelector(
                isWallet: isWallet.value,
                selector: (w) {
                  isWallet.value = w;
                  payment.value = null;
                },
              ),
            //! Payment
            if (!isWallet.value) ...[
              const Gap(Insets.med),
              if (settings.digitalPayment) ...[
                Text(
                  tr.payment_method,
                  style: context.textTheme.titleMedium,
                ),
                const Gap(Insets.med),
                PaymentSelectionGrid(
                  methods: paymentMethods,
                  selected: payment.value,
                  onChange: (data) => payment.value = data,
                ),
              ],
            ],
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
