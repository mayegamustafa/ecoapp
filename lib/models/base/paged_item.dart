import 'dart:convert';

import 'package:e_com/models/models.dart';

class PagedItem<T> {
  const PagedItem({
    required this.listData,
    required this.pagination,
  });

  const PagedItem.empty()
      : listData = const [],
        pagination = null;

  bool get isEmpty => listData.isEmpty;
  bool get isNotEmpty => listData.isNotEmpty;
  int get length => listData.length;
  int get totalLength => pagination?.totalItem ?? 0;

  T operator [](int index) => listData[index];

  final List<T> listData;
  final PaginationInfo? pagination;

  factory PagedItem.fromJson(
    String? source,
    T Function(dynamic source) fromJsonT,
  ) =>
      PagedItem.fromMap(
        source == null ? {} : json.decode(source),
        fromJsonT,
      );

  factory PagedItem.fromMap(
    Map<String, dynamic> map,
    T Function(dynamic source) fromJsonT,
  ) {
    return PagedItem(
      listData: List<T>.from(map['data']?.map((x) => fromJsonT(x)) ?? []),
      pagination: map['pagination'] == null
          ? null
          : PaginationInfo.fromMap(map['pagination']),
    );
  }

  Map<String, dynamic> toMap(Object Function(T data) toJsonT) {
    return {
      'data': listData.map((x) => toJsonT(x)).toList(),
      'pagination': pagination?.toMap(),
    };
  }

  String toJson(Object Function(T data) toJsonT) {
    return json.encode(toMap(toJsonT));
  }

  PagedItem<T> copyWith({
    List<T>? listData,
    PaginationInfo? pagination,
  }) {
    return PagedItem<T>(
      listData: listData ?? this.listData,
      pagination: pagination ?? this.pagination,
    );
  }

  PagedItem<T> operator +(PagedItem<T> other) {
    return PagedItem<T>(
      listData: [...listData, ...other.listData],
      pagination: other.pagination,
    );
  }
}
