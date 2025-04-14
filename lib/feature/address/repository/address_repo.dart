import 'package:e_com/_core/_core.dart';
import 'package:e_com/models/models.dart';
import 'package:fpdart/fpdart.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

final addressRepoProvider = Provider<AddressRepo>((ref) {
  return AddressRepo(ref);
});

class AddressRepo {
  AddressRepo(this._ref);

  final Ref _ref;

  FutureEither<ApiResponse<UserModel>> createAddress(
    Map<String, dynamic> address,
  ) async {
    try {
      final response = await _dio.post(Endpoints.addressAdd, data: address);

      final res = ApiResponse.fromMap(
        response.data,
        (map) => UserModel.fromMap(map['user']),
      );

      return right(res);
    } on DioException catch (e) {
      return left(DioExp(e).toFailure());
    }
  }

  FutureEither<ApiResponse<UserModel>> deleteAddress(String key) async {
    try {
      final response = await _dio.get(Endpoints.addressDelete(key));
      final res = ApiResponse.fromMap(
        response.data,
        (map) => UserModel.fromMap(map['user']),
      );

      return right(res);
    } on DioException catch (e) {
      return left(DioExp(e).toFailure());
    }
  }

  FutureEither<ApiResponse<UserModel>> updateAddress(
    Map<String, dynamic> address,
    int id,
  ) async {
    try {
      final response = await _dio
          .post(Endpoints.addressUpdate, data: {'id': id, ...address});

      final res = ApiResponse.fromMap(
        response.data,
        (map) => UserModel.fromMap(map['user']),
      );

      return right(res);
    } on DioException catch (e) {
      return left(DioExp(e).toFailure());
    }
  }

  DioClient get _dio => DioClient(_ref);
}
