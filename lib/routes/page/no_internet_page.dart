import 'dart:io';

import 'package:e_com/_core/_core.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class NoInternetPage extends HookConsumerWidget {
  const NoInternetPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      body: Padding(
        padding: defaultPadding,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Assets.lottie.noInternet.lottie(height: 300),
              Text(
                context.tr.something_went_wrong,
                style: context.textTheme.titleLarge,
              ),
              Text(
                context.tr.check_internet,
                style: context.textTheme.titleMedium,
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  OutlinedButton.icon(
                    style: OutlinedButton.styleFrom(
                      fixedSize: const Size(150, 50),
                    ),
                    onPressed: () async {
                      ref.invalidate(serverStatusProvider);
                    },
                    icon: const Icon(Icons.refresh_rounded),
                    label: Text(context.tr.retry),
                  ),
                  OutlinedButton.icon(
                    style: OutlinedButton.styleFrom(
                      fixedSize: const Size(150, 50),
                    ),
                    onPressed: () => exit(0),
                    icon: const Icon(Icons.exit_to_app_rounded),
                    label: Text(context.tr.exit),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
