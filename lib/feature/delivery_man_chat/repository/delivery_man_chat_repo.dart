import 'dart:io';

import 'package:dio/dio.dart';
import 'package:e_com/main.export.dart';
import 'package:fpdart/fpdart.dart';

final deliveryManChatRepoProvider = Provider<DeliveryManChatRepo>((ref) {
  return DeliveryManChatRepo(ref);
});

class DeliveryManChatRepo {
  DeliveryManChatRepo(this._ref);

  final Ref _ref;
  DioClient get _dio => DioClient(_ref);

  FutureEither<ApiResponse<List<DeliveryMan>>> getChat() async {
    try {
      final response = await _dio.get(Endpoints.deliveryManChatList);

      final res = ApiResponse.fromMap(
        response.data,
        (map) => List<DeliveryMan>.from(
          map['delivery_men']?['data'].map(
            (x) => DeliveryMan.fromMap(x),
          ),
        ),
      );

      return right(res);
    } on DioException catch (e) {
      final failure = DioExp(e).toFailure();
      return left(failure);
    }
  }

  FutureEither<ApiResponse<PagedItem<DeliveryManMessage>>> loadMoreFromUrl(
      String url) async {
    try {
      final response = await _dio.get(url);

      final res = ApiResponse.fromMap(
        response.data,
        (map) => PagedItem<DeliveryManMessage>.fromMap(
            map['messages'], (e) => DeliveryManMessage.fromMap(e)),
      );

      return right(res);
    } on DioException catch (e) {
      final failure = DioExp(e).toFailure();
      return left(failure);
    }
  }

  FutureEither<ApiResponse<DeliveryManChat>> getChatDetails(String id) async {
    try {
      final response = await _dio.get(Endpoints.deliveryManChatDetails(id));

      final res = ApiResponse.fromMap(
        response.data,
        (map) => DeliveryManChat.fromMap(map),
      );

      return right(res);
    } on DioException catch (e) {
      final failure = DioExp(e).toFailure();
      return left(failure);
    }
  }

  FutureEither<ApiResponse<String>> sendReply(
    String deliverymanId,
    String message,
    List<File> files,
  ) async {
    try {
      final multiFiles = <MultipartFile>[];
      for (var file in files) {
        multiFiles.add(await MultipartFile.fromFile(file.path));
      }

      final response = await _dio.post(
        Endpoints.deliveryManChatReply,
        data: {
          'deliveryman_id': deliverymanId,
          'message': message,
          'files': multiFiles,
        },
      );

      final res = ApiResponse.fromMap(
          response.data, (map) => map['message'].toString());

      return right(res);
    } on DioException catch (e) {
      final failure = DioExp(e).toFailure();
      return left(failure);
    }
  }
}
