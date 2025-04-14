import 'dart:io';

import 'package:e_com/_core/_core.dart';
import 'package:e_com/feature/app_drawer/app_drawer_view.dart';
import 'package:e_com/feature/cart/controller/carts_ctrl.dart';
import 'package:e_com/routes/routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'nav_button.dart';
import 'nav_destination.dart';

class NavigationRoot extends HookConsumerWidget {
  const NavigationRoot(this.child, {super.key});
  final Widget child;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cartCount = ref.watch(
      cartCtrlProvider.select((carts) => carts.valueOrNull?.length ?? 0),
    );

    final rootPath = GoRouterState.of(context).uri.pathSegments.first;
    final int getIndex =
        RouteNames.nestedRoutes.map((e) => e.name).toList().indexOf(rootPath);

    final index = useState(0);
    final showDrawer = useState(false);

    final duration = 250.ms;
    const curve = Curves.easeInOutCubic;

    useEffect(() {
      index.value = getIndex;
      return null;
    }, [rootPath]);

    return Scaffold(
      body: Stack(
        children: [
          KDrawerMenu(
            onItemTap: (route) {
              showDrawer.value = false;
              if (route != null) route.pushNamed(context);
            },
          ),
          GestureDetector(
            onTap: () => showDrawer.value = false,
            child: SizedBox(
              height: context.height,
              width: context.width,
              child: Scaffold(
                body: IgnorePointer(ignoring: showDrawer.value, child: child),
                bottomNavigationBar: NavigationBar(
                  selectedIndex: index.value,
                  destinations: [
                    for (var i = 0; i < _destinations().length; i++)
                      NavButton(
                        count: cartCount,
                        destination: _destinations()[i],
                        index: i,
                        selectedIndex: index.value,
                        onPressed: () {
                          if (_destinations()[i].isDrawerButton) {
                            showDrawer.value = !showDrawer.value;
                          } else {
                            index.value = i;
                            RouteNames.nestedRoutes[i].push(context);
                          }
                        },
                      ),
                  ],
                ),
              ),
            )
                .animate(target: showDrawer.value ? 1 : 0)
                .boxShadow(
                  end: BoxShadow(
                    blurRadius: 15,
                    color: context.isLight
                        ? const Color.fromRGBO(0, 0, 0, 0.18)
                        : context.colors.secondaryContainer.withOpacity(0.1),
                    offset: const Offset(-3, -10),
                  ),
                  duration: duration,
                  curve: curve,
                )
                .move(
                  begin: Offset.zero,
                  end: Offset(
                    context.onMobile ? context.width * .8 : context.width * .5,
                    context.onMobile
                        ? context.height * .2
                        : context.height * .1,
                  ),
                  duration: duration,
                  curve: curve,
                )
                .scaleXY(begin: 1, end: .9, duration: duration, curve: curve)
                .rotate(begin: 0, end: .03, duration: duration, curve: curve),
          ),
        ],
      ),
    );
  }

  List<KNavDestination> _destinations() => [
        KNavDestination(
          text: TR.current.home,
          selectedIcon: Icons.home_rounded,
          icon: Icons.home_outlined,
        ),
        KNavDestination(
          text: TR.current.wishlist,
          selectedIcon: Icons.favorite_rounded,
          icon: Icons.favorite_border_rounded,
        ),
        KNavDestination(
          text: TR.current.campaign,
          icon: Icons.campaign_rounded,
          selectedIcon: Icons.qr_code_scanner_rounded,
          focused: true,
        ),
        KNavDestination(
          text: TR.current.shopping,
          selectedIcon: Icons.shopping_basket_rounded,
          icon: Icons.shopping_basket_outlined,
        ),
        KNavDestination(
          text: TR.current.profile,
          selectedIcon: Icons.person_rounded,
          icon: Icons.person_outline_rounded,
          isDrawerButton: true,
        ),
      ];
}

class ExitDialog extends StatelessWidget {
  const ExitDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      elevation: 5,
      shadowColor: Colors.white,
      icon: SizedBox(
        height: 100,
        child: Assets.lottie.warning.lottie(),
      ),
      title: Text(context.tr.hey),
      content: Text(
        context.tr.sure_to_exit,
        textAlign: TextAlign.center,
      ),
      actions: [
        SizedBox(
          width: 120,
          child: OutlinedButton(
            style: const ButtonStyle(
              shape: WidgetStatePropertyAll(
                StadiumBorder(),
              ),
            ),
            onPressed: () {
              exit(0);
            },
            child: Text(context.tr.yes),
          ),
        ),
        SizedBox(
          width: 120,
          child: FilledButton(
            style: ElevatedButton.styleFrom(
              shape: const StadiumBorder(),
            ),
            onPressed: () {
              context.pop();
            },
            child: Text(context.tr.no),
          ),
        ),
      ],
    );
  }
}
