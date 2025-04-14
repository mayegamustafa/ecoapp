import 'package:e_com/feature/auth/controller/auth_ctrl.dart';
import 'package:e_com/feature/check_out/controller/checkout_ctrl.dart';
import 'package:e_com/feature/check_out/view/local/address_card.dart';
import 'package:e_com/feature/check_out/view/local/billing_address_fields.dart';
import 'package:e_com/feature/check_out/view/local/selectable_card.dart';
import 'package:e_com/feature/settings/controller/settings_ctrl.dart';
import 'package:e_com/feature/settings/provider/settings_provider.dart';
import 'package:e_com/main.export.dart';
import 'package:e_com/routes/routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:go_router/go_router.dart';

class CheckoutShippingView extends HookConsumerWidget {
  const CheckoutShippingView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final settings = ref.watch(settingsProvider);

    final checkoutCtrl =
        useCallback(() => ref.read(checkoutCtrlProvider.notifier));
    final checkout = ref.watch(checkoutCtrlProvider);

    final formKey = useMemoized(GlobalKey<FormBuilderState>.new);

    final isLoggedIn = ref.watch(authCtrlProvider);
    if (settings == null) return ErrorView.withScaffold('Settings not found');

    final isCarrierSpecific =
        settings.settings.shippingConfig.type.isCarrierSpecific;
    final tr = context.tr;
    return Scaffold(
      appBar: KAppBar(
        title: Text(tr.checkout),
        leading: SquareButton.backButton(
          onPressed: () => context.pop(),
        ),
      ),
      body: Padding(
        padding: defaultPadding,
        child: RefreshIndicator(
          onRefresh: () => ref.read(settingsCtrlProvider.notifier).reload(),
          child: SingleChildScrollView(
            physics: defaultScrollPhysics,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 20),

                //! shipping details
                if (!isLoggedIn)
                  FormBuilder(
                    key: formKey,
                    child: BillingAddressFields(formKey: formKey),
                  )
                else
                  AddressCard(checkout: checkout),

                const SizedBox(height: 30),

                //! Delivery Method
                if (isCarrierSpecific) ...[
                  Text(
                    tr.shipping_method,
                    style: context.textTheme.titleLarge,
                  ),
                  const SizedBox(height: 15),
                  ScrollableFlex(
                    clipBehavior: Clip.none,
                    children: [
                      ...settings.validShipping.map(
                        (ship) {
                          final priceConfig = checkout.priceConfig(ship);

                          return SelectableCard(
                            header: HostedImage(
                              ship.image,
                              height: 50,
                              width: 90,
                              fit: BoxFit.contain,
                            ),
                            isSelected: checkout.shipping?.uid == ship.uid,
                            onTap: () => checkoutCtrl().setShipping(ship),
                            title: Text(
                              ship.methodName,
                              textAlign: TextAlign.center,
                            ),
                            subTitle: priceConfig == null
                                ? Text(
                                    ship.isFreeShipping
                                        ? context.tr.free
                                        : 0.formate(),
                                  )
                                : Text(
                                    priceConfig.formate(rateCheck: true),
                                  ),
                          );
                        },
                      ),
                    ],
                  ),
                ],
                const SizedBox(height: 80),
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: Padding(
        padding: defaultPaddingAll,
        child: SubmitButton(
          width: context.width,
          onPressed: () {
            // if user is Guest validate billing fields and save them
            if (!isLoggedIn) {
              final isValid = formKey.currentState?.saveAndValidate(
                autoScrollWhenFocusOnInvalid: true,
              );
              if (isValid != true) return;

              final data = formKey.currentState!.value;

              checkoutCtrl().setBillingFromMap(data);
            }

            if (isCarrierSpecific && checkout.shipping == null) {
              Toaster.showError(tr.select_payment_method);
              return;
            }

            if (ref.watch(checkoutCtrlProvider).billingAddress == null) {
              Toaster.showError(tr.next_pay);
              return;
            }
            RouteNames.checkoutPayment.pushNamed(context);
          },
          child: Text(tr.next_pay),
        ),
      ),
    );
  }
}
