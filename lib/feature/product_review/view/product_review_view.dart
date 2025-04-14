import 'package:e_com/_core/_core.dart';
import 'package:e_com/feature/product_review/controller/product_review_ctrl.dart';
import 'package:e_com/models/models.dart';
import 'package:e_com/models/product/rating.dart';
import 'package:e_com/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class ProductReview extends ConsumerWidget {
  const ProductReview({
    super.key,
    required this.rating,
    required this.productID,
  });

  final Rating rating;
  final String productID;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tr = context.tr;
    return Padding(
      padding: defaultPaddingAll,
      child: ListView.builder(
        physics: const NeverScrollableScrollPhysics(),
        itemCount: rating.review.isEmpty ? 1 : rating.review.length,
        itemBuilder: (context, index) {
          if (rating.review.isEmpty) {
            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  height: 70,
                  width: 70,
                  decoration: BoxDecoration(
                    border: Border.all(
                      width: 3,
                      color: context.colors.error,
                    ),
                    borderRadius: BorderRadius.circular(100),
                  ),
                  child: Icon(
                    Icons.close,
                    size: 45,
                    color: context.colors.error,
                  ),
                ),
                const SizedBox(height: 20),
                Text(
                  tr.write_a_review,
                  style: context.textTheme.bodyLarge!.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  tr.there_no_review,
                  style: context.textTheme.titleMedium,
                  textAlign: TextAlign.center,
                )
              ],
            );
          }
          final review = rating.review[index];

          return Container(
            decoration: BoxDecoration(
              borderRadius: defaultRadius,
              color: context.colors.secondaryContainer.withOpacity(0.05),
            ),
            padding: const EdgeInsets.all(10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      height: 70,
                      width: 70,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(100),
                        image: DecorationImage(
                          fit: BoxFit.cover,
                          image: HostedImage.provider(
                            review.profile,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          review.user,
                          style: context.textTheme.titleLarge,
                        ),
                        const SizedBox(height: 5),
                        Row(
                          children: [
                            KRatingBar(
                              rating: review.rating.toDouble(),
                              itemSize: 20,
                            ),
                            const SizedBox(width: 5),
                            Text(
                              '(${review.rating.toString()})',
                            )
                          ],
                        ),
                      ],
                    )
                  ],
                ),
                const SizedBox(height: 5),
                Text(
                  review.review,
                  style: context.textTheme.titleMedium,
                )
              ],
            ),
          );
        },
      ),
    );
  }
}

class ReviewPopup extends ConsumerWidget {
  const ReviewPopup({super.key, required this.productID});

  final String productID;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final review = ref.watch(reviewCtrlProvider(productID));
    final reviewCtrl = ref.read(reviewCtrlProvider(productID).notifier);
    final tr = context.tr;
    return AlertDialog(
      elevation: 5,
      shadowColor: Colors.white,
      icon: SizedBox(
        height: 80,
        child: Assets.lottie.reviewStar.lottie(),
      ),
      title: Text(
        tr.appreciate_rating,
        style: context.textTheme.titleLarge,
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          KRatingBar(
            rating: review.rate.toDouble(),
            itemSize: 30,
            onRatingUpdate: (rating) {
              reviewCtrl.updateRating(rating);
            },
          ),
          const SizedBox(height: 20),
          TextField(
            decoration: InputDecoration(
              hintText: tr.write_a_review,
            ),
            controller: reviewCtrl.reviewCtrl,
          ),
          const SizedBox(height: 20),
          SizedBox(
            width: double.infinity,
            child: FilledButton(
              style: FilledButton.styleFrom(
                shape: const StadiumBorder(),
              ),
              onPressed: () {
                reviewCtrl.submitReview(context);
                context.pop();
              },
              child: Text(
                tr.submit,
              ),
            ),
          ),
          TextButton(
            onPressed: () {
              context.pop();
            },
            child: Text(tr.no_thanks),
          )
        ],
      ),
    );
  }
}
