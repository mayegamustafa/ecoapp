import 'package:collection/collection.dart';
import 'package:e_com/feature/region_settings/controller/region_ctrl.dart';
import 'package:e_com/feature/user_dash/provider/user_dash_provider.dart';
import 'package:e_com/feature/withdraw/controller/withdraw_ctrl.dart';
import 'package:e_com/feature/withdraw/view/local/withdraw_confirm_dialog.dart';
import 'package:e_com/main.export.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:go_router/go_router.dart';

import 'local/withdraw_method_card.dart';

class WithdrawNowView extends HookConsumerWidget {
  const WithdrawNowView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final methodList = ref.watch(withdrawMethodsProvider);

    final region = ref.watch(regionCtrlProvider);

    final selected = useState<WithdrawMethod?>(null);
    final formKey = useMemoized(GlobalKey<FormBuilderState>.new);

    final userBalance =
        ref.watch(userDashProvider.select((value) => value?.user.balance));

    Future<bool> request(Map<String, dynamic> data) async {
      if (selected.value == null) return false;
      final ctrl = ref.read(withdrawCtrlProvider.notifier);
      return await ctrl.request('${selected.value!.id}', data['amount']);
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(context.tr.withdrawNow),
      ),
      body: methodList.when(
        loading: () => Loader.grid(12, 4),
        error: (err, st) =>
            ErrorView(err, st, invalidate: withdrawMethodsProvider),
        data: (methods) {
          return Padding(
            padding: Insets.padAll,
            child: Column(
              children: [
                Expanded(
                  flex: 8,
                  child: RefreshIndicator(
                    onRefresh: () async {
                      final data =
                          await ref.refresh(withdrawMethodsProvider.future);
                      final match = data
                          .firstWhereOrNull((e) => e.id == selected.value?.id);

                      selected.value = match;
                    },
                    child: SingleChildScrollView(
                      physics: const AlwaysScrollableScrollPhysics(),
                      child: FormBuilder(
                        key: formKey,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Gap(Insets.med),
                            if (userBalance != null)
                              DecoratedContainer(
                                width: double.infinity,
                                padding: const EdgeInsets.all(Insets.med),
                                borderRadius: Corners.med,
                                color: context.colors.secondary.withOpacity(.1),
                                child: Column(
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Text(
                                          userBalance.formate(),
                                          style:
                                              context.textTheme.headlineMedium,
                                        ),
                                        const Gap(Insets.sm),
                                        Text(
                                          '(${(userBalance / (region.currency?.rate ?? 1)).formate(useBase: true)})',
                                          style: context.textTheme.titleSmall,
                                        ),
                                      ],
                                    ),
                                    const Gap(Insets.med),
                                    Text(
                                      context.tr.availableBalance,
                                      style: context.textTheme.bodyLarge,
                                    ),
                                  ],
                                ),
                              ),
                            const Gap(Insets.med),
                            Text(
                              context.tr.withdrawMethods,
                              style: context.textTheme.titleLarge,
                            ),
                            const Gap(Insets.lg),
                            if (selected.value != null)
                              ShadowContainer(
                                child: Padding(
                                  padding: Insets.padAll,
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      SpacedText(
                                        left: context.tr.withdrawLimit,
                                        right: selected.value!.limit,
                                      ),
                                      const Gap(Insets.med),
                                      SpacedText(
                                        left: context.tr.charge,
                                        right: selected.value!.chargeString,
                                      ),
                                      const Gap(Insets.med),
                                      SpacedText(
                                        left: context.tr.duration,
                                        right: selected.value!.durationString,
                                      ),
                                      const Gap(Insets.med),
                                      Text(context.tr.description),
                                      Html(
                                        data: selected.value!.description,
                                        shrinkWrap: true,
                                        style: {
                                          '*': Style(margin: Margins.zero),
                                        },
                                      ),
                                      const Divider(),
                                      const Gap(Insets.med),
                                      FormBuilderTextField(
                                        name: 'amount',
                                        textInputAction: TextInputAction.next,
                                        keyboardType: TextInputType.number,
                                        inputFormatters: [
                                          FilteringTextInputFormatter.digitsOnly
                                        ],
                                        decoration: InputDecoration(
                                          hintText: TR
                                              .of(context)
                                              .withdrawAmountIn(
                                                region.defCurrency?.name ?? '',
                                              ),
                                        ),
                                        validator:
                                            FormBuilderValidators.compose(
                                          [
                                            FormBuilderValidators.required(),
                                            FormBuilderValidators.min(
                                              selected.value!.minLimit,
                                            ),
                                            FormBuilderValidators.max(
                                              selected.value!.maxLimit,
                                            ),
                                          ],
                                        ),
                                      ),
                                      if (selected.value?.customInputs !=
                                          null) ...[
                                        const Gap(Insets.med),
                                        Text(
                                          '${context.tr.withdrawInformation} :',
                                          style: context.textTheme.bodyLarge,
                                        ),
                                        const Gap(Insets.med),
                                        _CustomInputFields(
                                          inputs: selected.value!.customInputs,
                                          key: ValueKey(selected.value!.id),
                                        ),
                                      ]
                                    ],
                                  ),
                                ),
                              )
                            else
                              DecoratedContainer(
                                color: context.colors.errorContainer
                                    .withOpacity(.05),
                                padding: Insets.padAll,
                                borderRadius: Corners.med,
                                alignment: Alignment.center,
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Icon(
                                      Icons.info_outline_rounded,
                                      color: context.colors.errorContainer,
                                    ),
                                    const Gap(Insets.med),
                                    Expanded(
                                      child: Text(
                                        TR
                                            .of(context)
                                            .msgSelectWithdrawalMethod,
                                        style: context.textTheme.bodyLarge!
                                            .copyWith(
                                          color: context.colors.errorContainer,
                                        ),
                                        textAlign: TextAlign.start,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            const Gap(Insets.xl),
                            Text(
                              context.tr.withdrawMethods,
                              style: context.textTheme.titleLarge,
                            ),
                            const Gap(Insets.lg),
                            MasonryGridView.builder(
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              mainAxisSpacing: Insets.med,
                              crossAxisSpacing: Insets.med,
                              gridDelegate:
                                  SliverSimpleGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: context.onMobile ? 3 : 5,
                              ),
                              itemCount: methods.length,
                              itemBuilder: (context, index) {
                                final method = methods[index];
                                return WithdrawMethodCard(
                                  method: method,
                                  isSelected: method.id == selected.value?.id,
                                  onSelected: (method) {
                                    selected.value = method;
                                    formKey.currentState?.reset();
                                  },
                                );
                              },
                            ),
                            const Gap(Insets.offset),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () => context.pop(),
                        child: Text(context.tr.cancel),
                      ),
                    ),
                    const Gap(Insets.med),
                    Expanded(
                      child: SubmitLoadButton.dense(
                        onPressed: selected.value == null
                            ? null
                            : (l) async {
                                final state = formKey.currentState!;
                                if (!state.saveAndValidate()) return;

                                l.value = true;

                                final data = state.value.nonNull();
                                final result = await request(data);

                                l.value = false;

                                if (!result) return;
                                if (!context.mounted) return;
                                showDialog(
                                  context: context,
                                  builder: (ctx) =>
                                      WithdrawConfirmDialog(formData: data),
                                );
                              },
                        child: Text(context.tr.submit),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

class _CustomInputFields extends StatelessWidget {
  const _CustomInputFields({
    super.key,
    required this.inputs,
  });
  final List<WithdrawInput> inputs;
  @override
  Widget build(BuildContext context) {
    return SeparatedColumn(
      separatorBuilder: () => const Gap(Insets.lg),
      children: [
        for (var input in inputs)
          FormBuilderTextField(
            name: input.name,
            textInputAction: input.isTextArea()
                ? TextInputAction.newline
                : TextInputAction.next,
            maxLines: input.isTextArea() ? 3 : 1,
            decoration: InputDecoration(
              labelText: input.label,
              alignLabelWithHint: true,
            ),
            validator: input.required ? FormBuilderValidators.required() : null,
          ),
      ],
    );
  }
}
