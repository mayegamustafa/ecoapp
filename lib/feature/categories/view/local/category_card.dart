import 'package:e_com/_core/_core.dart';
import 'package:e_com/models/models.dart';
import 'package:e_com/routes/routes.dart';
import 'package:e_com/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class CategoryCard extends ConsumerWidget {
  const CategoryCard({super.key, required this.category});
  final CategoriesData category;
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return InkWell(
      borderRadius: defaultRadius,
      onTap: () => RouteNames.categoryProducts
          .pushNamed(context, pathParams: {'id': category.uid}),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: defaultRadius,
          color: context.colors.surface,
          boxShadow: [
            BoxShadow(
              blurRadius: 6,
              color: context.colors.primaryContainer
                  .withOpacity(context.isDark ? 0.3 : 0.1),
              offset: const Offset(0, 0),
            ),
          ],
        ),
        height: 110,
        width: 120,
        child: Column(
          children: [
            const SizedBox(height: 5),
            Container(
              width: 70,
              height: 70,
              decoration: BoxDecoration(
                color: context.colors.onErrorContainer,
                borderRadius: BorderRadius.circular(100),
              ),
              child: Padding(
                padding: defaultPaddingAll,
                child: ClipRRect(
                  borderRadius: defaultRadius,
                  child: HostedImage(category.image, height: 40),
                ),
              ),
            ),
            const SizedBox(height: 5),
            Flexible(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 2),
                child: Text(
                  category.name,
                  maxLines: 1,
                  textAlign: TextAlign.center,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
