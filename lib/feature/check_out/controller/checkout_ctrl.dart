import 'package:e_com/_core/_core.dart';
import 'package:e_com/feature/auth/controller/auth_ctrl.dart';
import 'package:e_com/feature/cart/controller/carts_ctrl.dart';
import 'package:e_com/feature/check_out/repository/checkout_repo.dart';
import 'package:e_com/feature/settings/provider/settings_provider.dart';
import 'package:e_com/feature/user_dash/controller/dash_ctrl.dart';
import 'package:e_com/feature/user_dash/provider/user_dash_provider.dart';
import 'package:e_com/models/models.dart';
import 'package:flutter/foundation.dart';
import 'package:fpdart/fpdart.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:url_launcher/url_launcher_string.dart';

final checkoutCtrlProvider =
    AutoDisposeNotifierProvider<CheckoutCtrlNotifier, CheckoutModel>(
        CheckoutCtrlNotifier.new);

class CheckoutCtrlNotifier extends AutoDisposeNotifier<CheckoutModel> {
  @override
  CheckoutModel build() {
    final billing =
        ref.watch(userDashProvider.select((v) => v?.user.billingAddress));

    final carts =
        ref.watch(cartCtrlProvider.select((v) => v.valueOrNull?.listData));

    final settings = ref.watch(settingsProvider.select((v) => v?.zones));

    return CheckoutModel.empty.copyWith(
      billingAddress: billing?.firstOrNull,
      carts: carts,
      zones: settings,
    );
  }

  CheckoutRepo get _repo => ref.watch(checkoutRepoProvider);

  void setShipping(ShippingData shippingUid) =>
      state = state.copyWith(shippingUid: shippingUid);

  void setPayment(PaymentData payment) {
    final iCodActive = ref.watch(
      settingsProvider.select((v) => v?.settings.cashOnDelivery ?? false),
    );
    if (payment.isCOD && !iCodActive) {
      Toaster.showError('Cash on delivery is not available');
      return;
    }

    state = state.copyWith(payment: () => payment, inputs: {});
  }

  void setCodPayment() =>
      state = state.copyWith(payment: () => PaymentData.codPayment);

  void setBilling(BillingAddress address) {
    state = state.copyWith(billingAddress: address);
  }

  void setBillingFromMap(Map<String, dynamic> map) {
    final billing = state.billingAddress ?? BillingAddress.empty;
    state = state.copyWith(billingAddress: billing.copyWithMap(map));
  }

  void copyWithAddress({
    ValueGetter<Country?>? country,
    ValueGetter<CountryState?>? cState,
    ValueGetter<StateCity?>? city,
    ValueGetter<String?>? lat,
    ValueGetter<String?>? lng,
  }) {
    final billing = state.billingAddress ?? BillingAddress.empty;
    state = state.copyWith(
      billingAddress: billing.copyWith(
        country: country,
        state: cState,
        city: city,
        lat: lat,
        lng: lng,
      ),
    );
  }

  void setCoupon(String coupon) => state = state.copyWith(couponCode: coupon);

  void toggleCreateAccount() {
    state = state.copyWith(createAccount: !state.createAccount);
  }

  void updateWallet(bool isWallet) {
    state = state.copyWith(isWallet: isWallet, payment: () => null);
  }

  void setCustomInputData(Map<String, dynamic> inputs) {
    state = state.copyWith(inputs: inputs);
  }

  Future<void> submitOrder(
    Function(Either<String, OrderBaseModel> data, String oId) onSuccess,
  ) async {
    final isLoggedIn = ref.read(authCtrlProvider);

    final res = await _repo.submitOrder(state, !isLoggedIn);

    return await res.fold(
      (l) async {
        Toaster.showError(l);
        return;
      },
      (r) async {
        if (state.createAccount && r.data.accessToken != null) {
          await ref
              .read(authCtrlProvider.notifier)
              .setWildAccessToken(r.data.accessToken!);
        }

        await ref.read(cartCtrlProvider.notifier).clearGuestCart();

        if (isLoggedIn) await ref.read(userDashCtrlProvider.notifier).reload();

        Toaster.showSuccess(r.data.message);

        if (r.data.paymentUrl != null) {
          await launchUrlString(r.data.paymentUrl!);
          onSuccess(left(r.data.paymentLog.trx), r.data.order.orderId);

          return;
        }

        onSuccess(right(r.data), r.data.order.orderId);
      },
    );
  }

  Future<void> buyNow({
    required String productUid,
    required String digitalUid,
    required int? paymentUid,
    required String email,
    required Map<String, dynamic> formData,
    required bool isWallet,
    required Function(Either<String, OrderBaseModel> data) onSuccess,
  }) async {
    final isLoggedIn = ref.read(authCtrlProvider);
    final data = {
      'product_uid': productUid,
      'payment_id': paymentUid,
      'digital_attribute_uid': digitalUid,
      if (!isLoggedIn) 'email': email,
      'wallet_payment': isWallet ? '1' : '0',
      ...formData,
    }.nonNull();

    Toaster.showLoading('Loading...');
    final res = await _repo.submitDigitalOrder(data: data);

    res.fold(
      (l) => Toaster.showError(l),
      (r) async {
        Toaster.showSuccess(r.data.message);

        if (r.data.paymentUrl != null) {
          await launchUrlString(r.data.paymentUrl!);
          onSuccess(left(r.data.paymentLog.trx));
          Toaster.remove();
          return;
        }

        onSuccess(right(r.data));
      },
    );
    if (isLoggedIn) ref.read(userDashCtrlProvider.notifier).reload();
  }
}
