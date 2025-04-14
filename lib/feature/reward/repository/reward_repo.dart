import 'package:e_com/main.export.dart';

final rewardRepoProvider = Provider<RewardRepo>((ref) {
  return RewardRepo(ref);
});

class RewardRepo with ApiHandler {
  const RewardRepo(this._ref);

  final Ref _ref;

  DioClient get _dio => DioClient(_ref);

  FutureEither<ApiResponse<RewardInfo>> getRewardInfo({
    int? status,
    String date = '',
  }) async {
    final url = Uri(
      path: Endpoints.rewardLog,
      queryParameters: {
        if (status != null) 'status': '$status',
        if (date.isNotEmpty) 'date': date,
      },
    );
    final data = await apiCallHandlerBase(
      call: () => _dio.get(url.toString()),
      mapper: (map) => RewardInfo.fromMap(map),
    );

    return data;
  }

  FutureEither<ApiResponse<PostMessage>> redeemPoint(int id) async {
    final data = await apiCallHandlerBase(
      call: () => _dio.post(
        Endpoints.redeemPoint,
        data: {'reward_id': id},
      ),
      mapper: (map) => PostMessage.fromMap(map),
    );

    return data;
  }

  FutureEither<ApiResponse<RewardInfo>> fromUrl(String url) async {
    final data = await apiCallHandlerBase(
      call: () => _dio.get(url),
      mapper: (map) => RewardInfo.fromMap(map),
    );
    return data;
  }
}
