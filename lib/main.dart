import 'dart:io';

import 'package:background_downloader/background_downloader.dart';
import 'package:e_com/feature/payment/view/web_view_page.dart';
import 'package:e_com/main.export.dart';
import 'package:e_com/themes/theme_config.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import 'routes/routes.dart';
import 'themes/app_theme.dart';

Future<void> _initFirebase() async {
  await FireMessage.initiateWithFirebase();
  LNService.initialize();
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await PaymentBrowser.setupBrowser();

  if (kDebugMode) HttpOverrides.global = MyHttpOverrides();

  // Endpoints.betaBaseUrl = 'http://192.168.0.107/InHouse/cartuser/v2.1/api';

  await locatorSetUp();

  FileDownloader().configureNotification(
    running: const TaskNotification('Downloading', 'file: {filename}'),
    complete: const TaskNotification('Download finished', 'file: {filename}'),
    error: const TaskNotification('Download error', 'file: {filename}'),
    progressBar: true,
    tapOpensFile: true,
  );

  ///* To enable FIREBASE, change the value to true
  FireMessage.isFireActive = false;

  await _initFirebase();

  FlutterError.onError = (e) => talk.ex(e.exception, e.stack, e.summary);

  PlatformDispatcher.instance.onError = (e, s) {
    talk.ex(e, s, 'Async error');
    return true;
  };

  await locate<LocalDB>().resetIfNecessary();

  runApp(
    const ProviderScope(
      child: MyApp(),
    ),
  );
}

class MyApp extends HookConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final routes = ref.watch(goRoutesProvider);
    final theme = ref.watch(appThemeProvider);
    final mode = ref.watch(themeModeProvider);
    final locale = ref.watch(localeProvider);

    useEffect(() {
      return null;
    }, [locale]);

    return _EagerInitialization(
      child: RefreshConfiguration(
        headerBuilder: () => WaterDropHeader(
          waterDropColor: context.colors.primary,
        ),
        footerBuilder: () => const ClassicFooter(
          loadStyle: LoadStyle.ShowWhenLoading,
          loadingText: '',
          noDataText: 'No more messages',
        ),
        child: MaterialApp.router(
          debugShowCheckedModeBanner: false,
          title: AppDefaults.appName,
          themeMode: mode,
          theme: theme.theme(true),
          darkTheme: theme.theme(false),
          routerConfig: routes,
          locale: locale,
          supportedLocales: TR.delegate.supportedLocales,
          localizationsDelegates: const [
            TR.delegate,
            FormBuilderLocalizations.delegate,
            ...GlobalMaterialLocalizations.delegates,
          ],
        ),
      ),
    );
  }
}

class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)..badCertificateCallback = (cert, host, port) => true;
  }
}

class _EagerInitialization extends HookConsumerWidget {
  const _EagerInitialization({required this.child});
  final Widget child;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return child;
  }
}
