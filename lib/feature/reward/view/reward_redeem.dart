import 'package:e_com/main.export.dart';
import 'package:flutter/material.dart';

class RewardRedeemView extends ConsumerWidget {
  const RewardRedeemView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: Text(context.tr.rewardRedeem),
      ),
      body: const SingleChildScrollView(
        child: Column(
          children: [],
        ),
      ),
    );
  }
}
