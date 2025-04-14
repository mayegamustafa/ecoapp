import 'package:e_com/main.export.dart';

final withdrawRepoProvider = Provider<WithdrawRepo>((ref) {
  return WithdrawRepo(ref);
});

class WithdrawRepo with ApiHandler {
  const WithdrawRepo(this._ref);

  final Ref _ref;

  DioClient get _dio => DioClient(_ref);

  FutureEither<ApiResponse<List<WithdrawMethod>>> getMethods() async {
    final data = await apiCallHandlerBase(
      call: () => _dio.get(Endpoints.withdrawMethods),
      mapper: (map) => List<WithdrawMethod>.from(
        map['methods']?['data']?.map((x) => WithdrawMethod.fromMap(x)) ?? [],
      ),
    );

    return data;
  }

  FutureEither<ApiResponse<PagedItem<WithdrawData>>> getWithdrawList({
    String search = '',
    String date = '',
  }) async {
    final url = Uri(
      path: Endpoints.withdrawList,
      queryParameters: {
        if (search.isNotEmpty) 'search': search,
        if (date.isNotEmpty) 'date': date,
      },
    );
    final data = await apiCallHandlerBase(
      call: () => _dio.get(url.toString()),
      mapper: (map) => PagedItem.fromMap(
        map['withdraw_list'],
        (v) => WithdrawData.fromMap(v),
      ),
    );

    return data;
  }

  FutureEither<ApiResponse<PagedItem<WithdrawData>>> getWithdrawListFromUrl(
    String url,
  ) async {
    final data = await apiCallHandlerBase(
      call: () => _dio.get(url),
      mapper: (map) => PagedItem<WithdrawData>.fromMap(
        map['withdraw_list'],
        (v) => WithdrawData.fromMap(v),
      ),
    );

    return data;
  }

  FutureEither<ApiResponse<({String msg, WithdrawData data})>> request(
    String method,
    String amount,
  ) async {
    final data = await apiCallHandlerBase(
      call: () => _dio.post(
        Endpoints.withdrawRequest,
        data: {'id': method, 'amount': amount},
      ),
      mapper: (map) {
        return (
          msg: '${map['message']}',
          data: WithdrawData.fromMap(map['withdraw'])
        );
      },
    );

    return data;
  }

  FutureEither<ApiResponse<String>> storeWithdraw(
    String id,
    Map<String, dynamic> formData,
  ) async {
    final body = {'id': id, ...formData};
    final data = await apiCallHandlerBase(
      call: () => _dio.post(Endpoints.withdrawStore, data: body),
      mapper: (map) => map['message'].toString(),
    );

    return data;
  }
}
