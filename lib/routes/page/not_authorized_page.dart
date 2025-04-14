import 'package:e_com/_core/_core.dart';
import 'package:e_com/routes/routes.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class NotAuthorizedPage extends ConsumerWidget {
  const NotAuthorizedPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ColorFiltered(
              colorFilter: ColorFilter.mode(
                context.colors.primary,
                BlendMode.srcATop,
              ),
              child: Assets.lottie.notAuthenticated.lottie(height: 200),
            ),
            Text(
              context.tr.not_authorized,
              style: context.textTheme.headlineSmall,
            ),
            const SizedBox(height: 10),
            Text(context.tr.login_to_continue),
            const SizedBox(height: 20),
            FilledButton(
                onPressed: () => RouteNames.login.pushNamed(context),
                child: Text(context.tr.login_now)),
            const SizedBox(height: 10),
            TextButton.icon(
              onPressed: () => RouteNames.home.goNamed(context),
              icon: const Icon(Icons.arrow_back_rounded),
              label: Text(context.tr.Back_to_home),
            ),
          ],
        ),
      ),
    );
  }
}
