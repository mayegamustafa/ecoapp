import 'package:e_com/_core/_core.dart';
import 'package:e_com/feature/campaign/providers/campaign_provider.dart';
import 'package:e_com/feature/campaign/view/local/campaign_loader.dart';
import 'package:e_com/feature/campaign/view/local/campaign_tile.dart';
import 'package:e_com/models/base/paged_item.dart';
import 'package:e_com/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class CampaignsView extends ConsumerWidget {
  const CampaignsView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final campaignData = ref.watch(campaignListProvider);

    return Scaffold(
      appBar: KAppBar(title: Text(context.tr.campaign)),
      body: RefreshIndicator(
        onRefresh: () => ref.read(campaignListProvider.notifier).reload(),
        child: campaignData.when(
          loading: () => const CampaignLoader(),
          error: ErrorView.new,
          data: (campaign) {
            final PagedItem(:listData, :pagination) = campaign;
            return ListViewWithFooter(
              onNext: () {
                ref.read(campaignListProvider.notifier).next();
              },
              onPrevious: () {
                ref.read(campaignListProvider.notifier).previous();
              },
              itemCount: listData.length,
              pagination: pagination,
              physics: defaultScrollPhysics,
              emptyListWidget:
                  const Center(child: NoItemsAnimationWithFooter()),
              itemBuilder: (context, index) => SizedBox(
                height: 280,
                child: CampaignTile(
                  campaign: listData[index],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
