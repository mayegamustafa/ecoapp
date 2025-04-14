import 'package:e_com/_core/_core.dart';
import 'package:e_com/models/models.dart';
import 'package:fpdart/fpdart.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

final guestCartRepoProvider = Provider<GuestCartRepo>((ref) {
  return GuestCartRepo(ref);
});

class GuestCartRepo {
  GuestCartRepo(this._ref);
  final Ref _ref;

  final int _limit = 5;

  final _key = CachedKeys.guestCart;
  SharedPreferences get _pref => _ref.watch(sharedPrefProvider);

  PagedItem<CartData> getCart() {
    final data = _pref.getString(_key);

    final res = PagedItem<CartData>.fromJson(
      data,
      (x) => CartData.fromMap(x),
    );
    return res;
  }

  Future<void> clearAll() async => await _pref.remove(_key);

  Future<String> deleteCart(String id) async {
    final old = getCart();
    final data = PagedItem(
      listData: old.listData.where((element) => element.uid != id).toList(),
      pagination: null,
    );

    await _pref.setString(_key, data.toJson((x) => x.toMap()));

    return 'Product deleted from cart';
  }

  FutureEither<String> addToCart(
    ProductsData product,
    String? variant,
  ) async {
    final old = getCart();
    if (old.length >= _limit) {
      return left(const Failure('Cart limit reached'));
    }
    if (old.listData.any((element) => element.uid == product.uid)) {
      return left(const Failure('Product already in cart'));
    }
    final att =
        product.variantPrices[variant] ?? product.variantPrices.values.first;

    if (att.quantity <= 0) {
      return left(const Failure('Product out of stock'));
    }
    final tax = product.totalAdditiveTax(att.baseDiscount);

    final cart = CartData(
      product: product,
      uid: product.uid,
      basePrice: att.basePrice,
      baseDiscount: att.baseDiscount,
      price: att.price,
      discount: att.discount,
      originalTotal: att.price * 1,
      total: att.discount * 1,
      tax: tax,
      totalTaxes: tax * 1,
      variant: variant ?? product.variantPrices.keys.first,
      quantity: 1,
    );

    final data = PagedItem(
      listData: [...old.listData, cart],
      pagination: null,
    );
    await _pref.setString(_key, data.toJson((x) => x.toMap()));
    return right('Product added to cart');
  }

  Future<void> updateQuantity(String cartUid, int quantity) async {
    if (quantity <= 0) return;

    final old = getCart();

    final cart = [
      for (final cart in old.listData)
        if (cart.uid == cartUid)
          cart.copyWith(
            quantity: quantity,
            total: cart.discount * quantity,
            originalTotal: (cart.price) * quantity,
            totalTaxes: (cart.tax) * quantity,
          )
        else
          cart,
    ];

    final data = old.copyWith(listData: cart);

    await _pref.setString(_key, data.toJson((x) => x.toMap()));

    return;
  }
}
