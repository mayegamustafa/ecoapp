import 'package:e_com/_core/_core.dart';
import 'package:e_com/models/models.dart';

class OrderDetails {
  const OrderDetails({
    required this.uid,
    required this.product,
    required this.digitalProduct,
    required this.orderId,
    required this.quantity,
    required this.totalPrice,
    required this.originalTotalPrice,
    required this.totalTax,
    required this.discount,
    required this.attribute,
    required this.digitalAttributes,
  });

  factory OrderDetails.fromMap(Map<String, dynamic> map) {
    final isRegular = !Map.from(map['product']).containsKey('attribute');

    return OrderDetails(
      uid: map['uid'] ?? '',
      product: isRegular ? ProductsData.fromMap(map['product']) : null,
      digitalProduct: isRegular ? null : DigitalProduct.fromMap(map['product']),
      orderId: map.parseInt('order_id'),
      quantity: map.parseInt('quantity'),
      totalPrice: map.parseNum('total_price'),
      originalTotalPrice: map.parseNum('original_total_price'),
      totalTax: map.parseNum('total_taxes'),
      discount: map.parseNum('discount'),
      attribute: map['attribute'] ?? '',
      digitalAttributes: map['digital_attributes'] is! List
          ? []
          : List<DigitalAttribute>.from(
              map['digital_attributes'].map((x) => DigitalAttribute.fromMap(x)),
            ),
    );
  }

  final String uid;
  final String? attribute;
  final DigitalProduct? digitalProduct;
  final int orderId;
  final ProductsData? product;
  final int quantity;
  final num totalPrice;
  final num originalTotalPrice;
  final num totalTax;
  final num discount;
  final List<DigitalAttribute> digitalAttributes;

  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'product': isRegular ? product?.toMap() : digitalProduct?.toMap(),
      'order_id': orderId,
      'quantity': quantity,
      'total_price': totalPrice,
      'original_total_price': originalTotalPrice,
      'total_taxes': totalTax,
      'discount': discount,
      'attribute': attribute,
      'digital_attributes': digitalAttributes.map((x) => x.toMap()).toList(),
    };
  }

  bool get isRegular => product != null;
}
