import 'dart:io';

import 'package:e_com/_core/_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class MaintenancePage extends HookConsumerWidget {
  const MaintenancePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isLoading = useState(false);
    return Scaffold(
      body: Padding(
        padding: defaultPadding,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Assets.lottie.underMaintenance.lottie(height: 300),
              Text(
                context.tr.maintenance,
                style: context.textTheme.titleLarge,
              ),
              Text(
                context.tr.inconvenience,
                style: context.textTheme.titleMedium,
                textAlign: TextAlign.center,
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
                      isLoading.value = true;

                      final statusCtrl =
                          ref.read(serverStatusProvider.notifier);
                      await statusCtrl.retryStatusResolver();
                      isLoading.value = false;
                    },
                    icon: RepaintBoundary(
                      child: const Icon(Icons.refresh_rounded)
                          .animate(
                            target: isLoading.value ? 1 : 0,
                            onPlay: (c) => c.repeat(),
                          )
                          .rotate(duration: 1.seconds),
                    ),
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
