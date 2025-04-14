import 'package:e_com/feature/orders/controller/order_tracking_ctrl.dart';
import 'package:e_com/main.export.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class DeliverymanReviewDialog extends HookConsumerWidget {
  const DeliverymanReviewDialog({super.key, required this.id});
  final String id;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final review = useState(0);
    final massageCtrl = useTextEditingController();

    return AlertDialog(
      elevation: 5,
      shadowColor: Colors.white,
      icon: SizedBox(
        height: 80,
        child: Assets.lottie.reviewStar.lottie(),
      ),
      title: Text(
        context.tr.msgAppreciateRating,
        style: context.textTheme.titleLarge,
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          KRatingBar(
            rating: review.value.toDouble(),
            itemSize: 30,
            onRatingUpdate: (rating) {
              review.value = rating.toInt();
            },
          ),
          const SizedBox(height: 20),
          TextField(
            controller: massageCtrl,
            decoration: InputDecoration(
              hintText: context.tr.writeAReview,
            ),
          ),
          const SizedBox(height: 20),
          SubmitLoadButton(
            style: FilledButton.styleFrom(
              shape: const StadiumBorder(),
            ),
            onPressed: (l) async {
              l.value = true;
              await ref
                  .read(orderTrackingCtrlProvider(id).notifier)
                  .deliverymanReview(massageCtrl.text, review.value);
              l.value = false;
              if (context.mounted) context.pop();
            },
            child: Text(context.tr.submit),
          ),
          TextButton(
            onPressed: () => context.pop(),
            child: Text(context.tr.noThanks),
          )
        ],
      ),
    );
  }
}
