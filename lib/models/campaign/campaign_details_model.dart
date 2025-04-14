import 'package:e_com/models/models.dart';

class CampaignDetails {
  CampaignDetails({
    required this.campaign,
    required this.products,
  });

  factory CampaignDetails.fromMap(Map<String, dynamic> map) {
    return CampaignDetails(
      campaign: CampaignModel.fromMap(map['campaign']),
      products: PagedItem<ProductsData>.fromMap(
          map['products'], (x) => ProductsData.fromMap(x)),
    );
  }

  final CampaignModel campaign;
  final PagedItem<ProductsData> products;

  CampaignDetails copyWith({
    CampaignModel? campaign,
    PagedItem<ProductsData>? products,
  }) {
    return CampaignDetails(
      campaign: campaign ?? this.campaign,
      products: products ?? this.products,
    );
  }

  CampaignDetails updateList(List<ProductsData> products) {
    return CampaignDetails(
      campaign: campaign,
      products: this.products.copyWith(listData: products),
    );
  }
}
