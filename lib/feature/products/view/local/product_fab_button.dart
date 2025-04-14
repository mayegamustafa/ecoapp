import 'package:e_com/feature/auth/controller/auth_ctrl.dart';
import 'package:e_com/feature/cart/controller/carts_ctrl.dart';
import 'package:e_com/feature/settings/provider/settings_provider.dart';
import 'package:e_com/feature/user_dash/provider/user_dash_provider.dart';
import 'package:e_com/main.export.dart';
import 'package:flutter/material.dart';
import 'package:fpdart/fpdart.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

class ProductFabButton extends HookConsumerWidget {
  const ProductFabButton({
    super.key,
    required this.product,
    required this.selectedVariant,
    required this.campaignId,
    required this.onReviewTap,
    required this.isInStock,
    required this.onBuyTap,
  });

  final Function()? onReviewTap;
  final Function()? onBuyTap;
  final String? campaignId;
  final bool isInStock;
  final Either<ProductsData, DigitalProduct> product;

  final String? selectedVariant;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final orderedProducts = ref.watch(userDashProvider)?.allOrderedProductsID;
    final whatsApp =
        ref.watch(settingsProvider.select((v) => v?.settings.whatsappConfig));

    final isLoggedIn = ref.watch(authCtrlProvider);

    final cartsCtrl = useCallback(() => ref.read(cartCtrlProvider.notifier));

    final uid = product.fold((l) => l.uid, (r) => r.uid);
    final canReview = orderedProducts?.contains(uid) ?? false;

    final enableCart = isInStock;
    final isLoading = useState(false);

    final seller = product.fold((l) => l.store, (r) => r.store);

    final (waNum, isActive) =
        (seller?.whatsappNumber, seller?.whatsappActive ?? false);

    final useSeller = (waNum?.isNotEmpty ?? false) && isActive;
    final adminWAActive = whatsApp?.enabled ?? false;

    void orderViaWhatsapp() async {
      if (whatsApp == null) return;

      final query = {
        'phone': useSeller ? waNum : whatsApp.phone,
        'text': whatsApp.messageBuilder(product, selectedVariant ?? ''),
        'type': 'phone_number',
        'app_absent': '0',
      };

      final uri = Uri(
        scheme: 'https',
        host: 'api.whatsapp.com',
        path: 'send/',
        queryParameters: query,
      );

      await launchUrl(uri);
    }

    final showForAdmin = adminWAActive && seller == null;

    final showReview = isLoggedIn && canReview && onReviewTap != null;
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 5),
      color: context.colors.surface,
      child: SeparatedRow(
        separatorBuilder: () => const Gap(5),
        children: [
          if (showReview)
            CircularButton.filled(
              fillColor: context.colors.secondaryContainer,
              margin: defaultPaddingAll.copyWith(right: 0),
              onPressed: onReviewTap,
              iconSize: 22,
              icon: const Icon(Icons.star_border_rounded),
            ),
          Expanded(
            flex: 3,
            child: SubmitButton(
              height: 50,
              isLoading: isLoading.value,
              onPressed: enableCart
                  ? () async {
                      isLoading.value = true;
                      product.fold(
                        (l) async => await cartsCtrl().addToCart(
                          product: l,
                          attribute: selectedVariant,
                          cUid: campaignId,
                        ),
                        (r) => onBuyTap?.call(),
                      );

                      isLoading.value = false;
                    }
                  : null,
              icon:
                  showReview ? null : const Icon(Icons.shopping_basket_rounded),
              child: Text(
                product.fold(
                  (l) => context.tr.add_to_cart,
                  (r) => context.tr.choose_attributes,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ),
          if (adminWAActive)
            if (showForAdmin || useSeller)
              Expanded(
                flex: 3,
                child: SubmitButton(
                  height: 50,
                  isLoading: isLoading.value,
                  style: FilledButton.styleFrom(
                    backgroundColor: const Color(0xFF1D5E54),
                    foregroundColor: const Color.fromARGB(255, 96, 255, 115),
                  ),
                  onPressed: enableCart ? () => orderViaWhatsapp() : null,
                  icon: Icon(MdiIcons.whatsapp),
                  child: Text(
                    context.tr.waOrder,
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
        ],
      ),
    );
  }
}
