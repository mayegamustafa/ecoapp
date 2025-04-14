import 'dart:io';

import 'package:e_com/_core/_core.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class InvalidPurchasePage extends HookConsumerWidget {
  const InvalidPurchasePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      body: Padding(
        padding: defaultPadding,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Assets.lottie.warning.lottie(height: 100),
              const SizedBox(height: 20),
              Text(
                context.tr.not_installed,
                style: context.textTheme.titleLarge,
              ),
              Text(
                context.tr.contact_provider,
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
                      final statusCtrl =
                          ref.read(serverStatusProvider.notifier);
                      await statusCtrl.retryStatusResolver();
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
