import 'dart:io';

import 'package:dio/dio.dart';
import 'package:e_com/main.export.dart';
import 'package:fpdart/fpdart.dart';

mixin ApiHandler {
  // @Deprecated('Use apiCallHandlerBase instead')
  FutureEither<T> apiCallHandler<T>({
    required Future<Response> Function() call,
    required T Function(Map<String, dynamic> map) mapper,
  }) async {
    try {
      final Response(:statusCode, :data) = await call.call();

      if (statusCode != null && statusCode >= 200 && statusCode < 300) {
        var decode = data as Map<String, dynamic>;
        return right(mapper(decode));
      } else {
        return failure('Call ended with code $statusCode', data);
      }
    } on SocketException catch (e, st) {
      return failure(e.message, e, st);
    } on DioException catch (e, st) {
      return left(DioExp(e).toFailure(st));
    } on Failure catch (e, st) {
      return left(e.copyWith(stackTrace: st));
    } catch (e, st) {
      return failure('$e', e, st);
    }
  }

  FutureEither<ApiResponse<T>> apiCallHandlerBase<T>({
    required Future<Response> Function() call,
    required T Function(Map<String, dynamic> data) mapper,
    bool logOnError = true,
  }) async {
    try {
      final Response(:statusCode, :data) = await call.call();

      if (statusCode != null && statusCode >= 200 && statusCode < 300) {
        final mapped = data as Map<String, dynamic>;
        final response = ApiResponse.fromMap(mapped, mapper);

        return right(response);
      } else {
        return failure('Call ended with code $statusCode', data);
      }
    } on SocketException catch (e, st) {
      return failure(e.message, e, st);
    } on DioException catch (e, st) {
      return left(DioExp(e).toFailure(st));
    } on Failure catch (e, st) {
      return left(e.copyWith(stackTrace: st));
    } catch (e, st) {
      return failure('$e', e, st);
    }
  }
}
