import 'package:e_com/feature/check_out/view/local/payment_selection_grid.dart';
import 'package:e_com/feature/check_out/view/local/wallet_selector.dart';
import 'package:e_com/feature/payment/controller/payment_ctrl.dart';
import 'package:e_com/feature/settings/controller/settings_ctrl.dart';
import 'package:e_com/feature/user_dash/controller/dash_ctrl.dart';
import 'package:e_com/main.export.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class PayNowBottomSheetView extends HookConsumerWidget {
  const PayNowBottomSheetView(this.order, {super.key});

  final OrderModel order;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final ctrl = useAnimationController();
    final selected = useState<PaymentData?>(null);

    final configData = ref.watch(settingsCtrlProvider);
    final paymentCtrl =
        useCallback(() => ref.read(paymentCtrlProvider.notifier));

    final isWallet = useState(false);
    final tr = context.tr;
    return SizedBox(
      height: context.height * .8,
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          title: Text(tr.pay_now),
          centerTitle: true,
          elevation: 0,
          leading: IconButton(
            onPressed: () => context.pop(),
            icon: const Icon(Icons.close),
          ),
        ),
        body: BottomSheet(
          animationController: ctrl,
          onClosing: () {},
          builder: (context) {
            return Padding(
              padding: const EdgeInsets.all(10),
              child: configData.when(
                loading: () => const Center(child: CircularProgressIndicator()),
                error: ErrorView.new,
                data: (config) {
                  final ConfigModel(:settings, :paymentMethods) = config;

                  return SingleChildScrollView(
                    physics: defaultScrollPhysics,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        //! Payment

                        const Gap(Insets.med),
                        Text(
                          tr.payment_method,
                          style: context.textTheme.titleMedium,
                        ),
                        const Gap(Insets.med),
                        if (settings.walletActive) ...[
                          WalletSelector(
                            isWallet: isWallet.value,
                            selector: (v) {
                              isWallet.value = v;
                              selected.value = null;
                            },
                          ),
                          const Gap(Insets.med),
                        ],
                        if (!isWallet.value)
                          PaymentSelectionGrid(
                            methods: paymentMethods,
                            selected: selected.value,
                            onChange: (data) => selected.value = data,
                          ),

                        const SizedBox(height: 30),
                      ],
                    ),
                  );
                },
              ),
            );
          },
        ),
        bottomNavigationBar: BottomAppBar(
          height: 100,
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
          child: Column(
            children: [
              SpacedText(
                right: order.amount.formate(),
                left: tr.total,
                style: context.textTheme.titleLarge,
              ),
              const SizedBox(height: 5),
              SubmitButton(
                width: context.width,
                onPressed: () async {
                  if (!isWallet.value && selected.value == null) {
                    return Toaster.showError(tr.select_payment_method);
                  }
                  await paymentCtrl()
                      .payNow(context, order.uid, selected.value);

                  if (isWallet.value) {
                    ref.invalidate(userDashCtrlProvider);
                  }

                  if (context.mounted) context.pop();
                },
                child: Text(tr.pay_now),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
