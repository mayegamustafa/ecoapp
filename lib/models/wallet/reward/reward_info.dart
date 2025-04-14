import 'package:e_com/main.export.dart';

class RewardInfo {
  const RewardInfo({
    required this.rewardLogs,
    required this.overview,
  });

  final PagedItem<RewardLog> rewardLogs;
  final RewardOverview overview;

  factory RewardInfo.fromMap(Map<String, dynamic> map) {
    return RewardInfo(
      rewardLogs: PagedItem.fromMap(
        map['reward_logs'],
        (x) => RewardLog.fromMap(x),
      ),
      overview: RewardOverview.fromMap(map['reward_overview']),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'reward_logs': rewardLogs.toMap((x) => x.toString()),
      'reward_overview': overview.toMap(),
    };
  }
}
