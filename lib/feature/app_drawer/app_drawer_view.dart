import 'package:e_com/_core/_core.dart';
import 'package:e_com/feature/auth/controller/auth_ctrl.dart';
import 'package:e_com/feature/settings/provider/settings_provider.dart';
import 'package:e_com/feature/user_dash/provider/user_dash_provider.dart';
import 'package:e_com/routes/routes.dart';
import 'package:e_com/themes/theme_config.dart';
import 'package:e_com/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class KDrawerMenu extends HookConsumerWidget {
  const KDrawerMenu({super.key, required this.onItemTap});

  /// used to close the drawer when an item is tapped
  final Function(RouteName? route) onItemTap;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authCtrl = useCallback(() => ref.read(authCtrlProvider.notifier));
    final user = ref.watch(userDashProvider.select((x) => x?.user));
    final config = ref.watch(
      settingsProvider.select((x) => x?.settings),
    );
    final isLoggedIn = ref.watch(authCtrlProvider);
    final isWalletActive = config?.walletActive ?? false;
    final isRewardActive = config?.pointSystemActive ?? false;
    final tr = context.tr;
    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 8,
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (isLoggedIn)
                    Padding(
                      padding: defaultPadding,
                      child: Center(
                        child: Container(
                          constraints: const BoxConstraints(maxWidth: 150),
                          height: 130 + context.mq.viewPadding.top,
                          decoration: BoxDecoration(
                            borderRadius: const BorderRadius.vertical(
                              bottom: Radius.circular(70),
                            ),
                            color: context.colors.secondary.withOpacity(.06),
                          ),
                          padding: const EdgeInsets.all(20),
                          alignment: Alignment.bottomCenter,
                          child: Stack(
                            clipBehavior: Clip.none,
                            children: [
                              if (user != null)
                                Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(180),
                                  ),
                                  clipBehavior: Clip.hardEdge,
                                  child: HostedImage.square(
                                    user.image,
                                    dimension: 90,
                                  ),
                                )
                              else
                                CircleAvatar(
                                  backgroundColor: context
                                      .colors.secondaryContainer
                                      .withOpacity(.5),
                                  radius: 45,
                                  child: const Icon(
                                    Icons.person_rounded,
                                    size: 45,
                                  ),
                                ),
                              Positioned(
                                bottom: -3,
                                right: 0,
                                child: CircularButton.filled(
                                  onPressed: () =>
                                      onItemTap(RouteNames.userEditing),
                                  fillColor: context.colors.primary,
                                  iconColor: context.colors.onPrimary,
                                  icon: const Icon(Icons.edit_rounded),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    )
                  else
                    SizedBox(height: 130 + context.mq.viewPadding.top),
                  const SizedBox(height: 30),
                  HiddenButton(
                    child: Padding(
                      padding: defaultPadding,
                      child: Text(
                        '${tr.hello},',
                        style: context.textTheme.headlineSmall
                            ?.copyWith(fontWeight: FontWeight.w500),
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Padding(
                    padding: defaultPadding,
                    child: Text(
                      isLoggedIn ? (user?.name ?? '') : tr.guest,
                      style: context.textTheme.headlineSmall
                          ?.copyWith(fontWeight: FontWeight.w600),
                    ),
                  ),
                  if (user != null && isWalletActive)
                    DecoratedContainer(
                      padding: Insets.padAll,
                      child: Text.rich(
                        TextSpan(
                          text: '${context.tr.balance}: ',
                          children: [
                            TextSpan(
                              text: user.balance.formate(),
                              style: context.textTheme.titleLarge?.bold
                                  .textColor(context.colors.primary),
                            ),
                          ],
                        ),
                        style: context.textTheme.titleLarge,
                      ),
                    ),
                  const SizedBox(height: 20),
                  if (!isLoggedIn)
                    ListTile(
                      tileColor: context.colors.primary,
                      textColor: context.colors.onPrimary,
                      titleTextStyle: context.textTheme.titleLarge,
                      iconColor: context.colors.onPrimary,
                      onTap: () {
                        onItemTap(RouteNames.login);
                      },
                      leading: const Icon(Icons.login_rounded),
                      title: Text(tr.login_now),
                    ),
                  if (isLoggedIn)
                    ListTile(
                      onTap: () {
                        RouteNames.orders.pushNamed(context);
                      },
                      leading: Icon(
                        Icons.home_rounded,
                        color: context.colors.primary,
                      ),
                      title: Text(
                        tr.my_order,
                        style: context.textTheme.titleLarge,
                      ),
                    ),
                  ListTile(
                    onTap: () {
                      RouteNames.trackOrder.pushNamed(context);
                    },
                    leading: Icon(
                      Icons.local_shipping,
                      color: context.colors.primary,
                    ),
                    title: Text(
                      tr.track_order,
                      style: context.textTheme.titleLarge,
                    ),
                  ),
                  if (isLoggedIn && isRewardActive)
                    ListTile(
                      onTap: () {
                        RouteNames.reward.pushNamed(context);
                      },
                      leading: Icon(
                        Icons.star_rounded,
                        color: context.colors.primary,
                      ),
                      title: Text(
                        context.tr.reward,
                        style: context.textTheme.titleLarge,
                      ),
                    ),
                  if (isLoggedIn)
                    if (config?.deliveryManEnabled ?? false)
                      if (config?.deliveryChatEnabled ?? false)
                        ListTile(
                          onTap: () =>
                              RouteNames.deliveryManChat.pushNamed(context),
                          leading: Icon(
                            Icons.chat,
                            color: context.colors.primary,
                          ),
                          title: Text(
                            tr.chatWithDeliveryPartner,
                            style: context.textTheme.titleLarge,
                          ),
                        ),
                  if (isLoggedIn)
                    ListTile(
                      onTap: () {
                        RouteNames.sellerChatList.pushNamed(context);
                      },
                      leading: Icon(
                        Icons.chat,
                        color: context.colors.primary,
                      ),
                      title: Text(
                        context.tr.chatWithSeller,
                        style: context.textTheme.titleLarge,
                      ),
                    ),
                  if (isLoggedIn)
                    ListTile(
                      onTap: () {
                        RouteNames.address.pushNamed(context);
                      },
                      leading: Icon(
                        Icons.location_on,
                        color: context.colors.primary,
                      ),
                      title: Text(
                        tr.userAddress,
                        style: context.textTheme.titleLarge,
                      ),
                    ),
                  if (isLoggedIn && isWalletActive)
                    ListTile(
                      onTap: () {
                        RouteNames.transactions.pushNamed(context);
                      },
                      leading: Icon(
                        Icons.wallet_rounded,
                        color: context.colors.primary,
                      ),
                      title: Text(
                        context.tr.wallet,
                        style: context.textTheme.titleLarge,
                      ),
                    ),
                  if (isLoggedIn)
                    ListTile(
                      onTap: () {
                        onItemTap(RouteNames.wishlist);
                      },
                      leading: Icon(
                        Icons.favorite_rounded,
                        color: context.colors.primary,
                      ),
                      title: Text(
                        tr.wishlist,
                        style: context.textTheme.titleLarge,
                      ),
                    ),
                  ListTile(
                    onTap: () {
                      onItemTap(RouteNames.settings);
                    },
                    leading: Icon(
                      Icons.settings_rounded,
                      color: context.colors.primary,
                    ),
                    title: Text(
                      tr.settings,
                      style: context.textTheme.titleLarge,
                    ),
                  ),
                  ListTile(
                    onTap: () {
                      RouteNames.contactUs.pushNamed(context);
                    },
                    leading: Icon(
                      Icons.person,
                      color: context.colors.primary,
                    ),
                    title: Text(
                      tr.contact,
                      style: context.textTheme.titleLarge,
                    ),
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            flex: 2,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Divider(endIndent: context.width / 3, thickness: 2),
                const SizedBox(height: 10),
                Padding(
                  padding: const EdgeInsets.only(left: 10),
                  child: Row(
                    children: [
                      if (isLoggedIn)
                        InkWell(
                          borderRadius: BorderRadius.circular(100),
                          onTap: () async {
                            await authCtrl().logOut();
                            onItemTap(null);
                          },
                          child: Container(
                            decoration: BoxDecoration(
                              border: Border.all(
                                color: context.colors.primary,
                              ),
                              borderRadius: BorderRadius.circular(100),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(5),
                              child: SizedBox.square(
                                dimension: 40,
                                child: ColorFiltered(
                                  colorFilter: ColorFilter.mode(
                                    context.colors.primary,
                                    BlendMode.srcIn,
                                  ),
                                  child: Assets.lottie.logout1.lottie(),
                                ),
                              ),
                            ),
                          ),
                        ),
                      const SizedBox(width: 20),
                      Container(
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: context.colors.primary,
                          ),
                          borderRadius: BorderRadius.circular(100),
                        ),
                        child: ColorFiltered(
                          colorFilter: ColorFilter.mode(
                            context.colors.primary,
                            BlendMode.srcIn,
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(5),
                            child: RepaintBoundary(
                              child: ThemeToggle(
                                size: 40,
                                onTap: () {
                                  ref
                                      .read(themeModeProvider.notifier)
                                      .toggleTheme();
                                },
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 20),
                      InkWell(
                        borderRadius: BorderRadius.circular(100),
                        onTap: () => onItemTap(null),
                        child: Container(
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: context.colors.primary,
                            ),
                            borderRadius: BorderRadius.circular(100),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(5),
                            child: SizedBox.square(
                              dimension: 40,
                              child: ColorFiltered(
                                colorFilter: ColorFilter.mode(
                                  context.colors.primary,
                                  BlendMode.srcIn,
                                ),
                                child: Assets.lottie.backArrow.lottie(),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
