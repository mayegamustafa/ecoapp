import 'dart:convert';

import 'package:e_com/_core/_core.dart';

class PaginationInfo {
  PaginationInfo({
    required this.totalItem,
    required this.perPage,
    required this.currentPage,
    required this.lastPage,
    required this.from,
    required this.to,
    required this.prevPageUrl,
    required this.nextPageUrl,
    required this.path,
  });

  factory PaginationInfo.fromJson(String source) =>
      PaginationInfo.fromMap(json.decode(source));

  factory PaginationInfo.fromMap(Map<String, dynamic> map) {
    return PaginationInfo(
      totalItem: map.parseInt('total'),
      perPage: map.parseInt('per_page'),
      currentPage: map.parseInt('current_page'),
      lastPage: map.parseInt('last_page'),
      from: map.parseInt('from'),
      to: map.parseInt('to'),
      prevPageUrl: map['prev_page_url'],
      nextPageUrl: map['next_page_url'],
      path: map['path'] ?? '',
    );
  }

  final int currentPage;
  final int from;
  final int lastPage;
  final String? nextPageUrl;
  final String path;
  final int perPage;
  final String? prevPageUrl;

  final int to;
  final int totalItem;

  int get limitedTotal => lastPage > 3 ? 3 : lastPage;

  Map<String, dynamic> toMap() {
    final result = <String, dynamic>{};

    result.addAll({'total': totalItem});
    result.addAll({'per_page': perPage});
    result.addAll({'current_page': currentPage});
    result.addAll({'last_page': lastPage});
    result.addAll({'from': from});
    result.addAll({'to': to});
    result.addAll({'prev_page_url': prevPageUrl});
    result.addAll({'next_page_url': nextPageUrl});
    result.addAll({'path': path});

    return result;
  }

  String toJson() => json.encode(toMap());
}
