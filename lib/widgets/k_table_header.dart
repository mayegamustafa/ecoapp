import 'package:e_com/main.export.dart';
import 'package:flutter/material.dart';

class KTableHeader extends StatelessWidget {
  const KTableHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: context.colors.primary,
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(20),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 5),
        child: Row(
          children: [
            Expanded(
              flex: 3,
              child: Center(
                child: Text(
                  'Date',
                  style: context.onTab
                      ? context.textTheme.bodyLarge!
                          .copyWith(color: context.colors.onPrimary)
                      : context.textTheme.labelMedium!.copyWith(
                          color: context.colors.onPrimary,
                        ),
                ),
              ),
            ),
            Expanded(
              flex: 4,
              child: Center(
                child: Text(
                  'Trx',
                  style: context.onTab
                      ? context.textTheme.bodyLarge!
                          .copyWith(color: context.colors.onPrimary)
                      : context.textTheme.labelMedium!.copyWith(
                          color: context.colors.onPrimary,
                        ),
                ),
              ),
            ),
            Expanded(
              flex: 3,
              child: Text(
                'Receivable',
                style: context.onTab
                    ? context.textTheme.bodyLarge!
                        .copyWith(color: context.colors.onPrimary)
                    : context.textTheme.labelMedium!.copyWith(
                        color: context.colors.onPrimary,
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ExpansionTable extends StatelessWidget {
  const ExpansionTable({
    super.key,
    required this.readableTime,
    required this.date,
    required this.trx,
    required this.receivable,
    required this.builder,
  });

  final String readableTime, date, trx, receivable;

  final Map<Widget, Widget> Function(BuildContext context) builder;

  @override
  Widget build(BuildContext context) {
    final tStyle = context.onTab
        ? context.textTheme.bodyLarge
        : context.textTheme.labelMedium;
    return ExpansionTile(
      title: Row(
        children: [
          Expanded(
            flex: 3,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(readableTime, style: tStyle),
                Text(date, style: tStyle),
              ],
            ),
          ),
          Expanded(
            flex: 3,
            child: Center(
              child: SelectableText(trx, style: tStyle),
            ),
          ),
          Expanded(
            flex: 2,
            child: Center(
              child: Text(receivable, style: tStyle),
            ),
          ),
        ],
      ),
      trailing: Icon(
        Icons.keyboard_arrow_down_rounded,
        size: 20,
        color: context.colors.primary,
      ),
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 16.0, bottom: 20),
          child: SeparatedColumn(
            crossAxisAlignment: CrossAxisAlignment.start,
            separatorBuilder: () => const Gap(Insets.sm),
            children: [
              for (var MapEntry(:key, :value) in builder(context).entries)
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [key, const Gap(Insets.sm), value],
                ),
            ],
          ),
        ),
      ],
    );
  }
}
