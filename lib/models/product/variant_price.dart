import 'package:e_com/_core/_core.dart';

class Variant {
  const Variant({
    required this.name,
    required this.attributes,
  });

  factory Variant.fromMap(Map<String, dynamic> map) {
    return Variant(
      name: map['name'],
      attributes: List<StockAttr>.from(
        map['stock_attributes']?.map((x) => StockAttr.fromMap(x)) ?? [],
      ),
    );
  }

  final List<StockAttr> attributes;
  final String name;

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'attributes': {
        'data': attributes.map((x) => x.toMap()).toList(),
      },
    };
  }
}

class StockAttr {
  const StockAttr({
    required this.name,
    required this.displayName,
  });

  factory StockAttr.fromMap(Map<String, dynamic> map) {
    return StockAttr(
      name: map['name'],
      displayName: map['display_name'],
    );
  }

  final String displayName;
  final String name;

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'display_name': displayName,
    };
  }
}

class VariantPrice {
  VariantPrice({
    required this.quantity,
    required this.price,
    required this.discount,
    required this.basePrice,
    required this.baseDiscount,
    required this.displayName,
  });

  factory VariantPrice.fromMap(Map<String, dynamic> map) {
    return VariantPrice(
      quantity: map.parseInt('qty'),
      price: map.parseNum('price'),
      discount: map.parseNum('discount'),
      basePrice: map.parseNum('base_price'),
      baseDiscount: map.parseNum('base_discount'),
      displayName: map['display_name'] ?? '',
    );
  }

  final num baseDiscount;
  final num basePrice;
  final num discount;
  final String displayName;
  final num price;
  final int quantity;

  Map<String, dynamic> toMap() {
    return {
      'qty': quantity,
      'price': price,
      'discount': discount,
      'base_price': basePrice,
      'base_discount': baseDiscount,
      'display_name': displayName,
    };
  }

  bool get isDiscounted => price != discount;

  VariantPrice copyWith({
    num? baseDiscount,
    num? basePrice,
    num? discount,
    num? price,
    int? quantity,
    String? displayName,
  }) {
    return VariantPrice(
      baseDiscount: baseDiscount ?? this.baseDiscount,
      basePrice: basePrice ?? this.basePrice,
      discount: discount ?? this.discount,
      price: price ?? this.price,
      quantity: quantity ?? this.quantity,
      displayName: displayName ?? this.displayName,
    );
  }
}
