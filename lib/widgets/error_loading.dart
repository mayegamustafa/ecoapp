import 'dart:ui';

import 'package:e_com/main.export.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:go_router/go_router.dart';

class ErrorView extends HookConsumerWidget {
  const ErrorView(
    this.error,
    this.stackTrace, {
    this.onReload,
    this.invalidate,
    super.key,
  });

  final Function()? onReload;
  final ProviderOrFamily? invalidate;
  final Object error;
  final StackTrace? stackTrace;

   Widget withSF() => Scaffold(body: this);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    useEffect(() {
      talk.ex(error, stackTrace, 'Error View');
      return null;
    }, const []);
    return SafeArea(
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            HiddenButton(
              child: Assets.lottie.somethingWentWrong.lottie(),
            ),
            if (onReload != null || invalidate != null)
              OutlinedButton.icon(
                style: OutlinedButton.styleFrom(
                  fixedSize: const Size(150, 50),
                ),
                onPressed: () async {
                  onReload?.call();
                  if (invalidate != null) ref.invalidate(invalidate!);
                },
                icon: const Icon(Icons.refresh_rounded),
                label: Text(context.tr.retry),
              ),
            const Gap(Insets.med),
            if (kDebugMode)
              if (error.toString().startsWith('<!DOCTYPE html>'))
                Html(data: '$error')
              else
                Text(
                  '$error',
                  style: context.textTheme.bodyLarge,
                  textAlign: TextAlign.center,
                ),
          ],
        ),
      ),
    );
  }

  static Widget compact(error, [Function()? onReload, stackTrace]) {
    return Column(
      children: [
        if (kDebugMode) Text('$error'),
        TextButton(
          onPressed: onReload,
          child: Text(TR.current.retry),
        ),
      ],
    );
  }

  static Widget reload(e, s, Function()? onReload) {
    return ErrorView(
      e,
      s ?? StackTrace.current,
      onReload: onReload,
    );
  }

  static Widget withScaffold(error, [stackTrace]) {
    return Builder(
      builder: (context) {
        return Scaffold(
          appBar: KAppBar(
            leading: SquareButton.backButton(
              onPressed: () => context.pop(),
            ),
          ),
          body: ErrorView(error, stackTrace),
        );
      },
    );
  }
}

class Loader extends StatelessWidget {
  const Loader({this.widget, super.key});

  Loader.grid([int count = 5, int cross = 3, Key? key])
      : widget = _LoaderGrid(count, cross),
        super(key: key);

  Loader.list([int count = 5, double height = 50, Key? key])
      : widget = _LoaderList(count, height),
        super(key: key);

  Loader.shimmer(double? height, double? width, {super.key})
      : widget = _LoaderShimmer(height, width);

  Loader.fullScreen(bool useScaffold, {super.key, Widget Function()? builder})
      : widget = _FullScreenLoader(useScaffold: useScaffold, builder: builder);

  Loader.scaffold({super.key, String title = '', Widget? child})
      : widget = _FullScreenLoader(
          useScaffold: true,
          builder: () => Scaffold(
            appBar: KAppBar(title: Text(title)),
            body: child ?? const Loader(),
          ),
        );
 Widget withSF() => Scaffold(body: this);
  final Widget? widget;

  @override
  Widget build(BuildContext context) {
    if (widget != null) return widget!;
    return Center(
      child: CircularProgressIndicator(
        color: context.colors.primaryContainer,
      ),
    );
  }
}

class _LoaderShimmer extends Loader {
  const _LoaderShimmer([this.height, this.width]);

  final double? height;
  final double? width;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: Corners.lgBorder,
      child: KShimmer.card(
        height: height,
        width: width,
        padding: EdgeInsets.zero,
      ),
    );
  }
}

class _LoaderGrid extends Loader {
  const _LoaderGrid(this.itemCount, this.crossCount);

  final int crossCount;
  final int itemCount;

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      shrinkWrap: true,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        mainAxisSpacing: Insets.med,
        crossAxisSpacing: Insets.med,
        crossAxisCount: crossCount,
      ),
      itemCount: itemCount,
      itemBuilder: (context, index) {
        return const _LoaderShimmer();
      },
    );
  }
}

class _LoaderList extends Loader {
  const _LoaderList(this.itemCount, this.height);

  final double height;
  final int itemCount;

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      shrinkWrap: true,
      itemCount: itemCount,
      separatorBuilder: (context, index) => const Gap(Insets.med),
      itemBuilder: (context, index) => _LoaderShimmer(height, double.infinity),
    );
  }
}

class _FullScreenLoader extends Loader {
  const _FullScreenLoader({required this.useScaffold, this.builder});

  final bool useScaffold;
  final Widget Function()? builder;

  @override
  Widget build(BuildContext context) {
    Widget child = const Loader();
    if (builder != null) child = builder!();

    if (useScaffold) return Scaffold(body: child);
    return child;
  }
}

class EmptyWidget extends StatelessWidget {
  const EmptyWidget({super.key})
      : isError = false,
        onReload = null;

  const EmptyWidget.onError({super.key, this.onReload}) : isError = true;

  final Function()? onReload;
  final bool isError;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text.rich(
        TextSpan(
          text: context.tr.nothing_to_show,
          style: context.textTheme.titleLarge,
          children: [
            const TextSpan(text: '\n'),
            if (onReload != null)
              WidgetSpan(
                child: SquareButton(
                  padding: const EdgeInsets.all(10),
                  onPressed: onReload,
                  child: Text(TR.current.reload),
                ),
              ),
          ],
        ),
        textAlign: TextAlign.center,
      ),
    );
  }
}

class BlurredLoading extends StatelessWidget {
  const BlurredLoading({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final borderColor =
        context.colors.secondary.withOpacity(context.isDark ? 0.8 : 0.2);

    return ClipRRect(
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10.0, sigmaY: 10.0),
        child: Container(
          decoration: BoxDecoration(
            color: context.colors.surface.withOpacity(0.5),
            borderRadius: defaultRadius,
            border: Border.all(color: borderColor),
          ),
          alignment: Alignment.center,
          child: RepaintBoundary(
            child: Image.asset(
              context.isDark
                  ? Assets.logo.logoDark.path
                  : Assets.logo.logoWhite.path,
              height: 60,
            )
                .animate(
                  onPlay: (c) => c.repeat(reverse: true),
                )
                .scaleXY(
                  end: 1,
                  begin: 0.8,
                  duration: 300.ms,
                  curve: Curves.easeInOutQuad,
                ),
          ),
        ),
      ),
    );
  }
}
