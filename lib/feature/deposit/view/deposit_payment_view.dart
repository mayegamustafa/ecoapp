import 'package:buttons_tabbar/buttons_tabbar.dart';
import 'package:e_com/feature/check_out/view/local/payment_selection_grid.dart';
import 'package:e_com/feature/deposit/controller/deposit_ctrl.dart';
import 'package:e_com/feature/deposit/view/local/deposite_method_appbar.dart';
import 'package:e_com/feature/payment/controller/payment_ctrl.dart';
import 'package:e_com/feature/region_settings/controller/region_ctrl.dart';
import 'package:e_com/feature/settings/provider/settings_provider.dart';
import 'package:e_com/main.export.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:go_router/go_router.dart';

class DepositPaymentView extends HookConsumerWidget {
  const DepositPaymentView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final depositMethod = ref.watch(depositCtrlProvider);
    final formKey = useMemoized(GlobalKey<FormBuilderState>.new);
    final region = ref.watch(regionCtrlProvider);
    final settings = ref.watch(settingsProvider);

    if (settings == null) {
      return ErrorView(
        'Settings not found',
        null,
        invalidate: settingsProvider,
      );
    }

    return Scaffold(
      appBar: const PreferredSize(
        preferredSize: Size(double.infinity, 180),
        child: DepositMethodAppbar(),
      ),
      bottomNavigationBar: SubmitLoadButton(
        padding: Insets.padAll,
        onPressed: depositMethod == null
            ? null
            : (l) async {
                final state = formKey.currentState!;
                if (!state.saveAndValidate()) return;

                l.value = true;

                final data = state.value.nonNull();

                final amount = data.parseNum('amount') / region.currency!.rate;
                data['amount'] = amount;

                Logger.json(data, 'FORM');

                final ctrl = ref.read(depositCtrlProvider.notifier);
                final deposit = await ctrl.makeDeposit(data);

                Logger.json(deposit?.toMap(), 'DEPOSIT');

                l.value = false;
                if (!context.mounted) return;
                if (deposit == null) return;

                if (deposit.method.isManual) return context.pop();

                l.value = true;

                await ref
                    .read(paymentCtrlProvider.notifier)
                    .initializePayment(context, deposit, isDeposit: true);

                l.value = false;
              },
        child: Text(context.tr.deposit),
      ),
      body: DefaultTabController(
        length: 2,
        initialIndex: 0,
        child: Column(
          children: [
            ButtonsTabBar(
              contentPadding: const EdgeInsets.symmetric(horizontal: 30),
              buttonMargin: Insets.padH.copyWith(top: 10),
              backgroundColor: context.colors.primary,
              unselectedBackgroundColor:
                  context.colors.onSurface.withOpacity(.1),
              unselectedLabelStyle: const TextStyle(color: Colors.grey),
              labelStyle: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
              onTap: (i) {
                ref.invalidate(depositCtrlProvider);
                formKey.currentState?.reset();
              },
              tabs: const [
                Tab(
                  text: "Payment Method",
                ),
                Tab(text: "Offline Payment"),
              ],
            ),
            Expanded(
              child: FormBuilder(
                key: formKey,
                child: TabBarView(
                  children: [
                    PaymentMethodTab(
                      useOffline: false,
                      onDateSelect: (date, field) {
                        if (date != null) {
                          formKey.currentState!.fields[field]
                              ?.didChange(date.formate());
                        }
                      },
                    ),
                    PaymentMethodTab(
                      onDateSelect: (date, field) {
                        if (date != null) {
                          formKey.currentState!.fields[field]
                              ?.didChange(date.formate());
                        }
                      },
                      useOffline: true,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class PaymentMethodTab extends HookConsumerWidget {
  const PaymentMethodTab({
    super.key,
    required this.useOffline,
    required this.onDateSelect,
  });

  final bool useOffline;
  final Function(DateTime? date, String field) onDateSelect;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final depositMethod = ref.watch(depositCtrlProvider);

    final region = ref.watch(regionCtrlProvider);
    final settings = ref.watch(settingsProvider);
    final scroll = useScrollController();

    if (settings == null) {
      return ErrorView(
        'Settings not found',
        null,
        invalidate: settingsProvider,
      );
    }

    final SettingsModel(minDepositAmount: min, maxDepositAmount: max) =
        settings.settings;

    return SingleChildScrollView(
      controller: scroll,
      padding: Insets.padAll,
      physics: defaultScrollPhysics,
      child: Column(
        children: [
          if (depositMethod != null)
            ShadowContainer(
              padding: Insets.padAll,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ...[
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (depositMethod.image.isNotEmpty)
                          HostedImage.square(
                            depositMethod.image,
                            dimension: 100,
                          ),
                        const Gap(Insets.med),
                        Flexible(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              if (depositMethod.name.isNotEmpty)
                                Text(
                                  depositMethod.name,
                                  style: context.textTheme.bodyLarge?.bold,
                                ),
                              if (depositMethod.percentCharge
                                  .formate()
                                  .isNotEmpty)
                                Text(
                                  'Charge : ${depositMethod.percentCharge.formate()}%',
                                ),
                              if (depositMethod.currency.name.isNotEmpty)
                                Text(
                                  'Currency : ${depositMethod.currency.name}',
                                ),
                              Text(
                                'Rate :  ${1.formate(useSymbol: false, useBase: true)} = ${depositMethod.rate}',
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const Gap(Insets.med),
                  ]
                ],
              ),
            ),
          if (depositMethod != null)
            ShadowContainer(
              offset: const Offset(0, 0),
              margin: Insets.padV,
              padding: Insets.padAll,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Deposit amount',
                    style: context.textTheme.bodyMedium,
                  ).markAsRequired(),
                  const Gap(Insets.sm),
                  FormBuilderTextField(
                    name: 'amount',
                    inputFormatters: [
                      FilteringTextInputFormatter.digitsOnly,
                    ],
                    textInputAction: TextInputAction.next,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      hintText: 'Enter amount',
                      prefixIcon: ConstrainedBox(
                        constraints: const BoxConstraints(
                          maxHeight: 20,
                          maxWidth: 20,
                        ),
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: CircleAvatar(
                            backgroundColor: Colors.transparent,
                            radius: 15,
                            child: Text(
                              region.currency?.symbol ?? '\$',
                              style: context.textTheme.titleMedium?.bold,
                            ),
                          ),
                        ),
                      ),
                    ),
                    validator: FormBuilderValidators.compose(
                      [
                        FormBuilderValidators.required(),
                        FormBuilderValidators.min(
                          min.formateSelf(rateCheck: true),
                        ),
                        FormBuilderValidators.max(
                          max.formateSelf(rateCheck: true),
                        ),
                      ],
                    ),
                  ),
                  const Gap(Insets.med),
                  if (depositMethod.manualInputs.isNotEmpty)
                    for (var field in depositMethod.manualInputs) ...[
                      Text(
                        field.name.replaceAll('_', ' ').toTitleCase,
                        style: context.textTheme.bodyMedium,
                      ).markAsRequired(field.isRequired),
                      const Gap(Insets.sm),
                      Row(
                        children: [
                          Flexible(
                            child: FormBuilderTextField(
                              name: field.name,
                              textInputAction: field.type.isTextArea
                                  ? TextInputAction.newline
                                  : TextInputAction.next,
                              maxLines: field.type.isTextArea ? 3 : 1,
                              keyboardType: field.type.isEmail
                                  ? TextInputType.emailAddress
                                  : (field.type.isDate
                                      ? TextInputType.datetime
                                      : null),
                              validator: FormBuilderValidators.compose(
                                [
                                  if (field.isRequired)
                                    FormBuilderValidators.required(),
                                  (v) {
                                    if (field.type.isEmail &&
                                        v?.isNotEmpty == true) {
                                      return FormBuilderValidators.email()
                                          .call(v);
                                    }
                                    return null;
                                  }
                                ],
                              ),
                            ),
                          ),
                          if (field.type.isDate)
                            IconButton.filled(
                              onPressed: () async {
                                final date = await showDatePicker(
                                  context: context,
                                  firstDate: DateTime(1950),
                                  lastDate: DateTime.now().add(30.days),
                                );
                                onDateSelect(date, field.name);
                              },
                              icon: const Icon(
                                Icons.calendar_month_rounded,
                              ),
                            ),
                        ],
                      ),
                    ]
                ],
              ),
            ),
          MethodsSection(
            useOffline: useOffline,
            onSelected: (v) {
              ref.read(depositCtrlProvider.notifier).setMethod(v);
              scroll.animateTo(
                0,
                duration: kThemeChangeDuration,
                curve: Curves.ease,
              );
            },
          ),
          const Gap(Insets.med),
        ],
      ),
    );
  }
}

class MethodsSection extends HookConsumerWidget {
  const MethodsSection({
    super.key,
    required this.onSelected,
    required this.useOffline,
  });

  final bool useOffline;

  final Function(PaymentData? method) onSelected;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final config = ref.watch(settingsProvider);
    final depositMethod = ref.watch(depositCtrlProvider);

    if (config == null) return ErrorView.withScaffold('Settings not found');

    final ConfigModel(:settings, :paymentMethods, :offlinePaymentMethods) =
        config;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if ((settings.digitalPayment && !useOffline) ||
            (settings.offlinePayment && useOffline))
          ExpansionTile(
            initiallyExpanded: true,
            maintainState: true,
            title: Text(context.tr.payment_method),
            children: [
              PaymentSelectionGrid(
                methods: useOffline ? offlinePaymentMethods : paymentMethods,
                onChange: (x) {
                  onSelected(x);
                },
                selected: depositMethod,
              ),
              const Gap(Insets.med),
            ],
          ),
      ],
    );
  }
}

class OfflinePayment extends HookConsumerWidget {
  const OfflinePayment({
    super.key,
    required this.onSelected,
  });

  final Function(PaymentData? method) onSelected;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final config = ref.watch(settingsProvider);
    final depositMethod = ref.watch(depositCtrlProvider);

    if (config == null) return ErrorView.withScaffold('Settings not found');

    final ConfigModel(:settings, :paymentMethods, :offlinePaymentMethods) =
        config;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (settings.offlinePayment)
          ExpansionTile(
            title: Text(context.tr.offlinePayment),
            children: [
              PaymentSelectionGrid(
                methods: offlinePaymentMethods,
                onChange: (x) {
                  onSelected(x);
                },
                selected: depositMethod,
              ),
              const Gap(Insets.med),
            ],
          ),
      ],
    );
  }
}
