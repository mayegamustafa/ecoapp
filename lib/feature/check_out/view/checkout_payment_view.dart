import 'package:e_com/feature/auth/controller/auth_ctrl.dart';
import 'package:e_com/feature/check_out/controller/checkout_ctrl.dart';
import 'package:e_com/feature/check_out/view/local/address_card.dart';
import 'package:e_com/feature/check_out/view/local/payment_selection_grid.dart';
import 'package:e_com/feature/check_out/view/local/wallet_selector.dart';
import 'package:e_com/feature/settings/controller/settings_ctrl.dart';
import 'package:e_com/feature/settings/provider/settings_provider.dart';
import 'package:e_com/main.export.dart';
import 'package:e_com/routes/routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:fpdart/fpdart.dart';
import 'package:go_router/go_router.dart';

class CheckoutPaymentView extends HookConsumerWidget {
  const CheckoutPaymentView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final checkoutCtrl = ref.read(checkoutCtrlProvider.notifier);
    final checkout = ref.watch(checkoutCtrlProvider);
    final isLoggedIn = ref.watch(authCtrlProvider);
    final config = ref.watch(settingsProvider);
    if (config == null) return ErrorView.withScaffold('Settings not found');

    final ConfigModel(:settings, :paymentMethods, :offlinePaymentMethods) =
        config;

    final inputs = checkout.payment?.manualInputs ?? [];

    final formKey = useMemoized(() => GlobalKey<FormBuilderState>());

    final enabled = settings.digitalPayment ||
        settings.offlinePayment ||
        settings.cashOnDelivery;

    final isCarrierSpecific =
        config.settings.shippingConfig.type.isCarrierSpecific;

    final canShowCod = !settings.digitalPayment && settings.cashOnDelivery;
    final tr = context.tr;
    return Scaffold(
      appBar: KAppBar(
        title: Text(tr.checkout),
        leading: SquareButton.backButton(
          onPressed: () => context.pop(),
        ),
      ),
      body: RefreshIndicator(
        onRefresh: () => ref.read(settingsCtrlProvider.notifier).reload(),
        child: SingleChildScrollView(
          padding: defaultPadding,
          physics: defaultScrollPhysics,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Gap(Insets.med),
              if (!isLoggedIn) ...[
                Text(
                  tr.shipping_address,
                  style: context.textTheme.headlineSmall,
                ),
                const Gap(Insets.med),
                AddressCard(
                  checkout: checkout,
                  onChangeTap: () =>
                      RouteNames.shippingDetails.goNamed(context),
                ),
                const Gap(Insets.med),
                const Divider(),
              ],
              if (settings.walletActive && isLoggedIn)
                WalletSelector(
                  isWallet: checkout.isWallet,
                  selector: (isWallet) => checkoutCtrl.updateWallet(isWallet),
                ),
              if (!checkout.isWallet)
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    //! COD
                    if (canShowCod) ...[
                      const Gap(Insets.med),
                      Container(
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          borderRadius: defaultRadius,
                          color: context.colors.secondaryContainer
                              .withOpacity(.05),
                          border: (checkout.payment?.isCOD ?? false)
                              ? Border.all(
                                  color: context.colors.secondaryContainer,
                                  width: 1,
                                )
                              : null,
                        ),
                        padding: defaultPaddingAll,
                        child: ListTile(
                          leading: Assets.logo.cod.image(height: 50, width: 50),
                          title: Text(PaymentData.codPayment.name),
                          onTap: () => checkoutCtrl.setCodPayment(),
                        ),
                      ),
                    ],

                    //! digital Payment
                    if (settings.digitalPayment) ...[
                      const SizedBox(height: 20),
                      Text(
                        tr.payment_method,
                        style: context.textTheme.headlineSmall
                            ?.copyWith(fontWeight: FontWeight.w600),
                      ),
                      const Gap(Insets.med),
                      PaymentSelectionGrid(
                        methods: [
                          if (settings.cashOnDelivery) PaymentData.codPayment,
                          ...paymentMethods,
                        ],
                        selected: checkout.payment,
                        onChange: (data) {
                          checkoutCtrl.setPayment(data);
                          formKey.currentState?.reset();
                        },
                      ),
                    ],

                    //! offline Payment
                    if (settings.offlinePayment) ...[
                      const SizedBox(height: 20),
                      Text(
                        tr.offlinePayment,
                        style: context.textTheme.headlineSmall,
                      ),
                      const Gap(Insets.med),
                      PaymentSelectionGrid(
                        methods: offlinePaymentMethods,
                        selected: checkout.payment,
                        onChange: (data) {
                          checkoutCtrl.setPayment(data);
                          formKey.currentState?.reset();
                        },
                      ),
                      if (inputs.isNotEmpty)
                        FormBuilder(
                          key: formKey,
                          child: OfflinePayInputs(
                            inputs: inputs,
                            key: ValueKey(checkout.payment?.id),
                            onDateSelect: (date, name) {
                              if (date == null) return;
                              formKey.currentState!.fields[name]
                                  ?.didChange(date.formate());
                            },
                          ),
                        ),
                    ],
                    if (!enabled)
                      const Center(
                        child: NoItemsAnimation(),
                      ),
                    const SizedBox(height: 100)
                  ],
                ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: Container(
        margin: defaultPaddingAll,
        height: 50,
        width: context.width - 40,
        child: FilledButton(
          onPressed: !enabled
              ? null
              : () async {
                  final state = formKey.currentState;

                  if (!checkout.isWallet && checkout.payment == null) {
                    Toaster.showError(tr.Select_shipping_method);
                    return;
                  }
                  if (isCarrierSpecific && checkout.shipping == null) {
                    Toaster.showError(tr.Select_shipping_method);
                    return;
                  }

                  if (state != null) {
                    if (!state.saveAndValidate()) return;

                    final inputKeys = checkout.payment?.inputKeys ?? [];

                    final data = state.value
                        .filterWithKey((k, _) => inputKeys.contains(k));

                    checkoutCtrl.setCustomInputData(data);
                  }

                  RouteNames.checkoutSummary.pushNamed(context);
                },
          child: Text(tr.submit_order),
        ),
      ),
    );
  }
}

class OfflinePayInputs extends StatelessWidget {
  const OfflinePayInputs({
    super.key,
    required this.inputs,
    required this.onDateSelect,
    this.style,
  });

  final List<CustomPayField> inputs;
  final TextStyle? style;

  final Function(DateTime? date, String field) onDateSelect;

  @override
  Widget build(BuildContext context) {
    return SeparatedColumn(
      separatorBuilder: () => const Gap(Insets.med),
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          context.tr.paymentOptions,
          style: style ?? context.textTheme.headlineSmall,
        ),
        for (var input in inputs)
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                input.displayName,
                style: context.textTheme.bodyLarge,
              ).markAsRequired(input.isRequired),
              const SizedBox(height: 5),
              Row(
                children: [
                  Flexible(
                    child: FormBuilderTextField(
                      name: input.name,
                      decoration: InputDecoration(
                        hintText: input.displayName,
                      ),
                      maxLines: input.type.isTextArea ? 2 : 1,
                      keyboardType: input.type.keyboardType,
                      textInputAction: input.type.isTextArea
                          ? TextInputAction.newline
                          : TextInputAction.next,
                      validator: FormBuilderValidators.compose(
                        [
                          if (input.isRequired)
                            FormBuilderValidators.required(),
                          (v) {
                            v ??= '';
                            if (input.type.isEmail && v.isNotEmpty) {
                              return FormBuilderValidators.email().call(v);
                            }
                            return null;
                          }
                        ],
                      ),
                    ),
                  ),
                  if (input.type.isDate)
                    IconButton.filled(
                      onPressed: () async {
                        final date = await showDatePicker(
                          context: context,
                          firstDate: DateTime(1950),
                          lastDate: DateTime.now().add(30.days),
                        );

                        onDateSelect(date, input.name);
                      },
                      icon: const Icon(
                        Icons.calendar_month_rounded,
                      ),
                    ),
                ],
              ),
            ],
          ),
      ],
    );
  }
}
