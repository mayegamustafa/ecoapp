import 'dart:io';

import 'package:dio/dio.dart';
import 'package:e_com/_core/_core.dart';
import 'package:e_com/models/models.dart';
import 'package:fpdart/fpdart.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

final chatWithSellerRepoProvider = Provider<ChatWithSellerRepoRepo>((ref) {
  return ChatWithSellerRepoRepo(ref);
});

class ChatWithSellerRepoRepo {
  ChatWithSellerRepoRepo(this._ref);

  final Ref _ref;
  DioClient get _dio => DioClient(_ref);

  FutureEither<ApiResponse<List<Seller>>> getChat() async {
    try {
      final response = await _dio.get(Endpoints.sellerChatList);

      final res = ApiResponse.fromMap(
        response.data,
        (map) => List<Seller>.from(
          map['sellers']?['data'].map(
            (x) => Seller.fromMap(x),
          ),
        ),
      );

      return right(res);
    } on DioException catch (e, s) {
      final failure = DioExp(e).toFailure(s);
      return left(failure);
    }
  }

  FutureEither<ApiResponse<PagedItem<SellerMassage>>> loadMoreFromUrl(
      String url) async {
    try {
      final response = await _dio.get(url);

      final res = ApiResponse.fromMap(
        response.data,
        (map) => PagedItem<SellerMassage>.fromMap(
            map['messages'], (e) => SellerMassage.fromMap(e)),
      );

      return right(res);
    } on DioException catch (e) {
      final failure = DioExp(e).toFailure();
      return left(failure);
    }
  }

  FutureEither<ApiResponse<SellerChat>> getChatDetails(String id) async {
    try {
      final response = await _dio.get(Endpoints.sellerChatDetails(id));

      final res = ApiResponse.fromMap(
        response.data,
        (map) => SellerChat.fromMap(map),
      );

      return right(res);
    } on DioException catch (e) {
      final failure = DioExp(e).toFailure();
      return left(failure);
    }
  }

  FutureEither<ApiResponse<String>> sendReply(
    String sellerId,
    String message,
    List<File> files,
  ) async {
    try {
      final multiFiles = <MultipartFile>[];
      for (var file in files) {
        multiFiles.add(await MultipartFile.fromFile(file.path));
      }

      final response = await _dio.post(
        Endpoints.sellerChatReply,
        data: {
          'seller_id': sellerId,
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
