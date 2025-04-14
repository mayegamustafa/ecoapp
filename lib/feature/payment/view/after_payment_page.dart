import 'package:e_com/feature/auth/controller/auth_ctrl.dart';
import 'package:e_com/feature/orders/controller/order_pay_log_ctrl.dart';
import 'package:e_com/feature/user_dash/controller/dash_ctrl.dart';
import 'package:e_com/main.export.dart';
import 'package:e_com/routes/routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class AfterPaymentView extends HookConsumerWidget {
  const AfterPaymentView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final trxNo = context.query('id');
    final orderId = context.query('orderId');
    final statusQu = context.query('status');
    final isDeposit = context.queryParams.parseBool('dep');

    final status = useState(statusQu);
    final isLoading = useState(false);
    final tr = context.tr;

    useEffect(
      () {
        Future(() {
          if (ref.read(authCtrlProvider)) {
            ref.read(userDashCtrlProvider.notifier).reload();
          }
        });
        return null;
      },
      [statusQu],
    );

    checkOrderStatus() async {
      if (trxNo == null) return;
      isLoading.value = true;

      final payStatus =
          await ref.read(orderPaymentLogProvider.notifier).statusCheck(trxNo);

      isLoading.value = false;
      status.value = payStatus;
      HapticFeedback.lightImpact();
    }

    useOnAppLifecycleStateChange(
      (_, c) {
        if (c == AppLifecycleState.resumed) checkOrderStatus();
      },
    );

    final color = switch (status.value) {
      's' || '2' => context.colors.errorContainer,
      'w' || '1' => Colors.orange,
      _ => context.colors.error,
    };
    final icon = switch (status.value) {
      's' || '2' => Icons.done,
      'w' || '1' => Icons.hourglass_bottom_rounded,
      _ => Icons.close,
    };
    final title = switch (status.value) {
      's' || '2' => isDeposit ? tr.depositSuccess : tr.payment_success,
      'w' || '1' => isDeposit ? tr.depositProcessing : tr.paymentProcessing,
      _ => isDeposit ? context.tr.depositFailed : tr.payment_failed,
    };
    final text = switch (status.value) {
      's' || '2' => tr.payment_success_massage,
      'w' || '1' => tr.paymentProcessMsg,
      _ => tr.payment_failed_massage,
    };

    return Scaffold(
      body: RefreshIndicator(
        onRefresh: () async {
          checkOrderStatus();
        },
        child: Stack(
          children: [
            if (isLoading.value) const LinearProgressIndicator(),
            SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              padding: defaultPadding,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Image.asset(
                    Assets.illustration.payment.path,
                    height: 300,
                    width: double.infinity,
                  ),
                  const SizedBox(height: 20),
                  Container(
                    decoration: BoxDecoration(
                      color: color.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(100),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(10),
                      child: Icon(
                        icon,
                        size: 20,
                        color: color,
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                    width: double.infinity,
                  ),
                  Text(
                    title,
                    style: context.textTheme.titleLarge,
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 5),
                  Text(
                    text,
                    style: context.textTheme.bodyLarge,
                  ),
                  const SizedBox(height: 5),
                  if (orderId != null) ...[
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          '${tr.order_id}: ',
                          style: context.textTheme.titleMedium,
                        ),
                        Text(
                          orderId,
                          style: context.textTheme.titleMedium?.copyWith(
                            color: context.colors.primary,
                          ),
                        ),
                        const Gap(Insets.sm),
                        InkWell(
                          borderRadius: BorderRadius.circular(100),
                          onTap: () => Clipper.copy(orderId),
                          child: Padding(
                            padding: Insets.padSym(10, 10),
                            child: const Icon(Icons.copy, size: 16),
                          ),
                        ),
                        InkWell(
                          borderRadius: BorderRadius.circular(100),
                          onTap: () => RouteNames.orderDetails
                              .pushNamed(context, query: {'id': orderId}),
                          child: Padding(
                            padding: Insets.padSym(10, 10),
                            child: const Icon(Icons.open_in_new, size: 16),
                          ),
                        ),
                      ],
                    ),
                    const Gap(Insets.med),
                  ],
                  if (ref.watch(authCtrlProvider) && !isDeposit)
                    GestureDetector(
                      onTap: () => RouteNames.orders.pushNamed(context),
                      child: Text(
                        tr.order_history,
                        style: context.textTheme.bodyLarge!.copyWith(
                          decorationColor: context.colors.primary,
                          fontWeight: FontWeight.bold,
                          color: context.colors.primary,
                        ),
                      ),
                    ),
                  const SizedBox(height: 30),
                  SubmitButton(
                    onPressed: () => RouteNames.home.goNamed(context),
                    child: Text(tr.continue_shopping),
                  ),
                  const SizedBox(height: 100),
                  Text(
                    tr.have_question,
                    style: context.textTheme.bodyLarge,
                  ),
                  GestureDetector(
                    onTap: () => RouteNames.supportTicket.pushNamed(context),
                    child: Text(
                      tr.customer_support,
                      style: context.textTheme.bodyLarge?.copyWith(
                        decorationColor: context.colors.primary,
                        fontWeight: FontWeight.bold,
                        color: context.colors.primary,
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
