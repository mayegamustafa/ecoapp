import 'package:badges/badges.dart' as badges;
import 'package:e_com/feature/auth/controller/auth_ctrl.dart';
import 'package:e_com/feature/cart/controller/carts_ctrl.dart';
import 'package:e_com/feature/product_review/view/product_review_view.dart';
import 'package:e_com/feature/products/controller/product_ctrl.dart';
import 'package:e_com/feature/products/view/local/digital_buy_view.dart';
import 'package:e_com/main.export.dart';
import 'package:e_com/routes/routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:fpdart/fpdart.dart';
import 'package:go_router/go_router.dart';
import 'package:share_plus/share_plus.dart';

import 'local/local.dart';

class ProductDetailsView extends HookConsumerWidget {
  const ProductDetailsView({
    super.key,
    required this.id,
    required this.campaignId,
    required this.animation,
  });

  final String? campaignId;
  final String id;
  final Animation<double> animation;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    /// Route queries

    final isRegular = context.query('isRegular') == 'false' ? false : true;
    final type = context.query('t');
    final toReview = context.query('toReview');

    /// riverpod providers

    final argument = (uid: id, isRegular: isRegular, campaignId: campaignId);
    final productData = ref.watch(productCtrlProvider(argument));
    final isLoggedIn = ref.watch(authCtrlProvider);

    /// UI methods

    final tabIndex = useState(0);

    final onReviewTap = useCallback(
      () => showDialog(
        context: context,
        builder: (context) => ReviewPopup(productID: id),
      ),
    );

    useEffect(() {
      if (toReview == 'true') {
        tabIndex.value = 1;
        Future.delayed(Duration.zero, () => onReviewTap());
      }
      return null;
    }, const []);

    final tabController =
        useTabController(initialLength: 3, initialIndex: tabIndex.value);
    final tabControllerD = useTabController(initialLength: 1);

    final selectedVariant = useState<Map<String, String>>({});
    final variantPrice = useState<VariantPrice?>(null);

    void setNewValiant(String variantName, String variant) {
      selectedVariant.value = {...selectedVariant.value, variantName: variant};
    }

    void variantInit(ProductsData product) {
      if (selectedVariant.value.isEmpty) {
        for (final v in product.variants) {
          selectedVariant.value[v.name] = v.attributes.first.name;
        }
      }
    }

    return productData.when(
      error: (e, st) => Scaffold(
        body: ErrorView(e, st, invalidate: productCtrlProvider),
      ),
      loading: () => const ProductDetailsLoader(),
      data: (productBase) {
        final product = productBase.product;
        final digitalProduct = productBase.digitalProduct;
        final relatedProduct = productBase.relatedProduct;

        // is regular product or digital
        final bool isProduct = product != null;

        String variantString() =>
            selectedVariant.value.values.join('-').replaceAll(' ', '');

        if (product != null) {
          variantInit(product);

          variantPrice.value = product.variantPrices[variantString()];
        }

        final store = product?.store ?? digitalProduct?.store;

        final productUrl = isProduct ? product.url : digitalProduct?.url;

        return Scaffold(
          appBar: _ProductDetailsAppBar(
            animation,
            url: productUrl,
          ),
          bottomNavigationBar: ProductFabButton(
            product: isProduct ? left(product) : right(digitalProduct!),
            selectedVariant: variantString(),
            campaignId: campaignId,
            onReviewTap: tabController.index == 1 ? onReviewTap : null,
            isInStock:
                isProduct ? (variantPrice.value?.quantity ?? 0) > 0 : true,
            onBuyTap: () async {
              await showDialog(
                context: context,
                builder: (_) => DigitalBuyView(product: digitalProduct!),
              );
            },
          ),
          body: NestedScrollView(
            physics: defaultScrollPhysics,
            headerSliverBuilder: (context, _) {
              return [
                SliverList(
                  delegate: SliverChildListDelegate(
                    [
                      const SizedBox(height: 20),
                      HeroWidget(
                        tag: HeroTags.productImgTag(product, type ?? ''),
                        child: ProductImageSlider(
                          id: id,
                          isProduct: isProduct,
                          images: [
                            if (isProduct)
                              ...product.galleryImage
                            else
                              digitalProduct!.featuredImage,
                          ],
                        ),
                      ),
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: context.isLight
                              ? context.colors.surface
                              : context.colors.secondaryContainer
                                  .withOpacity(0.1),
                          borderRadius: const BorderRadius.vertical(
                            top: Radius.circular(30),
                          ),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            HeroWidget(
                              tag: HeroTags.productNameTag(product, type),
                              child: SelectableText(
                                isProduct ? product.name : digitalProduct!.name,
                                style:
                                    context.textTheme.headlineSmall?.copyWith(
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                            if (isProduct)
                              ProductDescHeader(
                                product: product,
                                variantPrice: variantPrice.value,
                              ),
                            const SizedBox(height: 20),
                            if (isProduct)
                              VariantSelection(
                                product: product,
                                selectedVariant: selectedVariant.value,
                                onVariantChange: setNewValiant,
                              ),
                            SeparatedRow(
                              separatorBuilder: () => const Gap(5),
                              children: [
                                if (isProduct)
                                  Flexible(
                                    child: SubmitLoadButton(
                                      style: OutlinedButton.styleFrom(
                                        backgroundColor: context.colors.primary
                                            .withOpacity(.05),
                                        foregroundColor: context.colors.primary,
                                        side: BorderSide(
                                          color: context.colors.outline,
                                        ),
                                      ),
                                      onPressed: (l) async {
                                        l.value = true;
                                        await ref
                                            .read(cartCtrlProvider.notifier)
                                            .addToCart(
                                              product: product,
                                              attribute: variantString(),
                                              cUid: campaignId,
                                            );
                                        l.value = false;
                                        if (context.mounted) {
                                          RouteNames.shippingDetails
                                              .pushNamed(context);
                                        }
                                      },
                                      icon: const Icon(
                                          Icons.shopping_cart_rounded),
                                      child: Text(context.tr.buy_now),
                                    ),
                                  ),
                                if (isLoggedIn && store != null)
                                  Flexible(
                                    child: SubmitButton(
                                      style: OutlinedButton.styleFrom(
                                        backgroundColor: context.colors.primary
                                            .withOpacity(.05),
                                        foregroundColor: context.colors.primary,
                                        side: BorderSide(
                                          color: context.colors.outline,
                                        ),
                                      ),
                                      onPressed: () {
                                        RouteNames.sellerChatDetails.pushNamed(
                                          context,
                                          pathParams: {
                                            'id': store.storeId.toString(),
                                          },
                                          query: {'url': productUrl},
                                        );
                                      },
                                      icon: const Icon(Icons.chat_outlined),
                                      child: Text(context.tr.sellerChat),
                                    ),
                                  ),
                              ],
                            ),
                            const SizedBox(height: 10),
                            if (product?.shortDescription != null ||
                                digitalProduct?.shortDescription != null) ...[
                              Text(
                                context.tr.short_description,
                                style: context.textTheme.titleLarge,
                              ),
                              const SizedBox(height: 5),
                              Container(
                                height: 2,
                                width: context.width / 2.4,
                                decoration: BoxDecoration(
                                  color: context.colors.primary,
                                  borderRadius: BorderRadius.circular(100),
                                ),
                              ),
                            ],
                            const SizedBox(height: 5),
                            if (isProduct)
                              Html(
                                data: product.shortDescription,
                                style: {
                                  "*": Style(
                                    fontSize: FontSize(16),
                                    lineHeight: const LineHeight(1.3),
                                    fontWeight: FontWeight.w400,
                                    color: context.colors.onSurface,
                                    backgroundColor: context.colors.surface,
                                  ),
                                },
                              )
                            else if (digitalProduct?.shortDescription != null)
                              Html(
                                data: digitalProduct!.shortDescription,
                                style: {
                                  "*": Style(
                                    lineHeight: const LineHeight(1.2),
                                    fontSize: FontSize(16),
                                    fontWeight: FontWeight.w400,
                                    color: context.colors.onSurface,
                                    backgroundColor: context.colors.surface,
                                  ),
                                },
                              ),
                            TabBar(
                              tabAlignment: TabAlignment.start,
                              isScrollable: true,
                              controller:
                                  isProduct ? tabController : tabControllerD,
                              onTap: (value) => tabIndex.value = value,
                              physics: const NeverScrollableScrollPhysics(),
                              indicatorColor: context.colors.primary,
                              labelStyle: context.textTheme.bodyLarge,
                              unselectedLabelStyle: context.textTheme.bodyLarge,
                              indicatorSize: TabBarIndicatorSize.label,
                              labelPadding:
                                  const EdgeInsets.only(left: 10, right: 10),
                              tabs: [
                                Tab(
                                  child: Text(
                                    context.tr.description,
                                  ),
                                ),
                                if (isProduct) ...[
                                  Tab(
                                    child: Text(
                                      context.tr.review,
                                    ),
                                  ),
                                  Tab(
                                    child: Text(
                                      context.tr.shipping_details,
                                    ),
                                  ),
                                ],
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ];
            },
            body: TabBarView(
              controller: isProduct ? tabController : tabControllerD,
              physics: defaultScrollPhysics,
              clipBehavior: Clip.none,
              children: [
                ProductDesc(
                  description:
                      product?.description ?? digitalProduct?.description ?? '',
                  relatedProduct: relatedProduct,
                  isRegular: isRegular,
                ),
                if (isProduct)
                  Container(
                    color: context.colors.secondaryContainer.withOpacity(0.01),
                    child: ProductReview(
                      rating: product.rating,
                      productID: product.uid,
                    ),
                  ),
                if (isProduct) ShippingTabView(product: product)
              ],
            ),
          ),
        );
      },
    );
  }
}

class ProductDetailsLoader extends StatelessWidget {
  const ProductDetailsLoader({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const _ProductDetailsAppBar(null, url: null),
      body: Padding(
        padding: const EdgeInsets.all(10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            KShimmer.card(height: 120, width: context.width),
            const SizedBox(height: 10),
            KShimmer.card(height: 20, width: context.width / 1.4),
            const SizedBox(height: 10),
            Row(
              children: [
                KShimmer.card(height: 20, width: 80),
                const SizedBox(width: 10),
                KShimmer.card(height: 20, width: 100),
              ],
            ),
            const SizedBox(height: 10),
            KShimmer.card(height: 20, width: context.width / 1.6),
            const SizedBox(height: 10),
            KShimmer.card(height: 60, width: context.width),
            const SizedBox(height: 10),
            Row(
              children: [
                KShimmer.card(height: 40, width: 80),
                const SizedBox(width: 10),
                KShimmer.card(height: 40, width: 80),
              ],
            ),
            const SizedBox(height: 10),
            KShimmer.card(height: 40, width: 80),
            const SizedBox(height: 10),
            Expanded(child: KShimmer.card(width: context.width)),
          ],
        ),
      ),
    );
  }
}

class _ProductDetailsAppBar extends ConsumerWidget
    implements PreferredSizeWidget {
  const _ProductDetailsAppBar(
    this.animation, {
    required this.url,
  });
  final Animation<double>? animation;
  final String? url;

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cartCount = ref.watch(
      cartCtrlProvider.select((carts) => carts.valueOrNull?.length ?? 0),
    );

    final animation = this.animation ?? kAlwaysCompleteAnimation;

    return AnimatedBuilder(
      animation: animation,
      builder: (context, child) => FadeTransition(
        opacity: CurvedAnimation(
          parent: animation,
          curve: const Interval(.0, 1, curve: Curves.easeInExpo),
        ),
        child: child,
      ),
      child: KAppBar(
        actions: [
          IconButton.outlined(
            onPressed:
                url == null ? null : () => Share.shareUri(Uri.parse(url!)),
            icon: const Icon(Icons.share),
          ),
          badges.Badge(
            badgeContent: Text(
              cartCount.toString(),
              style: context.textTheme.bodyLarge
                  ?.copyWith(color: context.colors.surface),
            ),
            child: IconButton.outlined(
              onPressed: () => RouteNames.carts.goNamed(context),
              icon: const Icon(Icons.shopping_basket_outlined),
            ),
          ),
          const SizedBox(width: 20),
        ],
        title: Text(context.tr.product_details),
        leading: SquareButton.backButton(
          onPressed: () => context.pop(),
        ),
      ),
    );
  }
}
