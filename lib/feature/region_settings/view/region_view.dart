import 'package:e_com/_core/_core.dart';
import 'package:e_com/feature/region_settings/controller/region_ctrl.dart';
import 'package:e_com/feature/settings/provider/settings_provider.dart';
import 'package:e_com/models/models.dart';
import 'package:e_com/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class RegionView extends ConsumerWidget {
  const RegionView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final config = ref.watch(settingsProvider);
    final region = ref.watch(regionCtrlProvider);
    final regionCtrl = ref.read(regionCtrlProvider.notifier);
    return Scaffold(
      appBar: KAppBar(
        leading: SquareButton.backButton(
          onPressed: () => context.pop(),
        ),
        title: Text(context.tr.language_and_currency),
      ),
      body: config == null
          ? const EmptyWidget.onError()
          : Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: SingleChildScrollView(
                physics: defaultScrollPhysics,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      context.tr.language,
                      style: context.textTheme.titleLarge,
                    ),
                    const SizedBox(height: 10),
                    ...TR.delegate.supportedLocales.map(
                      (lang) => LanguageTile(local: lang, region: region),
                    ),
                    const Divider(height: 40),
                    Text(
                      context.tr.currency,
                      style: context.textTheme.titleLarge,
                    ),
                    const SizedBox(height: 10),
                    ...config.currency.map(
                      (currency) => RadioListTile(
                        groupValue: region.currency?.uid,
                        value: currency.uid,
                        onChanged: (value) {
                          regionCtrl.setCurrencyCode(currency,
                              resetState: true);
                        },
                        secondary: Text.rich(
                          TextSpan(
                            text: currency.name,
                            style: context.textTheme.bodyLarge!.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                            children: [
                              TextSpan(
                                text: ' (${currency.symbol})',
                                style: context.textTheme.bodyMedium!.copyWith(
                                  fontWeight: FontWeight.w300,
                                ),
                              )
                            ],
                          ),
                        ),
                        controlAffinity: ListTileControlAffinity.trailing,
                      ),
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}

class LanguageTile extends ConsumerWidget {
  const LanguageTile({
    super.key,
    required this.local,
    required this.region,
  });

  final Locale local;
  final RegionModel region;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final regionCtrl = ref.read(regionCtrlProvider.notifier);
    final lang = AppLang.getAppLang(local);
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: Container(
        decoration: BoxDecoration(
          color: context.colors.secondary.withOpacity(0.04),
          borderRadius: BorderRadius.circular(10),
        ),
        child: RadioListTile(
          groupValue: region.langCode,
          value: local.languageCode,
          onChanged: (value) {
            regionCtrl.setLangCode(lang.key, resetState: true);
            ref.read(localeProvider.notifier).setLocale(local);
          },
          secondary: Text(
            lang.key.toUpperCase(),
            style: context.textTheme.titleLarge,
          ),
          title: Text(
            lang.name,
            style: context.textTheme.bodyLarge,
          ),
          controlAffinity: ListTileControlAffinity.trailing,
        ),
      ),
    );
  }
}
