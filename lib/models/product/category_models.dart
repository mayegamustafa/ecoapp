import 'dart:convert';

import 'package:e_com/_core/_core.dart';
import 'package:e_com/feature/region_settings/repository/region_repo.dart';
import 'package:e_com/locator.dart';
import 'package:e_com/models/models.dart';

class CategoriesBase {
  CategoriesBase({required this.categoriesData});

  factory CategoriesBase.fromJson(String source) =>
      CategoriesBase.fromMap(json.decode(source));

  factory CategoriesBase.fromMap(Map<String, dynamic> map) {
    return CategoriesBase(
      categoriesData: List<CategoriesData>.from(
          map['data']?.map((x) => CategoriesData.fromMap(x))),
    );
  }

  final List<CategoriesData> categoriesData;

  Map<String, dynamic> toMap() {
    return {
      'data': categoriesData.map((x) => x.toMap()),
    };
  }
}

class CategoriesData {
  CategoriesData({
    required this.uid,
    required this.names,
    required this.image,
  });

  factory CategoriesData.fromJson(String source) =>
      CategoriesData.fromMap(json.decode(source));

  factory CategoriesData.fromMap(Map<String, dynamic> map) {
    return CategoriesData(
      uid: map['uid'] ?? '',
      names: Map<String, String?>.from(map['name']),
      image: map['image'] ?? '',
    );
  }

  String toJson() => json.encode(toMap());

  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'name': names,
      'image': image,
    };
  }

  String get name {
    final local = locate<RegionRepo>().getLanguage();

    return names[local] ?? names.firstNoneNull() ?? 'N/A';
  }

  final String image;
  final Map<String, String?> names;
  final String uid;
}

class CategoryDetails {
  CategoryDetails({
    required this.category,
    required this.products,
    required this.homeTitle,
  });

  factory CategoryDetails.fromJson(String source) =>
      CategoryDetails.fromMap(json.decode(source));

  factory CategoryDetails.fromMap(Map<String, dynamic> map) {
    return CategoryDetails(
      category: CategoriesData.fromMap(map['category']),
      products: PagedItem<ProductsData>.fromMap(
        map['products'],
        (x) => ProductsData.fromMap(x),
      ),
      homeTitle: map['title'],
    );
  }

  final CategoriesData category;
  final PagedItem<ProductsData> products;
  final String? homeTitle;

  Map<String, dynamic> toMap() {
    return {
      'category': category.toMap(),
      'products': products.toMap((data) => data.toMap()),
      'title': homeTitle,
    };
  }
}
