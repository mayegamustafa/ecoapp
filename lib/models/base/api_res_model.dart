import 'dart:convert';

import 'package:e_com/_core/_core.dart';
import 'package:e_com/models/settings/region_model.dart';

class ApiResponse<T> {
  ApiResponse({
    required this.code,
    required this.currency,
    required this.data,
    required this.locale,
    required this.message,
    required this.status,
  });

  factory ApiResponse.fromJson(
    String source,
    T Function(dynamic source) fromJsonT,
  ) {
    return ApiResponse.fromMap(json.decode(source), fromJsonT);
  }

  factory ApiResponse.fromMap(
    Map<String, dynamic> map,
    T Function(Map<String, dynamic> data) fromJsonT,
  ) {
    return ApiResponse<T>(
      code: map.parseInt('code'),
      currency: Currency.fromMap(map['currency']),
      data: fromJsonT(map['data']),
      locale: map['locale'] as String,
      message: map['message'] as String,
      status: map['status'] as String,
    );
  }

  final int code;
  final Currency currency;
  final T data;
  final String locale;
  final String message;
  final String status;

  Map<String, dynamic> toMap(Object Function(T) toJsonT) {
    return {
      'code': code,
      'currency': currency,
      'data': toJsonT(data),
      'locale': locale,
      'message': message,
      'status': status,
    };
  }

  String toJson(Object Function(T) toJsonT) => json.encode(toMap(toJsonT));
}

class PostMeg<T> {
  const PostMeg({
    required this.msg,
    required this.data,
  });

  final String? msg;
  final T data;

  factory PostMeg.fromMap(Map<String, dynamic> map, FromJsonT<T> data) {
    return PostMeg(
      msg: map['message']?.toString(),
      data: data(map),
    );
  }
}
