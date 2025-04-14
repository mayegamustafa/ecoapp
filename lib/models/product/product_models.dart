import 'dart:convert';

import 'package:collection/collection.dart';
import 'package:e_com/_core/_core.dart';
import 'package:e_com/feature/region_settings/repository/region_repo.dart';
import 'package:e_com/locator.dart';
import 'package:e_com/models/models.dart';

class ProductsData {
  const ProductsData({
    required this.uid,
    required this.name,
    required this.order,
    required this.brandNames,
    required this.categoryNames,
    required this.price,
    required this.discountAmount,
    required this.inStock,
    required this.shortDescription,
    required this.description,
    required this.maximumPurchaseQty,
    required this.minimumPurchaseQty,
    required this.rating,
    required this.featuredImage,
    required this.galleryImage,
    required this.shippingInfo,
    required this.variants,
    required this.variantPrices,
    required this.url,
    required this.store,
    required this.weight,
    required this.shippingFee,
    required this.multiplyFee,
    required this.taxes,
    required this.clubPoint,
  });

  factory ProductsData.fromJson(String source) =>
      ProductsData.fromMap(json.decode(source));

  factory ProductsData.fromMap(Map<String, dynamic> map) {
    return ProductsData(
      brandNames: Map<String, String?>.from(map['brand']),
      categoryNames: Map<String, String?>.from(map['category']),
      description: map['description'] ?? '',
      featuredImage: map['featured_image'] ?? '',
      galleryImage: List<String>.from(map['gallery_image']),
      inStock: map['in_stock'] ?? false,
      maximumPurchaseQty: map.parseInt('maximum_purchase_qty'),
      minimumPurchaseQty: map.parseInt('minimum_purchaseqty'),
      name: map['name'] ?? '',
      order: map.parseInt('order'),
      price: map.parseNum('price'),
      discountAmount: map.parseNum('discount_amount'),
      rating: Rating.fromMap(map['rating']),
      shippingInfo: List<ShippingData>.from(
          map['shipping_info']['data']?.map((x) => ShippingData.fromMap(x))),
      shortDescription: map['short_description'] ?? '',
      uid: map['uid'] ?? '',
      variants: map['varient'] is! List
          ? []
          : List<Variant>.from(map['varient'].map((x) => Variant.fromMap(x))),
      variantPrices: map['varient_price'] is! Map
          ? {}
          : Map<String, dynamic>.from(map['varient_price'])
              .map((k, v) => MapEntry(k, VariantPrice.fromMap(v))),
      url: map['url'] ?? '',
      store: map['seller'] == null ? null : StoreModel.fromMap(map['seller']),
      weight: map.parseNum('weight'),
      shippingFee: map.parseNum('shipping_fee'),
      multiplyFee: map['shipping_fee_multiply_by_qty'] ?? false,
      taxes: Tax.fromList(map['taxes']),
      clubPoint: map.parseNum('club_point'),
    );
  }

  final Map<String, String?> brandNames;
  final Map<String, String?> categoryNames;
  final String description;
  final num discountAmount;
  final String featuredImage;
  final List<String> galleryImage;
  final bool inStock;
  final int maximumPurchaseQty;
  final int minimumPurchaseQty;
  final bool multiplyFee;
  final String name;
  final int order;
  final num price;
  final Rating rating;
  final num shippingFee;
  final List<ShippingData> shippingInfo;
  final String shortDescription;
  final StoreModel? store;
  final List<Tax> taxes;
  final String uid;
  final String url;
  final List<Variant> variants;
  final Map<String, VariantPrice> variantPrices;
  final num weight;
  final num clubPoint;

  String get category {
    final local = locate<RegionRepo>().getLanguage();

    return categoryNames[local] ?? categoryNames.firstNoneNull() ?? 'N/A';
  }

  String get brand {
    final local = locate<RegionRepo>().getLanguage();

    return brandNames[local] ?? brandNames.firstNoneNull() ?? 'N/A';
  }

  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'name': name,
      'order': order,
      'brand': brandNames,
      'category': categoryNames,
      'price': price,
      'discount_amount': discountAmount,
      'in_stock': inStock,
      'short_description': shortDescription,
      'description': description,
      'maximum_purchase_qty': maximumPurchaseQty,
      'minimum_purchaseqty': minimumPurchaseQty,
      'rating': rating.toMap(),
      'featured_image': featuredImage,
      'gallery_image': galleryImage,
      'shipping_info': {'data': shippingInfo.map((e) => e.toMap()).toList()},
      'varient': variants.map((e) => e.toMap()).toList(),
      'varient_price': variantPrices.map((k, v) => MapEntry(k, v.toMap())),
      'url': url,
      'seller': store?.toMap(),
      'weight': weight,
      'shipping_fee': shippingFee,
      'shipping_fee_multiply_by_qty': multiplyFee,
      'taxes': {'data': taxes.map((e) => e.toMap()).toList()},
      'club_point': clubPoint,
    };
  }

  num calculatedPrice(num price) {
    return price + totalAdditiveTax(price);
  }

  num totalAdditiveTax(num price) {
    final flats = taxes
        .where((e) => !e.isPercentage())
        .map((e) => e.amount)
        .sum
        .formateSelf(rateCheck: true);

    final percentage =
        taxes.where((e) => e.isPercentage()).map((e) => e.amount).sum;

    final percentPrice = price * (percentage / 100);

    return percentPrice + flats;
  }

  String toJson() => json.encode(toMap());

  bool get isDiscounted => price != discountAmount;

  // List<String> get variantNames => variants.map((e) => e.name).toList();

  // List<String> variantsByType(String type) =>
  //     variants[type].map((e) => e.toString()).toList();

  int get stockCount {
    int quantity = 0;
    variantPrices.forEach((key, value) {
      quantity += value.quantity;
    });
    return quantity;
  }

  bool get availableAny => stockCount > 0;
}
