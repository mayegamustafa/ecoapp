import 'package:e_com/main.export.dart';

final depositRepoProvider = Provider<DepositRepo>((ref) {
  return DepositRepo(ref);
});

class DepositRepo with ApiHandler {
  const DepositRepo(this._ref);

  final Ref _ref;

  DioClient get _dio => DioClient(_ref);
  FutureEither<ApiResponse<PagedItem<PaymentLog>>> getDepositLog({
    String trx = '',
    String date = '',
  }) async {
    final url = Uri(path: Endpoints.depositLogs, queryParameters: {
      if (trx.isNotEmpty) 'trx_code': trx,
      if (date.isNotEmpty) 'date': date
    });
    final data = await apiCallHandlerBase(
      call: () => _dio.get(url.toString()),
      mapper: (map) =>
          PagedItem.fromMap(map['deposit_logs'], (x) => PaymentLog.fromMap(x)),
    );
    return data;
  }

  FutureEither<ApiResponse<PagedItem<PaymentLog>>> fromUrl(String url) async {
    final data = await apiCallHandlerBase(
      call: () => _dio.get(url),
      mapper: (map) =>
          PagedItem.fromMap(map['deposit_logs'], (x) => PaymentLog.fromMap(x)),
    );
    return data;
  }

  FutureEither<ApiResponse<PostMeg<PaymentLog>>> makeDeposit(QMap form) async {
    final data = await apiCallHandlerBase(
      call: () => _dio.post(Endpoints.makeDeposit, data: form),
      mapper: (map) {
        return PostMeg.fromMap(
          map,
          (m) => PaymentLog.fromMap(
            m['log'] ?? m['payment_log'],
            m['payment_url'],
          ),
        );
      },
    );

    return data;
  }
}
