import 'package:e_com/main.export.dart';

final transactionsRepoProvider = Provider<TransactionRepo>((ref) {
  return TransactionRepo(ref);
});

class TransactionRepo with ApiHandler {
  const TransactionRepo(this._ref);

  final Ref _ref;

  DioClient get _dio => DioClient(_ref);

  FutureEither<ApiResponse<PagedItem<TransactionData>>> transactionList({
    String search = '',
    String date = '',
  }) async {
    final url = Uri(
      path: Endpoints.transactions,
      queryParameters: {
        if (search.isNotEmpty) 'search': search,
        if (date.isNotEmpty) 'date': date,
      },
    );
    final data = await apiCallHandlerBase(
      call: () => _dio.get(url.toString()),
      mapper: (map) => PagedItem<TransactionData>.fromMap(
        map['transactions'],
        (map) => TransactionData.fromMap(map),
      ),
    );

    return data;
  }

  FutureEither<ApiResponse<PagedItem<TransactionData>>> transactionListFromUrl(
    String url,
  ) async {
    final data = await apiCallHandlerBase(
      call: () => _dio.get(url),
      mapper: (map) => PagedItem.fromMap(
        map['transactions'],
        (x) => TransactionData.fromMap(x),
      ),
    );
    return data;
  }
}
