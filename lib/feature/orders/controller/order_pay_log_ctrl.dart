import 'package:e_com/feature/orders/repository/order_repo.dart';

import '../../../main.export.dart';

final orderPaymentLogProvider =
    NotifierProvider<OrderPaymentLogNotifier, PaymentLog?>(
        OrderPaymentLogNotifier.new);

class OrderPaymentLogNotifier extends Notifier<PaymentLog?> {
  @override
  PaymentLog? build() => null;

  Future<String> statusCheck(String trx) async {
    final result = await ref.watch(orderRepoProvider).getPaymentLog(trx);

    return result.fold(
      (l) => '3',
      (r) => r.data.payStatus.toString(),
    );
  }
}
