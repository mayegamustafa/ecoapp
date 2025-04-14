import 'dart:async';

import 'package:e_com/_core/_core.dart';
import 'package:e_com/feature/auth/controller/auth_ctrl.dart';
import 'package:e_com/feature/cart/repository/carts_repo.dart';
import 'package:e_com/feature/cart/repository/guest_carts.repo.dart';
import 'package:e_com/feature/user_dash/controller/dash_ctrl.dart';
import 'package:e_com/feature/user_dash/provider/user_dash_provider.dart';
import 'package:e_com/feature/user_dash/repository/dash_repo.dart';
import 'package:e_com/models/models.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

final cartCtrlProvider =
    AsyncNotifierProvider<CartCtrl, PagedItem<CartData>>(CartCtrl.new);

class CartCtrl extends AsyncNotifier<PagedItem<CartData>> {
  @override
  FutureOr<PagedItem<CartData>> build() {
    final isLoggedIn = ref.watch(authCtrlProvider);
    if (!isLoggedIn) return ref.read(guestCartRepoProvider).getCart();
    final carts = ref.watch(userDashProvider.select((value) => value?.carts));

    return carts ?? const PagedItem.empty();
  }

  CartsRepo get _repo => ref.watch(cartsRepoProvider);

  Future<void> paginationHandler(bool isNext) async {
    final stateData = await future;
    final url = isNext
        ? stateData.pagination?.nextPageUrl
        : stateData.pagination?.prevPageUrl;

    if (url == null) return;
    state = const AsyncValue.loading();

    final repo = ref.watch(userDashRepoProvider);

    final res = await repo.dashFromUrl(url);
    res.fold(
      (l) => state = AsyncError(l, StackTrace.current),
      (r) => state = AsyncData(r.data.carts),
    );
  }

  Future<void> reload() async {
    state = const AsyncValue.loading();
    if (ref.read(authCtrlProvider)) {
      await ref.read(userDashCtrlProvider.notifier).reload();
    }
    ref.invalidateSelf();
  }

  Future<void> addToCart({
    required ProductsData product,
    String? cUid,
    String? attribute,
    int quantity = 1,
    Function()? onSuccess,
  }) async {
    final loggedIn = ref.read(authCtrlProvider);
    if (!loggedIn) {
      await _guestAddToCart(product, attribute);
      return;
    }
    await _userAddToCart(product, quantity, attribute, cUid, onSuccess);
  }

  Future<void> _userAddToCart(
    ProductsData product,
    int quantity,
    String? attribute,
    String? cUid,
    Function()? onSuccess,
  ) async {
    final res = await _repo.addToCart(
      productUid: product.uid,
      quantity: quantity,
      attribute: attribute,
      campaignUid: cUid,
    );

    await res.fold(
      (l) async => Toaster.showError(l),
      (r) async {
        onSuccess?.call();
        await ref.read(userDashCtrlProvider.notifier).reload();
        Toaster.showSuccess(r.data.message);
      },
    );
  }

  Future<void> _guestAddToCart(ProductsData product, String? attribute) async {
    final repo = ref.read(guestCartRepoProvider);
    final message = await repo.addToCart(product, attribute);
    message.fold(
      (l) => Toaster.showError(l),
      (r) => Toaster.showSuccess(r),
    );
    ref.invalidateSelf();
  }

  Future<void> deleteCart(BuildContext context, String pUid) async {
    final isLoggedIn = ref.watch(authCtrlProvider);
    if (!isLoggedIn) {
      final repo = ref.read(guestCartRepoProvider);
      final message = await repo.deleteCart(pUid);

      Toaster.showSuccess(message);
      ref.invalidateSelf();
      return;
    }
    final res = await _repo.deleteCart(pUid);
    await res.fold(
      (l) async => Toaster.showError(l),
      (r) async {
        await ref.read(userDashCtrlProvider.notifier).reload();
        Toaster.showSuccess(r.data.message);
      },
    );
  }

  Future<void> updateQuantity(String cartUid, int quantity) async {
    final isLoggedIn = ref.watch(authCtrlProvider);
    if (!isLoggedIn) {
      final repo = ref.read(guestCartRepoProvider);
      await repo.updateQuantity(cartUid, quantity);
      ref.invalidateSelf();
      return;
    }
    final res = await _repo.updateQuantity(uid: cartUid, quantity: quantity);
    await res.fold(
      (l) async => Toaster.showError(l),
      (r) async {
        ref.read(userDashCtrlProvider.notifier).reload();
        final stateData = await future;
        final data = [
          for (final cart in stateData.listData)
            if (cart.uid == cartUid)
              cart.copyWith(
                quantity: quantity,
                total: cart.price * quantity,
              )
            else
              cart,
        ];
        state = AsyncValue.data(stateData.copyWith(listData: data));
      },
    );
  }

  Future<void> transferFromGuest() async {
    final carts = ref.read(guestCartRepoProvider).getCart();
    if (carts.isEmpty) return;
    final res = await _repo.transferFromGuest(carts.listData);

    await res.fold(
      (l) async => Toaster.showError(l),
      (r) async {
        await ref.read(guestCartRepoProvider).clearAll();
        ref.read(userDashCtrlProvider.notifier).reload();
      },
    );
  }

  Future<void> clearGuestCart() async {
    final isLoggedIn = ref.watch(authCtrlProvider);
    if (isLoggedIn) return;
    await ref.read(guestCartRepoProvider).clearAll();
    ref.invalidateSelf();
  }
}
